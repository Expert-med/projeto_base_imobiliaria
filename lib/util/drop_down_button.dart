import 'package:flutter/material.dart';

class StatusDropdown extends StatefulWidget {
  final List<String> statusOptions;
  final String? selectedStatus;
  final ValueChanged<String?> onChanged;
  final String labeltext;

  StatusDropdown({
    required this.statusOptions,
    required this.selectedStatus,
    required this.onChanged,
    required this.labeltext,
  });

  @override
  _StatusDropdownState createState() => _StatusDropdownState();
}

class _StatusDropdownState extends State<StatusDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: widget.labeltext,
        labelStyle: TextStyle(
                                    color: Color(0xFF6e58e9), 
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
        filled: true,
        fillColor: Colors.black12,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dropdownColor: Colors.white,
      value: widget.selectedStatus,
      items: widget.statusOptions.map((String status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(
            status,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
      onChanged: widget.onChanged,
    );
  }
}
