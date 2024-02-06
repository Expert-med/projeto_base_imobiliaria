import 'package:flutter/material.dart';

class CustomCadastrarButton extends StatelessWidget {
  final Function() onPressed;
  final String buttonLabel;

  CustomCadastrarButton({
    required this.onPressed,
    required this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: ElevatedButton(
                      onPressed: onPressed,
                      child: Text(
                        buttonLabel,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 10.0,
                        backgroundColor: Color(0xFF466B66),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 20.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
