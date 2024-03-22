import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/services/firebase/auth/auth_service.dart';
import '../pages/auth/auth_page.dart';
import '../pages/user_config_page.dart';
import '../theme/appthemestate.dart'; // Importe a página de configurações do usuário aqui

class CustomPopupMenu extends StatelessWidget {
 
  const CustomPopupMenu({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final themeNotifier = Provider.of<AppThemeStateNotifier>(context);
     
    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: themeNotifier.isDarkModeEnabled ? Colors.black54:Colors.white70 ,
        iconTheme: IconThemeData(color: themeNotifier.isDarkModeEnabled ? Colors.white : Colors.black),
      ),
      child: PopupMenuButton(
        icon: const Icon(Icons.keyboard_arrow_down_outlined),
        itemBuilder: (_) => [
          PopupMenuItem(
            value: 'settings',
            child: Text(
              'Configurações',
             
            ),
          ),
          PopupMenuItem(
            value: 'logout',
            child: Text(
              'Logout',
             
            ),
          ),
        ],
        onSelected: (value) {
          if (value == 'settings') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserConfig()),
            );
          }
          if (value == 'logout') {
            AuthService().logout();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => AuthPage()),
              (route) => false,
            );
          }
        },
      ),
    );
  }
}
