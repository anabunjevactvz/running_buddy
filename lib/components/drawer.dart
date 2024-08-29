import 'package:flutter/material.dart';
import 'package:running/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  final void Function()? onQuizTap;
  final int currentScore; // Dodano za prikaz bodova

  const MyDrawer({
    super.key,
    this.onProfileTap,
    this.onSignOut,
    this.onQuizTap,
    required this.currentScore, // Dodano za prikaz bodova
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const DrawerHeader(
                child: Icon(Icons.person, color: Colors.white, size: 64),
              ),
              MyListTile(
                  icon: Icons.home,
                  text: 'HOME',
                  onTap: () => Navigator.pop(context)),
              MyListTile(
                  icon: Icons.person, text: 'PROFILE', onTap: onProfileTap),
              MyListTile(
                  icon: Icons.quiz, text: 'NETIQUETTE QUIZ', onTap: onQuizTap),
            ],
          ),
          Column(
            children: [
              // Prikaz trenutnog broja bodova
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Your score: $currentScore',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              // Logout dugme
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: MyListTile(
                    icon: Icons.logout, text: 'LOGOUT', onTap: onSignOut),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
