import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Twój Profil', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.white, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Statystyki', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard('🔥 Streak', '12 Dni'),
              _buildStatCard('🏆 Złoto', '3'),
              _buildStatCard('📚 Lekcje', '1'),
            ],
          ),
          const Divider(height: 40),
          const Text('Ustawienia', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ListTile(leading: const Icon(Icons.notifications), title: const Text('Powiadomienia'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
          ListTile(leading: const Icon(Icons.palette), title: const Text('Personalizacja'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
          ListTile(leading: const Icon(Icons.info), title: const Text('O projekcie'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
          ListTile(leading: const Icon(Icons.favorite, color: Colors.red), title: const Text('Wsparcie projektu'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
        ],
      ),
    );
  }
  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
      child: Column(children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(value, style: const TextStyle(fontSize: 18, color: Colors.green))]),
    );
  }
}