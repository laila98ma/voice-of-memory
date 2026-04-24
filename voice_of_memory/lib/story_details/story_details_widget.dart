import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/custom_code/widgets/audio_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'story_details_model.dart';
export 'story_details_model.dart';

class StoryDetailsWidget extends StatefulWidget {
  const StoryDetailsWidget({
    super.key,
    required this.audioUrl,
    this.storyName,
    this.narrator,
    this.tags,
    this.createdAt,
  });

  final String audioUrl;
  final String? storyName;
  final String? narrator;
  final List<String>? tags;
  final DateTime? createdAt;

  static String routeName = 'StoryDetails';
  static String routePath = '/storyDetails';

  @override
  State<StoryDetailsWidget> createState() => _StoryDetailsWidgetState();
}

class _StoryDetailsWidgetState extends State<StoryDetailsWidget> {
  late StoryDetailsModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StoryDetailsModel());
  }

  @override
  void dispose() {
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
        title: Text(
          widget.storyName ?? 'Story',
          style: GoogleFonts.playfairDisplay(color: const Color(0xFF2C2C2C), fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Narrator card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))]),
              child: Row(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(color: const Color(0xFFEDE8DF), borderRadius: BorderRadius.circular(26)),
                    child: const Icon(Icons.person, color: Color(0xFF9C9C9C), size: 30),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.narrator ?? '—', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF2C2C2C))),
                      if (widget.createdAt != null)
                        Text(DateFormat('yyyy').format(widget.createdAt!),
                          style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF7C7C7C))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Duration placeholder row
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]),
              child: Row(children: [
                const Icon(Icons.access_time, color: Color(0xFF9C9C9C), size: 18),
                const SizedBox(width: 8),
                Text('Audio recording', style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF7C7C7C))),
              ]),
            ),
            const SizedBox(height: 12),

            // Audio player
            if (widget.audioUrl.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))]),
                child: AudioPlayerWidget(audioUrl: widget.audioUrl),
              )
            else
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                child: Center(child: Text('No audio available', style: GoogleFonts.inter(color: const Color(0xFF9C9C9C)))),
              ),

            const SizedBox(height: 12),

            // Tags
            if (widget.tags != null && widget.tags!.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.tag, color: Color(0xFFD4A574), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        spacing: 8, runSpacing: 8,
                        children: widget.tags!.map((tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(color: const Color(0xFFF0EBE1), borderRadius: BorderRadius.circular(12)),
                          child: Text(tag, style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8B7355), fontWeight: FontWeight.w500)),
                        )).toList(),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _navIcon(context, Icons.home_rounded, HomePageWidget.routeName),
        _navIcon(context, Icons.list_rounded, BrowseStoriesPageWidget.routeName),
        _navIcon(context, Icons.search, HomePageWidget.routeName),
        _navIcon(context, Icons.mic_none_rounded, RecordNewStoryPageWidget.routeName),
        _navIcon(context, Icons.person_outline_rounded, MyRecordingsPageWidget.routeName),
      ]),
    );
  }

  Widget _navIcon(BuildContext context, IconData icon, String route) {
    return GestureDetector(
      onTap: () { if (Navigator.of(context).canPop()) context.pop(); context.pushNamed(route); },
      child: SizedBox(width: 56, child: Icon(icon, color: const Color(0xFF9C9C9C), size: 26)),
    );
  }
}
