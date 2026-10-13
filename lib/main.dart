import 'package:flutter/material.dart';
import 'colors.dart';
import 'call_log.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedTab = 0;
  int selectedNav = 0;
  String dialNumber = '';

  List<CallLog> get filteredLogs {
    if (tabBars[selectedTab] == 'Missed') {
      return callLogs.where((c) => c.type == CallType.missed).toList();
    }
    return callLogs;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: selectedNav == 0 ? _homePage() : _keypadPage(),
        ),
        bottomNavigationBar: _bottomNav(),
      ),
    );
  }

  // Home Page
  Widget _homePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _searchBar(),
          const SizedBox(height: 16),
          _tabChips(),
          const SizedBox(height: 24),
          _favouritesRow(),
          const SizedBox(height: 16),
          ..._buildSections(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Search Bar
  Widget _searchBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.searchBar,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        children: [
          Icon(Icons.menu, color: AppColors.textPrimary),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Search contacts',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ),
          Icon(Icons.mic_none, color: AppColors.textPrimary),
        ],
      ),
    );
  }

  // Tab Chips
  Widget _tabChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabBars.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final bool selected = selectedTab == index;
          return GestureDetector(
            onTap: () => setState(() => selectedTab = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.chipSelected : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.chipBorder, width: 1),
              ),
              child: Text(
                tabBars[index],
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Favourites Row
  Widget _favouritesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Text(
              'Favourites',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
            ),
            SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down,
                size: 18, color: AppColors.textPrimary),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.searchBar,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'View contacts',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 12),
          ),
        ),
      ],
    );
  }

  // Today / Yesterday Sections
  List<Widget> _buildSections() {
    final List<Widget> widgets = [];
    String? currentSection;

    for (final log in filteredLogs) {
      if (log.section != currentSection) {
        currentSection = log.section;
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 10, left: 4),
            child: Text(
              log.section,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        );
      }
      widgets.add(_callTile(log));
    }
    return widgets;
  }

  // Call Tile
  Widget _callTile(CallLog log) {
    IconData directionIcon;
    Color directionColor = AppColors.textSecondary;

    switch (log.type) {
      case CallType.outgoing:
        directionIcon = Icons.call_made;
        break;
      case CallType.incoming:
        directionIcon = Icons.call_received;
        break;
      case CallType.missed:
        directionIcon = Icons.call_missed;
        directionColor = AppColors.missed;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _avatar(log.name),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(directionIcon, size: 13, color: directionColor),
                    const SizedBox(width: 4),
                    Text(
                      '${log.country} . ${log.time} . SIM ${log.sim}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.call_outlined, color: AppColors.textPrimary),
        ],
      ),
    );
  }

  // Avatar
  Widget _avatar(String name) {
    final String letter = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return CircleAvatar(
      radius: 20,
      backgroundColor: const Color(0xFF1B1B24),
      child: Text(
        letter,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  //Keypad Page
  Widget _keypadPage() {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'];
    return Column(
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  dialNumber.isEmpty ? 'Enter number' : dialNumber,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: dialNumber.isEmpty
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    fontSize: 28,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (dialNumber.isNotEmpty) {
                    setState(() {
                      dialNumber =
                          dialNumber.substring(0, dialNumber.length - 1);
                    });
                  }
                },
                icon: const Icon(Icons.backspace_outlined),
                color: AppColors.textPrimary,
              ),
            ],
          ),
        ),
        const Spacer(),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 1.3,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: keys
              .map(
                (k) => GestureDetector(
              onTap: () => setState(() => dialNumber += k),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(40),
                ),
                alignment: Alignment.center,
                child: Text(
                  k,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                  ),
                ),
              ),
            ),
          )
              .toList(),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _simCallButton(1, Colors.blue),
            _simCallButton(2, Colors.orange),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _simCallButton(int sim, Color color) {
    return ElevatedButton.icon(
      onPressed: () {
        if (dialNumber.isEmpty) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('SIM $sim diye call: $dialNumber')),
        );
      },
      icon: const Icon(Icons.call, color: Colors.white),
      label: Text(
        'SIM $sim',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  // Bottom Navigation
  Widget _bottomNav() {
    return Container(
      height: 80,
      color: AppColors.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(Icons.home, 'Home', 0),
          _navItem(Icons.dialpad, 'Keypad', 1),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final bool selected = selectedNav == index;
    return GestureDetector(
      onTap: () => setState(() => selectedNav = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFE6E6F2) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: selected ? const Color(0xFF1B1B24) : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}