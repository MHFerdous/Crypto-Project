import 'dart:convert';
import 'dart:math';

const String charset =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 !@#\$%^&*()-_=+[]{}|;:'\",.<>?/\\`~\n\t\r";

String cleanUnsupported(String text) {
  return text.split('').where((c) => charset.contains(c)).join();
}

int charToIndex(String c) {
  int index = charset.indexOf(c);
  if (index == -1) throw Exception("Unsupported character: '$c'");
  return index;
}

String indexToChar(int i) {
  return charset[i % charset.length];
}

String generateKey(int length) {
  final rand = Random.secure();
  return List.generate(
    length,
    (_) => charset[rand.nextInt(charset.length)],
  ).join();
}

String vernamEncrypt(String plaintext, String key) {
  if (plaintext.length != key.length) {
    throw Exception("Key length must match plaintext length.");
  }
  return List.generate(plaintext.length, (i) {
    int p = charToIndex(plaintext[i]);
    int k = charToIndex(key[i]);
    return indexToChar((p + k) % charset.length);
  }).join();
}

String vernamDecrypt(String ciphertext, String key) {
  if (ciphertext.length != key.length) {
    throw Exception("Key length must match ciphertext length.");
  }
  return List.generate(ciphertext.length, (i) {
    int c = charToIndex(ciphertext[i]);
    int k = charToIndex(key[i]);
    return indexToChar((c - k + charset.length) % charset.length);
  }).join();
}

String encodeBase64(String text) => base64Encode(utf8.encode(text));

String decodeBase64(String encoded) => utf8.decode(base64Decode(encoded));

String encryptRailFence(String text, int key) {
  if (key <= 1 || text.isEmpty) return text;
  List<StringBuffer> rails = List.generate(key, (_) => StringBuffer());
  int row = 0;
  bool directionDown = false;
  for (var char in text.runes) {
    rails[row].write(String.fromCharCode(char));
    if (row == 0 || row == key - 1) directionDown = !directionDown;
    row += directionDown ? 1 : -1;
  }
  return rails.map((sb) => sb.toString()).join();
}

String decryptRailFence(String cipher, int key) {
  if (key <= 1 || cipher.isEmpty) return cipher;
  List<int> pattern = List.filled(cipher.length, 0);
  int row = 0;
  bool directionDown = false;
  for (int i = 0; i < cipher.length; i++) {
    pattern[i] = row;
    if (row == 0 || row == key - 1) directionDown = !directionDown;
    row += directionDown ? 1 : -1;
  }
  List<int> rowCounts = List.filled(key, 0);
  for (var r in pattern) {
    rowCounts[r]++;
  }
  List<List<String>> rows = List.generate(key, (_) => []);
  int index = 0;
  for (int r = 0; r < key; r++) {
    rows[r] = cipher.substring(index, index + rowCounts[r]).split('');
    index += rowCounts[r];
  }
  List<int> rowIndices = List.filled(key, 0);
  return List.generate(cipher.length, (i) {
    int r = pattern[i];
    return rows[r][rowIndices[r]++];
  }).join();
}

String caesarEncrypt(String text, int shift) {
  return text.split('').map((char) {
    int code = char.codeUnitAt(0);
    if (code >= 32 && code <= 126) {
      return String.fromCharCode(((code - 32 + shift) % 95) + 32);
    } else {
      return char;
    }
  }).join();
}

String caesarDecrypt(String cipher, int shift) {
  return caesarEncrypt(cipher, -shift % 95);
}
