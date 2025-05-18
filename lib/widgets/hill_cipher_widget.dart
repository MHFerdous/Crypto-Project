class HillCipher {
  final List<String> charset;
  final int size;

  HillCipher({required this.charset, required this.size});

  List<int> textToNumbers(String text) {
    return text.split('').map((c) => charset.indexOf(c)).toList();
  }

  String numbersToText(List<int> numbers) {
    return numbers.map((n) => charset[n % charset.length]).join();
  }

  List<List<int>> createKeyMatrix(String keyText) {
    final keyNums = textToNumbers(keyText);
    if (keyNums.length != size * size) {
      throw ArgumentError('Key must form a $size x $size matrix.');
    }
    List<List<int>> matrix = List.generate(size, (_) => List.filled(size, 0));
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        matrix[i][j] = keyNums[i * size + j];
      }
    }
    return matrix;
  }

  List<List<int>> matrixModInv(List<List<int>> matrix, int modulus) {
    int n = matrix.length;
    int det = _modularDeterminant(matrix, modulus);
    int detInv = _modInverse(det, modulus);

    if (detInv == -1) {
      throw ArgumentError(
        "Matrix determinant is not invertible modulo charset length.",
      );
    }

    List<List<int>> adj = _adjugate(matrix);
    List<List<int>> inv = List.generate(n, (_) => List.filled(n, 0));
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        inv[i][j] = (detInv * adj[i][j]) % modulus;
        if (inv[i][j] < 0) inv[i][j] += modulus;
      }
    }
    return inv;
  }

  String process(String text, String keyText, bool encrypt) {
    int mod = charset.length;
    text = text.split('').where((c) => charset.contains(c)).join();
    List<List<int>> keyMatrix = createKeyMatrix(keyText);

    if (text.length % size != 0) {
      text += charset[0] * (size - text.length % size);
    }

    if (!encrypt) {
      keyMatrix = matrixModInv(keyMatrix, mod);
    }

    List<String> chunks = [
      for (int i = 0; i < text.length; i += size) text.substring(i, i + size),
    ];

    String result = '';
    for (String chunk in chunks) {
      List<int> vec = textToNumbers(chunk);
      List<int> res = List.filled(size, 0);
      for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
          res[i] += keyMatrix[i][j] * vec[j];
        }
        res[i] %= mod;
      }
      result += numbersToText(res);
    }
    return result;
  }

  int _modularDeterminant(List<List<int>> matrix, int modulus) {
    if (matrix.length == 2) {
      return ((matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]) %
                  modulus +
              modulus) %
          modulus;
    } else if (matrix.length == 3) {
      int a = matrix[0][0], b = matrix[0][1], c = matrix[0][2];
      int d = matrix[1][0], e = matrix[1][1], f = matrix[1][2];
      int g = matrix[2][0], h = matrix[2][1], i = matrix[2][2];
      int det = a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g);
      return ((det % modulus) + modulus) % modulus;
    } else {
      throw ArgumentError("Only 2x2 and 3x3 matrices are supported.");
    }
  }

  int _modInverse(int a, int m) {
    a = a % m;
    for (int x = 1; x < m; x++) {
      if ((a * x) % m == 1) return x;
    }
    return -1;
  }

  List<List<int>> _adjugate(List<List<int>> matrix) {
    int n = matrix.length;
    List<List<int>> adj = List.generate(n, (_) => List.filled(n, 0));
    if (n == 2) {
      adj[0][0] = matrix[1][1];
      adj[0][1] = -matrix[0][1];
      adj[1][0] = -matrix[1][0];
      adj[1][1] = matrix[0][0];
    } else if (n == 3) {
      for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 3; c++) {
          List<List<int>> minor = [];
          for (int i = 0; i < 3; i++) {
            if (i == r) continue;
            List<int> row = [];
            for (int j = 0; j < 3; j++) {
              if (j == c) continue;
              row.add(matrix[i][j]);
            }
            minor.add(row);
          }
          int detMinor = minor[0][0] * minor[1][1] - minor[0][1] * minor[1][0];
          adj[c][r] = ((r + c) % 2 == 0 ? 1 : -1) * detMinor;
        }
      }
    } else {
      throw ArgumentError("Only 2x2 and 3x3 matrices are supported.");
    }
    return adj;
  }
}
