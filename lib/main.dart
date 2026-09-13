import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ZingCipherApp());
}

class ZingCipherApp extends StatelessWidget {
  const ZingCipherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZingCipher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Dark Navy Background
        colorScheme: const ColorScheme.dark(primary: Color(0xFFD8B4FE)), // Light Purple Accent
      ),
      home: const CipherScreen(),
    );
  }
}

class CipherScreen extends StatefulWidget {
  const CipherScreen({super.key});

  @override
  State<CipherScreen> createState() => _CipherScreenState();
}

class _CipherScreenState extends State<CipherScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _outputText = "";
  
  // True = English to Numbers, False = Numbers to English
  bool _isEncodeMode = true; 

  // 🚀 LOGIC 1: English to Secret Numbers
  void _encodeText(String text) {
    String result = '';
    for (int i = 0; i < text.length; i++) {
      String char = text[i].toLowerCase();
      if (RegExp(r'[a-z]').hasMatch(char)) {
        int num = char.codeUnitAt(0) - 96; // 'a' = 97 in ASCII. 97-96 = 1
        result += '${num.toString().padLeft(2, '0')} '; // 1 becomes '01'
      } else if (char == ' ') {
        result += '00 '; // Space is '00'
      } else {
        result += '$char '; // Special symbols (.,!?) rahenge waise hi
      }
    }
    setState(() {
      _outputText = result.trim();
    });
  }

  // 🚀 LOGIC 2: Secret Numbers to Small English
  void _decodeText(String text) {
    String result = '';
    List<String> parts = text.trim().split(RegExp(r'\s+'));
    
    for (String part in parts) {
      if (part == '00') {
        result += ' '; // '00' becomes Space
      } else if (RegExp(r'^[0-9]{2}$').hasMatch(part)) {
        int num = int.parse(part);
        if (num >= 1 && num <= 26) {
          result += String.fromCharCode(num + 96); // Number back to SMALL Char ('a' is 97)
        } else {
          result += part; // If wrong number, keep it as it is
        }
      } else {
        result += part; // Special symbols
      }
    }
    setState(() {
      _outputText = result;
    });
  }

  void _processText() {
    if (_inputController.text.isEmpty) {
      setState(() => _outputText = "Please enter some text!");
      return;
    }
    if (_isEncodeMode) {
      _encodeText(_inputController.text);
    } else {
      _decodeText(_inputController.text);
    }
  }

  void _copyToClipboard() {
    if (_outputText.isNotEmpty && _outputText != "Please enter some text!") {
      Clipboard.setData(ClipboardData(text: _outputText));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to Clipboard! 📋', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), 
          backgroundColor: Color(0xFFC084FC),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _swapMode() {
    setState(() {
      _isEncodeMode = !_isEncodeMode;
      _outputText = "";
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZingCipher 🕵️‍♂️', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔄 GOOGLE TRANSLATE STYLE SWAP HEADER
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFD8B4FE).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD8B4FE).withOpacity(0.3), width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _isEncodeMode ? 'English' : 'Numbers',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFE9D5FF), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: _swapMode,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFC084FC).withOpacity(0.3),
                      ),
                      child: const Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 28),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _isEncodeMode ? 'Numbers' : 'English',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFE9D5FF), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // 📝 GLASSY INPUT BOX
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD8B4FE).withOpacity(0.2), width: 1),
              ),
              child: TextField(
                controller: _inputController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: _isEncodeMode 
                      ? 'Type english message here...' 
                      : 'Type secret numbers (e.g., 08 05 12 12 15)...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                  contentPadding: const EdgeInsets.all(20),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 25),

            // 🚀 GLOSSY LIGHT PURPLE TRANSLATE BUTTON
            GestureDetector(
              onTap: _processText,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC084FC), Color(0xFFD8B4FE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC084FC).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    'TRANSLATE 🚀',
                    style: TextStyle(color: Color(0xFF2E1065), fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 📄 GLASSY OUTPUT CONTAINER
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8B4FE).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD8B4FE).withOpacity(0.4), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC084FC).withOpacity(0.05),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Result:', style: TextStyle(color: Color(0xFFE9D5FF), fontSize: 16)),
                        GestureDetector(
                          onTap: _copyToClipboard,
                          child: const Icon(Icons.copy_rounded, color: Color(0xFFD8B4FE)),
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: Colors.white24, thickness: 1),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: SelectableText(
                          _outputText.isEmpty ? "translation will appear here..." : _outputText,
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 22, 
                            fontWeight: FontWeight.w500, 
                            letterSpacing: 1.2
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
