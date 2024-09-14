import 'package:flutter/material.dart';
import '../colors.dart';
import 'dart:math';
import 'Encrypt.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedEncryption;
  int _selectedIndex = 0; // Set the Encrypt tab as initially selected

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
      // Stay on the Home screen (no action needed)
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EncryptScreen()),
        );
        break;
      // Add cases for other navigation items if needed
      // case 2:
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => DecryptScreen()),
      //   );
      //   break;
      // case 3:
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => ActivityScreen()),
      //   );
      //   break;
      // case 4:
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => SettingsScreen()),
      //   );
      //   break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove shadow if needed
        flexibleSpace: SafeArea(
          child: _buildAppBarContent(),
        ),
        toolbarHeight:
            100.0, // Increase this value if needed for proper spacing
      ),
      backgroundColor: colors.darkColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Encryption Methods',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildEncryptionMethods(context),
                const SizedBox(height: 32.0),
                const Text(
                  'Recent Activities',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 1.0),
              ],
            ),
          ),
          Flexible(
            child: ListView(
              padding: EdgeInsets
                  .zero, // Remove any padding if you want full-width items
              children: [
                _buildActivityItem('File decrypted', 'Nov 23, 2023'),
                _buildActivityItem('File encrypted', 'Oct 23, 2023'),
                _buildActivityItem('File encrypted', 'Dec 23, 2023'),
                _buildActivityItem('File shared', 'Nov 10, 2023'),
                _buildActivityItem('File deleted', 'Oct 5, 2023'),
                _buildActivityItem('File updated', 'Sep 30, 2023'),
                _buildActivityItem('File uploaded', 'Sep 20, 2023'),
                _buildActivityItem('File encrypted', 'Aug 15, 2023'),
                _buildActivityItem('File encrypted', 'Dec 23, 2023'),
                _buildActivityItem('File shared', 'Nov 10, 2023'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colors.darkMediumColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Encrypt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_circle_outline),
            label: 'Decrypt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
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

  Widget _buildAppBarContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: CircleAvatar(
              backgroundImage:
                  AssetImage('assets/img.png'), // Add your profile image here
              radius: 24.0, // Adjust the size here
            ),
          ),
          Expanded(
            child: _buildAppBarTitle(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle() {
    String greeting = _getGreeting();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
      children: [
        Text(
          greeting,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2, // Adjust line height to fit within the desired space
          ),
        ),
        const SizedBox(height: 2.0), // Reduced height between lines
        const Text(
          'Encrypt your file easily and securely',
          style: TextStyle(
            fontSize: 12.0,
            color: colors.lightColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEncryptionMethods(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
                child: FlippingCard(
                    title: 'AES-256',
                    description:
                        'AES-256 encryption is a symmetric key algorithm that provides robust data protection through a 256-bit key, ensuring high security and resistance against brute-force attacks.')),
            SizedBox(width: 8),
            Expanded(
                child: FlippingCard(
                    title: 'Blowfish',
                    description:
                        'Blowfish is a fast, symmetric key encryption algorithm that uses variable-length keys (32-448 bits) for secure data encryption, widely known for its efficiency.')),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: FlippingCard(
                    title: 'Twofish',
                    description:
                        'Twofish is a symmetric key block cipher encryption algorithm, known for its speed and flexibility. It uses a 128-bit block size and supports key sizes up to 256 bits.')),
            SizedBox(width: 8),
            Expanded(
                child: FlippingCard(
                    title: 'ChaCha20',
                    description:
                        'ChaCha20 is a fast, secure stream cipher that encrypts data using a 256-bit key, offering high performance and resistance to cryptographic attacks.')),
          ],
        ),
      ],
    );
  }

  Widget _buildActivityItem(String activity, String date) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 6.0, horizontal: 26.0), // Adjust vertical padding
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity, style: const TextStyle(color: Colors.white)),
                Text(date, style: const TextStyle(color: colors.lightColor)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 26.0), // Space between text and icon
            child: Icon(Icons.lock_outline, color: colors.lightColor),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour < 12) {
      return 'Hello,\nGood Morning';
    } else if (hour < 17) {
      return 'Hello,\nGood Afternoon';
    } else {
      return 'Hello,\nGood Evening';
    }
  }
}

class FlippingCard extends StatefulWidget {
  final String title;
  final String description;

  const FlippingCard(
      {super.key, required this.title, required this.description});

  @override
  _FlippingCardState createState() => _FlippingCardState();
}

class _FlippingCardState extends State<FlippingCard> {
  bool isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFlipped = !isFlipped;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotate = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            child: child,
            builder: (context, child) {
              final angle = rotate.value;
              return Transform(
                transform: Matrix4.rotationY(angle),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: isFlipped
            ? Container(
                key: ValueKey<bool>(isFlipped),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: colors.darkMediumColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  widget.description,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            : Container(
                key: ValueKey<bool>(!isFlipped),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: colors.darkMediumColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
      ),
    );
  }
}
