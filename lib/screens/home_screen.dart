import 'package:crypto_project/screens/about_developers_screen.dart';
import 'package:crypto_project/widgets/caesar_cipher_widget.dart';
import 'package:crypto_project/widgets/cipher_calculation.dart';
import 'package:crypto_project/widgets/hill_cipher_widget.dart';
import 'package:crypto_project/widgets/rail_fence_cipher_widget.dart';
import 'package:crypto_project/widgets/vernam_cipher_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth/login_screen.dart';

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

  final String _selectedMatrixSize = '2x2';

  final List<String> _matrixSizes = ['2x2', '3x3'];

  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final int _shift = 3;
  final int _rails = 2;
  bool _isEncrypt = true;
  String _resultText = '';
  String _resultKey = '';
  bool _showResult = false;

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _logOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (context) =>
                            const Center(child: CircularProgressIndicator()),
                  );

                  await Future.delayed(const Duration(seconds: 2));

                  try {
                    await Supabase.instance.client.auth.signOut();
                    navigator.pop();
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text('Logged out...')),
                    );
                    navigator.pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  } catch (e) {
                    navigator.pop();
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text('Error signing out: $e')),
                    );
                  }
                },
                child: const Text('Yes'),
              ),
            ],
          ),
    );
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
          title: Text('Cipher Tools'),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: () {
                _logOut(context);
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        backgroundColor: Color(0xFF121212),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                CipherHeading(selectedCipher: selectedCipher),

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
                        _isEncrypt
                            ? 'Enter Plaintext'
                            : (selectedCipher == 'Vernam Cipher'
                                ? 'Encrypted (Base64)'
                                : 'Enter Ciphertext'),
                    labelStyle: TextStyle(color: Colors.white70),
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
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _buildCipherSpecificOutputs();
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
                    visible: _showResult,
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
                  child:
                      (_isEncrypt && selectedCipher == 'Vernam Cipher')
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CipherText:'),
                              SizedBox(height: 4),
                              Card(
                                color: Color(0xFF2C2C3E),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: SelectableText(
                                          _resultText,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.copy,
                                          color: Colors.white,
                                        ),
                                        tooltip: 'Copy',
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(text: _resultText),
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Copied to clipboard',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Generated Key:'),
                              SizedBox(height: 4),
                              Card(
                                color: Color(0xFF2C2C3E),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: SelectableText(
                                          _resultKey,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.copy,
                                          color: Colors.white,
                                        ),
                                        tooltip: 'Copy',
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(text: _resultKey),
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Copied to clipboard',
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _isEncrypt
                                  ? Text('CipherText:')
                                  : Text('PlainText'),
                              SizedBox(height: 4),
                              Card(
                                color: Color(0xFF2C2C3E),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: SelectableText(
                                          _resultText,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.copy,
                                          color: Colors.white,
                                        ),
                                        tooltip: 'Copy',
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(text: _resultText),
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Copied to clipboard',
                                              ),
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
        _resultText = _isEncrypt ? output : output;
      });
    } catch (e) {
      setState(() {
        _resultText = 'Error: ${e.toString()}';
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
        _resultText = _isEncrypt ? output : output;
      });
    } catch (e) {
      setState(() {
        _resultText = 'Error: ${e.toString()}';
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
        _resultText = _isEncrypt ? output : output;
      });
    } catch (e) {
      setState(() {
        _resultText = 'Error: ${e.toString()}';
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
          _resultText = ' ${encodeBase64(encrypted)}';
          _resultKey = ' ${encodeBase64(_keyController.text)}';
        });
      } else {
        String decrypted = vernamDecrypt(
          decodeBase64(_inputController.text),
          decodeBase64(_keyController.text),
        );
        setState(() {
          _resultText = decrypted;
        });
      }
    } catch (e) {
      setState(() {
        _resultText = 'Error: ${e.toString()}';
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

class CipherHeading extends StatelessWidget {
  const CipherHeading({super.key, required this.selectedCipher});

  final String selectedCipher;

  @override
  Widget build(BuildContext context) {
    return Text(
      '✨ $selectedCipher',
      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    );
  }
}
