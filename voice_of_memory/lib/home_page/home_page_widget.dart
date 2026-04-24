import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});
  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> _categories = ['Villages', 'Traditions', 'Wars'];
  String? _selectedCategory;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF2C2C2C), size: 26),
          onPressed: () {},
        ),
        title: Text(
          'Voice of Memory',
          style: GoogleFonts.playfairDisplay(
            color: const Color(0xFF2C2C2C),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF2C2C2C), size: 26),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: TextField(
                onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF2C2C2C)),
                decoration: InputDecoration(
                  hintText: 'Search stories...',
                  hintStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF7C7C7C)),
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
                      child: Text(
                        cat,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                          color: selected ? const Color(0xFFD4A574) : const Color(0xFF8B7355),
                        ),
                      ),
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
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFD4A574)));
                }
                var records = snapshot.data!;
                if (_searchQuery.isNotEmpty) {
                  records = records.where((r) =>
                    r.name.toLowerCase().contains(_searchQuery) ||
                    r.narrator.toLowerCase().contains(_searchQuery)).toList();
                }
                if (_selectedCategory != null) {
                  records = records.where((r) =>
                    r.tags.any((t) => t.toLowerCase() == _selectedCategory!.toLowerCase())).toList();
                }
                if (records.isEmpty) {
                  return Center(child: Text('No stories found', style: GoogleFonts.inter(color: const Color(0xFF7C7C7C), fontSize: 15)));
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  itemCount: records.length,
                  itemBuilder: (context, i) {
                    final r = records[i];
                    return GestureDetector(
                      onTap: () => context.pushNamed(
                        StoryDetailsWidget.routeName,
                        queryParameters: {
                          'audioUrl': serializeParam(r.url, ParamType.String),
                          'storyName': serializeParam(r.name, ParamType.String),
                          'narrator': serializeParam(r.narrator, ParamType.String),
                          'tags': serializeParam(r.tags, ParamType.String, isList: true),
                          'createdAt': serializeParam(r.createdAt, ParamType.DateTime),
                        }.withoutNulls,
                      ),
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
          ),
        ],
      ),
      bottomNavigationBar: _BottomNav(currentIndex: 0),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navIcon(context, Icons.home_rounded, 0, HomePageWidget.routeName),
          _navIcon(context, Icons.list_rounded, 1, BrowseStoriesPageWidget.routeName),
          _navIcon(context, Icons.search, 2, HomePageWidget.routeName),
          _navIcon(context, Icons.mic_none_rounded, 3, RecordNewStoryPageWidget.routeName),
          _navIcon(context, Icons.person_outline_rounded, 4, MyRecordingsPageWidget.routeName),
        ],
      ),
    );
  }

  Widget _navIcon(BuildContext context, IconData icon, int index, String route) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () { if (!isActive) { if (Navigator.of(context).canPop()) context.pop(); context.pushNamed(route); } },
      child: SizedBox(width: 56, child: Icon(icon, color: isActive ? const Color(0xFF2C2C2C) : const Color(0xFF9C9C9C), size: 26)),
    );
  }
}
