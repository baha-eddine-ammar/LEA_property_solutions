import 'package:flutter/material.dart';
import '../widgets/notification_center.dart' as notification_widget;

class NotificationService {
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Notifications list
  final List<notification_widget.Notification> _notifications = [];
  
  // Stream controller for notifications
  final ValueNotifier<int> unreadCount = ValueNotifier<int>(0);

  // Initialize with sample notifications
  void initialize() {
    // Add sample notifications
    _addSampleNotifications();
    
    // Update unread count
    _updateUnreadCount();
  }

  // Get all notifications
  List<notification_widget.Notification> getAllNotifications() {
    return List.from(_notifications);
  }

  // Add a new notification
  void addNotification(notification_widget.Notification notification) {
    _notifications.add(notification);
    _updateUnreadCount();
  }

  // Mark a notification as read
  void markAsRead(notification_widget.Notification notification) {
    final index = _notifications.indexWhere((n) => n.id == notification.id);
    if (index != -1) {
      _notifications[index].isRead = true;
      _updateUnreadCount();
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    _updateUnreadCount();
  }

  // Delete notifications by IDs
  void deleteNotifications(List<String> ids) {
    _notifications.removeWhere((notification) => ids.contains(notification.id));
    _updateUnreadCount();
  }

  // Update unread count
  void _updateUnreadCount() {
    final count = _notifications.where((notification) => !notification.isRead).length;
    unreadCount.value = count;
  }

  // Add sample notifications for demo
  void _addSampleNotifications() {
    _notifications.addAll([
      notification_widget.Notification(
        id: '1',
        title: 'Welcome to LEA Property',
        message: 'Thank you for joining our community. Start exploring properties now!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: notification_widget.NotificationType.system,
        isRead: false,
      ),
      notification_widget.Notification(
        id: '2',
        title: 'Special Offer: 10% Off',
        message: 'Book any property this weekend and get 10% off your stay!',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: notification_widget.NotificationType.promotion,
        imageUrl: 'https://images.unsplash.com/photo-1560520653-9e0e4c89eb11',
        isRead: false,
      ),
      notification_widget.Notification(
        id: '3',
        title: 'New Message from Host',
        message: 'You have a new message from the host of "Modern Beachfront Villa"',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        type: notification_widget.NotificationType.message,
        isRead: true,
      ),
      notification_widget.Notification(
        id: '4',
        title: 'Booking Confirmed',
        message: 'Your booking for "Luxury Countryside Estate" has been confirmed.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: notification_widget.NotificationType.booking,
        isRead: true,
      ),
      notification_widget.Notification(
        id: '5',
        title: 'Rate Your Stay',
        message: 'How was your recent stay at "Modern City Apartment"? Please leave a review.',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        type: notification_widget.NotificationType.system,
        isRead: false,
      ),
      notification_widget.Notification(
        id: '6',
        title: 'Limited Time Offer',
        message: 'Book a property in London and get a free airport transfer!',
        timestamp: DateTime.now().subtract(const Duration(days: 5)),
        type: notification_widget.NotificationType.promotion,
        imageUrl: 'https://images.unsplash.com/photo-1520531158340-44015069e78e',
        isRead: false,
      ),
    ]);
  }
}
