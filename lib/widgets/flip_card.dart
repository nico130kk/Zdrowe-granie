import 'package:flutter/material.dart';

class FlipCardWidget extends StatefulWidget {
  final String frontText; final String backText;
  const FlipCardWidget({super.key, required this.frontText, required this.backText});
  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget> {
  bool _isFlipped = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isFlipped = !_isFlipped),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => ScaleTransition(scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation), child: FadeTransition(opacity: animation, child: child)),
        child: _isFlipped ? _buildCardSide(widget.backText, Colors.green.shade50, Colors.green.shade900, key: const ValueKey('back')) : _buildCardSide(widget.frontText, Colors.white, Colors.black, key: const ValueKey('front')),
      ),
    );
  }
  Widget _buildCardSide(String text, Color bgColor, Color textColor, {required Key key}) {
    return Container(
      key: key, width: double.infinity, height: double.infinity, padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 5))]),
      child: Center(child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: textColor, height: 1.4))),
    );
  }
}