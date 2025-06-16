import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immuno_warriors/screens/simulation/simulation_screen.dart';
import 'package:immuno_warriors/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _currentUserId =
      FirebaseAuth.instance.currentUser?.uid ?? 'no_current_user_id';

  String? _selectedUserDocId;
  Map<String, dynamic>? _selectedUserData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream:
                _firestore
                    .collection('users')
                    .where('isOnline', isEqualTo: true)
                    .where('id', isNotEqualTo: _currentUserId)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                // Enhanced error display for clarity
                return Center(
                  child: Text(
                    'Erreur de chargement des données: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Safely access data from snapshot
              // If snapshot.data is null or docs is empty, it means no online players (except current user)
              final List<DocumentSnapshot> players = snapshot.data?.docs ?? [];

              if (players.isEmpty) {
                return Center(
                  child: Text(
                    'Aucun joueur en ligne trouvé (à part vous).',
                    style: GoogleFonts.orbitron(
                      color: AppTheme.neonBlue,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'SCANNER',
                        style: GoogleFonts.orbitron(
                          color: AppTheme.neonPink,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: AppTheme.glowEffect(AppTheme.neonPink),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              horizontalMargin: 5,
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    'Nom',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Grade',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Récompense',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              rows:
                                  players.map((doc) {
                                    // Safely cast and access document data
                                    final Map<String, dynamic>? data =
                                        doc.data() as Map<String, dynamic>?;

                                    // Handle cases where data might be null or malformed
                                    if (data == null) {
                                      // You might want to log this or return an empty DataRow
                                      print(
                                        'Warning: Document data is null for doc ID: ${doc.id}',
                                      );
                                      return DataRow(cells: _buildEmptyCells());
                                    }

                                    final String docId = doc.id;
                                    final String displayName =
                                        data['displayName'] as String? ?? 'N/A';

                                    // Safely access nested gameData
                                    final Map<String, dynamic>? gameData =
                                        data['gameData']
                                            as Map<String, dynamic>?;

                                    final int grade =
                                        gameData?['grade'] as int? ?? 0;
                                    final int reward = (grade / 2).toInt();

                                    return DataRow(
                                      onLongPress: () {
                                        setState(() {
                                          _selectedUserDocId = docId;
                                          _selectedUserData =
                                              data; // Store the safely accessed data
                                        });
                                      },
                                      cells: [
                                        DataCell(
                                          Text(
                                            displayName,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 16,
                                              ),
                                              Text(
                                                '$grade',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons
                                                    .monetization_on, // Changed to coins icon
                                                color: Colors.greenAccent,
                                                size: 16,
                                              ),
                                              Text(
                                                '$reward',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (_selectedUserDocId != null && _selectedUserData != null)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: _buildPopupDialog(
                    context,
                    _selectedUserDocId!,
                    _selectedUserData!,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method for empty cells in case of malformed data
  List<DataCell> _buildEmptyCells() {
    return const [
      DataCell(Text('Erreur de données', style: TextStyle(color: Colors.red))),
      DataCell(Text('-', style: TextStyle(color: Colors.white70))),
      DataCell(Text('-', style: TextStyle(color: Colors.white70))),
    ];
  }

  Widget _buildPopupDialog(
    BuildContext context,
    String docId,
    Map<String, dynamic> userData,
  ) {
    // Safely access nested gameData
    final Map<String, dynamic>? gameData =
        userData['gameData'] as Map<String, dynamic>?;

    final int grade = gameData?['grade'] as int? ?? 0;
    final int coin = gameData?['coin'] as int? ?? 0;
    final int reward = (grade / 2).toInt();
    final String displayName = userData['displayName'] as String? ?? 'N/A';

    return AlertDialog(
      backgroundColor: AppTheme.darkBackground.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: Row(
        children: [
          const Icon(Icons.account_circle, size: 32, color: AppTheme.neonPink),
          const SizedBox(width: 8),
          Text(
            displayName,
            style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.monetization_on,
                color: Colors.greenAccent,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Coins: $coin',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 8),
              Text(
                'Grade: $grade',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 8),
              Text(
                'Récompense: $reward',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _selectedUserDocId = null;
              _selectedUserData = null;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SimulationScreen()),
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: AppTheme.neonGreen,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text(
            'Attaquer',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _selectedUserDocId = null;
              _selectedUserData = null;
            });
          },
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.neonPink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(color: AppTheme.neonPink),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}
