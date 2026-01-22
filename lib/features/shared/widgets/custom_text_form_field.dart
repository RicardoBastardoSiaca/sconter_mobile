import 'package:flutter/material.dart';


class CustomTextFormField extends StatefulWidget {

  final String? label;
  final String? hint;
  final Icon? prefixIcon;
  final String? errorMessage;
  final bool obscureText;
  final bool showHidePassword;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.showHidePassword = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.onFieldSubmitted,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40)
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),   
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0,5)
          )
        ]
      ),
      child: TextFormField(
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: widget.validator,
        obscureText: _obscureText,
        keyboardType: widget.keyboardType,
        style: const TextStyle( fontSize: 18, color: Colors.black87 ),
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          floatingLabelStyle: const TextStyle(color: Color.fromARGB(255, 116, 116, 116), fontWeight: FontWeight.bold, fontSize: 16),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith( borderSide: BorderSide( color: Colors.transparent )),
          focusedErrorBorder: border.copyWith( borderSide: BorderSide( color: Colors.transparent )),
          isDense: true,
          label: widget.label != null ? Text(widget.label!) : null,
          hintText: widget.hint,
          hintStyle: const TextStyle( color: Color.fromARGB(255, 101, 101, 101), fontSize: 14 ),
          errorText: widget.errorMessage,
          contentPadding: const EdgeInsets.only(left: 30,),
          errorStyle: const TextStyle( color: Colors.red, fontSize: 12, ),
          focusColor: colors.primary,
          suffixIcon: widget.showHidePassword ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          ) : null,
        ),
      ),
    );
  }
}
