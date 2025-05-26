import 'dart:convert';
import 'dart:math';

const String charset =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 !@#\$%^&*()-_=+[]{}|;:'\",.<>?/\\`~\n\t\r";
const String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

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

// Hill Cipher Implementation

List<int> textToNumbers(String text, String charset) {
  return text.split('').map((c) => charset.indexOf(c)).toList();
}

String numbersToText(List<int> numbers, String charset) {
  return numbers.map((n) => charset[n % charset.length]).join();
}

int modInverse(int a, int m) {
  a = a % m;
  for (int x = 1; x < m; x++) {
    if ((a * x) % m == 1) return x;
  }
  throw Exception("Modular inverse does not exist.");
}

List<List<int>> matrixModInverse(List<List<int>> matrix, int modulus) {
  int n = matrix.length;
  int det = determinant(matrix) % modulus;
  if (det == 0) throw Exception("Matrix is not invertible.");
  int detInv = modInverse(det, modulus);
  List<List<int>> adj = adjugate(matrix);
  return List.generate(n, (i) {
    return List.generate(n, (j) {
      return (adj[i][j] * detInv) % modulus;
    });
  });
}

int determinant(List<List<int>> matrix) {
  int n = matrix.length;
  if (n == 2) {
    return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0];
  } else if (n == 3) {
    int a = matrix[0][0],
        b = matrix[0][1],
        c = matrix[0][2],
        d = matrix[1][0],
        e = matrix[1][1],
        f = matrix[1][2],
        g = matrix[2][0],
        h = matrix[2][1],
        i = matrix[2][2];
    return a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g);
  } else {
    throw Exception("Only 2x2 and 3x3 matrices are supported.");
  }
}

List<List<int>> adjugate(List<List<int>> matrix) {
  int n = matrix.length;
  if (n == 2) {
    return [
      [matrix[1][1], -matrix[0][1]],
      [-matrix[1][0], matrix[0][0]],
    ];
  } else if (n == 3) {
    List<List<int>> adj = List.generate(3, (_) => List.filled(3, 0));
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        List<List<int>> minor = [];
        for (int k = 0; k < 3; k++) {
          if (k == i) continue;
          List<int> row = [];
          for (int l = 0; l < 3; l++) {
            if (l == j) continue;
            row.add(matrix[k][l]);
          }
          minor.add(row);
        }
        int det = minor[0][0] * minor[1][1] - minor[0][1] * minor[1][0];
        adj[j][i] = ((i + j) % 2 == 0 ? 1 : -1) * det;
      }
    }
    return adj;
  } else {
    throw Exception("Only 2x2 and 3x3 matrices are supported.");
  }
}

String hillProcess(
  String text,
  String keyText,
  String mode,
  int size,
  String alphabet,
) {
  int modulus = alphabet.length;
  text = text.toUpperCase();
  //keyText = keyText.toUpperCase();

  text = text.split('').where((c) => alphabet.contains(c)).join();
  int n = size;
  List<int> keyNums = textToNumbers(keyText, alphabet);
  if (keyNums.length != n * n) {
    throw Exception("Key must form a square matrix.");
  }
  List<List<int>> keyMatrix = List.generate(n, (i) {
    return List.generate(n, (j) => keyNums[i * n + j]);
  });
  if (text.length % n != 0) {
    text += alphabet[0] * (n - text.length % n);
  }
  List<String> chunks = [];
  for (int i = 0; i < text.length; i += n) {
    chunks.add(text.substring(i, i + n));
  }
  String result = '';
  if (mode == 'decrypt') {
    keyMatrix = matrixModInverse(keyMatrix, modulus);
  }
  for (String chunk in chunks) {
    List<int> vec = textToNumbers(chunk, alphabet);
    List<int> res = List.filled(n, 0);
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        res[i] += keyMatrix[i][j] * vec[j];
      }
      res[i] %= modulus;
    }
    result += numbersToText(res, alphabet);
  }
  return result;
}

String hillEncrypt(String plaintext, String keyText, int matrixSize) {
  return hillProcess(plaintext, keyText, 'encrypt', matrixSize, alphabet);
}

String hillDecrypt(String ciphertext, String keyText, int matrixSize) {
  return hillProcess(ciphertext, keyText, 'decrypt', matrixSize, alphabet);
}
