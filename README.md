# 🔐 Cipher Calculation App

A Flutter-based application that enables users to encrypt and decrypt messages using various classical cipher techniques. The app supports:

- **Rail Fence Cipher**
- **Hill Cipher**
- **Caesar Cipher**
- **Vernam Cipher**

Additionally, it incorporates user authentication (sign-up and login) powered by Supabase.

## ✨ Features

- **User Authentication**: Secure sign-up and login functionalities using Supabase.
- **Multiple Cipher Techniques**:
  - **Rail Fence Cipher**: Customise the number of rails for encryption/decryption.
  - **Hill Cipher**: Supports both 2x2 and 3x3 matrix sizes.
  - **Caesar Cipher**: Shift letters by a specified number.
  - **Vernam Cipher**: Implements the one-time pad encryption method.
- **User-Friendly Interface**: Clean and intuitive UI for seamless user experience.
- **Real-Time Results**: Instant encryption/decryption results are displayed upon input.

## 🚀 Run The App

### Prerequisites

- **Flutter SDK**: Ensure Flutter is installed on your machine. [Installation Guide](https://flutter.dev/docs/get-started/install)
- **Supabase Account**: Set up a project on [Supabase](https://supabase.io/) to handle authentication.

### Installation

   ```bash
   git clone https://github.com/MHFerdous/Crypto-Project
   cd Crypto-Project
   ```

   ```bash
   flutter pub get
   ```
 
   ```bash
   final supabaseUrl = 'https://your-supabase-url.supabase.co';
   final supabaseAnonKey = 'your-anon-key';
   ```

   ```bash
   flutter run
   ```

