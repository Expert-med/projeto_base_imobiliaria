import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


//import 'package:projeto_cme_novo/autenticacao/checkPage.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String subtitle;
  final String title;
  final Widget? leading;
  final showNotificacao;
  final bool isDarkMode;

  CustomAppBar(
      {required this.subtitle,
      required this.title,
      this.leading,
      this.showNotificacao,
      required this.isDarkMode});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(60.0);
}

class _CustomAppBarState extends State<CustomAppBar> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  late DocumentReference hospitalDoc;
  late DocumentReference clienteDoc;

  @override
  void initState() {
    super.initState();
   
  }





 

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;

    return AppBar(
      toolbarHeight: 50,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? Colors.black
              : Color.fromARGB(255, 238, 238, 238),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 50, bottom: 20, right: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'CoreMellow',
                      fontSize: isSmallScreen ? 15 : 23,
                      color: Color(0xFF6e58e9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.subtitle != '')
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 16,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
              Spacer(),
              // if (!isSmallScreen)
              //   Image.asset(
              //     'logoExpertMed1.png',
              //     height: 100,
              //     width: 100,
              //   ),
              // if (isSmallScreen)
              //   Image.asset(
              //     'logoExpertMed1.png',
              //     height: 50,
              //     width: 50,
              //   ),
              
              
            ],
          ),
        ),
      ),
      leading: widget.leading,
    );
  }
}
