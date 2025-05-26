import 'package:crypto_project/other_files/cipher_calculation.dart';
import 'package:crypto_project/screens/about_developers_screen.dart';
import 'package:crypto_project/screens/rail_fence_cipher.dart';
import 'package:crypto_project/screens/varnam_cipher_screen.dart';
import 'package:crypto_project/screens/widgets/build_appbar.dart';
import 'package:crypto_project/screens/widgets/button_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'caesar_cipher_screen.dart';

class HillCipherScreen extends StatefulWidget {
  const HillCipherScreen({super.key});

  @override
  State<HillCipherScreen> createState() => _HillCipherScreenState();
}

class _HillCipherScreenState extends State<HillCipherScreen> {
  String _selectedCipher = 'Hill Cipher';
  final List<String> _ciphers = [
    'Rail Fence Cipher',
    'Hill Cipher',
    'Caesar Cipher',
    'Vernam Cipher',
  ];

  String _selectedMatrixSize = '2x2';

  final List<String> _matrixSizes = ['2x2', '3x3'];

  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isEncrypt = true;
  String _resultText = '';
  bool _showResult = false;
  bool _isError = false;

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
        appBar: buildAppBar(context),
        backgroundColor: Color(0xFF121212),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  '🔺 $_selectedCipher',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),
                Text('Action'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: _isEncrypt,
                      onChanged: (val) {
                        setState(() {
                          _isEncrypt = val!;
                          _showResult = false;
                          _inputController.clear();
                          _keyController.clear();
                        });
                      },
                    ),
                    Text('Encrypt'),
                    Radio(
                      value: false,
                      groupValue: _isEncrypt,
                      onChanged: (val) {
                        setState(() {
                          _isEncrypt = val!;
                          _showResult = false;
                          _inputController.clear();
                          _keyController.clear();
                        });
                      },
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
                        _isEncrypt ? 'Enter Plaintext' : 'Enter Ciphertext',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Text';
                    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return "Unsupported characters detected in Text!\nAllowed characters: 'A-Z' and 'a-z' for Classic Hill Cipher.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Text('Matrix Size', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: _selectedMatrixSize,
                  items:
                      _matrixSizes.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                  onChanged:
                      (value) => setState(() => _selectedMatrixSize = value!),
                  dropdownColor: Color(0xFF2C2C3E),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _keyController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'Key'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Key';
                    } else if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return "Unsupported characters detected in Key!\nAllowed characters: 'A-Z' and 'a-z' for Classic Hill Cipher.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _hillCipherOutput();
                      _showResult = true;
                    }
                  },
                  icon: Icon(_isEncrypt ? Icons.lock : Icons.lock_open),
                  label: Text(_isEncrypt ? 'Encrypt' : 'Decrypt'),
                ),
                SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: _showResult && !_isError,
                    child: Card(
                      color: Colors.green.shade900,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child:
                            _isEncrypt
                                ? Text(
                                  'Encryption Successful!',
                                  style: TextStyle(color: Colors.white),
                                )
                                : Text(
                                  'Decryption Successful!',
                                  style: TextStyle(color: Colors.white),
                                ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Visibility(
                  visible: _showResult,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isEncrypt ? Text('CipherText:') : Text('PlainText'),
                      SizedBox(height: 4),
                      Card(
                        color: Color(0xFF2C2C3E),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SelectableText(
                                  _resultText,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.copy, color: Colors.white),
                                tooltip: 'Copy',
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: _resultText),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Copied to clipboard'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ButtonTextWidget(),
              ],
            ),
          ),
        ),
      ),
    );
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
        _resultText = _isEncrypt ? output : output;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _resultText = 'Error: ${e.toString()}';
      });
    }

    setState(() {});
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Color(0xFF1E1E2C),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          children: [
            const SizedBox(height: 48),
            Text(
              'Choose a Cipher',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            for (final cipher in _ciphers)
              RadioListTile(
                title: Text(cipher, style: TextStyle(color: Colors.white)),
                value: cipher,
                groupValue: _selectedCipher,
                onChanged: (value) {
                  setState(() {
                    _selectedCipher = value!;
                    _inputController.clear();
                    _keyController.clear();
                    _showResult = false;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (cipher == 'Rail Fence Cipher') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RailFenceCipherScreen(),
                          ),
                        );
                      } else if (cipher == 'Hill Cipher') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HillCipherScreen(),
                          ),
                        );
                      }
                      if (cipher == 'Caesar Cipher') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CaesarCipherScreen(),
                          ),
                        );
                      }
                      if (cipher == 'Vernam Cipher') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VernamCipherScreen(),
                          ),
                        );
                      }
                    });
                  });
                  Navigator.pop(context);
                },
              ),
            Divider(color: Colors.white24),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AboutDevelopersScreen()),
                );
              },
              child: Text('About Us'),
            ),
          ],
        ),
      ),
    );
  }
}
