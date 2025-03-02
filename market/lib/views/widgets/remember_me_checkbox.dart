import 'package:flutter/material.dart';

class RememberMeCheckbox extends StatefulWidget {
  final Function(bool) onChanged;

  const RememberMeCheckbox({
    super.key,
    required this.onChanged,
  });

  @override
  RememberMeCheckboxState createState() =>
      RememberMeCheckboxState();
}

class RememberMeCheckboxState
    extends State<RememberMeCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isChecked = !isChecked;
              widget.onChanged(isChecked);
            });
          },
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.purpleAccent, // Fondo rosa
              borderRadius: BorderRadius.circular(
                6,
              ), // Bordes redondeados
            ),
            child: Icon(
              Icons.star,
              color:
                  isChecked
                      ? Colors.black
                      : Colors
                          .white, // Estrella negra o blanca
              size: 15,
            ),
          ),
        ),
        const SizedBox(width: 5),
        const Text(
          "Recordarme",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
