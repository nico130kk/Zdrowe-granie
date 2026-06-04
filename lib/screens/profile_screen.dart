import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final profile = userProvider.profile;

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // 🏆 LICZENIE MEDALI 🏆
    // Szukamy w słowniku postępów tych, które mają max dni (brąz=6, srebro=14, złoto=30)
    int countBronze = profile.challengesProgress.entries.where((e) => e.key.endsWith('_braz') && e.value >= 6).length;
    int countSilver = profile.challengesProgress.entries.where((e) => e.key.endsWith('_srebro') && e.value >= 14).length;
    int countGold = profile.challengesProgress.entries.where((e) => e.key.endsWith('_zloto') && e.value >= 30).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text("Twój Profil", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // AVATAR I NICK
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text("Wojownik Zdrowia", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Aktywny gracz", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            
            const SizedBox(height: 32),

            // KARTA STREAKA
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.orange.withValues(alpha: 0.4), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.white, size: 48),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Seria Dni", style: TextStyle(color: Colors.white70, fontSize: 16)),
                      Text("${profile.streak} Dni z Rzędu!", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Zdobyte Medale", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),

            // GABLOTA MEDALI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMedalCounter(countBronze, "Brąz", Colors.orange[700]!),
                _buildMedalCounter(countSilver, "Srebro", Colors.blueGrey[400]!),
                _buildMedalCounter(countGold, "Złoto", Colors.amber[500]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedalCounter(int count, String name, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(Icons.military_tech, color: color, size: 48),
          const SizedBox(height: 8),
          Text(name, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text("$count", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}