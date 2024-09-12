import 'dart:io';
import 'package:encryptxpert/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';// Import url_launcher package
import 'Home.dart';

class EncryptScreen extends StatefulWidget {
  @override
  _EncryptScreenState createState() => _EncryptScreenState();
}

class _EncryptScreenState extends State<EncryptScreen> {
  String? _selectedEncryption;
  String? _selectedFilePath;
  String? _fileName;
  bool _isLoading = false;
  int _selectedIndex = 1;
  bool _isFileSelected = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        break;
    }
  }

  Future<void> _pickFile() async {
    if (_isFileSelected) return; // Prevent picking a new file if one is already selected

    setState(() {
      _isLoading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'jpg', 'png', 'pdf', 'doc'],
    );

    if (result != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
        _fileName = result.files.single.name; // Get the file name
        _isFileSelected = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _removeSelectedFile() {
    setState(() {
      _selectedFilePath = null;
      _fileName = null;
      _isFileSelected = false;
    });
  }

  Future<void> _viewFile(String filePath) async {
    final fileUri = Uri.file(filePath);

    try {
      if (await canLaunchUrl(fileUri)) {
        await launchUrl(fileUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to open file.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLargeScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF121A21),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: isLargeScreen ? 120.0 : 100.0,
        title: const Text('Encrypt File'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: isLargeScreen ? 36 : 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _isFileSelected ? () => _viewFile(_selectedFilePath!) : _pickFile, // Open file if selected, otherwise pick a new file
              child: Container(
                height: screenHeight * 0.2,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2A34),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : _fileName == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.insert_drive_file,
                      color: Colors.white,
                      size: isLargeScreen ? 60 : 48,
                    ),
                    SizedBox(height: isLargeScreen ? 16 : 8),
                    Text(
                      'Select File',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isLargeScreen ? 20 : 16,
                      ),
                    ),
                  ],
                )
                    : Stack(
                  children: [
                    Center(
                      child: _buildFileIcon(_fileName!, _selectedFilePath!),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: _removeSelectedFile,
                        child: Container(
                          width: 40, // Increase size of circle
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24, // Adjust icon size
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.08),
            const Text(
              'Choose Encryption Type',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildEncryptionButton('AES-256', isLargeScreen),
                    _buildEncryptionButton('Blowfish', isLargeScreen),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildEncryptionButton('Twofish', isLargeScreen),
                    _buildEncryptionButton('ChaCha20', isLargeScreen),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
            Center(
              child: SizedBox(
                width: isLargeScreen ? 455 : 355,
                child: Container(
                  decoration: BoxDecoration(
                    color: _selectedEncryption != null
                        ? Colors.blue
                        : colors.darkMediumColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _selectedEncryption != null
                        ? () {
                      // Start encryption logic
                    }
                        : null,
                    child: Text(
                      'Start Encryption',
                      style: TextStyle(
                        fontSize: isLargeScreen ? 20 : 18,
                        color: _selectedEncryption != null
                            ? Colors.white
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colors.darkMediumColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Encrypt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_open),
            label: 'Decrypt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: colors.lightColor,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildFileIcon(String fileName, String filePath) {
    final fileExtension = fileName.split('.').last.toLowerCase();
    String iconPath;

    switch (fileExtension) {
      case 'txt':
        iconPath = 'assets/txt_icon.png';
        break;
      case 'jpg':
        iconPath = 'assets/jpg_icon.png';
        break;
      case 'png':
        iconPath = 'assets/png_icon.png';
        break;
      case 'pdf':
        iconPath = 'assets/pdf_icon.png';
        break;
      case 'doc':
        iconPath = 'assets/unknown_icon.png'; // Provide a default or unknown icon
        break;
      default:
        iconPath = 'assets/unknown_icon.png';
    }

    return GestureDetector(
      onTap: () => _viewFile(filePath), // Handle file view when icon is clicked
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8), // Adjust spacing between icon and text
          Text(
            fileName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEncryptionButton(String encryptionType, bool isLargeScreen) {
    final isSelected = _selectedEncryption == encryptionType;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEncryption = isSelected ? null : encryptionType;
        });
      },
      child: Container(
        width: isLargeScreen ? 220 : 160,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : colors.darkMediumColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            encryptionType,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: isLargeScreen ? 18 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
