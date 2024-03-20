import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/models/imoveis/newImovelList.dart';
import 'package:projeto_imobiliaria/pages/imoveis/imoveis_Favoritos.dart';
import 'package:projeto_imobiliaria/pages/map/map_flutter.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import '../../components/imovel/imovel_grid.dart';
import '../../components/imovel/imovel_list_view.dart';
import 'cad_imovel_page.dart';

class ImovelPage extends StatefulWidget {
  bool isDarkMode;

  ImovelPage(this.isDarkMode, {Key? key}) : super(key: key);

  @override
  State<ImovelPage> createState() => _ImovelPageState();
}

class _ImovelPageState extends State<ImovelPage> {
  bool _showFavoriteOnly = false;
  bool _showGrid = true;
  bool _showList = false;
  bool _showMap = false;
  bool _isHoveredG = false;
  bool _isHoveredL = false;
  bool _isHoveredM = false;
  bool _isHoveredF = false;

  @override
  void initState() {
    super.initState();
    NewImovelList().buscarImoveis();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 900;
    

    return Scaffold(
      appBar: isSmallScreen
          ? CustomAppBar(
              isDarkMode: widget.isDarkMode,
              subtitle: '',
              title: 'Imóveis',
            )
          : null,
      body: LayoutBuilder(builder: (context, constraints) {
       return Row(
        children: [
          if (!isSmallScreen) CustomMenu(isDarkMode: widget.isDarkMode),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 400,
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                           SizedBox(width: 10),
                         Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Color(0xFF6e58e9),
                              width: 2, // largura da borda
                            ),
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(50),
                            color: _isHoveredG ? Colors.white : Color(0xFF6e58e9),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () {
                                setState(() {
                                  _showGrid = true;
                                  _showList = false;
                                  _showMap = false;
                                });
                              },
                              onHover: (hovering) {
                                setState(() {
                                  _isHoveredG = hovering;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                width: 125,
                                height: 55,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center, // Centralizar o ícone verticalmente
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      width: 30,
                                      child: Icon(Icons.grid_on_sharp, color: _isHoveredG ? Color(0xFF6e58e9) : Colors.white),
                                    ),
                                    Expanded(
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 300),
                                        opacity: 1.0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Text(
                                            'GRID',
                                            style: TextStyle(color: _isHoveredG ? Color(0xFF6e58e9) : Colors.white, fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                          SizedBox(width: 10),
                          Material(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xFF6e58e9),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () {
                                setState(() {
                                  _showGrid = false;
                                  _showList = true;
                                  _showMap = false;
                                });
                              },
                              onHover: (hovering) {
                                setState(() {
                                  _isHoveredL = hovering;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                width: _isHoveredL ? 125 : 55,
                                height: 55,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center, // Centralizar o ícone verticalmente
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      width: _isHoveredL ? 30 : 0,
                                      child: Icon(Icons.list, color: Colors.white),
                                    ),
                                    Expanded(
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 300),
                                        opacity: _isHoveredL ? 1.0 : 0.0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Text(
                                            'Lista',
                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                           SizedBox(width: 10),
                          Material(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xFF6e58e9),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () {
                                setState(() {
                                  _showGrid = false;
                                  _showList = false;
                                  _showMap = true;
                                });
                              },
                              onHover: (hovering) {
                                setState(() {
                                  _isHoveredM = hovering;

                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                width: _isHoveredM ? 125 : 55,
                                height: 55,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center, // Centralizar o ícone verticalmente
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      width: _isHoveredM ? 30 : 0,
                                      child: Icon(Icons.place, color: Colors.white),
                                    ),
                                    Expanded(
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 300),
                                        opacity: _isHoveredM ? 1.0 : 0.0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Text(
                                            'MAPA',
                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        Material(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xFF6e58e9),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () {
                                setState(() {
                                  _showGrid = false;
                                  _showList = false;
                                  _showMap = false;
                                });
                              },
                              onHover: (hovering) {
                                setState(() {
                                  _isHoveredF = hovering;

                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                width: _isHoveredF ? 125 : 55,
                                height: 55,
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center, // Centralizar o ícone verticalmente
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      width: _isHoveredF ? 30 : 0,
                                      child: Icon(Icons.favorite, color: Colors.white),
                                    ),
                                    Expanded(
                                      child: AnimatedOpacity(
                                        duration: Duration(milliseconds: 300),
                                        opacity: _isHoveredF ? 1.0 : 0.0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Text(
                                            'FAVORITOS',
                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: 
                  _showGrid
                      ? ImovelGrid(widget.isDarkMode, _showFavoriteOnly)
                      : _showList ? ImovelListView(widget.isDarkMode, _showFavoriteOnly) : _showMap ? MapPageFlutter() : ImoveisFavoritos(isDarkMode: false),
                ),
              ],
            ),
          ),
        ],
      );

      }),
      drawer: isSmallScreen ? CustomMenu(isDarkMode: false) : null,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CadastroImovel()
                  ),
                );
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 4),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                widget.isDarkMode = !widget.isDarkMode;
              });
            },
            child: Icon(Icons.lightbulb),
          ),
        ],
      ),
    );
  }
}
