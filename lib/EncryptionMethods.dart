import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart' as crypto_pkg;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:blowfish/blowfish.dart';


class EncryptionMethods {
  static final _random = Random();

  // Define unique identifiers for encryption methods
  static const Map<String, String> _uniqueIdentifiers = {
    'AES-256-GCM': 'a1e2s256',
    'AES-128-GCM': 'a1e2s128',
    'ChaCha20': 'c1h2a20',
    'TripleDES': 't1d2s3'
  };

  // Encrypt file method
  static Future<String> encryptFile(
      String filePath, String encryptionType) async {
    // Sample function to simulate file encryption
    String fileContent =
        'Sample file content'; // Replace with actual file reading

    String encryptedData;
    String? identifier;
    switch (encryptionType) {
      case 'AES-256-GCM':
        encryptedData = await _encryptAES256GCM(fileContent);
        identifier = _uniqueIdentifiers['AES-256-GCM'];
        break;
      case 'AES-128-GCM':
        encryptedData = await _encryptAES128GCM(fileContent);
        identifier = _uniqueIdentifiers['AES-128-GCM'];
        break;
      case 'ChaCha20':
        encryptedData = await _encryptChaCha20(fileContent);
        identifier = _uniqueIdentifiers['ChaCha20'];
        break;
      default:
        throw Exception('Unknown encryption type');
    }

    // Generate decryption key
    String decryptionKey = _generateDecryptionKey(encryptionType);

    // Insert identifier randomly into encrypted data
    if (identifier != null) {
      encryptedData = _insertIdentifier(encryptedData, identifier);
    }

    // Output or save the encrypted data with key
    print('Encrypted Data with Key: $encryptedData');
    return 'Encryption Successful: $encryptedData';
  }

  // AES-256-GCM Encryption using encrypt package
  static Future<String> _encryptAES256GCM(String data) async {
    final key = encrypt.Key.fromLength(32); // 256 bits = 32 bytes
    final iv = encrypt.IV.fromLength(12);  // 96 bits = 12 bytes for GCM
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm));

    final encrypted = encrypter.encrypt(data, iv: iv);
    return '${encrypted.base64}-${base64Encode(iv.bytes)}';
  }

  // AES-128-GCM Encryption using encrypt package
  static Future<String> _encryptAES128GCM(String data) async {
    final key = encrypt.Key.fromLength(16); // 128 bits = 16 bytes
    final iv = encrypt.IV.fromLength(12);  // 96 bits = 12 bytes for GCM
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm));

    final encrypted = encrypter.encrypt(data, iv: iv);
    return '${encrypted.base64}-${base64Encode(iv.bytes)}';
  }

  // ChaCha20 Encryption using cryptography package
  static Future<String> _encryptChaCha20(String data) async {
    final algorithm = crypto_pkg.Chacha20(macAlgorithm: crypto_pkg.Hmac.sha256());
    final secretKey = await algorithm.newSecretKey();
    final nonce = algorithm.newNonce(); // Generate a new nonce

    final secretBox = await algorithm.encrypt(
      utf8.encode(data),
      secretKey: secretKey,
      nonce: nonce,
    );

    final encryptedData = base64Encode(secretBox.cipherText);

    return '$encryptedData-${base64Encode(nonce)}-${base64Encode(secretBox.mac.bytes)}';
  }

// Insert identifier at a random position in the data
  static String _insertIdentifier(String data, String identifier) {
    final identifierBytes = utf8.encode(identifier);
    final dataBytes = utf8.encode(data);

    final randomPosition = _random.nextInt(dataBytes.length + 1);

    final result = Uint8List(dataBytes.length + identifierBytes.length);
    result.setRange(0, randomPosition, dataBytes);
    result.setRange(randomPosition, randomPosition + identifierBytes.length, identifierBytes);
    result.setRange(randomPosition + identifierBytes.length, result.length, dataBytes.sublist(randomPosition));

    return utf8.decode(result);
  }

  // Generate decryption key
  static String _generateDecryptionKey(String encryptionType) {
    return '$encryptionType';
  }
}
