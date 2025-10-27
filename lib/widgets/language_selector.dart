import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LanguageSelector extends StatefulWidget {
  final Function(String) onLanguageChanged;
  final String currentLanguage;

  const LanguageSelector({
    Key? key,
    required this.onLanguageChanged,
    this.currentLanguage = 'English',
  }) : super(key: key);

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  late String _selectedLanguage;
  
  final List<Language> _languages = [
    Language(code: 'en', name: 'English', flag: '🇺🇸'),
    Language(code: 'es', name: 'Spanish', flag: '🇪🇸'),
    Language(code: 'fr', name: 'French', flag: '🇫🇷'),
    Language(code: 'de', name: 'German', flag: '🇩🇪'),
    Language(code: 'it', name: 'Italian', flag: '🇮🇹'),
    Language(code: 'pt', name: 'Portuguese', flag: '🇵🇹'),
    Language(code: 'ru', name: 'Russian', flag: '🇷🇺'),
    Language(code: 'zh', name: 'Chinese', flag: '🇨🇳'),
    Language(code: 'ja', name: 'Japanese', flag: '🇯🇵'),
    Language(code: 'ar', name: 'Arabic', flag: '🇸🇦'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language, color: AppTheme.primaryColor),
      title: const Text(
        'Language',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        _selectedLanguage,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        _showLanguageBottomSheet(context);
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final language = _languages[index];
                    final isSelected = language.name == _selectedLanguage;
                    
                    return ListTile(
                      leading: Text(
                        language.flag,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        language.name,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? AppTheme.primaryColor : null,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppTheme.primaryColor,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedLanguage = language.name;
                        });
                        widget.onLanguageChanged(language.code);
                        Navigator.pop(context);
                        
                        // Show confirmation
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Language changed to ${language.name}'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppTheme.successColor,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Language {
  final String code;
  final String name;
  final String flag;

  Language({
    required this.code,
    required this.name,
    required this.flag,
  });
}
