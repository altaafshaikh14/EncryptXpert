import 'dart:io';
import 'package:encryptxpert/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher package
import 'Home.dart';
import 'package:permission_handler/permission_handler.dart';
import '../EncryptionMethods.dart';

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
    if (_isFileSelected) {
      return; // Prevent picking a new file if one is already selected
    }

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
      _selectedEncryption = null;
    });
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission is required to open files.')),
      );
    }
  }

  Future<void> _viewFile(String filePath) async {
    final fileUri = Uri.file(filePath);

    try {
      await _requestPermissions();
      if (await canLaunchUrl(fileUri)) {
        await launchUrl(fileUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open file.')),
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
        toolbarHeight: MediaQuery.of(context).size.height * 0.1, // 10% of screen height
        title: const Text('Encrypt File'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.07, // 7% of screen width
          fontWeight: FontWeight.bold,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
            GestureDetector(
              onTap: () {
                if (!_isFileSelected) {
                  _pickFile(); // Prompt to pick a file if none is selected.
                }
                // Do nothing if a file is already selected.
              },
              // onTap: _isFileSelected
              //     ? () => _viewFile(_selectedFilePath!)
              //     : _pickFile, // Open file if selected, otherwise pick a new file
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2, // 20% of screen height
                width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
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
                      size: MediaQuery.of(context).size.width * 0.12, // 12% of screen width
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02), // 2% of screen height
                    Text(
                      'Select File',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.05, // 5% of screen width
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
                      top: MediaQuery.of(context).size.height * 0.01, // 2% of screen height
                      right: MediaQuery.of(context).size.width * 0.02, // 2% of screen width
                      child: GestureDetector(
                        onTap: _removeSelectedFile,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.08, // 8% of screen width
                          height: MediaQuery.of(context).size.width * 0.08, // 8% of screen width
                          decoration: const BoxDecoration(
                            color: colors.darkMediumColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 24, // Adjust icon size if needed
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.04),
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
                    _buildEncryptionButton('AES-256', context),
                    SizedBox(width: screenWidth * 0.01),
                    _buildEncryptionButton('Blowfish',context),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildEncryptionButton('Twofish', context),
                    SizedBox(width: screenWidth * 0.01),
                    _buildEncryptionButton('ChaCha20', context),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.05),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85, // 80% of screen width
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
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width * 0.04, // 4% of screen width for vertical padding
                        horizontal: MediaQuery.of(context).size.width * 0.05, // 5% of screen width for horizontal padding
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _selectedEncryption != null && _selectedFilePath != null
                        ? () async {
                      // Start encryption logic
                      String encryptedData = await EncryptionMethods.encryptFile(
                          '$_selectedFilePath',
                          '$_selectedEncryption'
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Encryption Successful: $encryptedData'),
                        ),
                      );
                    }
                        : null,
                    child: Text(
                      'Start Encryption',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05, // Font size based on screen width
                        color: _selectedEncryption != null
                            ? Colors.white
                            : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )

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
        iconPath =
            'assets/unknown_icon.png'; // Provide a default or unknown icon
        break;
      default:
        iconPath = 'assets/unknown_icon.png';
    }

    return GestureDetector(
      //onTap: () => _viewFile(filePath), // Handle file view when icon is clicked
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

  Widget _buildEncryptionButton(String encryptionType, BuildContext context) {
    final isSelected = _selectedEncryption == encryptionType;
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final buttonWidth = screenWidth * 0.4; // Adjust button width as a percentage of screen width
    final buttonHeight = 50.0; // Fixed height for buttons

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedFilePath != null) {
            _selectedEncryption = isSelected ? null : encryptionType;
          } else {
            _showFileSelectionAlert();
          }
        });
      },
      child: Container(
        width: buttonWidth, // Use dynamic width
        height: buttonHeight, // Use fixed height
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
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
              fontSize: 16, // Keep font size consistent
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }


  void _showFileSelectionAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('File Not Selected'),
          content: const Text(
              'Please select a file before choosing an encryption method.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

