import 'package:flutter/material.dart';

class _NumberInputDialog extends StatefulWidget {
  final String title;
  final String? initialValue;
  final String hintText;
  final String confirmText;
  final String cancelText;
  final ValueChanged<String>? onSaved;

  const _NumberInputDialog({
    // super.key,
    required this.title,
    this.initialValue,
    this.hintText = 'Ingrese cantidad',
    this.confirmText = 'Guardar',
    this.cancelText = 'Cancelar',
    this.onSaved,
  });

  @override
  _NumberInputDialogState createState() => _NumberInputDialogState();
}
class _NumberInputDialogState extends State<_NumberInputDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
    _controller.addListener(_validateInput);
    _validateInput();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateInput() {
    final text = _controller.text;
    final isValid = text.isNotEmpty && 
                   double.tryParse(text) != null && 
                   double.parse(text) > 0;
    
    setState(() {
      _isValid = isValid;
    });
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_controller.text);
      widget.onSaved?.call(_controller.text);
    }
  }

  void _onCancel() {
    Navigator.of(context).pop(null);
  }

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese una cantidad';
    }
    
    final number = double.tryParse(value);
    if (number == null) {
      return 'Ingrese un número válido';
    }
    
    if (number < 0) {
      return 'Numero debe ser mayor positivo';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
          validator: _validator,
          onChanged: (value) => _validateInput(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _onCancel,
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[700],
          ),
          child: Text(widget.cancelText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ),
        ElevatedButton(
          onPressed: _isValid ? _onSave : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(widget.confirmText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ),
      ],
    );
  }
}



Future<String?> showNumberInputDialog({
  required BuildContext context,
  required String title,
  String? initialValue,
  String hintText = 'Ingrese cantidad',
  String confirmText = 'Guardar',
  String cancelText = 'Cancelar',
  ValueChanged<String>? onSaved,
}) async {
  return showDialog<String>(
    context: context,
    builder: (context) => _NumberInputDialog(
      title: title,
      initialValue: initialValue,
      hintText: hintText,
      confirmText: confirmText,
      cancelText: cancelText,
      onSaved: onSaved,
    ),
  );
}

