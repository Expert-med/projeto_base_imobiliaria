import 'package:flutter/material.dart';
import 'package:projeto_imobiliaria/components/custom_menu.dart';
import 'package:projeto_imobiliaria/util/app_bar_model.dart';
import '../../components/imovel/imovel_grid.dart';
import '../../components/imovel/imovel_list_view.dart';

class ImovelPage extends StatefulWidget {
  bool isDarkMode;

  ImovelPage(this.isDarkMode, {Key? key}) : super(key: key);

  @override
  State<ImovelPage> createState() => _ImovelPageState();
}

class _ImovelPageState extends State<ImovelPage> {
  bool _showFavoriteOnly = false;
  bool _showGrid = true;

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
              child: _showGrid
                  ? ImovelGrid( widget.isDarkMode,  _showFavoriteOnly)
                  : ImovelListView( widget.isDarkMode,  _showFavoriteOnly),
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
              setState(() {
                _showGrid = !_showGrid;
              });
            },
            child: Icon(
              _showGrid ? Icons.list : Icons.grid_on,
            ),
          ),
          SizedBox(height: 10),
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
