import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/language_selector.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _currentLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            floating: true,
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.black),
                onPressed: () {
                  // Navigate to settings
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/images/profile.jpg'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'John Doe',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Member since 2023',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Profile Actions
                  _buildActionButton(
                    icon: Icons.edit,
                    label: 'Edit profile',
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.favorite,
                    label: 'Wishlists',
                    onTap: () {},
                  ),
                  const Divider(height: 32),
                  // Hosting Section
                  const Text(
                    'Hosting',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActionButton(
                    icon: Icons.home,
                    label: 'List your property',
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.business,
                    label: 'Learn about hosting',
                    onTap: () {},
                  ),
                  const Divider(height: 32),
                  // Support Section
                  const Text(
                    'Support',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActionButton(
                    icon: Icons.help,
                    label: 'Get help',
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.info,
                    label: 'How LEA works',
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.security,
                    label: 'Safety center',
                    onTap: () {},
                  ),
                  const Divider(height: 32),
                  // Settings Section
                  const Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LanguageSelector(
                    currentLanguage: _currentLanguage,
                    onLanguageChanged: (language) {
                      setState(() {
                        _currentLanguage = language;
                      });
                    },
                  ),
                  const Divider(height: 32),

                  // Legal Section
                  const Text(
                    'Legal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildActionButton(
                    icon: Icons.privacy_tip,
                    label: 'Privacy policy',
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.description,
                    label: 'Terms of service',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle logout
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
