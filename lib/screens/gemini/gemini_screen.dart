import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GeminiScreen extends StatefulWidget {
  const GeminiScreen({super.key});

  @override
  State<GeminiScreen> createState() => _GeminiScreenState();
}

class _GeminiScreenState extends State<GeminiScreen> {
  static const String _prefsKey = 'gemini_chat_history';
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isLoading = false;

  // L'API est initialisée dans main.dart avec Gemini.init(apiKey: ...)
// On utilise Gemini.instance.prompt pour envoyer les messages.

  void _sendMessage() async {
  final text = _controller.text.trim();
  if (text.isEmpty || _isLoading) return;
  setState(() {
    _messages.add(_ChatMessage(content: text, isUser: true));
    _saveMessagesToPrefs();
    _isLoading = true;
    _controller.clear();
  });
  await Future.delayed(const Duration(milliseconds: 100));
  _scrollToBottom();
  try {
    final value = await Gemini.instance.prompt(parts: [Part.text(text)]);
    setState(() {
      _messages.add(_ChatMessage(content: value?.output ?? '[Aucune réponse]', isUser: false));
      _saveMessagesToPrefs();
      _isLoading = false;
    });
    _scrollToBottom();
  } catch (e) {
    setState(() {
      _messages.add(_ChatMessage(content: 'Erreur Gemini : $e', isUser: false));
      _saveMessagesToPrefs();
      _isLoading = false;
    });
    _scrollToBottom();
  }
}

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMessagesFromPrefs();
  }

  Future<void> _saveMessagesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> serialized = _messages.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(_prefsKey, serialized);
  }

  Future<void> _loadMessagesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? serialized = prefs.getStringList(_prefsKey);
    if (serialized != null) {
      setState(() {
        _messages.clear();
        _messages.addAll(serialized.map((s) => _ChatMessage.fromJson(jsonDecode(s))));
      });
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Couleurs du thème néon
    const Color neonPink = Color(0xFFFF00F5);
    const Color neonPurple = Color(0xFFB400FF);
    const Color darkBackground = Color(0xFF0A0A1A);
    
    // Effet de lueur pour les éléments interactifs
    List<BoxShadow> glowEffect(Color color) {
      return [
        BoxShadow(
          color: color.withOpacity(0.4),
          blurRadius: 8,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 20,
          spreadRadius: 5,
        ),
      ];
    }

    return Scaffold(
      backgroundColor: darkBackground,
      body: Stack(
        children: [
          // Fond avec effet de dégradé
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  darkBackground.withOpacity(0.8),
                  darkBackground,
                ],
              ),
            ),
          ),
          // Contenu principal
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec bouton de retour
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: neonPink.withOpacity(0.5),
                              width: 1,
                            ),
                            boxShadow: glowEffect(neonPink),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'GEMINI IA',
                        style: GoogleFonts.orbitron(
                          color: neonPurple,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: glowEffect(neonPurple),
                        ),
                      ),
                    ],
                  ),
                ),
                // Avatar Gemini
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [neonPurple, neonPink],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          ...glowEffect(neonPurple),
                          BoxShadow(
                            color: neonPink.withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                // Liste des messages
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        return Align(
                          alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            constraints: const BoxConstraints(maxWidth: 300),
                            decoration: BoxDecoration(
                              color: msg.isUser
                                  ? neonPink.withOpacity(0.15)
                                  : neonPurple.withOpacity(0.12),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(18),
                                topRight: const Radius.circular(18),
                                bottomLeft: Radius.circular(msg.isUser ? 18 : 0),
                                bottomRight: Radius.circular(msg.isUser ? 0 : 18),
                              ),
                              boxShadow: msg.isUser ? glowEffect(neonPink) : glowEffect(neonPurple),
                              border: Border.all(
                                color: msg.isUser ? neonPink.withOpacity(0.3) : neonPurple.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              msg.content,
                              style: GoogleFonts.rajdhani(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: msg.isUser ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Zone de saisie
                Container(
                  margin: const EdgeInsets.all(18),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: neonPink.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          enabled: !_isLoading,
                          style: GoogleFonts.rajdhani(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Tapez votre message...',
                            hintStyle: GoogleFonts.rajdhani(color: Colors.white54),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _isLoading ? null : _sendMessage,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: neonPink.withOpacity(_isLoading ? 0.1 : 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: neonPink,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.send_rounded,
                                  color: neonPink,
                                  size: 22,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String content;
  final bool isUser;

  _ChatMessage({required this.content, required this.isUser});

  Map<String, dynamic> toJson() => {
    'content': content,
    'isUser': isUser,
  };

  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _ChatMessage(
    content: json['content'] as String,
    isUser: json['isUser'] as bool,
  );
}
