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
        scaffoldBackgroundColor: const Color(0xFF0F172A), 
        colorScheme: const ColorScheme.dark(primary: Color(0xFFD8B4FE)),
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
  bool _isEncodeMode = true; 

  // 😈 THE "CRAZY" SECRET DICTIONARY 😈
  final Map<String, String> _encodeMap = {
    'a': 'z1,X', 'b': '8#mV', 'c': 'q9.P', 'd': '4!kL', 'e': 'v7~A',
    'f': '2@pQ', 'g': 'm5\$w', 'h': '9^cT', 'i': 'b3*R', 'j': '6&yN',
    'k': 'x0(O', 'l': '1)hD', 'm': 'd8_E', 'n': 'u4+F', 'o': '3-gJ',
    'p': 's2=K', 'q': '7[fU', 'r': '0]iI', 's': 'w9{B', 't': '5}lH',
    'u': 'j6|M', 'v': 'e3;C', 'w': 'r5:S', 'x': 't2,G', 'y': 'o8.W',
    'z': 'n7/Y', ' ': '===' // Space ban gaya '==='
  };

  late Map<String, String> _decodeMap;

  @override
  void initState() {
    super.initState();
    // Decode map automatically ulta (reverse) ho jayega
    _decodeMap = _encodeMap.map((key, value) => MapEntry(value, key));
  }

  // 🚀 LOGIC 1: English to Crazy Code
  void _encodeText(String text) {
    String result = '';
    for (int i = 0; i < text.length; i++) {
      String char = text[i].toLowerCase();
      if (_encodeMap.containsKey(char)) {
        result += '${_encodeMap[char]} '; 
      } else {
        result += '$char '; // Agar koi ? ya ! hai to waise hi rahega
      }
    }
    setState(() => _outputText = result.trim());
  }

  // 🚀 LOGIC 2: Crazy Code to Small English
  void _decodeText(String text) {
    String result = '';
    List<String> parts = text.trim().split(RegExp(r'\s+'));
    
    for (String part in parts) {
      if (_decodeMap.containsKey(part)) {
        result += _decodeMap[part]!; 
      } else {
        result += part; 
      }
    }
    setState(() => _outputText = result);
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
                      _isEncodeMode ? 'English' : 'Secret Code',
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
                      _isEncodeMode ? 'Secret Code' : 'English',
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
                      : 'Paste the crazy secret code here...',
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
                            fontSize: 20, 
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
