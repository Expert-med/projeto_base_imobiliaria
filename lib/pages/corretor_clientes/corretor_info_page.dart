import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import '../../components/imovel/imovel_grid_favorites.dart';
import '../../models/corretores/corretor.dart';
import '../../util/new_app_bar_model.dart';
import '../corretores/lista_corretores_page.dart';
import '../imoveis/imoveis_Favoritos.dart';
import '../map/map_page.dart';

class CorretorInfoPage extends StatefulWidget {
  final Corretor corretor;
  final bool isDarkMode;

  const CorretorInfoPage(
      {required this.corretor, required this.isDarkMode, Key? key})
      : super(key: key);

  @override
  _CorretorInfoPageState createState() => _CorretorInfoPageState();
}

class _CorretorInfoPageState extends State<CorretorInfoPage> {
  List<String> imoveisFavoritos = [];
  List<String> userPreferences = [];

  @override
  void initState() {
    super.initState();
    // Carregue os imóveis favoritos do cliente aqui, se necessário
  }

  @override
  void dispose() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String imageBannerUrl = widget.corretor.infoBanner['image_url'].toString();
    print(widget.corretor.infoBanner['image_url'].toString());

    if (imageBannerUrl.isEmpty) {
      imageBannerUrl = 'https://www.cbde.org.br/images/default.jpg';
    }

    return Scaffold(
      appBar: NewCustomAppBar(isDarkMode: widget.isDarkMode, title: ''),
      backgroundColor: widget.isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Color.fromARGB(255, 238, 238, 238),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          '${widget.corretor.name[0].toUpperCase()}${widget.corretor.name.substring(1)} - \'CRECI\'',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: !widget.isDarkMode
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Color.fromARGB(255, 238, 238, 238),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double availableWidth = constraints.maxWidth;
                            return Image.network(
                              imageBannerUrl,
                              height: 500,
                              width: availableWidth,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8), // Adiciona um espaçamento entre widgets
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Imóveis cadastrados pelo Corretor',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: !widget.isDarkMode ? Colors.black : Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height *
                    0.5, // Defina a altura desejada aqui
                child: FavoriteImoveisGrid(
                  false,
                  widget.isDarkMode,
                  widget.corretor.imoveisCadastrados,
                ),
              ),
            ),
            if (widget.corretor.infoBanner['about_text'].toString() != '')
              Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                child: Text(
                  'Sobre o Corretor:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: !widget.isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
              ),
            if (widget.corretor.infoBanner['about_text'].toString() != '')
              Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Color.fromARGB(255, 238, 238, 238),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            '${widget.corretor.infoBanner['about_text'][0].toUpperCase()}${widget.corretor.infoBanner['about_text'].substring(1)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: !widget.isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            Padding(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Color.fromARGB(255, 238, 238, 238),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'INFORMAÇÕES LARHUB',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: !widget.isDarkMode
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
