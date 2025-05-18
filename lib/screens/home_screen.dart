import 'package:crypto_project/widgets/cipher_calculation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCipher = 'Vernam Cipher';
  final List<String> ciphers = [
    'Vernam Cipher',
    'Rail Fence Cipher',
    'Caesar Cipher',
    'Hill Cipher',
  ];

  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final List<TextEditingController> _matrixControllers = List.generate(
    9,
    (_) => TextEditingController(),
  );

  int _shift = 3;
  int _rails = 2;
  bool _isEncrypt = true;
  String _result = '';

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    for (var controller in _matrixControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: Text('🔐 Cipher Tools'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Color(0xFF121212),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Text(
                '✨ $selectedCipher',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Text('Action'),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: _isEncrypt,
                    onChanged: (val) => setState(() => _isEncrypt = val!),
                  ),
                  Text('Encrypt'),
                  Radio(
                    value: false,
                    groupValue: _isEncrypt,
                    onChanged: (val) => setState(() => _isEncrypt = val!),
                  ),
                  Text('Decrypt'),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _inputController,
                style: TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: InputDecoration(
                  labelText:
                      _isEncrypt
                          ? 'Enter Plaintext'
                          : (selectedCipher == 'Vernam Cipher'
                              ? 'Encrypted (Base64)'
                              : 'Enter Ciphertext'),
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFF2C2C3E),
                ),
              ),
              const SizedBox(height: 16),
              _buildCipherSpecificInputs(),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _process,
                icon: Icon(Icons.lock),
                label: Text(_isEncrypt ? 'Encrypt' : 'Decrypt'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 32),
              SelectableText(
                _result,
                style: TextStyle(color: Colors.greenAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCipherSpecificInputs() {
    switch (selectedCipher) {
      case 'Caesar Cipher':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shift Amount:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (_shift > 1) setState(() => _shift--);
                  },
                ),
                Text('$_shift'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_shift < 25) setState(() => _shift++);
                  },
                ),
              ],
            ),
          ],
        );
      case 'Rail Fence Cipher':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Number of Rails:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (_rails > 2) setState(() => _rails--);
                  },
                ),
                Text('$_rails'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_rails < 10) setState(() => _rails++);
                  },
                ),
              ],
            ),
          ],
        );
      case 'Vernam Cipher':
        if (!_isEncrypt) {
          return TextField(
            controller: _keyController,
            decoration: InputDecoration(labelText: 'Key (Base64)'),
          );
        }
        return SizedBox.shrink();
      case 'Hill Cipher':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Matrix (3x3):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: List.generate(9, (index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    controller: _matrixControllers[index],
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF2C2C3E),
                      border: OutlineInputBorder(),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Color(0xFF1E1E2C),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          children: [
            const SizedBox(height: 40),
            Text(
              'Choose a Cipher',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            for (final cipher in ciphers)
              RadioListTile(
                title: Text(cipher, style: TextStyle(color: Colors.white)),
                value: cipher,
                groupValue: selectedCipher,
                onChanged: (value) {
                  setState(() {
                    selectedCipher = value!;
                    _inputController.clear();
                    _keyController.clear();
                    _result = '';
                  });
                  Navigator.pop(context);
                },
              ),
            Divider(color: Colors.white24),
            const SizedBox(height: 10),
            Text(
              'Made with ❤️ by\nFerdous, Nadim, Hasan & Sayem',
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _process() {
    String input = _inputController.text;

    try {
      String output = '';
      switch (selectedCipher) {
        case 'Vernam Cipher':
          if (_isEncrypt) {
            String cleanInput = cleanUnsupported(input);
            String key = generateKey(cleanInput.length);
            String encrypted = vernamEncrypt(cleanInput, key);
            _result =
                'Encrypted: ${encodeBase64(encrypted)}\nKey: ${encodeBase64(key)}';
          } else {
            String decodedInput = decodeBase64(input);
            String decodedKey = decodeBase64(_keyController.text);
            String decrypted = vernamDecrypt(decodedInput, decodedKey);
            _result = 'Decrypted: $decrypted';
          }
          break;
        case 'Caesar Cipher':
          output =
              _isEncrypt
                  ? caesarEncrypt(input, _shift)
                  : caesarDecrypt(input, _shift);
          _result = _isEncrypt ? 'Encrypted: $output' : 'Decrypted: $output';
          break;
        case 'Rail Fence Cipher':
          output =
              _isEncrypt
                  ? encryptRailFence(input, _rails)
                  : decryptRailFence(input, _rails);
          _result = _isEncrypt ? 'Encrypted: $output' : 'Decrypted: $output';
          break;
        case 'Hill Cipher':
          List<List<int>> keyMatrix = List.generate(
            3,
            (i) => List.generate(3, (j) {
              int val = int.tryParse(_matrixControllers[i * 3 + j].text) ?? 0;
              return val;
            }),
          );
          /*if (_isEncrypt) {
            output = hillEncrypt(input, keyMatrix);
            _result = 'Encrypted: $output';
          } else {
            output = hillDecrypt(input, keyMatrix);
            _result = 'Decrypted: $output';
          }*/
          break;
      }
    } catch (e) {
      _result = 'Error: ${e.toString()}';
    }

    setState(() {});
  }
}
