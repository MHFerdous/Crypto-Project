import 'package:flutter/material.dart';
import 'cipher_calculation.dart';

class VernamCipherWidget extends StatefulWidget {
  const VernamCipherWidget({super.key});

  @override
  _VernamCipherWidgetState createState() => _VernamCipherWidgetState();
}

class _VernamCipherWidgetState extends State<VernamCipherWidget> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  String _result = '';
  bool _isEncrypt = true;

  void _process() {
    String input = _inputController.text;
    String key = _keyController.text;

    try {
      if (_isEncrypt) {
        input = cleanUnsupported(input);
        key = generateKey(input.length);
        String encrypted = vernamEncrypt(input, key);
        setState(() {
          _result =
              'Encrypted: ${encodeBase64(encrypted)}\nKey: ${encodeBase64(key)}';
        });
      } else {
        String decrypted = vernamDecrypt(
          decodeBase64(input),
          decodeBase64(key),
        );
        setState(() {
          _result = 'Decrypted: $decrypted';
        });
      }
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
              labelText: _isEncrypt ? 'Plaintext' : 'Encrypted (Base64)',
            ),
          ),
          if (!_isEncrypt)
            TextField(
              controller: _keyController,
              decoration: InputDecoration(labelText: 'Key (Base64)'),
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
