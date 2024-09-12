import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:crypto/crypto.dart' as crypto; // Add prefix to avoid conflict
import 'package:cryptography/cryptography.dart' as crypto_pkg; // Add prefix to avoid conflict
import 'package:encrypt/encrypt.dart' as encrypt; // Ensure this is imported correctly

class EncryptionMethods {
  static final _random = Random();

  // Encrypt file method
  static Future<String> encryptFile(String filePath, String encryptionType) async {
    // Sample function to simulate file encryption
    String fileContent = 'Sample file content'; // Replace with actual file reading

    String encryptedData;
    switch (encryptionType) {
      case 'AES-256':
        encryptedData = _encryptAES256(fileContent);
        break;
      case 'Blowfish':
        encryptedData = _encryptBlowfish(fileContent);
        break;
      case 'Twofish':
        encryptedData = _encryptTwofish(fileContent);
        break;
      case 'ChaCha20':
        encryptedData = await _encryptChaCha20(fileContent);
        break;
      default:
        throw Exception('Unknown encryption type');
    }

    // Generate decryption key
    String decryptionKey = _generateDecryptionKey(encryptionType);

    // Append decryption key to encrypted data
    String encryptedDataWithKey = '$encryptedData|$decryptionKey';

    // Output or save the encrypted data with key
    print('Encrypted Data with Key: $encryptedDataWithKey');
    return 'Encryption Successfull: $encryptedDataWithKey';
  }

  // AES-256 Encryption
  static String _encryptAES256(String data) {
    final key = encrypt.Key.fromLength(32); // 256 bits = 32 bytes
    final iv = encrypt.IV.fromLength(16);  // 128 bits = 16 bytes
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.encrypt(data, iv: iv).base64;
  }

  // Blowfish Encryption (Placeholder: Implement or find a library)
  static String _encryptBlowfish(String data) {
    // Blowfish encryption logic
    // You may need a package that supports Blowfish, such as cryptography
    return data; // Placeholder
  }

  // Twofish Encryption (Placeholder: Implement or find a library)
  static String _encryptTwofish(String data) {
    // Twofish encryption logic
    // You may need a package that supports Twofish
    return data; // Placeholder
  }

  // ChaCha20 Encryption using cryptography package
  static Future<String> _encryptChaCha20(String data) async {
    final algorithm = crypto_pkg.Chacha20(macAlgorithm: crypto_pkg.Hmac.sha256());
    final secretKey = await algorithm.newSecretKey();
    final nonce = algorithm.newNonce(); // Generate a new nonce

    // Encrypt
    final secretBox = await algorithm.encrypt(
      utf8.encode(data),
      secretKey: secretKey,
      nonce: nonce,
    );

    // Encode encrypted data to base64
    final encryptedData = base64Encode(secretBox.cipherText);

    // Return nonce, encrypted data, and MAC
    return '$encryptedData-${base64Encode(nonce)}-${base64Encode(secretBox.mac.bytes)}';
  }

  // Generate decryption key
  static String _generateDecryptionKey(String encryptionType) {
    // Directly use encryptionType in decryption key without random identifier
    return '$encryptionType';
  }
}
