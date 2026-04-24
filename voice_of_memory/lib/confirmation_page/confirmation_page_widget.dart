import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'confirmation_page_model.dart';
export 'confirmation_page_model.dart';

class ConfirmationPageWidget extends StatefulWidget {
  const ConfirmationPageWidget({super.key});
  static String routeName = 'ConfirmationPage';
  static String routePath = '/confirmationPage';

  @override
  State<ConfirmationPageWidget> createState() => _ConfirmationPageWidgetState();
}

class _ConfirmationPageWidgetState extends State<ConfirmationPageWidget>
    with SingleTickerProviderStateMixin {
  late ConfirmationPageModel _model;
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConfirmationPageModel());
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    Future.delayed(const Duration(milliseconds: 200), () => _animCtrl.forward());
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C)),
          onPressed: () => context.pop(),
        ),
        title: Text('Completed',
          style: GoogleFonts.playfairDisplay(color: const Color(0xFF2C2C2C), fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFD4A574), width: 3),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD4A574),
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 44),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Story saved successfully',
                  style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF2C2C2C))),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    if (Navigator.of(context).canPop()) context.pop();
                    context.pushNamed(HomePageWidget.routeName);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5EDE0),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFD4A574), width: 1.5),
                    ),
                    child: Center(
                      child: Text('Back to Home',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF8B7355))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 64,
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Icons.home_rounded, Icons.list_rounded, Icons.mic_none_rounded, Icons.search, Icons.person_outline_rounded]
            .map((icon) => SizedBox(width: 56, child: Icon(icon, color: const Color(0xFF9C9C9C), size: 26)))
            .toList(),
        ),
      ),
    );
  }
}
