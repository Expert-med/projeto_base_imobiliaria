import 'package:flutter/material.dart';

class CustomActionButtons extends StatelessWidget {
  final String buttonLabel;
  final Function() onPressed;

  CustomActionButtons({
    required this.buttonLabel,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
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
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
