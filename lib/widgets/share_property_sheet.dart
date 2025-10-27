import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../theme/app_theme.dart';

class SharePropertySheet extends StatelessWidget {
  final PropertyListing property;

  const SharePropertySheet({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          
          // Title
          Text(
            'Share this property',
            style: AppTheme.headingMedium,
          ),
          const SizedBox(height: 8),
          
          // Property info
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  property.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title,
                      style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      property.location,
                      style: AppTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Share options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildShareOption(
                context,
                icon: Icons.message_outlined,
                label: 'Message',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  _showShareConfirmation(context, 'Message');
                },
              ),
              _buildShareOption(
                context,
                icon: Icons.email_outlined,
                label: 'Email',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _showShareConfirmation(context, 'Email');
                },
              ),
              _buildShareOption(
                context,
                icon: Icons.copy_outlined,
                label: 'Copy Link',
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                  _showShareConfirmation(context, 'Copy Link');
                },
              ),
              _buildShareOption(
                context,
                icon: Icons.more_horiz,
                label: 'More',
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context);
                  _showShareConfirmation(context, 'More options');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Cancel button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: AppTheme.secondaryButtonStyle,
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildShareOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  void _showShareConfirmation(BuildContext context, String method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Property shared via $method'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
