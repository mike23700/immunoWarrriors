import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:immuno_warriors/theme/app_theme.dart';
import 'package:immuno_warriors/providers/user_profile_provider.dart';
import 'package:immuno_warriors/models/user_profile.dart';
import 'package:immuno_warriors/screens/auth/auth.dart'; // Exporte LoginScreen

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final userProfile = context.read<UserProfileProvider>().userProfile;
    if (userProfile != null) {
      _nameController.text = userProfile.displayName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            'Changer la photo de profil',
            style: GoogleFonts.rajdhani(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera, color: AppTheme.neonBlue),
                title: Text(
                  'Prendre une photo',
                  style: GoogleFonts.rajdhani(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library, color: AppTheme.neonPink),
                title: Text(
                  'Choisir depuis la galerie',
                  style: GoogleFonts.rajdhani(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Ou choisir un avatar par défaut',
                style: GoogleFonts.rajdhani(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  return GestureDetector(
                    onTap: () {
                      context.read<UserProfileProvider>().selectDefaultAvatar(index);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.watch<UserProfileProvider>().userProfile?.defaultAvatarIndex == index
                              ? AppTheme.neonBlue
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/avatars/avatar_$index.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> _pickImage(ImageSource source) async {
    try {
      await context.read<UserProfileProvider>().changeProfileImage(source);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur lors de la sélection de l\'image: ${e.toString()}',
            style: GoogleFonts.rajdhani(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _signOut() async {
    try {
      await context.read<UserProfileProvider>().signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur lors de la déconnexion: ${e.toString()}',
            style: GoogleFonts.rajdhani(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProvider, _) {
        final userProfile = userProvider.userProfile;
        final user = FirebaseAuth.instance.currentUser;
        
        if (userProfile == null || user == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.darkBackground,
          body: Stack(
            children: [
              // Fond avec effet de dégradé
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppTheme.backgroundGradient,
                ),
              ),
              
              // Contenu principal
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête avec bouton de retour
                      Row(
                        children: [
                          // Bouton de retour
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.neonBlue.withOpacity(0.5),
                                  width: 1,
                                ),
                                boxShadow: AppTheme.glowEffect(AppTheme.neonBlue),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Titre
                          Text(
                            'PROFIL',
                            style: GoogleFonts.orbitron(
                              color: AppTheme.neonBlue,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              shadows: AppTheme.glowEffect(AppTheme.neonBlue),
                            ),
                          ),
                          const Spacer(),
                          // Bouton de déconnexion
                          GestureDetector(
                            onTap: _signOut,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.logout_rounded,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Section Photo de profil et nom
                      Center(
                        child: Column(
                          children: [
                            // Photo de profil
                            GestureDetector(
                              onTap: _showImageSourceDialog,
                              child: Stack(
                                children: [
                                  // Photo de profil
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [AppTheme.neonBlue, AppTheme.neonPink],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        ...AppTheme.glowEffect(AppTheme.neonBlue),
                                        BoxShadow(
                                          color: AppTheme.neonPink.withOpacity(0.5),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: userProfile.photoUrl != null && userProfile.photoUrl!.isNotEmpty
                                          ? Image.network(
                                              userProfile.photoUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return _buildDefaultAvatar(userProfile);
                                              },
                                            )
                                          : _buildDefaultAvatar(userProfile),
                                    ),
                                  ),
                                  // Icône d'édition
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppTheme.neonBlue,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.edit_rounded,
                                        color: AppTheme.neonBlue,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Nom d'utilisateur
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_isEditing) ...[
                                  SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: _nameController,
                                      style: GoogleFonts.rajdhani(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: AppTheme.neonBlue,
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: AppTheme.neonBlue.withOpacity(0.5),
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: AppTheme.neonBlue,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      if (_nameController.text.trim().isNotEmpty) {
                                        await userProvider.updateDisplayName(_nameController.text.trim());
                                        setState(() {
                                          _isEditing = false;
                                        });
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Nom mis à jour avec succès',
                                              style: GoogleFonts.rajdhani(),
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.green,
                                          width: 1,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.check_rounded,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ] else ...[
                                  Text(
                                    userProfile.displayName,
                                    style: GoogleFonts.orbitron(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _isEditing = true;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppTheme.neonBlue.withOpacity(0.5),
                                          width: 1,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.edit_rounded,
                                        color: AppTheme.neonBlue,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            
                            // Email
                            const SizedBox(height: 8),
                            Text(
                              user.email ?? 'Aucun email',
                              style: GoogleFonts.rajdhani(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Section Paramètres
                      Text(
                        'PARAMÈTRES',
                        style: GoogleFonts.rajdhani(
                          color: AppTheme.neonPink,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 15),
                      
                      // Carte des paramètres
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: AppTheme.neonBlue.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildSettingItem(
                              icon: Icons.notifications_rounded,
                              title: 'Notifications',
                              onTap: () {},
                            ),
                            const Divider(color: Colors.white10, height: 30),
                            _buildSettingItem(
                              icon: Icons.security_rounded,
                              title: 'Confidentialité',
                              onTap: () {},
                            ),
                            const Divider(color: Colors.white10, height: 30),
                            _buildSettingItem(
                              icon: Icons.help_rounded,
                              title: 'Aide & Support',
                              onTap: () {},
                            ),
                            const Divider(color: Colors.white10, height: 30),
                            _buildSettingItem(
                              icon: Icons.info_rounded,
                              title: 'À propos',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.neonBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppTheme.neonBlue,
                size: 22,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: GoogleFonts.rajdhani(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(UserProfile userProfile) {
    final defaultAvatarIndex = userProfile.defaultAvatarIndex;
    if (defaultAvatarIndex >= 0 && defaultAvatarIndex <= 2) {
      return Image.asset(
        'assets/avatars/avatar_$defaultAvatarIndex.png',
        fit: BoxFit.cover,
      );
    }
    return Icon(
      Icons.person_rounded,
      color: Colors.white,
      size: 50,
    );
  }
}
