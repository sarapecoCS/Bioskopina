import 'package:flutter/material.dart';

import '../screens/settings_screen.dart';
import '../screens/login_screen.dart';
import '../widgets/separator.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/util.dart';

class UserProfileDialog extends StatefulWidget {
  final User loggedUser;
  const UserProfileDialog({super.key, required this.loggedUser});

  @override
  State<UserProfileDialog> createState() => _UserProfileDialogState();
}

class _UserProfileDialogState extends State<UserProfileDialog> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    double imageWidth = screenSize.width * 0.25;
    double imageHeight = imageWidth;

    return Dialog(
      insetPadding: const EdgeInsets.only(right: 10, left: 10, top: 20),
      alignment: Alignment.topCenter,
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Palette.darkPurple,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Palette.lightPurple.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.memory(
                          imageFromBase64String(
                              widget.loggedUser.profilePicture!.profilePicture!),
                          width: imageWidth,
                          height: imageHeight,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: screenSize.width * 0.4, maxHeight: 50),
                          child: Text(
                            "${widget.loggedUser.username}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Palette.selectedGenre,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: screenSize.width * 0.4, maxHeight: 50),
                          child: Text(
                            "${widget.loggedUser.firstName} ${widget.loggedUser.lastName}",
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                MySeparator(
                  width: double.infinity,
                  paddingTop: 20,
                  paddingBottom: 5,
                  borderRadius: 50,
                  opacity: 0.8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Settings button with gradient background
                    Container(
                      decoration: BoxDecoration(
                        gradient: Palette.buttonGradient,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Settings',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(width: 5),
                            Icon(Icons.settings_rounded,
                                size: 15, color: Colors.white),
                          ],
                        ),
                      ),
                    ),

                    // Log Out button with gradient background
                    Container(
                      decoration: BoxDecoration(
                        gradient: Palette.buttonGradient,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Authorization.username = "";
                          Authorization.password = "";
                          LoggedUser.user = null;

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('Log Out', style: TextStyle(color: Colors.white)),
                            SizedBox(width: 5),
                            Icon(Icons.logout, size: 16, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Close button at top-right corner
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
              splashRadius: 20,
              tooltip: 'Close',
            ),
          ),
        ],
      ),
    );
  }
}
