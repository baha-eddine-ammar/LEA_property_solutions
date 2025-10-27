import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final String? imageUrl;
  final VoidCallback? onTap;
  bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.imageUrl,
    this.onTap,
    this.isRead = false,
  });
}

enum NotificationType {
  booking,
  promotion,
  system,
  message,
}

class NotificationCenter extends StatefulWidget {
  final List<Notification> notifications;
  final Function(Notification) onNotificationRead;
  final Function(List<String>) onNotificationsDeleted;
  final Function() onMarkAllAsRead;

  const NotificationCenter({
    Key? key,
    required this.notifications,
    required this.onNotificationRead,
    required this.onNotificationsDeleted,
    required this.onMarkAllAsRead,
  }) : super(key: key);

  @override
  State<NotificationCenter> createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _selectedNotifications = [];
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedNotifications.clear();
      }
    });
  }

  void _toggleNotificationSelection(String id) {
    setState(() {
      if (_selectedNotifications.contains(id)) {
        _selectedNotifications.remove(id);
      } else {
        _selectedNotifications.add(id);
      }
    });
  }

  void _deleteSelectedNotifications() {
    widget.onNotificationsDeleted(_selectedNotifications);
    setState(() {
      _isSelectionMode = false;
      _selectedNotifications.clear();
    });
  }

  List<Notification> _getFilteredNotifications(NotificationType type) {
    return widget.notifications.where((notification) => notification.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _selectedNotifications.isNotEmpty ? _deleteSelectedNotifications : null,
            )
          else
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: _toggleSelectionMode,
            ),
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: widget.onMarkAllAsRead,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Bookings'),
            Tab(text: 'Promotions'),
            Tab(text: 'System'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All notifications
          _buildNotificationList(widget.notifications),
          
          // Booking notifications
          _buildNotificationList(_getFilteredNotifications(NotificationType.booking)),
          
          // Promotion notifications
          _buildNotificationList(_getFilteredNotifications(NotificationType.promotion)),
          
          // System notifications
          _buildNotificationList(_getFilteredNotifications(NotificationType.system)),
        ],
      ),
    );
  }

  Widget _buildNotificationList(List<Notification> notifications) {
    if (notifications.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No notifications',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(Notification notification) {
    final isSelected = _selectedNotifications.contains(notification.id);
    
    // Get icon based on notification type
    IconData icon;
    Color iconColor;
    
    switch (notification.type) {
      case NotificationType.booking:
        icon = Icons.calendar_today;
        iconColor = Colors.blue;
        break;
      case NotificationType.promotion:
        icon = Icons.local_offer;
        iconColor = Colors.orange;
        break;
      case NotificationType.system:
        icon = Icons.info;
        iconColor = Colors.green;
        break;
      case NotificationType.message:
        icon = Icons.message;
        iconColor = Colors.purple;
        break;
    }

    return InkWell(
      onTap: _isSelectionMode
          ? () => _toggleNotificationSelection(notification.id)
          : () {
              if (!notification.isRead) {
                widget.onNotificationRead(notification);
              }
              if (notification.onTap != null) {
                notification.onTap!();
              }
            },
      onLongPress: () {
        if (!_isSelectionMode) {
          _toggleSelectionMode();
          _toggleNotificationSelection(notification.id);
        }
      },
      child: Container(
        color: isSelected ? Colors.grey[100] : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selection checkbox or notification icon
              _isSelectionMode
                  ? Checkbox(
                      value: isSelected,
                      onChanged: (value) {
                        _toggleNotificationSelection(notification.id);
                      },
                    )
                  : Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 20,
                      ),
                    ),
              const SizedBox(width: 16),
              
              // Notification content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // Image if available
                    if (notification.imageUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            notification.imageUrl!,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Unread indicator
              if (!notification.isRead && !_isSelectionMode)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(left: 8, top: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class NotificationBadge extends StatelessWidget {
  final int count;
  final double size;
  final Color color;
  final VoidCallback onTap;

  const NotificationBadge({
    Key? key,
    required this.count,
    this.size = 20,
    this.color = Colors.red,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return IconButton(
        icon: const Icon(Icons.notifications_none),
        onPressed: onTap,
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_active),
          onPressed: onTap,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            constraints: BoxConstraints(
              minWidth: size,
              minHeight: size,
            ),
            child: Center(
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.6,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
