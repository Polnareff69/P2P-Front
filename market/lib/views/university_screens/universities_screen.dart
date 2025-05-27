import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:market/views/widgets/floating_menu_button.dart';
import 'package:market/models/university_model.dart';

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({Key? key}) : super(key: key);

  @override
  State<UniversitiesScreen> createState() =>
      _UniversitiesScreenState();
}

class _UniversitiesScreenState
    extends State<UniversitiesScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final ScrollController _scrollController =
      ScrollController();
  String _selectedFilter = 'Todas';

  // Colores de TODA la screen
  static const Color _darkBg = Color(0xFF121212);
  static const Color _cardBg = Color(0xFF1E1E1E);
  static const Color _accentPurple = Color.fromARGB(
    255,
    98,
    17,
    184,
  );
  static const Color _lightPurple = Color.fromARGB(
    255,
    69,
    3,
    100,
  );
  static const Color _textPrimary = Color(0xFFFFFFFF);
  static const Color _textSecondary = Color(0xFFB0B0B0);
  static const Color _textTertiary = Color(0xFF808080);

  final List<University> universities = [
    University(
      name: 'Universidad de Antioquia',
      shortName: 'UdeA',
      description:
          'La universidad pública más prestigiosa de Antioquia, reconocida por su excelencia académica y tradición de más de 200 años.',
      type: 'Pública',
      ranking: '5ª en Colombia',
      founded: '1803',
      students: '44,000+',
      imageUrl: '',
      website: 'udea.edu.co',
      colors: [_accentPurple, _lightPurple],
      accentColor: _accentPurple,
    ),
    University(
      name: 'Universidad EAFIT',
      shortName: 'EAFIT',
      description:
          'Universidad privada de élite con acreditación internacional AACSB. Líder en innovación, tecnología y emprendimiento.',
      type: 'Privada',
      ranking: 'AACSB Elite',
      founded: '1960',
      students: '12,000+',
      imageUrl: '',
      website: 'eafit.edu.co',
      colors: [_accentPurple, _lightPurple],
      accentColor: _accentPurple,
    ),
    University(
      name: 'Universidad Pontificia Bolivariana',
      shortName: 'UPB',
      description:
          'Institución católica de alta calidad académica con fuerte tradición en ingeniería y ciencias aplicadas.',
      type: 'Privada',
      ranking: '69ª en Latinoamérica',
      founded: '1936',
      students: '18,000+',
      imageUrl: '',
      website: 'upb.edu.co',
      colors: [_accentPurple, _lightPurple],
      accentColor: _accentPurple,
    ),
    University(
      name: 'Universidad de Medellín',
      shortName: 'UdeM',
      description:
          'Universidad acreditada con 72 años de experiencia formando líderes. Campus vivo y transformador.',
      type: 'Privada',
      ranking: 'Alta Calidad',
      founded: '1950',
      students: '8,500+',
      imageUrl: '',
      website: 'udemedellin.edu.co',
      colors: [_accentPurple, _lightPurple],
      accentColor: _accentPurple,
    ),
    University(
      name: 'Universidad CES',
      shortName: 'CES',
      description:
          'Líder en ciencias de la salud y sostenibilidad. Fuerte compromiso con el desarrollo social y ambiental.',
      type: 'Privada',
      ranking: 'Líder en Sostenibilidad',
      founded: '1977',
      students: '6,000+',
      imageUrl: '',
      website: 'ces.edu.co',
      colors: [_accentPurple, _lightPurple],
      accentColor: _accentPurple,
    ),
    University(
      name: 'Tecnológico de Antioquia',
      shortName: 'TdeA',
      description:
          'Institución pública tecnológica enfocada en formación técnica, tecnológica y profesional de alta calidad.',
      type: 'Pública',
      ranking: 'Líder Tecnológico',
      founded: '1983',
      students: '25,000+',
      imageUrl: '',
      website: 'tdea.edu.co',
      colors: [_accentPurple, _lightPurple],
      accentColor: _accentPurple,
    ),
    University(
      name: 'Escuela de Ingeniería de Antioquia',
      shortName: 'EIA',
      description:
          'Universidad privada especializada en ingeniería con campus innovador en Las Palmas y enfoque práctico.',
      type: 'Privada',
      ranking: 'Top en Ingeniería',
      founded: '1978',
      students: '3,500+',
      imageUrl: '',
      website: 'eia.edu.co',
      colors: [_accentPurple, _lightPurple],
      accentColor: _accentPurple,
    ),
    University(
      name: 'Instituto Tecnológico Metropolitano',
      shortName: 'ITM',
      description:
          'Institución pública enfocada en tecnología e innovación social para el desarrollo regional sostenible.',
      type: 'Pública',
      ranking: 'Innovación Social',
      founded: '1944',
      students: '18,000+',
      imageUrl: '',
      website: 'itm.edu.co',
      colors: [_accentPurple, _lightPurple],
      accentColor: _accentPurple,
    ),
  ];

  List<University> get filteredUniversities {
    if (_selectedFilter == 'Todas') return universities;
    return universities
        .where((u) => u.type == _selectedFilter)
        .toList();
  }

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutCubic,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      floatingActionButton: const FloatingMenuButton(
        logoAssetPath:
            'assets/images/UMarketLogoNoBackground.png',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildProfessionalHeader(),

            // Filtros
            _buildElegantFilters(),

            // Estadísticas
            _buildStylishStats(),

            // Lista de universidades
            Expanded(child: _buildUniversitiesList()),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalHeader() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            24,
            16,
            24,
            32,
          ),
          child: Column(
            children: [
              // Botón de regreso y título en la misma línea
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                        border: Border.all(
                          color: _accentPurple.withOpacity(
                            0.2,
                          ),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: _textPrimary,
                        size: 20,
                        shadows: [
                          Shadow(
                            color: _accentPurple,
                            offset: Offset(1, 1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Título centrado
                  Column(
                    children: [
                      Text(
                        'Universidades',
                        style: GoogleFonts.nunito(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: _textPrimary,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(
                                255,
                                98,
                                17,
                                184,
                              ),
                              offset: const Offset(1, 3),
                              blurRadius: 6,
                            ),
                            Shadow(
                              color: Colors.black
                                  .withOpacity(0.6),
                              offset: const Offset(2, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Antioquia',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _accentPurple,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(
                                255,
                                98,
                                17,
                                184,
                              ),
                              offset: const Offset(1, 2),
                              blurRadius: 6,
                            ),
                            Shadow(
                              color: Colors.black
                                  .withOpacity(0.6),
                              offset: const Offset(2, 3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Espaciador para centrar
                  const SizedBox(width: 44),
                ],
              ),

              const SizedBox(height: 24),

              // Descripción elegante
              Text(
                'Descubre el mercado de las mejores instituciones de educación',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  color: _textSecondary,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  shadows: [
                    Shadow(
                      color: Color.fromARGB(
                        255,
                        98,
                        17,
                        184,
                      ),
                      offset: const Offset(1, 3),
                      blurRadius: 6,
                    ),
                    Shadow(
                      color: Colors.black.withOpacity(0.6),
                      offset: const Offset(2, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildElegantFilters() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        height: 52,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children:
              ['Todas', 'Pública', 'Privada'].map((filter) {
                final isSelected =
                    _selectedFilter == filter;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(
                        () => _selectedFilter = filter,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient:
                            isSelected
                                ? LinearGradient(
                                  colors: [
                                    Colors.purple.shade600,
                                    Colors.purple.shade900,
                                  ],
                                  begin:
                                      Alignment.topCenter,
                                  end:
                                      Alignment
                                          .bottomCenter,
                                )
                                : null,
                        color: isSelected ? null : _cardBg,
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        border: Border.all(
                          color:
                              isSelected
                                  ? _accentPurple
                                  : _accentPurple
                                      .withOpacity(0.1),
                          width: 4,
                        ),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: _accentPurple
                                        .withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(
                                      0,
                                      4,
                                    ),
                                  ),
                                ]
                                : null,
                      ),
                      child: Center(
                        child: Text(
                          filter,
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color:
                                isSelected
                                    ? Colors.white
                                    : _textSecondary,
                            shadows: [
                              Shadow(
                                color: Color.fromARGB(
                                  255,
                                  98,
                                  17,
                                  184,
                                ),
                                offset: const Offset(1, 2),
                                blurRadius: 6,
                              ),
                              Shadow(
                                color: Colors.black
                                    .withOpacity(0.8),
                                offset: const Offset(
                                  2,
                                  2.5,
                                ),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildStylishStats() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _accentPurple.withOpacity(0.15),
            width: 6,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
              '${filteredUniversities.length}',
              'Universidades',
              Icons.school_sharp,
            ),
            Container(
              width: 1,
              height: 55,
              color: _accentPurple.withOpacity(0.3),
            ),
            _buildStatItem(
              '135K+',
              'Estudiantes',
              Icons.people_alt_rounded,
            ),
            Container(
              width: 1,
              height: 55,
              color: _accentPurple.withOpacity(0.3),
            ),
            _buildStatItem(
              '220+',
              'Años Historia',
              Icons.access_time_filled_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String number,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _accentPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: _accentPurple,
            size: 21,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.6),
                offset: const Offset(2, 3),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          number,
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: _textPrimary,
            shadows: [
              Shadow(
                color: Color.fromARGB(255, 98, 17, 184),
                offset: const Offset(1, 2),
                blurRadius: 6,
              ),
              Shadow(
                color: Colors.black.withOpacity(0.6),
                offset: const Offset(2, 2.5),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        SizedBox(height: 1),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12.5,
            color: _textSecondary,
            fontWeight: FontWeight.w600,
            shadows: [
              Shadow(
                color: Color.fromARGB(255, 98, 17, 184),
                offset: const Offset(1, 2),
                blurRadius: 6,
              ),
              Shadow(
                color: Colors.black.withOpacity(0.6),
                offset: const Offset(2, 2.5),
                blurRadius: 4,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUniversitiesList() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: filteredUniversities.length,
        itemBuilder: (context, index) {
          return TweenAnimationBuilder<double>(
            duration: Duration(
              milliseconds: 400 + (index * 100),
            ),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: _buildProfessionalUniversityCard(
                    filteredUniversities[index],
                    index,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfessionalUniversityCard(
    University university,
    int index,
  ) {
    return GestureDetector(
      onTap: () => _onUniversityTap(university),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _accentPurple.withOpacity(0.1),
            width: 3.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.shade700
                  .withOpacity(0.3),
              blurRadius: 9,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de la card
            Row(
              children: [
                // Logo/Ícono
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.purple.shade600,
                        Colors.purple.shade900,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2,
                        spreadRadius: 0,
                        offset: Offset(2, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getUniversityIcon(
                      university.shortName,
                    ),
                    size: 28,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(
                          0.6,
                        ),
                        offset: const Offset(2, 3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Información principal
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        university.shortName,
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: _textPrimary,
                          letterSpacing: -0.3,
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(
                                255,
                                98,
                                17,
                                184,
                              ),
                              offset: const Offset(1, 2),
                              blurRadius: 6,
                            ),
                            Shadow(
                              color: Colors.black
                                  .withOpacity(0.6),
                              offset: const Offset(2, 3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        university.website,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: _accentPurple,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: const Offset(1, 2),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Chips de información
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  children: [
                    _buildModernChip(
                      university.type,
                      university.type == 'Pública'
                          ? Icons.public_rounded
                          : Icons.business_rounded,
                    ),
                    const SizedBox(height: 6),
                    _buildModernChip(
                      university.ranking,
                      Icons.star_rounded,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Nombre completo
            Text(
              university.name,
              style: GoogleFonts.nunito(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
                height: 1.3,
                shadows: [
                  Shadow(
                    color: Color.fromARGB(255, 98, 17, 184),
                    offset: const Offset(1, 2),
                    blurRadius: 6,
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(2, 3),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Descripción
            Text(
              university.description,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: _textSecondary,
                fontWeight: FontWeight.w500,
                height: 1.4,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.7),
                    offset: const Offset(1, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 16),

            // Footer con estadísticas
            Row(
              children: [
                _buildInfoPill(
                  Icons.calendar_today_rounded,
                  'Fundada ${university.founded}',
                ),
                const SizedBox(width: 12),
                _buildInfoPill(
                  Icons.people_rounded,
                  university.students,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _accentPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: _accentPurple,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(
                          0.9,
                        ),
                        offset: const Offset(1, 2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _accentPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _accentPurple.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: _accentPurple,
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 2,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.nunito(
              fontSize: 10,
              color: _accentPurple,
              fontWeight: FontWeight.w700,
              shadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  blurRadius: 2,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _darkBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _accentPurple.withOpacity(0.2),
          width: 2.2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: _textTertiary,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.9),
                offset: const Offset(1, 2),
                blurRadius: 5,
              ),
            ],
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.nunito(
              fontSize: 11,
              color: _textTertiary,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.9),
                  offset: const Offset(1, 2),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onUniversityTap(University university) {
    HapticFeedback.selectionClick();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => _buildProfessionalModal(university),
    );
  }

  Widget _buildProfessionalModal(University university) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: _darkBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(
          color: _accentPurple.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(
              top: 12,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              color: _textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header del modal
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.purple.shade600,
                        Colors.purple.shade900,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 2,
                        spreadRadius: 0,
                        offset: Offset(2, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getUniversityIcon(
                      university.shortName,
                    ),
                    size: 32,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(
                          0.9,
                        ),
                        offset: const Offset(2, 3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        university.shortName,
                        style: GoogleFonts.nunito(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: _textPrimary,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              color: Color.fromARGB(
                                255,
                                98,
                                17,
                                184,
                              ),
                              offset: const Offset(1, 2),
                              blurRadius: 6,
                            ),
                            Shadow(
                              color: Colors.black
                                  .withOpacity(0.6),
                              offset: const Offset(2, 3),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        university.website,
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          color: _accentPurple,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              color: Colors.black
                                  .withOpacity(0.9),
                              offset: const Offset(1, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: _textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contenido del modal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    university.name,
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                      height: 1.3,
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(
                            255,
                            98,
                            17,
                            184,
                          ),
                          offset: const Offset(1, 2),
                          blurRadius: 6,
                        ),
                        Shadow(
                          color: Colors.black.withOpacity(
                            0.6,
                          ),
                          offset: const Offset(2, 3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    university.description,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      color: _textSecondary,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(
                            0.7,
                          ),
                          offset: const Offset(1, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Información detallada
                  _buildDetailGrid([
                    _buildDetailCard(
                      'Tipo',
                      university.type,
                      Icons.category_rounded,
                    ),
                    _buildDetailCard(
                      'Ranking',
                      university.ranking,
                      Icons.emoji_events_rounded,
                    ),
                    _buildDetailCard(
                      'Fundada',
                      university.founded,
                      Icons.calendar_today_rounded,
                    ),
                    _buildDetailCard(
                      'Estudiantes',
                      university.students,
                      Icons.people_rounded,
                    ),
                  ]),

                  const SizedBox(height: 30),

                  // Botón de acción
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Aquí iría la navegación al mapa donde está la universidad
                    },
                    child: Container(
                      width: double.infinity,
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          25,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.purple.shade600,
                            Colors.purple.shade900,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Contenido del botón
                          Center(
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.map_rounded,
                                  color: Colors.white,
                                  size: 25,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black
                                          .withOpacity(0.7),
                                      offset: const Offset(
                                        1,
                                        2,
                                      ),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Ver Mapa',
                                  style: GoogleFonts.getFont(
                                    'Nunito Sans',
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight:
                                        FontWeight.w700,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black
                                            .withOpacity(
                                              0.7,
                                            ),
                                        offset:
                                            const Offset(
                                              1,
                                              2,
                                            ),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailGrid(List<Widget> items) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: items,
    );
  }

  Widget _buildDetailCard(
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _accentPurple.withOpacity(0.6),
          width: 3,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: _accentPurple,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(2, 3),
                    blurRadius: 4,
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: _textTertiary,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.6),
                      offset: const Offset(2, 3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: _textPrimary,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(
                  color: Color.fromARGB(255, 98, 17, 184),
                  offset: const Offset(1, 2),
                  blurRadius: 6,
                ),
                Shadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: const Offset(2, 3),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getUniversityIcon(String shortName) {
    switch (shortName) {
      case 'UdeA':
        return Icons.account_balance_rounded;
      case 'EAFIT':
        return Icons.engineering_rounded;
      case 'UPB':
        return Icons.church_rounded;
      case 'UdeM':
        return Icons.business_rounded;
      case 'CES':
        return Icons.medical_services_rounded;
      case 'TdeA':
        return Icons.precision_manufacturing_rounded;
      case 'EIA':
        return Icons.construction_rounded;
      case 'ITM':
        return Icons.computer_rounded;
      default:
        return Icons.school_rounded;
    }
  }
}
