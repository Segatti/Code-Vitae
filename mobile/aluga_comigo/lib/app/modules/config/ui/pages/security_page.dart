import 'package:aluga_comigo/app/shared/presenter/helpers/feed_session_helper.dart';
import 'package:aluga_comigo/app/shared/data/services/secure_storage_service.dart';
import 'package:aluga_comigo/app/shared/data/services/session_service.dart';
import 'package:aluga_comigo/app/shared/data/services/supabase_auth_service.dart';
import 'package:aluga_comigo/app/shared/data/services/supabase_database_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:material_ui/material_ui.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  late final SupabaseAuthService _auth;
  late final SecureStorageService _storage;
  late final SupabaseDatabaseService _database;

  @override
  void initState() {
    super.initState();
    _auth = inject<SupabaseAuthService>();
    _storage = inject<SecureStorageService>();
    _database = inject<SupabaseDatabaseService>();
  }

  String get _email => SessionService.customer?.email ?? '';

  Future<void> _changePassword() async {
    if (_email.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alterar senha'),
        content: Text(
          'Enviaremos um link de redefinição para $_email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Enviar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final result = await _auth.recoverPassword(_email);
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Link de redefinição enviado para seu e-mail.'),
          ),
        );
      },
    );
  }

  Future<void> _hideAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Esconder conta'),
        content: const Text(
          'Seu perfil ficará invisível para outros usuários. '
          'Você pode reativar fazendo login novamente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Esconder'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _database.setAccountActive(false);
      await _logout(showMessage: 'Conta ocultada com sucesso.');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao ocultar conta')),
      );
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apagar conta'),
        content: const Text(
          'Esta ação é permanente. Todos os seus dados serão removidos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await _auth.deleteCurrentUser();
    await _logout(showMessage: 'Conta apagada.');
  }

  Future<void> _logout({String? showMessage}) async {
    await _auth.signOut();
    await _storage.deleteData(StorageKey.user);
    FeedSessionHelper.resetSwipeFeeds();
    SessionService.clearCustomer();
    if (!mounted) return;
    if (showMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(showMessage)),
      );
    }
    context.navigate('/auth/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.chevron_left,
            size: 40,
            color: Colors.grey,
          ),
        ),
        titleSpacing: 0,
        title: Text(
          'Segurança',
          style: GoogleFonts.rubik(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          const Divider(height: 2, thickness: 2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Email',
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFEFEFEF),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Text(
                            _email.isEmpty ? '—' : _email,
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2C29A3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _email.isEmpty ? null : _changePassword,
                          child: Text(
                            'Alterar minha senha',
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2C29A3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _hideAccount,
                          child: Text(
                            'Esconder conta',
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD72323),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _deleteAccount,
                          child: Text(
                            'Apagar conta',
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
