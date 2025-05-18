import 'package:flutter/material.dart';
import 'cipher_calculation.dart';

class CaesarCipherWidget extends StatefulWidget {
  const CaesarCipherWidget({super.key});

  @override
  _CaesarCipherWidgetState createState() => _CaesarCipherWidgetState();
}

class _CaesarCipherWidgetState extends State<CaesarCipherWidget> {
  final TextEditingController _inputController = TextEditingController();
  int _shift = 3;
  String _result = '';
  bool _isEncrypt = true;

  void _process() {
    String input = _inputController.text;

    try {
      String output = _isEncrypt
          ? caesarEncrypt(input, _shift)
          : caesarDecrypt(input, _shift);
      setState(() {
        _result = _isEncrypt ? 'Encrypted: $output' : 'Decrypted: $output';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SwitchListTile(
            title: Text(_isEncrypt ? 'Encrypt' : 'Decrypt'),
            value: _isEncrypt,
            onChanged: (val) {
              setState(() {
                _isEncrypt = val;
              });
            },
          ),
          TextField(
            controller: _inputController,
            decoration: InputDecoration(
              labelText: _isEncrypt ? 'Plaintext' : 'Ciphertext',
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text('Shift:'),
              SizedBox(width: 10),
              DropdownButton<int>(
                value: _shift,
                items: List.generate(25, (index) => index + 1)
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text('$e'),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _shift = val!;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _process,
            child: Text(_isEncrypt ? 'Encrypt' : 'Decrypt'),
          ),
          SizedBox(height: 32),
          SelectableText(_result),
        ],
      ),
    );
  }
}
