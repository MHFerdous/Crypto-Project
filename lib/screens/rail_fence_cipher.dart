import 'package:crypto_project/other_files/cipher_calculation.dart';
import 'package:crypto_project/screens/about_developers_screen.dart';
import 'package:crypto_project/screens/varnam_cipher_screen.dart';
import 'package:crypto_project/screens/widgets/build_appbar.dart';
import 'package:crypto_project/screens/widgets/button_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'caesar_cipher_screen.dart';
import 'hill_cipher_screen.dart';

class RailFenceCipherScreen extends StatefulWidget {
  const RailFenceCipherScreen({super.key});

  @override
  State<RailFenceCipherScreen> createState() => _RailFenceCipherScreenState();
}

class _RailFenceCipherScreenState extends State<RailFenceCipherScreen> {
  String _selectedCipher = 'Rail Fence Cipher';
  final List<String> _ciphers = [
    'Rail Fence Cipher',
    'Hill Cipher',
    'Caesar Cipher',
    'Vernam Cipher',
  ];

  final TextEditingController _inputController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _rails = 2;
  bool _isEncrypt = true;
  String _resultText = '';
  bool _showResult = false;
  bool _isError = false;

  @override
  void dispose() {
    _inputController.dispose();
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
                  '🚉 $_selectedCipher',
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
                            : (_selectedCipher == 'Vernam Cipher'
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
                        if (_rails < 26) setState(() => _rails++);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _railFenceOutput();
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
        _isError = true;
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
            for (final cipher in _ciphers)
              RadioListTile(
                title: Text(cipher, style: TextStyle(color: Colors.white)),
                value: cipher,
                groupValue: _selectedCipher,
                onChanged: (value) {
                  setState(() {
                    _selectedCipher = value!;
                    _inputController.clear();
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
