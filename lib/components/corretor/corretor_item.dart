import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/corretores/corretor.dart';
import '../../pages/corretor_clientes/corretor_info_page.dart';



class CorretorItem extends StatelessWidget {
  final bool isDarkMode;
  final Corretor cliente;

  const CorretorItem(this.isDarkMode, this.cliente, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(cliente.imageUrl),
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
                      color: !isDarkMode ? Colors.black :Colors.white,
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
                      color: !isDarkMode ? Colors.black :Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          InkWell(
            onTap: () {
              Get.toNamed('/corretor/${cliente.id}');

            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                color: !isDarkMode ? Colors.black :Colors.white,
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
    );
  }
}
