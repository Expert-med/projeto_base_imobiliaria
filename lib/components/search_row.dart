import 'package:flutter/material.dart';
import '../util/dark_color_util.dart';

class SearchRow extends StatefulWidget {
  final bool isDarkMode;

  const SearchRow({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  _SearchRowState createState() => _SearchRowState();
}

class _SearchRowState extends State<SearchRow> {
  TextEditingController locationController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20, right: 10, top: 20),
            child: TextFormField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Localização',
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10, right: 10, top: 20),
            child: TextFormField(
              controller: typeController,
              decoration: InputDecoration(
                labelText: 'Tipo',
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
            onPressed: () {
              print('Localização: ${locationController.text}');
              print('Tipo: ${typeController.text}');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Text(
                "Procurar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.black,
              elevation: 10.0,
              backgroundColor: widget.isDarkMode
                  ? darkenColor(Color(0xFF6e58e9), 0.5)
                  : Color(0xFF6e58e9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 10, right: 20, top: 20),
          child: InkWell(
                            onTap: () {
                             
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black26,
                              ),
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.filter_list,
                                color: Colors.black54,
                                size: 30,
                              ),
                            ),
                          ),
        ),
      ],
    );
  }
}
