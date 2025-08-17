import 'package:equatable/equatable.dart';

class SelectItem<T> extends Equatable {
  final T value;
  final String title;

  const SelectItem({required this.value, required this.title});

  @override
  List<Object?> get props => [value, title];

  @override
  bool? get stringify => true;
}
