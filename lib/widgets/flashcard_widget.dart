import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/flashcard.dart';

class FlashcardWidget extends StatefulWidget {
  final Flashcard flashcard;
  final Function(DifficultyLevel) onAnswered;
  final VoidCallback onCompleted;

  const FlashcardWidget({
    super.key,
    required this.flashcard,
    required this.onAnswered,
    required this.onCompleted,
  });

  @override
  FlashcardWidgetState createState() => FlashcardWidgetState();
}

class FlashcardWidgetState extends State<FlashcardWidget>
    with TickerProviderStateMixin {
  bool isFlipped = false;
  late AnimationController _flipController;
  late AnimationController _slideController;
  late Animation<double> _flipAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(1.0, 0)).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _flipController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (!isFlipped) {
      _flipController.forward();
      setState(() => isFlipped = true);
    } else {
      _flipController.reverse();
      setState(() => isFlipped = false);
    }
    HapticFeedback.lightImpact();
  }

  void _answerCard(DifficultyLevel difficulty) async {
    await _slideController.forward();
    _flipController.reset();
    _slideController.reset();
    setState(() => isFlipped = false);
    widget.onAnswered(difficulty);
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Flashcard
        Expanded(
          child: SlideTransition(
            position: _slideAnimation,
            child: GestureDetector(
              onTap: _flipCard,
              child: AnimatedBuilder(
                animation: _flipAnimation,
                builder: (context, child) {
                  final isShowingFront = _flipAnimation.value < 0.5;
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(_flipAnimation.value * 3.14159),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..rotateY(isShowingFront ? 0 : 3.14159),
                            child: Text(
                              isShowingFront
                                  ? widget.flashcard.front
                                  : widget.flashcard.back,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Action hint or difficulty buttons
        if (!isFlipped)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Tap to reveal answer',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDifficultyButton(
                'Hard',
                const Color(0xFFFF8A65), // Soft red
                DifficultyLevel.hard,
                Icons.sentiment_dissatisfied,
              ),
              _buildDifficultyButton(
                'Good',
                const Color(0xFFFFD54F), // Soft orange
                DifficultyLevel.good,
                Icons.sentiment_neutral,
              ),
              _buildDifficultyButton(
                'Easy',
                const Color(0xFF81C784), // Soft green
                DifficultyLevel.easy,
                Icons.sentiment_satisfied,
              ),
            ],
          ),
          const SizedBox(height: 8),

          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => widget.onCompleted(),
            icon: Icon(
              Icons.check_circle,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(
              'Mark as Complete',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDifficultyButton(
    String label,
    Color color,
    DifficultyLevel difficulty,
    IconData icon,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          onPressed: () => _answerCard(difficulty),
          icon: Icon(icon, size: 18),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
