import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'browse_stories_page_model.dart';
export 'browse_stories_page_model.dart';

class BrowseStoriesPageWidget extends StatefulWidget {
  const BrowseStoriesPageWidget({super.key});
  static String routeName = 'BrowseStoriesPage';
  static String routePath = '/browseStoriesPage';

  @override
  State<BrowseStoriesPageWidget> createState() => _BrowseStoriesPageWidgetState();
}

class _BrowseStoriesPageWidgetState extends State<BrowseStoriesPageWidget> {
  late BrowseStoriesPageModel _model;
  final List<String> _categories = ['Wars', 'Traditions', 'Villages'];
  String? _selectedCategory;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BrowseStoriesPageModel());
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
        title: Text('Browse Stories', style: GoogleFonts.playfairDisplay(color: const Color(0xFF2C2C2C), fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
              height: 46,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))]),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF9C9C9C)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF9C9C9C), size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: _categories.map((cat) {
                final selected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = selected ? null : cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFFD4A574).withOpacity(0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFD4A574), width: selected ? 1.5 : 1),
                      ),
                      child: Text(cat, style: GoogleFonts.inter(fontSize: 13,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        color: selected ? const Color(0xFFD4A574) : const Color(0xFF8B7355))),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<VoicesRecord>>(
              stream: queryVoicesRecord(queryBuilder: (q) => q.orderBy('createdAt', descending: true)),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFD4A574)));
                var records = snapshot.data!;
                if (_searchQuery.isNotEmpty) {
                  records = records.where((r) => r.name.toLowerCase().contains(_searchQuery) || r.narrator.toLowerCase().contains(_searchQuery)).toList();
                }
                if (_selectedCategory != null) {
                  records = records.where((r) => r.tags.any((t) => t.toLowerCase() == _selectedCategory!.toLowerCase())).toList();
                }
                if (records.isEmpty) return Center(child: Text('No stories found', style: GoogleFonts.inter(color: const Color(0xFF7C7C7C))));
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
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.name.isNotEmpty ? r.name : 'Unnamed Story',
                              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF2C2C2C))),
                            const SizedBox(height: 4),
                            Row(children: [
                              Container(width: 36, height: 36,
                                decoration: BoxDecoration(color: const Color(0xFFEDE8DF), borderRadius: BorderRadius.circular(18)),
                                child: const Icon(Icons.person, color: Color(0xFF9C9C9C), size: 22)),
                              const SizedBox(width: 8),
                              Text(r.narrator.isNotEmpty ? r.narrator : '—',
                                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF7C7C7C))),
                            ]),
                            const SizedBox(height: 10),
                            if (r.tags.isNotEmpty) Wrap(
                              spacing: 8,
                              children: r.tags.map((tag) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFFF0EBE1), borderRadius: BorderRadius.circular(12)),
                                child: Text('# $tag', style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8B7355))),
                              )).toList(),
                            ),
                            if (r.createdAt != null) ...[
                              const SizedBox(height: 10),
                              Row(children: [
                                const Icon(Icons.calendar_today_outlined, size: 13, color: Color(0xFF9C9C9C)),
                                const SizedBox(width: 4),
                                Text(DateFormat('MMM d, yyyy').format(r.createdAt!),
                                  style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF9C9C9C))),
                              ]),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
        _navIcon(context, Icons.list_rounded, BrowseStoriesPageWidget.routeName, true),
        _navIcon(context, Icons.search, HomePageWidget.routeName, false),
        _navIcon(context, Icons.mic_none_rounded, RecordNewStoryPageWidget.routeName, false),
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
