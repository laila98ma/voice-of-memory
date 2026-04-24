import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'record_new_story_page_model.dart';
export 'record_new_story_page_model.dart';

class RecordNewStoryPageWidget extends StatefulWidget {
  const RecordNewStoryPageWidget({super.key});
  static String routeName = 'RecordNewStoryPage';
  static String routePath = '/recordNewStoryPage';

  @override
  State<RecordNewStoryPageWidget> createState() => _RecordNewStoryPageWidgetState();
}

class _RecordNewStoryPageWidgetState extends State<RecordNewStoryPageWidget> {
  late RecordNewStoryPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _narratorController = TextEditingController();

  AudioRecorder? _audioRecorder;
  bool _isRecording = false;
  bool _isUploading = false;
  String? _recordedPath;
  Duration _elapsed = Duration.zero;
  Timer? _timer;

  bool _warsSelected = false;
  bool _traditionsSelected = false;
  bool _villagesSelected = false;

  String? _selectedNarrator;
  final List<String> _narrators = ['Hajj Mahmoud', 'Maram', 'Elders', 'Other'];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecordNewStoryPageModel());
    _audioRecorder = AudioRecorder();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder?.dispose();
    _titleController.dispose();
    _narratorController.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final hasPermission = await _audioRecorder!.hasPermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission required')),
      );
      return;
    }
    final path = '/tmp/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _audioRecorder!.start(const RecordConfig(), path: path);
    setState(() { _isRecording = true; _elapsed = Duration.zero; });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  Future<void> _stopAndUpload() async {
    if (!_isRecording) return;
    _timer?.cancel();
    final path = await _audioRecorder!.stop();
    setState(() { _isRecording = false; _recordedPath = path; _isUploading = true; });

    try {
      // Validate inputs
      final title = _titleController.text.trim();
      final narrator = _selectedNarrator ?? _narratorController.text.trim();
      if (title.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a story title')));
        setState(() => _isUploading = false);
        return;
      }

      // Upload to Cloudinary
      final url = await actions.uploadAudioToCloudinary(_recordedPath);
      if (url.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload failed. Please try again.')));
        setState(() => _isUploading = false);
        return;
      }

      // Build tags list
      final tags = <String>[
        if (_warsSelected) 'Wars',
        if (_traditionsSelected) 'Traditions',
        if (_villagesSelected) 'Villages',
      ];

      // Save to Firestore
      await VoicesRecord.collection.doc().set(createVoicesRecordData(
        name: title,
        url: url,
        narrator: narrator.isNotEmpty ? narrator : 'Unknown',
        tags: tags,
        createdAt: getCurrentTimestamp,
      ));

      setState(() => _isUploading = false);
      if (mounted) context.pushNamed(ConfirmationPageWidget.routeName);
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C)),
          onPressed: () => context.pop(),
        ),
        title: Text('Record New Story',
          style: GoogleFonts.playfairDisplay(color: const Color(0xFF2C2C2C), fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Narrator picker
            _sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Choose Narrator', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF7C7C7C))),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showNarratorPicker(),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F6F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE0D8CC)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_selectedNarrator ?? 'Choose Narrator',
                            style: GoogleFonts.inter(fontSize: 15,
                              color: _selectedNarrator != null ? const Color(0xFF2C2C2C) : const Color(0xFF9C9C9C))),
                          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF7C7C7C), size: 22),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Title field
            _sectionCard(
              child: TextField(
                controller: _titleController,
                style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF2C2C2C)),
                decoration: InputDecoration(
                  hintText: 'Story title...',
                  hintStyle: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF9C9C9C)),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tags
            _sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tags', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF7C7C7C))),
                  const SizedBox(height: 10),
                  _tagRow('Wars', _warsSelected, (v) => setState(() => _warsSelected = v!)),
                  const SizedBox(height: 6),
                  _tagRow('Traditions', _traditionsSelected, (v) => setState(() => _traditionsSelected = v!)),
                  const SizedBox(height: 6),
                  _tagRow('Villages', _villagesSelected, (v) => setState(() => _villagesSelected = v!)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Recording controls
            _sectionCard(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Record button
                      GestureDetector(
                        onTap: _isUploading ? null : (_isRecording ? null : _startRecording),
                        child: Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(
                            color: _isRecording ? const Color(0xFFCC3333) : const Color(0xFFE74C3C),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFC0392B), width: 4),
                          ),
                          child: Icon(_isRecording ? Icons.radio_button_checked : Icons.radio_button_checked,
                            color: Colors.white, size: 30),
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Stop button
                      GestureDetector(
                        onTap: _isUploading ? null : (_isRecording ? _stopAndUpload : null),
                        child: Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(
                            color: _isRecording ? const Color(0xFFE74C3C) : const Color(0xFFCCCCCC),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isRecording ? const Color(0xFFC0392B) : const Color(0xFFBBBBBB),
                              width: 4,
                            ),
                          ),
                          child: Icon(Icons.stop_rounded,
                            color: Colors.white, size: 30),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_isUploading)
                    Column(children: [
                      const CircularProgressIndicator(color: Color(0xFFD4A574)),
                      const SizedBox(height: 8),
                      Text('Uploading...', style: GoogleFonts.inter(color: const Color(0xFF7C7C7C), fontSize: 13)),
                    ])
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.access_time, color: Color(0xFF7C7C7C), size: 18),
                        const SizedBox(width: 6),
                        Text(_formatDuration(_elapsed),
                          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF2C2C2C))),
                      ],
                    ),
                  const SizedBox(height: 8),
                  if (_isRecording)
                    Text('Recording...', style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFFE74C3C))),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }

  Widget _tagRow(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFD4A574),
          side: const BorderSide(color: Color(0xFFD4A574), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Text(label, style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF2C2C2C))),
      ],
    );
  }

  void _showNarratorPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('Choose Narrator', style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ..._narrators.map((n) => ListTile(
              title: Text(n, style: GoogleFonts.inter(fontSize: 15)),
              trailing: _selectedNarrator == n ? const Icon(Icons.check, color: Color(0xFFD4A574)) : null,
              onTap: () { setState(() => _selectedNarrator = n); Navigator.pop(ctx); },
            )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _navIcon(context, Icons.home_rounded, HomePageWidget.routeName, false),
        _navIcon(context, Icons.list_rounded, BrowseStoriesPageWidget.routeName, false),
        _navIcon(context, Icons.search, HomePageWidget.routeName, false),
        _navIcon(context, Icons.mic_none_rounded, RecordNewStoryPageWidget.routeName, true),
        _navIcon(context, Icons.person_outline_rounded, MyRecordingsPageWidget.routeName, false),
      ]),
    );
  }

  Widget _navIcon(BuildContext context, IconData icon, String route, bool active) {
    return GestureDetector(
      onTap: () { if (!active) { if (Navigator.of(context).canPop()) context.pop(); context.pushNamed(route); } },
      child: SizedBox(width: 56, child: Icon(icon, color: active ? const Color(0xFF2C2C2C) : const Color(0xFF9C9C9C), size: 26)),
    );
  }
}
