import 'package:flutter/material.dart';

class VernamCipherWidget extends StatefulWidget {
  const VernamCipherWidget({
    super.key,
    required this.isEncrypt,
    required this.keyController,
  });

  final bool isEncrypt;
  final TextEditingController keyController;

  @override
  State<VernamCipherWidget> createState() => _VernamCipherWidgetState();
}

class _VernamCipherWidgetState extends State<VernamCipherWidget> {
  @override
  Widget build(BuildContext context) {
    {
      if (!widget.isEncrypt) {
        return TextFormField(
          controller: widget.keyController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Enter Key (Base64)',
            labelStyle: TextStyle(color: Colors.white70),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Color(0xFF2C2C3E),
          ),
        );
      }
      return SizedBox.shrink();
    }
  }
}
