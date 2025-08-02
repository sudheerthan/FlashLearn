import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../services/flashcard_service.dart';
import '../widgets/flashcard_widget.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({
    super.key,
    required this.startIndex,
    required this.onSessionComplete,
  });
  final int startIndex;
  final VoidCallback onSessionComplete;

  @override
  StudyScreenState createState() => StudyScreenState();
}

class StudyScreenState extends State<StudyScreen> {
  late PageController _pageController;
  List<Flashcard> studyQueue = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadStudyQueue();
    currentIndex = widget.startIndex;
    _pageController = PageController(initialPage: widget.startIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadStudyQueue() {
    setState(() {
      studyQueue = FlashcardService.getAllFlashcards();
    });
  }

  void _onCardAnswered(DifficultyLevel difficulty) {
    if (currentIndex < studyQueue.length) {
      final currentCard = studyQueue[currentIndex];
      FlashcardService.updateFlashcardAfterReview(currentCard.id, difficulty);

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (studyQueue.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Study Session')),
        body: const Center(child: Text('No cards to study right now!')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Session'),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        titleTextStyle: TextStyle(
          color: Theme.of(context).textTheme.titleLarge?.color,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentIndex + 1) / studyQueue.length,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              '${(currentIndex % studyQueue.length) + 1} of ${studyQueue.length}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final cardIndex = index % studyQueue.length;
                  return FlashcardWidget(
                    flashcard: studyQueue[cardIndex],
                    onAnswered: _onCardAnswered,
                    onCompleted: () {
                      FlashcardService.markCardAsCompleted(
                          studyQueue[cardIndex].id);
                      Navigator.pop(context, true); // Return true to indicate completion
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
