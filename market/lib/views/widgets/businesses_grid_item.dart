import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market/models/businesses_model.dart';

class BusinessesGridItem extends StatelessWidget {
  const BusinessesGridItem({
    super.key,
    required this.business,
  });

  final BusinessesModel business;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              business.color.withOpacity(0.55),
              business.color.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            business.title,
            style: GoogleFonts.nunitoSans(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
