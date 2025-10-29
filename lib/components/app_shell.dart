// app_shell.dart

import 'package:flutter/material.dart';

// Import all necessary pages (content views for the tabs).
import 'package:mechanicalengineering/utils/calculator_page.dart';
import 'package:mechanicalengineering/pages/dashboard.dart';
import 'package:mechanicalengineering/pages/tools_page.dart';

// Import utility functions for showing the notification dialog.
import 'package:mechanicalengineering/utils/notification_utils.dart';

// The main stateful widget that acts as the application's shell/structure (Scaffold, AppBar, Tabs).
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

// State management for the AppShell, holding active tab, notification count, etc.
class _AppShellState extends State<AppShell> {
  int _currentIndex =
      0; // State variable: Tracks the currently selected tab index (0=Dashboard).
  int _notificationCount =
      3; // State variable: Example notification count for the badge.

  // List of all content page widgets, ordered by their corresponding navigation tab index.
  final List<Widget> _pages = const [
    DashboardPage(), // Index 0
    CalculatorPage(), // Index 1
    ToolsPage(), // Index 2
  ];

  // Function to update the state when a tab is tapped. Passed down to AppNavigationBar.
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex =
          index; // Changes the current index to switch the displayed body widget.
    });
  }

  // Function to reset the notification counter. Passed to showNotificationsDialog utility.
  void _clearNotifications() {
    setState(() {
      _notificationCount =
          0; // Resets the badge count when the user clears notifications.
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieves the secondary (accent) color from the defined theme for use in custom widgets.
    final Color accentColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        // Conditionally renders a leading widget (back button).
        leading: _currentIndex != 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentIndex =
                        0; // Navigates the user back to the Dashboard (index 0).
                  });
                },
              )
            : null,
        // Renders nothing (null) on the Dashboard screen.
        title: const Text('Mechanical Engineering'),
        // Displays a constant title across all tabs.
        actions: [
          // Stack is used to layer the icon button and the notification badge.
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // Calls the segregated utility function to display the dialog.
                  // Passes the context and the local state-clearing function.
                  showNotificationsDialog(context, _clearNotifications);
                },
              ),
              // Notification badge rendering logic (only visible if count > 0).
              if (_notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      // Standard color for a notification badge.
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      _notificationCount > 9 ? '9+' : '$_notificationCount',
                      // Shows '9+' for counts over 9.
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8), // Adds some padding on the right side.
        ],
      ),
      body: _pages[_currentIndex],
      // Dynamically shows the page widget corresponding to the current index.

      // Delegates the BottomNavigationBar UI to the separate stateless component.
      bottomNavigationBar: AppNavigationBar(
        currentIndex: _currentIndex,
        // Passes the current state to highlight the correct tab.
        onTap: _onTabTapped,
        // Passes the state setter method to handle user taps.
        accentColor: accentColor, // Passes the theme accent color for styling.
      ),
    );
  }
}

// Separate widget for the Bottom Navigation Bar UI, which is stateless.
// It receives all necessary data and callbacks from its parent (_AppShellState).
class AppNavigationBar extends StatelessWidget {
  final int currentIndex; // The currently active tab index.
  final ValueChanged<int> onTap; // The function to call when a tab is pressed.
  final Color accentColor; // The color used to highlight the selected item.

  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the bar container.
        boxShadow: [
          // Custom shadow for a modern, subtle raised effect.
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        // Executes the parent's _onTabTapped method.
        type: BottomNavigationBarType.fixed,
        // Ensures items don't shift when selected.
        backgroundColor: Colors.white,
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.grey.shade600,
        selectedFontSize: 13,
        unselectedFontSize: 12,
        elevation: 0,
        // Shadow is handled by the parent Container.
        items: const [
          // Defines the icon and label for each of the four tabs.
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_rounded),
            label: 'Calculator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_rounded),
            label: 'Tools',
          ),
        ],
      ),
    );
  }
}
