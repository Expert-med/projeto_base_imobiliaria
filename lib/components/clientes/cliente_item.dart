import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/clientes/Clientes.dart';


class ClienteItem extends StatelessWidget {
  final bool isDarkMode;
  final Clientes cliente;

  const ClienteItem(this.isDarkMode, this.cliente, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(cliente.name, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}