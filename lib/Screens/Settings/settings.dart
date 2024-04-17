import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:unipay/Screens/Profile/profile.dart';
import 'package:unipay/Screens/Settings/widgets/forward_button.dart';
import 'package:unipay/Screens/Settings/widgets/setting_item.dart';
import 'package:unipay/Screens/Settings/widgets/setting_switch.dart';
import '../../components/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: color14,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    //Image.asset("assets/avatar.png", width: 70, height: 70),
                    const SizedBox(width: 20),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Personal info",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 14,
                            color: color15,
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    ForwardButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Privacy",
                icon: Ionicons.shield_checkmark,
                bgColor: color12,
                iconColor: color15,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "About",
                icon: Icons.info,
                bgColor: color12,
                iconColor: color15,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              SettingSwitch(
                title: "Dark Mode",
                icon: Ionicons.moon,
                bgColor: color12,
                iconColor: color15,
                value: isDarkMode,
                onTap: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Lock",
                icon: Icons.lock,
                bgColor: color12,
                iconColor: color15,
                onTap: () {},
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "Delete Account",
                icon: Icons.delete_forever_rounded,
                bgColor: color12,
                iconColor: color15,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}