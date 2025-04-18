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
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                255,
                97,
                13,
                175,
              ), // Fondo rosa
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.star,
              color:
                  isChecked
                      ? Colors.black
                      : Colors
                          .white, // Estrella negra o blanca
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 5),
        const Text(
          "Recordarme",
          style: TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
