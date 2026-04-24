import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'my_recordings_page_model.dart';
export 'my_recordings_page_model.dart';

class MyRecordingsPageWidget extends StatefulWidget {
  const MyRecordingsPageWidget({super.key});
  static String routeName = 'MyRecordingsPage';
  static String routePath = '/myRecordingsPage';

  @override
  State<MyRecordingsPageWidget> createState() => _MyRecordingsPageWidgetState();
}

class _MyRecordingsPageWidgetState extends State<MyRecordingsPageWidget> {
  late MyRecordingsPageModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyRecordingsPageModel());
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
        title: Text('My Recordings',
          style: GoogleFonts.playfairDisplay(color: const Color(0xFF2C2C2C), fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: StreamBuilder<List<VoicesRecord>>(
        stream: queryVoicesRecord(queryBuilder: (q) => q.orderBy('createdAt', descending: true)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFD4A574)));
          final records = snapshot.data!;
          if (records.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mic_none_rounded, color: Color(0xFFD4A574), size: 56),
                  const SizedBox(height: 16),
                  Text('No recordings yet', style: GoogleFonts.inter(color: const Color(0xFF7C7C7C), fontSize: 16)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => context.pushNamed(RecordNewStoryPageWidget.routeName),
                    child: Text('Record your first story →',
                      style: GoogleFonts.inter(color: const Color(0xFFD4A574), fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, i) {
              final r = records[i];
              return GestureDetector(
                onTap: () => context.pushNamed(StoryDetailsWidget.routeName,
                  queryParameters: {
                    'audioUrl': serializeParam(r.url, ParamType.String),
                    'storyName': serializeParam(r.name, ParamType.String),
                    'narrator': serializeParam(r.narrator, ParamType.String),
                    'tags': serializeParam(r.tags, ParamType.String, isList: true),
                    'createdAt': serializeParam(r.createdAt, ParamType.DateTime),
                  }.withoutNulls),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(color: const Color(0xFFEDE8DF), borderRadius: BorderRadius.circular(24)),
                        child: const Icon(Icons.person, color: Color(0xFF9C9C9C), size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.name.isNotEmpty ? r.name : 'Unnamed Story',
                              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF2C2C2C))),
                            const SizedBox(height: 3),
                            Text(r.narrator.isNotEmpty ? r.narrator : '—',
                              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF7C7C7C))),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFF9C9C9C), size: 22),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(context),
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
        _navIcon(context, Icons.mic_none_rounded, RecordNewStoryPageWidget.routeName, false),
        _navIcon(context, Icons.person_outline_rounded, MyRecordingsPageWidget.routeName, true),
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
