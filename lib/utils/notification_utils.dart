import 'package:flutter/material.dart';

// Helper widget that creates a single, styled list tile for a notification.
Widget buildNotificationItem({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String message,
  required String time,
}) {
  final Color secondaryColor = Theme.of(context).colorScheme.secondary;
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: secondaryColor.withAlpha(25), // ~10% opacity (25/255)
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: secondaryColor, size: 24),
    ),
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text(message, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(time, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    ),
  );
}

// Function to show the modal dialog containing notification details.
// It requires a callback to handle clearing the notification count in the parent state.
void showNotificationsDialog(
  BuildContext context,
  void Function() clearNotifications,
) {
  final Color secondaryColor = Theme.of(context).colorScheme.secondary;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.notifications_active, color: secondaryColor),
          const SizedBox(width: 12),
          const Text('Notifications'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            buildNotificationItem(
              context: context,
              icon: Icons.update,
              title: 'New Standards Update',
              message: 'ISO 9001:2024 revision is now available',
              time: '2 hours ago',
            ),
            const Divider(),
            buildNotificationItem(
              context: context,
              icon: Icons.lightbulb,
              title: 'Daily Engineering Fact',
              message:
                  'Did you know? The Golden Gate Bridge\'s color is called International Orange',
              time: '5 hours ago',
            ),
            const Divider(),
            buildNotificationItem(
              context: context,
              icon: Icons.new_releases,
              title: 'New Tool Available',
              message: 'Beam Calculator is now ready to use',
              time: '1 day ago',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            clearNotifications(); // Calls the callback passed from the parent widget
            Navigator.pop(context);
          },
          child: Text(
            'CLEAR ALL',
            style: TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'CLOSE',
            style: TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
