import 'package:flutter/material.dart';
import 'holo_simulateur_combat.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onLogout;
  final Color neonGreen = const Color(0xFF00FEC0);

  const DashboardScreen({super.key, required this.onLogout});

  final List<Map<String, dynamic>> defensiveResources = const [
    {'name': 'Énergie', 'value': 85, 'icon': Icons.bolt},
    {'name': 'Biomatériaux', 'value': 120, 'icon': Icons.biotech},
    {'name': 'Anticorps', 'value': 45, 'icon': Icons.medical_services},
    {'name': 'Points Recherche', 'value': 30, 'icon': Icons.science},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ImmunoWarriors', style: TextStyle(color: neonGreen)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: neonGreen,
            onPressed: () => _openNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            color: neonGreen,
            onPressed: () => _openSettings(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            color: neonGreen,
            onPressed: onLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildEnhancedResourceIndicator(),
            const SizedBox(height: 20),
            _buildMemoryIndicator(),
            const SizedBox(height: 20),
            _buildCombatAdviceCard(context),
            const SizedBox(height: 20),
            _buildAlertsSection(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildCustomNavBar(context),
      floatingActionButton: FloatingActionButton(
        backgroundColor: neonGreen,
        child: const Icon(Icons.chat, color: Colors.black),
        onPressed: () => _openGeminiChat(context),
      ),
    );
  }

  Widget _buildEnhancedResourceIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: neonGreen.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            'RESSOURCES DÉFENSIVES',
            style: TextStyle(color: neonGreen, fontSize: 16),
          ),
          const SizedBox(height: 15),
          Column(
            children: defensiveResources.map((resource) {
              final icon = resource['icon'] as IconData;
              final name = resource['name'] as String;
              final value = resource['value'] as int;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(icon, color: neonGreen, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(name, style: const TextStyle(color: Colors.white)),
                    ),
                    Text('$value', style: TextStyle(color: neonGreen, fontSize: 16)),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.autorenew, color: Colors.green, size: 16),
              const SizedBox(width: 6),
              Text(
                'Régénération: +5/min',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: neonGreen.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('MÉMOIRE IMMUNITAIRE', style: TextStyle(color: neonGreen)),
              Text('65%', style: TextStyle(color: neonGreen)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.65,
            minHeight: 10,
            color: neonGreen,
            backgroundColor: Colors.grey[800],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.memory, color: Colors.grey[400], size: 16),
              const SizedBox(width: 6),
              Text(
                'Pathogènes enregistrés: 12',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCombatAdviceCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border.all(color: neonGreen),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.military_tech, color: neonGreen, size: 30),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CONSEIL TACTIQUE',
                  style: TextStyle(color: neonGreen, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'Ciblez les pathogènes de type Gamma en priorité',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsSection(BuildContext context) {
    final List<Map<String, dynamic>> alerts = const [
      {'title': 'Base virale détectée', 'subtitle': 'Niveau 3', 'icon': Icons.warning},
      {'title': 'Mutation pathogène', 'subtitle': 'Type Gamma', 'icon': Icons.bug_report},
      {'title': 'Nouveaux anticorps', 'subtitle': 'Disponibles', 'icon': Icons.medical_services},
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ALERTES RÉCENTES',
              style: TextStyle(color: neonGreen, fontSize: 18),
            ),
            TextButton(
              onPressed: () => _openAllAlerts(context),
              child: Text(
                'Voir tout',
                style: TextStyle(color: neonGreen),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: alerts.map((alert) {
            final icon = alert['icon'] as IconData;
            final title = alert['title'] as String;
            final subtitle = alert['subtitle'] as String;

            return ListTile(
              leading: Icon(icon, color: neonGreen),
              title: Text(title, style: const TextStyle(color: Colors.white)),
              subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400])),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCustomNavBar(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: neonGreen.withOpacity(0.3))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavIcon(Icons.home, "Accueil", isActive: true),
          _buildNavIcon(Icons.radar, "Scanner"),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HoloSimulateurCombat()),
            ),
            child: _buildNavIcon(Icons.bolt, "Combat"),
          ),
          _buildNavIcon(Icons.science, "Bio-Forge"),
          _buildNavIcon(Icons.biotech, "R&D"),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String label, {bool isActive = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? neonGreen : Colors.grey, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? neonGreen : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _openNotifications(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
  }

  void _openSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
  }

  void _openGeminiChat(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const GeminiChatScreen()));
  }

  void _openAllAlerts(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AlertsScreen()));
  }
}

class GeminiChatScreen extends StatefulWidget {
  const GeminiChatScreen({super.key});

  @override
  State<GeminiChatScreen> createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    const ChatMessage(text: "Bonjour Commandant, voici votre briefing tactique...", isUser: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analyste Gemini"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color(0xFF00FEC0).withOpacity(0.2)
              : Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Envoyer un message à Gemini...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Color(0xFF00FEC0)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            backgroundColor: const Color(0xFF00FEC0),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                setState(() {
                  _messages.add(ChatMessage(text: _messageController.text, isUser: true));
                  _messageController.clear();

                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      _messages.add(const ChatMessage(
                        text: "Analyse en cours... Recommandation : Utilisez des anticorps de type B-45",
                        isUser: false,
                      ));
                    });
                  });
                });
              }
            },
            child: const Icon(Icons.send, color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  const ChatMessage({required this.text, required this.isUser});
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.warning, color: Color(0xFF00FEC0)),
            title: Text("Alerte: Mutation pathogène détectée"),
            subtitle: Text("Il y a 2 heures"),
          ),
          ListTile(
            leading: Icon(Icons.verified, color: Color(0xFF00FEC0)),
            title: Text("Niveau supérieur atteint"),
            subtitle: Text("Aujourd'hui"),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Mode sombre"),
            value: true,
            onChanged: (value) {},
          ),
          const ListTile(
            title: Text("Version"),
            subtitle: Text("1.0.0"),
          ),
        ],
      ),
    );
  }
}

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Toutes les alertes")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.warning, color: Color(0xFF00FEC0)),
            title: Text("Base virale Nv.3 détectée"),
            subtitle: Text("Secteur Gamma-12 • Il y a 2h"),
          ),
          ListTile(
            leading: Icon(Icons.bug_report, color: Color(0xFF00FEC0)),
            title: Text("Mutation pathogène identifiée"),
            subtitle: Text("Type Gamma-X • Aujourd'hui"),
          ),
        ],
      ),
    );
  }
}