import 'package:aluga_comigo/app/modules/auth/presenter/helpers/signup_access_validation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class SignupPasswordField extends StatefulWidget {
  const SignupPasswordField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  State<SignupPasswordField> createState() => _SignupPasswordFieldState();
}

class _SignupPasswordFieldState extends State<SignupPasswordField> {
  var _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: const ValueKey('signup_password_field'),
      controller: widget.controller,
      onChanged: widget.onChanged,
      validator: SignupAccessValidation.passwordError,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        hintText: 'Senha',
        hintStyle: GoogleFonts.rubik(fontSize: 18),
        errorStyle: const TextStyle(fontSize: 0),
        suffixIcon: IconButton(
          tooltip: _obscureText ? 'Mostrar senha' : 'Ocultar senha',
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
        contentPadding: const EdgeInsets.only(
          left: 24.0,
          bottom: 8.0,
          top: 8.0,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(25.7),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(25.7),
        ),
      ),
    );
  }
}
