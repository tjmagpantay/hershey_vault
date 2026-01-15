import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const HersheyApp());
}

class HersheyApp extends StatelessWidget {
  const HersheyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hershey',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF16171D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16171D),
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'images/top-logo.png', 
          height: 60,
        ),
      ),
      body: const Center(
        child: Text(
          'Your side project starts here',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 65,
        height: 65,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFF496853),
          elevation: 8,
          shape: const CircleBorder(),
          child: SvgPicture.asset(
            'assets/icons/nekogram.svg',
            width: 32,
            height: 32,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF262932),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItemSvg('shine.svg', 'shine-active.svg', 'Emoticons', 1),
              _buildNavItemSvg('leaf.svg', 'leaf-active.svg', 'Gif', 2),
              const SizedBox(width: 40),
              _buildNavItemSvg('catogram.svg', 'catogram-active.svg', 'Meme', 3),
              _buildNavItemSvg('heart.svg', 'heart-active.svg', 'Favorites', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : const Color(0xFF777A8D),
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItemSvg(String iconPath, String activeIconPath, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            isSelected ? 'assets/icons/$activeIconPath' : 'assets/icons/$iconPath',
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(
              isSelected ? Colors.white : const Color(0xFF777A8D),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: isSelected ? Colors.white : const Color(0xFF777A8D),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
