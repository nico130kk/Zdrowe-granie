import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';
import '../models/lesson_data.dart';
import 'flashcard_lesson_screen.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text("Drzewo Nawyku", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Center of the map
          final Offset mapCenter = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);

          return InteractiveViewer(
            constrained: false,
            boundaryMargin: const EdgeInsets.all(800),
            minScale: 0.5,
            maxScale: 1.5,
            child: SizedBox(
              width: constraints.maxWidth * 2,
              height: constraints.maxHeight * 2,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // 1. CONNECTION LINES (Drawn under nodes)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GraphConnectionPainter(
                        nodes: appNodes,
                        userProvider: context.watch<UserProvider>(),
                        center: mapCenter,
                      ),
                    ),
                  ),

                  // 2. NODES (Circles)
                  ...appNodes.map((node) {
                    final userProvider = context.watch<UserProvider>();
                    final profile = userProvider.profile;
                    final bool isCompleted = profile?.completedLessonsIDs.contains(node.id) ?? false;
                    
                    // LOCK LOGIC
                    bool isLocked = true;
                    if (node.requiredParentId == null) {
                      isLocked = false; // Start node
                    } else {
                      final parentContent = userProvider.lessonContents[node.requiredParentId];
                      bool parentHasChallenges = parentContent?['challenges'] != null;

                      if (parentHasChallenges) {
                        // If parent has challenges, check for bronze medal
                        int requiredBronzeToUnlock = parentContent?['challenges']?['bronze']?['days'] ?? 6;
                        int parentBronzeProgress = profile?.challengesProgress['${node.requiredParentId}_braz'] ?? 0;
                        if (parentBronzeProgress >= requiredBronzeToUnlock) {
                          isLocked = false;
                        }
                      } else {
                        // If parent has NO challenges, just check if it's completed
                        if (profile?.completedLessonsIDs.contains(node.requiredParentId) == true) {
                          isLocked = false;
                        }
                      }
                    }

                    return Positioned(
                      left: mapCenter.dx + node.x - 45, 
                      top: mapCenter.dy + node.y - 45,
                      child: _buildGraphNode(context, node, isLocked, isCompleted),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGraphNode(BuildContext context, MapNode node, bool isLocked, bool isCompleted) {
    // Visual style of nodes
    Color bgColor = isLocked ? Colors.grey[300]! : (isCompleted ? Colors.green[400]! : Colors.white);
    Color borderColor = isLocked ? Colors.grey[400]! : (isCompleted ? Colors.green[600]! : Colors.blueAccent);
    Color iconColor = isLocked ? Colors.grey[500]! : (isCompleted ? Colors.white : Colors.blueAccent);

    return GestureDetector(
      onTap: isLocked
          ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Zdobądź Brązowy Medal (lub ukończ) w poprzednim temacie! 🔒")))
          : () => Navigator.push(context, MaterialPageRoute(builder: (_) => FlashcardLessonScreen(lesson: node))),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 4),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.1), offset: const Offset(0, 4), blurRadius: 8),
              ],
            ),
            child: Center(
              child: Icon(
                isLocked ? Icons.lock : (isCompleted ? Icons.check : Icons.menu_book),
                color: iconColor,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
            child: Text(
              node.title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isLocked ? Colors.grey : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// DRAWING LINES
class GraphConnectionPainter extends CustomPainter {
  final List<MapNode> nodes;
  final UserProvider userProvider;
  final Offset center;

  GraphConnectionPainter({required this.nodes, required this.userProvider, required this.center});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final profile = userProvider.profile;

    for (var node in nodes) {
      if (node.requiredParentId != null) {
        final parent = nodes.firstWhere((n) => n.id == node.requiredParentId);
        
        final start = Offset(center.dx + parent.x, center.dy + parent.y);
        final end = Offset(center.dx + node.x, center.dy + node.y);

        final parentContent = userProvider.lessonContents[node.requiredParentId];
        bool parentHasChallenges = parentContent?['challenges'] != null;
        bool isUnlocked = false;

        if (parentHasChallenges) {
          int requiredBronzeToUnlock = parentContent?['challenges']?['bronze']?['days'] ?? 6;
          int parentBronzeProgress = profile?.challengesProgress['${node.requiredParentId}_braz'] ?? 0;
          isUnlocked = parentBronzeProgress >= requiredBronzeToUnlock;
        } else {
          isUnlocked = profile?.completedLessonsIDs.contains(node.requiredParentId) == true;
        }
        
        // Line highlights if the child node is unlocked
        paint.color = isUnlocked ? Colors.blueAccent.withValues(alpha: 0.6) : Colors.grey[300]!;

        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}