import 'package:flutter/material.dart';

class CustomNavigationDrawer extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavigationDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomNavigationDrawer> createState() => _CustomNavigationDrawerState();
}

class _CustomNavigationDrawerState extends State<CustomNavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header with user info
          _buildHeader(context),

          // Navigation items
          Expanded(child: _buildNavigationItems()),

          // Sign out button
          _buildSignOutButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: const Text(
        "John Doe",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      accountEmail: const Text(
        "john.doe@example.com",
        style: TextStyle(fontSize: 14),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: ClipOval(
          child: Image.network(
            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        image: DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400&h=200&fit=crop",
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.2),
            BlendMode.darken,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItems() {
    final navigationItems = [
      {'title': 'Home', 'icon': Icons.home, 'route': 0},
      {'title': 'Profile', 'icon': Icons.person, 'route': 1},
      {'title': 'Settings', 'icon': Icons.settings, 'route': 2},
      {'title': 'Help & Support', 'icon': Icons.help, 'route': 3},
      {'title': 'Notifications', 'icon': Icons.notifications, 'route': 4},
      {'title': 'Favorites', 'icon': Icons.favorite, 'route': 5},
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ...navigationItems.map((item) {
          return ListTile(
            leading: Icon(item['icon'] as IconData),
            title: Text(item['title'] as String),
            selected: widget.selectedIndex == item['route'],
            selectedTileColor: Colors.blue.withOpacity(0.1),
            onTap: () {
              widget.onItemTapped(item['route'] as int);
            },
          );
        }),
      ],
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout, size: 20),
          label: const Text("Sign Out", style: TextStyle(fontSize: 16)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            _showSignOutDialog(context);
          },
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add your sign out logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Signed out successfully")),
                );
              },
              child: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
