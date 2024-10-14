import 'package:flutter/material.dart';
import 'package:mediconecta_app/presentation/screens.dart';
import 'package:mediconecta_app/theme/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [const HomeScreen(), const ChartView(), const UserView()];

    return Scaffold(
      appBar: AppBar(
        title: const Text('MediConecta'),
      ),
      //No mantiene el estado
      // body: screens[selectedIndex],
      // Mantiene el stado cambiar de screen
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,
          //Le da una especie de elevación y sombreado
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black26,
          //     blurRadius: 10,
          //     spreadRadius: 1,
          //   ),
          // ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, Icons.home_filled, 0),
            _buildNavItem(Icons.bar_chart, Icons.bar_chart_outlined, 1),
            _buildNavItem(Icons.person,Icons.person_2_rounded, 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData iconSelected, int index) {
    bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withOpacity(0.2) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSelected ? iconSelected : icon,
          color: isSelected ? AppColors.primaryColor : Colors.grey,
          size: 30,
        ),
      ),
    );
  }
}
