import 'dart:io';

import 'package:aluga_comigo/app/modules/customer/data/models/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../shared/data/services/camera_service.dart';
import '../../../../shared/data/services/firebase_storage_service.dart';
import '../../../../shared/data/services/session_service.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';

abstract interface class IProfileController extends ChangeNotifier {
  static const int maxPhotos = 5;

  String? errorMessage;
  List<String> loadingList = [];

  CustomerModel? customer;
  List<XFile> selectedPhotos = [];

  int get totalPhotosCount;
  bool get canAddMorePhotos;

  Future<Unit> initialize();
  @override
  void dispose();

  void updatePage();

  Future<bool> getCustomer();
  Future<bool> updateProfile();
  Future<void> selectPhotos();
  Future<bool> uploadPhotos();
  void removePhoto(int index);
  void removeSelectedPhoto(int index);
  bool get canRemovePhotos;
}

class ProfileController extends IProfileController {
  final IGetProfile _getProfile;
  final IUpdateProfile _updateProfile;
  final CameraService _cameraService;
  final FirebaseStorageService _storageService;

  ProfileController(
    this._getProfile,
    this._updateProfile,
    this._cameraService,
    this._storageService,
  );

  late final _getCustomerCommand = Command0<CustomerModel>(_getProfile.call);

  late final _updateProfileCommand = Command1(_updateProfile.call);

  @override
  int get totalPhotosCount {
    final existingPhotos = customer?.photos.length ?? 0;
    return existingPhotos + selectedPhotos.length;
  }

  @override
  bool get canAddMorePhotos {
    return totalPhotosCount < IProfileController.maxPhotos;
  }

  @override
  bool get canRemovePhotos {
    // Pode remover se tiver mais de 1 foto no total
    return totalPhotosCount > 1;
  }

  @override
  Future<bool> getCustomer() async {
    loadingList.add('getCustomer');
    notifyListeners();

    await _getCustomerCommand.execute();
    loadingList.remove('getCustomer');
    notifyListeners();

    final result = _getCustomerCommand.value;
    return result.when(
      data: (data) {
        switch (data) {
          case PersonCustomerModel _:
            customer = data.copyWith(
              email: SessionService.customer!.email,
              password: SessionService.customer!.password,
            );
            break;
          case ImmobileCustomerModel _:
            customer = data.copyWith(
              email: SessionService.customer!.email,
              password: SessionService.customer!.password,
            );
            break;
        }
        notifyListeners();
        return true;
      },
      failure: (error) {
        errorMessage = 'Não foi possivel pegar seu perfil';
        notifyListeners();
        return false;
      },
      orElse: () => false,
    );
  }

  @override
  Future<bool> updateProfile() async {
    if (customer == null) {
      errorMessage = 'Não foi possivel pegar seu perfil';
      notifyListeners();
      return false;
    }

    // Verifica se tem pelo menos 1 foto antes de salvar
    final totalPhotos = (customer!.photos.length + selectedPhotos.length);
    if (totalPhotos == 0) {
      errorMessage = 'Você deve ter pelo menos 1 foto no perfil para salvar';
      notifyListeners();
      return false;
    }

    loadingList.add('updateProfile');
    notifyListeners();

    // Faz upload das fotos selecionadas antes de salvar
    if (selectedPhotos.isNotEmpty) {
      final uploadResult = await uploadPhotos();
      if (!uploadResult) {
        loadingList.remove('updateProfile');
        notifyListeners();
        return false;
      }
    }

    // Verifica novamente após o upload (caso não tenha fotos salvas)
    if (customer!.photos.isEmpty) {
      errorMessage = 'Você deve ter pelo menos 1 foto no perfil para salvar';
      loadingList.remove('updateProfile');
      notifyListeners();
      return false;
    }

    await _updateProfileCommand.execute(customer!);
    SessionService.setCustomer(customer!);
    loadingList.remove('updateProfile');
    notifyListeners();

    return true;
  }

  @override
  Future<void> selectPhotos() async {
    try {
      // Verifica se já atingiu o limite de fotos
      if (!canAddMorePhotos) {
        errorMessage =
            'Você já possui o limite máximo de ${IProfileController.maxPhotos} fotos';
        notifyListeners();
        return;
      }

      final photos = await _cameraService.getMultiImage();
      if (photos.isNotEmpty) {
        final existingPhotos = customer?.photos.length ?? 0;
        final currentSelectedCount = selectedPhotos.length;
        final totalCurrent = existingPhotos + currentSelectedCount;
        final availableSlots = IProfileController.maxPhotos - totalCurrent;

        if (availableSlots <= 0) {
          errorMessage =
              'Você já possui o limite máximo de ${IProfileController.maxPhotos} fotos';
          notifyListeners();
          return;
        }

        // Adiciona as novas fotos à lista existente, respeitando o limite
        final photosToAdd = photos.take(availableSlots).toList();
        selectedPhotos.addAll(photosToAdd);

        if (photos.length > availableSlots) {
          errorMessage =
              'Você pode adicionar apenas $availableSlots foto(s) mais. Limite máximo de ${IProfileController.maxPhotos} fotos.';
        }
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Erro ao selecionar fotos: $e';
      notifyListeners();
    }
  }

  Future<File?> _compressImage(File file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Comprime a imagem com qualidade 85 para reduzir o tamanho do arquivo
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality:
            85, // Qualidade de 0-100 (85 é um bom equilíbrio entre qualidade e tamanho)
        format: CompressFormat.jpeg, // Formato JPEG
        keepExif: false, // Remove metadados EXIF para reduzir tamanho
      );

      return compressedFile != null ? File(compressedFile.path) : null;
    } catch (e) {
      errorMessage = 'Erro ao comprimir imagem: $e';
      notifyListeners();
      return null;
    }
  }

  @override
  Future<bool> uploadPhotos() async {
    if (customer == null || selectedPhotos.isEmpty) {
      return true;
    }

    // Valida se não ultrapassará o limite de fotos
    final existingPhotos = customer!.photos.length;
    final totalAfterUpload = existingPhotos + selectedPhotos.length;

    if (totalAfterUpload > IProfileController.maxPhotos) {
      errorMessage =
          'Você não pode adicionar mais de ${IProfileController.maxPhotos} fotos. Remova algumas fotos antes de adicionar novas.';
      notifyListeners();
      return false;
    }

    final List<String> uploadedUrls = [];
    final userId = SessionService.customer!.id;

    for (var i = 0; i < selectedPhotos.length; i++) {
      final photo = selectedPhotos[i];
      final originalFile = File(photo.path);

      // Comprime a imagem antes do upload
      final compressedFile = await _compressImage(originalFile);
      if (compressedFile == null) {
        errorMessage = 'Erro ao comprimir a foto ${i + 1}';
        notifyListeners();
        return false;
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$userId/${timestamp}_$i.jpg';

      final result = await _storageService.upload(
        FirebaseStorageTables.users,
        fileName,
        compressedFile,
      );

      result.fold(
        (error) {
          errorMessage = 'Erro ao fazer upload da foto: ${error.message}';
          notifyListeners();
        },
        (url) {
          uploadedUrls.add(url);
        },
      );

      if (result.isLeft()) {
        return false;
      }

      // Remove o arquivo temporário comprimido após o upload
      try {
        await compressedFile.delete();
      } catch (e) {
        // Ignora erros ao deletar arquivo temporário
      }
    }

    // Adiciona as novas URLs às fotos existentes
    final currentPhotos = customer!.photos;
    final newPhotosList = [...currentPhotos, ...uploadedUrls];

    // Garante que não ultrapasse o limite (segurança extra)
    final finalPhotosList = newPhotosList
        .take(IProfileController.maxPhotos)
        .toList();

    switch (customer!) {
      case PersonCustomerModel data:
        customer = data.copyWith(photos: finalPhotosList);
        break;
      case ImmobileCustomerModel data:
        customer = data.copyWith(photos: finalPhotosList);
        break;
    }
    SessionService.setCustomer(customer!);

    // Limpa as fotos selecionadas após o upload
    selectedPhotos = [];
    notifyListeners();

    return true;
  }

  @override
  Future<Unit> initialize() async {
    await getCustomer();

    return unit;
  }

  @override
  void dispose() {
    _getCustomerCommand.cancel();
    _updateProfileCommand.cancel();
    super.dispose();
  }

  @override
  void removePhoto(int index) {
    if (customer == null) return;

    if (index >= 0 && index < customer!.photos.length) {
      final updatedPhotos = List<String>.from(customer!.photos);
      updatedPhotos.removeAt(index);
      switch (customer!) {
        case PersonCustomerModel data:
          customer = data.copyWith(photos: updatedPhotos);
          break;
        case ImmobileCustomerModel data:
          customer = data.copyWith(photos: updatedPhotos);
          break;
      }
      SessionService.setCustomer(customer!);
      notifyListeners();
    }
  }

  @override
  void removeSelectedPhoto(int index) {
    if (index >= 0 && index < selectedPhotos.length) {
      selectedPhotos.removeAt(index);
      notifyListeners();
    }
  }

  @override
  void updatePage() {
    notifyListeners();
  }
}
