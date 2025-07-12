import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/note_item_widget.dart';
import './widgets/notes_filter_widget.dart';
import './widgets/notes_search_widget.dart';
import './widgets/subject_card_widget.dart';

class NotesLibrary extends StatefulWidget {
  const NotesLibrary({super.key});

  @override
  State<NotesLibrary> createState() => _NotesLibraryState();
}

class _NotesLibraryState extends State<NotesLibrary>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _refreshController;

  bool _isRefreshing = false;
  String _searchQuery = '';
  List<String> _selectedSubjects = [];
  List<String> _selectedWeeks = [];
  Map<String, bool> _expandedSubjects = {};

  // Mock notes data organized by subjects
  final Map<String, Map<String, dynamic>> _notesData = {
    'Computer Science': {
      'courseCode': 'CS301',
      'totalNotes': 24,
      'lastUpdated': '2024-07-11',
      'weeks': {
        'Week 1': [
          {
            'id': 1,
            'title': 'Introduction to Algorithms',
            'uploadDate': '2024-07-08',
            'fileSize': '2.5 MB',
            'isDownloaded': true,
            'downloadProgress': 1.0,
            'isFavorite': false,
            'fileType': 'PDF',
            'downloadUrl': 'https://example.com/notes/cs301_week1_intro.pdf',
          },
          {
            'id': 2,
            'title': 'Big O Notation',
            'uploadDate': '2024-07-10',
            'fileSize': '1.8 MB',
            'isDownloaded': false,
            'downloadProgress': 0.0,
            'isFavorite': true,
            'fileType': 'PDF',
            'downloadUrl': 'https://example.com/notes/cs301_week1_bigo.pdf',
          },
        ],
        'Week 2': [
          {
            'id': 3,
            'title': 'Sorting Algorithms',
            'uploadDate': '2024-07-11',
            'fileSize': '3.2 MB',
            'isDownloaded': false,
            'downloadProgress': 0.0,
            'isFavorite': false,
            'fileType': 'PDF',
            'downloadUrl': 'https://example.com/notes/cs301_week2_sorting.pdf',
          },
        ],
      },
    },
    'Mathematics': {
      'courseCode': 'MATH201',
      'totalNotes': 18,
      'lastUpdated': '2024-07-10',
      'weeks': {
        'Week 1': [
          {
            'id': 4,
            'title': 'Linear Algebra Basics',
            'uploadDate': '2024-07-05',
            'fileSize': '2.1 MB',
            'isDownloaded': true,
            'downloadProgress': 1.0,
            'isFavorite': true,
            'fileType': 'PDF',
            'downloadUrl': 'https://example.com/notes/math201_week1_linear.pdf',
          },
        ],
        'Week 2': [
          {
            'id': 5,
            'title': 'Matrix Operations',
            'uploadDate': '2024-07-09',
            'fileSize': '1.9 MB',
            'isDownloaded': false,
            'downloadProgress': 0.0,
            'isFavorite': false,
            'fileType': 'PDF',
            'downloadUrl': 'https://example.com/notes/math201_week2_matrix.pdf',
          },
        ],
      },
    },
    'Physics': {
      'courseCode': 'PHY101',
      'totalNotes': 15,
      'lastUpdated': '2024-07-09',
      'weeks': {
        'Week 1': [
          {
            'id': 6,
            'title': 'Mechanics Fundamentals',
            'uploadDate': '2024-07-07',
            'fileSize': '2.8 MB',
            'isDownloaded': true,
            'downloadProgress': 1.0,
            'isFavorite': false,
            'fileType': 'PDF',
            'downloadUrl':
                'https://example.com/notes/phy101_week1_mechanics.pdf',
          },
        ],
      },
    },
  };

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _refreshController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Initialize all subjects as collapsed
    for (String subject in _notesData.keys) {
      _expandedSubjects[subject] = false;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  int get _totalNotesCount {
    return _notesData.values
        .map((subject) => subject['totalNotes'] as int)
        .fold(0, (sum, count) => sum + count);
  }

  int get _downloadedNotesCount {
    int count = 0;
    for (var subject in _notesData.values) {
      var weeks = subject['weeks'] as Map<String, dynamic>;
      for (var notes in weeks.values) {
        for (var note in notes as List) {
          if (note['isDownloaded'] == true) count++;
        }
      }
    }
    return count;
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _refreshController.reset();

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Notes library updated successfully',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(4.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _onFilterChanged(List<String> subjects, List<String> weeks) {
    setState(() {
      _selectedSubjects = subjects;
      _selectedWeeks = weeks;
    });
  }

  void _toggleSubjectExpansion(String subject) {
    setState(() {
      _expandedSubjects[subject] = !(_expandedSubjects[subject] ?? false);
    });
  }

  void _downloadNote(Map<String, dynamic> note) {
    setState(() {
      note['downloadProgress'] = 0.1;
    });

    // Simulate download progress
    _simulateDownload(note);
  }

  void _simulateDownload(Map<String, dynamic> note) async {
    for (double progress = 0.1; progress <= 1.0; progress += 0.1) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() {
          note['downloadProgress'] = progress;
          if (progress >= 1.0) {
            note['isDownloaded'] = true;
          }
        });
      }
    }
  }

  void _toggleFavorite(Map<String, dynamic> note) {
    setState(() {
      note['isFavorite'] = !(note['isFavorite'] as bool);
    });
  }

  void _shareNote(Map<String, dynamic> note) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${note['title']}"'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _viewNote(Map<String, dynamic> note) {
    if (note['isDownloaded'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening "${note['title']}"'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(4.w),
        ),
      );
    } else {
      _downloadNote(note);
    }
  }

  List<MapEntry<String, Map<String, dynamic>>> _getFilteredSubjects() {
    var filtered = _notesData.entries.where((entry) {
      if (_selectedSubjects.isNotEmpty &&
          !_selectedSubjects.contains(entry.key)) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        return entry.key.toLowerCase().contains(_searchQuery) ||
            _hasMatchingNotes(entry.value, _searchQuery);
      }

      return true;
    }).toList();

    return filtered;
  }

  bool _hasMatchingNotes(Map<String, dynamic> subjectData, String query) {
    var weeks = subjectData['weeks'] as Map<String, dynamic>;
    for (var notes in weeks.values) {
      for (var note in notes as List) {
        if ((note['title'] as String).toLowerCase().contains(query)) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final filteredSubjects = _getFilteredSubjects();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes Library',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            Text(
              '$_downloadedNotesCount of $_totalNotesCount downloaded',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: CustomIconWidget(
              iconName: _downloadedNotesCount == _totalNotesCount
                  ? 'cloud_done'
                  : 'cloud_download',
              color: _downloadedNotesCount == _totalNotesCount
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.lightTheme.colorScheme.primary,
        child: Column(
          children: [
            // Search and Filter Section
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  NotesSearchWidget(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    onFilterTap: () => _showFilterBottomSheet(),
                  ),
                  if (_selectedSubjects.isNotEmpty || _selectedWeeks.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: NotesFilterWidget(
                        selectedSubjects: _selectedSubjects,
                        selectedWeeks: _selectedWeeks,
                        onClearFilters: () => _onFilterChanged([], []),
                      ),
                    ),
                ],
              ),
            ),

            // Notes List
            Expanded(
              child: filteredSubjects.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: filteredSubjects.length,
                      itemBuilder: (context, index) {
                        final subjectEntry = filteredSubjects[index];
                        final subjectName = subjectEntry.key;
                        final subjectData = subjectEntry.value;
                        final isExpanded =
                            _expandedSubjects[subjectName] ?? false;

                        return Column(
                          children: [
                            SubjectCardWidget(
                              subjectName: subjectName,
                              subjectData: subjectData,
                              isExpanded: isExpanded,
                              onToggleExpansion: () =>
                                  _toggleSubjectExpansion(subjectName),
                            ),
                            if (isExpanded) ...[
                              SizedBox(height: 1.h),
                              _buildWeeklyNotes(subjectData),
                              SizedBox(height: 2.h),
                            ],
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyNotes(Map<String, dynamic> subjectData) {
    final weeks = subjectData['weeks'] as Map<String, dynamic>;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        children: weeks.entries.map((weekEntry) {
          final weekName = weekEntry.key;
          final notes = weekEntry.value as List;

          // Filter notes based on week selection and search
          final filteredNotes = notes.where((note) {
            if (_selectedWeeks.isNotEmpty &&
                !_selectedWeeks.contains(weekName)) {
              return false;
            }
            if (_searchQuery.isNotEmpty) {
              return (note['title'] as String)
                  .toLowerCase()
                  .contains(_searchQuery);
            }
            return true;
          }).toList();

          if (filteredNotes.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                child: Text(
                  weekName,
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
              ...filteredNotes
                  .map((note) => NoteItemWidget(
                        note: note,
                        onDownload: () => _downloadNote(note),
                        onShare: () => _shareNote(note),
                        onToggleFavorite: () => _toggleFavorite(note),
                        onView: () => _viewNote(note),
                      ))
                  .toList(),
              SizedBox(height: 1.h),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageWidget(
            imageUrl:
                'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?fm=jpg&q=60&w=400&ixlib=rb-4.0.3',
            width: 60.w,
            height: 30.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 3.h),
          Text(
            _searchQuery.isNotEmpty || _selectedSubjects.isNotEmpty
                ? 'No matching notes found'
                : 'No notes available',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _searchQuery.isNotEmpty || _selectedSubjects.isNotEmpty
                ? 'Try adjusting your search or filters'
                : 'Notes will appear here when uploaded by instructors',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          if (_searchQuery.isNotEmpty || _selectedSubjects.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
                _onFilterChanged([], []);
              },
              child: const Text('Clear Filters'),
            ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    final availableSubjects = _notesData.keys.toList();
    final availableWeeks = _notesData.values
        .expand((subject) => (subject['weeks'] as Map<String, dynamic>).keys)
        .toSet()
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.lightTheme.bottomSheetTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Filter Notes',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Subjects',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              children: availableSubjects.map((subject) {
                final isSelected = _selectedSubjects.contains(subject);
                return FilterChip(
                  label: Text(subject),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSubjects.add(subject);
                      } else {
                        _selectedSubjects.remove(subject);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 2.h),
            Text(
              'Weeks',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Wrap(
              spacing: 2.w,
              children: availableWeeks.map((week) {
                final isSelected = _selectedWeeks.contains(week);
                return FilterChip(
                  label: Text(week),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedWeeks.add(week);
                      } else {
                        _selectedWeeks.remove(week);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedSubjects.clear();
                        _selectedWeeks.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Clear All'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
