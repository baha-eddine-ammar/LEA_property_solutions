import 'package:flutter/material.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black, width: 2)),
                    ),
                    child: const Center(
                      child: Text(
                        'Messages',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Center(
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView(
              children: [
                _buildMessageItem(
                  senderName: 'Natacha',
                  senderLocation: 'Haslemere',
                  title: 'Airbnb update: Reservation request declined',
                  message: 'Request declined · Feb 5 - 10',
                  time: '2 hours ago',
                  isUnread: true,
                  senderImage: 'https://randomuser.me/api/portraits/women/32.jpg',
                ),
                const Divider(height: 1),
                _buildMessageItem(
                  senderName: 'LEA Support Team',
                  senderLocation: 'Support',
                  title: 'Welcome to LEA Property Solutions!',
                  message:
                      'Thank you for joining our platform. We\'re excited to help you find your perfect property. Browse our listings and feel free to contact us if you have any questions.',
                  time: 'Yesterday',
                  isUnread: false,
                  senderImage: 'https://randomuser.me/api/portraits/men/45.jpg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem({
    required String senderName,
    required String senderLocation,
    required String title,
    required String message,
    required String time,
    required bool isUnread,
    required String senderImage,
  }) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sender Image
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(senderImage),
            ),
            const SizedBox(width: 16),
            // Message Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        senderName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text(' · '),
                      Text(
                        senderLocation,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight:
                          isUnread ? FontWeight.bold : FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
