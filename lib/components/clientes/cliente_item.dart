import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/clientes/Clientes.dart';
import 'cliente_corretor.dart';

class ClienteItem extends StatelessWidget {
  final Clientes cliente;

  const ClienteItem(this.cliente, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(cliente.logoUrl),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: IntrinsicHeight(
                    child: Text(
                      '${cliente.name}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 15 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: IntrinsicHeight(
                    child: Text(
                      '${cliente.email}',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClienteInfoCorretor(
                        cliente: cliente),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.info,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
