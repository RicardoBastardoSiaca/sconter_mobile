import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasajerosInputFormField extends StatelessWidget {
  const PasajerosInputFormField({
    super.key,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    required this.initialValue,
    // required this.controller,
    // required this.labelText,
    // required this.hintText
  });

  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  // initialValue
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    // _controller
    TextEditingController controller = TextEditingController();
    final colors = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      // borderSide: BorderSide(
      //   color: colors.primary.withValues(alpha: 0.4 ),
      //   width: 1
      // ),
      borderRadius: BorderRadius.circular(5),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        // width: 50,
        height: 40,
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Center(
          child: TextFormField(
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'^(0|[1-9][0-9]*)$')),
            // ],
            // controller: controller
            textAlign: TextAlign.end,
            initialValue: '0',
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            // Set cursor at the end of the text on tap
            // onTap: () => controller.selection = TextSelection.fromPosition(
            //   TextPosition(offset: controller.text.length),
            // ),
            // controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length)),

            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            // inputFormatters: <TextInputFormatter>[
            //   FilteringTextInputFormatter.digitsOnly,
            // ],

            // Set cursor at the end of the text

            // TODO: Set cursor at the end of the text on tap
            // onTap: () => controller.selection = TextSelection.fromPosition(
            //   TextPosition(offset: controller.text.length),
            // ),
            style: const TextStyle(fontSize: 18, color: Colors.black87),
            decoration: InputDecoration(
              // prefix icon with size or height
              floatingLabelStyle: const TextStyle(
                color: Color.fromARGB(255, 116, 116, 116),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              enabledBorder: border,
              focusedBorder: border,
              // errorBorder: border.copyWith( borderSide: BorderSide( color: Colors.red.shade800 )),
              // focusedErrorBorder: border.copyWith( borderSide: BorderSide( color: Colors.red.shade800 )),
              // error border only bottom red
              errorBorder: border.copyWith(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedErrorBorder: border.copyWith(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              isDense: true,
              // hintStyle: const TextStyle( color: Color.fromARGB(255, 101, 101, 101), fontSize: 14 ),
              errorText: errorMessage,
              // contentPadding: const EdgeInsets.only(left: 30,),
              errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
              focusColor: colors.primary,
              // icon: Icon( Icons.supervised_user_circle_outlined, color: colors.primary, )
            ),
          ),
        ),
      ),
    );
  }
}
