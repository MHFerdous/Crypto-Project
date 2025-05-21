import 'package:crypto_project/widgets/caesar_cipher_widget.dart';
import 'package:crypto_project/widgets/cipher_calculation.dart';
import 'package:crypto_project/widgets/hill_cipher_widget.dart';
import 'package:crypto_project/widgets/rail_fence_cipher_widget.dart';
import 'package:crypto_project/widgets/vernam_cipher_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCipher = 'Rail Fence Cipher';
  final List<String> ciphers = [
    'Rail Fence Cipher',
    'Hill Cipher',
    'Caesar Cipher',
    'Vernam Cipher',
  ];

  final List<String> hillTypes = ['Classic Hill Cipher (A-Z only)'];
  final String _selectedMatrixSize = '2x2';

  final List<String> _matrixSizes = ['2x2', '3x3'];

  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final int _shift = 3;
  final int _rails = 2;
  bool _isEncrypt = true;
  String _result = '';
  bool _showResult = false;

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        drawer: _buildDrawer(),
        appBar: AppBar(
          title: Text('🔐 Cipher Tools'),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Color(0xFF121212),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
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
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                TextFormField(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Text';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildCipherSpecificInputs(),

                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _buildCipherSpecificOutputs();
                      _showResult = true;
                      ResultWidget(result: _result);
                    }
                  },
                  icon: Icon(_isEncrypt ? Icons.lock : Icons.lock_open),
                  label: Text(_isEncrypt ? 'Encrypt' : 'Decrypt'),
                ),
                SizedBox(height: 32),
                Visibility(
                  visible: _showResult,
                  child: SelectableText(
                    _result,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCipherSpecificInputs() {
    switch (selectedCipher) {
      case 'Rail Fence Cipher':
        return RailFenceCipherWidget(rails: _rails);

      case 'Hill Cipher':
        return HillCipherWidget(
          selectedMatrixSize: _selectedMatrixSize,
          matrixSizes: _matrixSizes,
          keyController: _keyController,
        );

      case 'Caesar Cipher':
        return CaesarCipherWidget(shift: _shift);

      case 'Vernam Cipher':
        return VernamCipherWidget(
          isEncrypt: _isEncrypt,
          keyController: _keyController,
        );

      default:
        return SizedBox.shrink();
    }
  }

  void _buildCipherSpecificOutputs() {
    switch (selectedCipher) {
      case 'Rail Fence Cipher':
        return _railFenceOutput();

      case 'Hill Cipher':
        return _hillCipherOutput();

      case 'Caesar Cipher':
        return _caesarOutput();

      case 'Vernam Cipher':
        return _vernamOutput();
    }
  }

  void _railFenceOutput() {
    try {
      String output =
          _isEncrypt
              ? encryptRailFence(_inputController.text, _rails)
              : decryptRailFence(_inputController.text, _rails);
      setState(() {
        _result = _isEncrypt ? 'Encrypted: $output' : 'Decrypted: $output';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.toString()}';
      });
    }
  }

  void _hillCipherOutput() {
    try {
      int matrixSize = _selectedMatrixSize == '2x2' ? 2 : 3;

      String output =
          _isEncrypt
              ? hillEncrypt(
                _inputController.text,
                _keyController.text,
                matrixSize,
              )
              : hillDecrypt(
                _inputController.text,
                _keyController.text,
                matrixSize,
              );

      setState(() {
        _result = _isEncrypt ? 'Encrypted: $output' : 'Decrypted: $output';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.toString()}';
      });
    }

    setState(() {});
  }

  void _caesarOutput() {
    try {
      String output =
          _isEncrypt
              ? caesarEncrypt(_inputController.text, _shift)
              : caesarDecrypt(_inputController.text, _shift);
      setState(() {
        _result = _isEncrypt ? 'Encrypted: $output' : 'Decrypted: $output';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.toString()}';
      });
    }
  }

  void _vernamOutput() {
    try {
      if (_isEncrypt) {
        _inputController.text = cleanUnsupported(_inputController.text);
        _keyController.text = generateKey(_inputController.text.length);
        String encrypted = vernamEncrypt(
          _inputController.text,
          _keyController.text,
        );
        setState(() {
          _result =
              'Encrypted: ${encodeBase64(encrypted)}\nKey: ${encodeBase64(_keyController.text)}';
        });
      } else {
        String decrypted = vernamDecrypt(
          decodeBase64(_inputController.text),
          decodeBase64(_keyController.text),
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
                    _showResult = false;
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
}

class ResultWidget extends StatelessWidget {
  const ResultWidget({super.key, required String result}) : _result = result;

  final String _result;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 32),
        SelectableText(_result, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
