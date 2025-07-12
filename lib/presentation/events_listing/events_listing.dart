import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/event_card_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/search_bar_widget.dart';

class EventsListing extends StatefulWidget {
  const EventsListing({super.key});

  @override
  State<EventsListing> createState() => _EventsListingState();
}

class _EventsListingState extends State<EventsListing>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<String> selectedFilters = [];
  bool isLoading = false;
  bool isSearching = false;

  final List<String> filterCategories = [
    'Academic',
    'Cultural',
    'Sports',
    'Workshops',
    'Seminars',
    'Competitions'
  ];

  final List<Map<String, dynamic>> eventsData = [
    {
      "id": 1,
      "title": "Annual Tech Symposium 2024",
      "description":
          "Join us for the biggest technology event of the year featuring industry experts, workshops, and networking opportunities.",
      "date": "2024-07-15",
      "time": "09:00 AM",
      "location": "Main Auditorium, Block A",
      "category": "Academic",
      "imageUrl":
          "https://images.unsplash.com/photo-1540575467063-178a50c2df87?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFeature": true,
      "attendees": 250,
      "organizer": "Computer Science Department"
    },
    {
      "id": 2,
      "title": "Cultural Fest - Harmony 2024",
      "description":
          "Celebrate diversity through music, dance, and art performances from students across all departments.",
      "date": "2024-07-20",
      "time": "06:00 PM",
      "location": "Open Ground, Campus",
      "category": "Cultural",
      "imageUrl":
          "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFeature": false,
      "attendees": 500,
      "organizer": "Cultural Committee"
    },
    {
      "id": 3,
      "title": "Inter-College Basketball Championship",
      "description":
          "Compete with the best teams from neighboring colleges in this exciting basketball tournament.",
      "date": "2024-07-18",
      "time": "02:00 PM",
      "location": "Sports Complex",
      "category": "Sports",
      "imageUrl":
          "https://images.unsplash.com/photo-1546519638-68e109498ffc?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFeature": false,
      "attendees": 150,
      "organizer": "Sports Department"
    },
    {
      "id": 4,
      "title": "AI & Machine Learning Workshop",
      "description":
          "Hands-on workshop covering fundamentals of artificial intelligence and machine learning applications.",
      "date": "2024-07-22",
      "time": "10:00 AM",
      "location": "Computer Lab 1, Block B",
      "category": "Workshops",
      "imageUrl":
          "https://images.unsplash.com/photo-1485827404703-89b55fcc595e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFeature": true,
      "attendees": 80,
      "organizer": "Tech Club"
    },
    {
      "id": 5,
      "title": "Career Guidance Seminar",
      "description":
          "Expert guidance on career opportunities, interview preparation, and industry insights for final year students.",
      "date": "2024-07-25",
      "time": "11:00 AM",
      "location": "Seminar Hall, Block C",
      "category": "Seminars",
      "imageUrl":
          "https://images.unsplash.com/photo-1559136555-9303baea8ebd?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFeature": false,
      "attendees": 200,
      "organizer": "Placement Cell"
    },
    {
      "id": 6,
      "title": "Photography Competition",
      "description":
          "Capture the essence of campus life through your lens. Multiple categories and exciting prizes await.",
      "date": "2024-07-28",
      "time": "09:00 AM",
      "location": "Entire Campus",
      "category": "Competitions",
      "imageUrl":
          "https://images.unsplash.com/photo-1452587925148-ce544e77e70d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "isFeature": false,
      "attendees": 120,
      "organizer": "Photography Club"
    }
  ];

  List<Map<String, dynamic>> get filteredEvents {
    List<Map<String, dynamic>> filtered = eventsData;

    if (selectedFilters.isNotEmpty) {
      filtered = filtered
          .where(
              (event) => selectedFilters.contains(event['category'] as String))
          .toList();
    }

    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered
          .where((event) =>
              (event['title'] as String).toLowerCase().contains(searchTerm) ||
              (event['description'] as String)
                  .toLowerCase()
                  .contains(searchTerm) ||
              (event['category'] as String).toLowerCase().contains(searchTerm))
          .toList();
    }

    return filtered;
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (selectedFilters.contains(filter)) {
        selectedFilters.remove(filter);
      } else {
        selectedFilters.add(filter);
      }
    });
  }

  void _clearAllFilters() {
    setState(() {
      selectedFilters.clear();
      _searchController.clear();
    });
  }

  Future<void> _refreshEvents() async {
    setState(() {
      isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Events',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: Text(
                      'Clear All',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: filterCategories.length,
                itemBuilder: (context, index) {
                  final category = filterCategories[index];
                  final isSelected = selectedFilters.contains(category);
                  final eventCount = eventsData
                      .where((event) => event['category'] == category)
                      .length;

                  return CheckboxListTile(
                    title: Text(
                      category,
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      '$eventCount events',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    value: isSelected,
                    onChanged: (value) {
                      _toggleFilter(category);
                      setState(() {});
                    },
                    activeColor: AppTheme.lightTheme.primaryColor,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredEvents;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Events',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshEvents,
        color: AppTheme.lightTheme.primaryColor,
        child: Column(
          children: [
            // Search Bar
            SearchBarWidget(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  isSearching = value.isNotEmpty;
                });
              },
            ),

            // Filter Chips
            if (selectedFilters.isNotEmpty)
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: selectedFilters.length + 1,
                  itemBuilder: (context, index) {
                    if (index == selectedFilters.length) {
                      return FilterChipWidget(
                        label: 'Clear All',
                        isSelected: false,
                        onTap: _clearAllFilters,
                        isAction: true,
                      );
                    }

                    final filter = selectedFilters[index];
                    final count = eventsData
                        .where((event) => event['category'] == filter)
                        .length;

                    return FilterChipWidget(
                      label: '$filter ($count)',
                      isSelected: true,
                      onTap: () => _toggleFilter(filter),
                    );
                  },
                ),
              ),

            // Events List
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final event = filtered[index];
                        return EventCardWidget(
                          event: event,
                          onTap: () => _navigateToEventDetails(event),
                          onAddToCalendar: () => _addToCalendar(event),
                          onShare: () => _shareEvent(event),
                          onSetReminder: () => _setReminder(event),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _suggestEvent,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          'Suggest Event',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'event_busy',
              color: AppTheme.lightTheme.colorScheme.outline,
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Events Found',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              selectedFilters.isNotEmpty || _searchController.text.isNotEmpty
                  ? 'Try adjusting your filters or search terms'
                  : 'No events are currently scheduled',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            if (selectedFilters.isNotEmpty || _searchController.text.isNotEmpty)
              ElevatedButton(
                onPressed: _clearAllFilters,
                child: const Text('Clear Filters'),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToEventDetails(Map<String, dynamic> event) {
    // Navigate to event details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${event['title']}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _addToCalendar(Map<String, dynamic> event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${event['title']}" to calendar'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _shareEvent(Map<String, dynamic> event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${event['title']}"'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _setReminder(Map<String, dynamic> event) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder set for "${event['title']}"'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _suggestEvent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suggest Event'),
        content: const Text(
            'Feature coming soon! You will be able to suggest events to administrators.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
