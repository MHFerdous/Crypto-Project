import 'package:flutter/material.dart';
import 'cipher_calculation.dart';

class RailFenceCipherWidget extends StatefulWidget {
  const RailFenceCipherWidget({super.key});

  @override
  _RailFenceCipherWidgetState createState() => _RailFenceCipherWidgetState();
}

class _RailFenceCipherWidgetState extends State<RailFenceCipherWidget> {
  final TextEditingController _inputController = TextEditingController();
  int _rails = 3;
  String _result = '';
  bool _isEncrypt = true;

  void _process() {
    String input = _inputController.text;

    try {
      String output = _isEncrypt
          ? encryptRailFence(input, _rails)
          : decryptRailFence(input, _rails);
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
              Text('Number of Rails:'),
              SizedBox(width: 10),
              DropdownButton<int>(
                value: _rails,
                items: List.generate(10, (index) => index + 2)
                    .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text('$e'),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _rails = val!;
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
