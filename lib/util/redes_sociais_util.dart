import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RedesSociaisRow extends StatelessWidget {
  final String facebook;
  final String linkedin;
  final String instagram;
  final String celular;
  RedesSociaisRow(
      {required this.celular,
      required this.facebook,
      required this.linkedin,
      required this.instagram});

  Future<void> _openSocialMediaLink(String url) async {
    final Uri _url = Uri.parse(url); // Substitua pela URL externa desejada
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (celular != '')
          InkWell(
            onTap: () {
              _openSocialMediaLink('https://wa.me/${celular}');
            },
            child: Icon(
              FontAwesomeIcons.whatsapp,
            ),
          ),
        if (celular != '')
          SizedBox(
            width: 20,
          ),
        if (instagram != '')
          InkWell(
            onTap: () {
              _openSocialMediaLink(instagram);
            },
            child: Icon(
              FontAwesomeIcons.instagram,
            ),
          ),
        if (instagram != '')
          SizedBox(
            width: 20,
          ),
        if (linkedin != '')
          InkWell(
            onTap: () {
              _openSocialMediaLink(linkedin);
            },
            child: Icon(
              FontAwesomeIcons.linkedin,
            ),
          ),
        if (linkedin != '')
          SizedBox(
            width: 20,
          ),
        if (facebook != '')
          InkWell(
            onTap: () {
              _openSocialMediaLink(facebook);
            },
            child: Icon(
              FontAwesomeIcons.facebook,
            ),
          ),
        if (facebook != '')
          SizedBox(
            width: 20,
          ),
          if(facebook.isEmpty && celular.isEmpty && instagram.isEmpty && linkedin.isEmpty)
          Text('Nenhuma informação de contato adicionada.')
      ],
    );
  }
}
