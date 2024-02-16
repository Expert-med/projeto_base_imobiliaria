import 'package:flutter/material.dart';

import '../core/services/firebase/auth/auth_service.dart';
import '../pages/auth/auth_page.dart';
import '../pages/user_config_page.dart'; // Importe a página de configurações do usuário aqui

class CustomPopupMenu extends StatelessWidget {
  final bool isDarkMode; // Adicione este parâmetro para passar o modo escuro

  const CustomPopupMenu({
    Key? key,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: isDarkMode ? Colors.black54:Colors.white70 ,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      child: PopupMenuButton(
        icon: const Icon(Icons.keyboard_arrow_down_outlined),
        itemBuilder: (_) => [
          PopupMenuItem(
            value: 'settings',
            child: Text(
              'Configurações',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black54,
              ),
            ),
          ),
          PopupMenuItem(
            value: 'logout',
            child: Text(
              'Logout',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black54,
              ),
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
