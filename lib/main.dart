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
        colorScheme: const ColorScheme.dark(primary: Color(0xFF38BDF8)),
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
  bool _isEncodeMode = true; // True = English to Numbers, False = Numbers to English

  // 🚀 LOGIC 1: English to Secret Numbers
  void _encodeText(String text) {
    String result = '';
    for (int i = 0; i < text.length; i++) {
      String char = text[i].toUpperCase();
      if (RegExp(r'[A-Z]').hasMatch(char)) {
        int num = char.codeUnitAt(0) - 64; // A = 65 in ASCII. 65-64 = 1
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

  // 🚀 LOGIC 2: Secret Numbers to English
  void _decodeText(String text) {
    String result = '';
    List<String> parts = text.trim().split(RegExp(r'\s+'));
    
    for (String part in parts) {
      if (part == '00') {
        result += ' '; // '00' becomes Space
      } else if (RegExp(r'^[0-9]{2}$').hasMatch(part)) {
        int num = int.parse(part);
        if (num >= 1 && num <= 26) {
          result += String.fromCharCode(num + 64); // Number back to Char
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
        const SnackBar(content: Text('Copied to Clipboard! 📋'), backgroundColor: Color(0xFF38BDF8)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZingCipher 🕵️‍♂️', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mode Switcher Button
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() { _isEncodeMode = true; _outputText = ""; _inputController.clear(); }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: _isEncodeMode ? const Color(0xFF38BDF8) : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(child: Text('Eng to Numbers', style: TextStyle(fontWeight: FontWeight.bold, color: _isEncodeMode ? Colors.white : Colors.white54))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() { _isEncodeMode = false; _outputText = ""; _inputController.clear(); }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: !_isEncodeMode ? const Color(0xFF4ADE80) : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(child: Text('Numbers to Eng', style: TextStyle(fontWeight: FontWeight.bold, color: !_isEncodeMode ? Colors.white : Colors.white54))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Input TextField
            TextField(
              controller: _inputController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                hintText: _isEncodeMode ? 'Type English message here...' : 'Type Secret Numbers (e.g., 08 05 12 12 15) here...',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            // Translate Button
            ElevatedButton(
              onPressed: _processText,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isEncodeMode ? const Color(0xFF38BDF8) : const Color(0xFF4ADE80),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('TRANSLATE 🚀', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 30),

            // Output Container
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: _isEncodeMode ? const Color(0xFF38BDF8) : const Color(0xFF4ADE80), width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Result:', style: TextStyle(color: Colors.white70, fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.copy, color: Colors.white),
                          onPressed: _copyToClipboard,
                        )
                      ],
                    ),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        child: SelectableText(
                          _outputText.isEmpty ? "Translation will appear here..." : _outputText,
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 2),
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
