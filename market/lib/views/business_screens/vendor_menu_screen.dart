import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(body: ListView(children: [PortafolioVendedor()])),
    );
  }
}

class PortafolioVendedor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 393,
          height: 852,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: -2,
                top: 592,
                child: Container(
                  width: 399,
                  height: 175,
                  decoration: BoxDecoration(color: const Color(0xFFF0F0ED)),
                ),
              ),
              Positioned(
                left: -17,
                top: 461,
                child: SizedBox(
                  width: 355,
                  height: 120,
                  child: Text(
                    '                                 Cloud White / Core Black / Clear Granite\n',
                    style: TextStyle(
                      color: const Color(0xFF646464),
                      fontSize: 12,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 4.8,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 135,
                top: 446,
                child: SizedBox(
                  width: 229,
                  height: 140,
                  child: Text(
                    'Tenis Samba OG',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 3,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 280,
                top: 713,
                child: SizedBox(
                  width: 239,
                  height: 40,
                  child: Text(
                    'Lucky shorts',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 4.04,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 25,
                top: 713,
                child: SizedBox(
                  width: 239,
                  height: 40,
                  child: Text(
                    'Air Jordan Low',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 4.04,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 150,
                top: 713,
                child: SizedBox(
                  width: 239,
                  height: 40,
                  child: Text(
                    '    Nike Court',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 4.04,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 153,
                top: 535,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(color: const Color(0xFF666666)),
                ),
              ),
              Positioned(
                left: 178,
                top: 535,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(color: const Color(0xFF9E9D9C)),
                ),
              ),
              Positioned(
                left: 203,
                top: 535,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(color: const Color(0xFF666666)),
                ),
              ),
              Positioned(
                left: 169,
                top: 523,
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: Text(
                    '0',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 4.38,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 158,
                top: 546,
                child: Container(
                  width: 15,
                  height: 2,
                  decoration: BoxDecoration(color: Colors.black),
                ),
              ),
              Positioned(
                left: 16,
                top: 583,
                child: Container(
                  width: 358,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 128,
                top: 776,
                child: Container(
                  width: 132,
                  height: 51,
                  decoration: ShapeDecoration(
                    color: const Color(0xD8222222),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 97,
                top: 776,
                child: SizedBox(
                  width: 137,
                  height: 34.64,
                  child: Text(
                    'Comprar',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w900,
                      height: 2.62,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 160,
                top: 205,
                child: Container(
                  width: 235,
                  height: 221,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/235x221"),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: -99,
                top: 205,
                child: Container(
                  width: 247,
                  height: 221,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/247x221"),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 169,
                top: 446,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 181,
                top: 446,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 193,
                top: 446,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF303841),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: 205,
                top: 446,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: OvalBorder(),
                  ),
                ),
              ),
              Positioned(
                left: -1,
                top: 0,
                child: Container(
                  width: 396,
                  height: 84,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: const Color(0xFF222222)),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 21,
                        top: 19,
                        child: Container(
                          width: 49,
                          height: 44,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF646464),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 36,
                        top: 30,
                        child: Container(width: 23, height: 23, child: Stack()),
                      ),
                      Positioned(
                        left: 273,
                        top: 18,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 19,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF646464),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(44),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                color: const Color(0xFF646464),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(44),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 21,
                top: 614,
                child: Container(
                  width: 103,
                  height: 108,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/103x108"),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 146,
                top: 614,
                child: Container(
                  width: 103,
                  height: 108,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/103x108"),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 270,
                top: 614,
                child: Container(
                  width: 103,
                  height: 108,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/103x108"),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 154,
                top: 458,
                child: SizedBox(
                  width: 309,
                  height: 120,
                  child: Text(
                    '\$ 599.000',
                    style: TextStyle(
                      color: const Color(0xFF646464),
                      fontSize: 15,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      height: 7,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 243,
                top: 536,
                child: Container(
                  width: 36,
                  height: 22,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF666666),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 251,
                top: 520,
                child: SizedBox(
                  width: 50,
                  height: 30,
                  child: Text(
                    'Talla',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w800,
                      height: 6.56,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 267,
                top: 542,
                child: Container(width: 12, height: 11, child: Stack()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
