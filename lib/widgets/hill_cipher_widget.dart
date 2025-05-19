import 'package:flutter/material.dart';

class HillCipherWidget extends StatefulWidget {
  HillCipherWidget({
    super.key,
    required this.selectedMatrixSize,
    required this.matrixSizes,
    required this.keyController,
  });

  late String selectedMatrixSize;
  late List<String> matrixSizes;
  final TextEditingController keyController;

  @override
  State<HillCipherWidget> createState() => _HillCipherWidgetState();
}

class _HillCipherWidgetState extends State<HillCipherWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Matrix Size', style: TextStyle(color: Colors.white70)),
        SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: widget.selectedMatrixSize,
          items:
              widget.matrixSizes.map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
          onChanged:
              (value) => setState(() => widget.selectedMatrixSize = value!),
          dropdownColor: Color(0xFF2C2C3E),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFF2C2C3E),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          controller: widget.keyController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Key',
            labelStyle: TextStyle(color: Colors.white70),
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Color(0xFF2C2C3E),
          ),
        ),
      ],
    );
  }
}
