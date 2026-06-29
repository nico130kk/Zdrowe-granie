/// Screen displaying the interactive custom graph map.
/// Dynamically checks parent nodes to safely unlock descendants based on 
/// customized JSON bronze medal day requirements or direct lesson completion.

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
          final Offset mapCenter = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
          final userProvider = context.watch<UserProvider>();
          final profile = userProvider.profile;

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
                  Positioned.fill(
                    child: CustomPaint(
                      painter: GraphConnectionPainter(
                        nodes: appNodes,
                        profile: profile,
                        userProvider: userProvider,
                        center: mapCenter,
                      ),
                    ),
                  ),

                  ...appNodes.map((node) {
                    final bool isCompleted = profile?.completedLessonsIDs.contains(node.id) ?? false;
                    bool isLocked = true;

                    if (node.requiredParentId == null) {
                      isLocked = false; 
                    } else {
                      final bool isParentCompleted = profile?.completedLessonsIDs.contains(node.requiredParentId) ?? false;
                      final parentContent = userProvider.lessonContents[node.requiredParentId];
                      
                      if (parentContent != null && parentContent['challenges'] != null) {
                        final int reqBronze = parentContent['challenges']['bronze']?['days'] ?? 6;
                        final int parentBronzeProgress = profile?.challengesProgress['${node.requiredParentId}_braz'] ?? 0;
                        
                        if (parentBronzeProgress >= reqBronze) {
                          isLocked = false;
                        }
                      } else if (isParentCompleted) {
                        isLocked = false;
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
    Color bgColor = isLocked ? Colors.grey[300]! : (isCompleted ? Colors.green[400]! : Colors.white);
    Color borderColor = isLocked ? Colors.grey[400]! : (isCompleted ? Colors.green[600]! : Colors.blueAccent);
    Color iconColor = isLocked ? Colors.grey[500]! : (isCompleted ? Colors.white : Colors.blueAccent);

    return GestureDetector(
      onTap: isLocked
          ? () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Zdobądź Brązowy Medal w poprzednim temacie! 🔒")))
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
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isLocked ? Colors.grey : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class GraphConnectionPainter extends CustomPainter {
  final List<MapNode> nodes;
  final dynamic profile;
  final UserProvider userProvider;
  final Offset center;

  GraphConnectionPainter({
    required this.nodes, 
    required this.profile, 
    required this.userProvider, 
    required this.center
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var node in nodes) {
      if (node.requiredParentId != null) {
        final parent = nodes.firstWhere((n) => n.id == node.requiredParentId);
        final start = Offset(center.dx + parent.x, center.dy + parent.y);
        final end = Offset(center.dx + node.x, center.dy + node.y);

        final bool isParentCompleted = profile?.completedLessonsIDs.contains(node.requiredParentId) ?? false;
        final parentContent = userProvider.lessonContents[node.requiredParentId];
        bool isUnlocked = false;

        if (parentContent != null && parentContent['challenges'] != null) {
          final int reqBronze = parentContent['challenges']['bronze']?['days'] ?? 6;
          final int parentBronzeProgress = profile?.challengesProgress['${node.requiredParentId}_braz'] ?? 0;
          
          if (parentBronzeProgress >= reqBronze) {
            isUnlocked = true;
          }
        } else if (isParentCompleted) {
          isUnlocked = true;
        }

        paint.color = isUnlocked ? Colors.blueAccent.withValues(alpha: 0.6) : Colors.grey[300]!;
        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}