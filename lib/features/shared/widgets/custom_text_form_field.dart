import 'package:flutter/material.dart';


class CustomTextFormField extends StatelessWidget {

  final String? label;
  final String? hint;
  final Icon? prefixIcon;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key, 
    this.label, 
    this.hint, 
    this.errorMessage, 
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged, 
    this.validator, 
    this.prefixIcon, 
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      // borderSide: BorderSide(
      //   color: colors.primary.withValues(alpha: 0.4 ),
      //   width: 1
      // ), 
      borderRadius: BorderRadius.circular(40)
    );

    // const borderRadius = Radius.circular(15);

    return Container(
      // padding: const EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 20),
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
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle( fontSize: 18, color: Colors.black87 ),
        decoration: InputDecoration(
          // prefix icon with size or height
          
          prefixIcon: prefixIcon,

          floatingLabelStyle: const TextStyle(color: Color.fromARGB(255, 116, 116, 116), fontWeight: FontWeight.bold, fontSize: 16),
          enabledBorder: border,
          focusedBorder: border,
          // errorBorder: border.copyWith( borderSide: BorderSide( color: Colors.red.shade800 )),
          // focusedErrorBorder: border.copyWith( borderSide: BorderSide( color: Colors.red.shade800 )),
          // error border only bottom red
          errorBorder: border.copyWith( borderSide: BorderSide( color: Colors.transparent )),
          focusedErrorBorder: border.copyWith( borderSide: BorderSide( color: Colors.transparent )),
          isDense: true,
          label: label != null ? Text(label!) : null,
          hintText: hint,
          hintStyle: const TextStyle( color: Color.fromARGB(255, 101, 101, 101), fontSize: 14 ),
          errorText: errorMessage,
          contentPadding: const EdgeInsets.only(left: 30,),
          errorStyle: const TextStyle( color: Colors.red, fontSize: 12, ),
          focusColor: colors.primary,
          // icon: Icon( Icons.supervised_user_circle_outlined, color: colors.primary, )
        ),
      ),
    );
  }
}
