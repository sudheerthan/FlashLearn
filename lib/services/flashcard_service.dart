// services/flashcard_service.dart
import 'package:flash_learn/models/flashcard.dart';

class FlashcardService {
  static final List<Flashcard> _flashcards = [
    Flashcard(
      id: '1',
      front: 'What is Flutter?',
      back:
          'Flutter is Google\'s UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.',
    ),
    Flashcard(
      id: '2',
      front: 'What is a Widget in Flutter?',
      back:
          'A Widget is a building block of Flutter UI. Everything in Flutter is a widget - from buttons to layout structures.',
    ),
    Flashcard(
      id: '3',
      front:
          'What is the difference between StatelessWidget and StatefulWidget?',
      back:
          'StatelessWidget is immutable and doesn\'t change over time, while StatefulWidget can change its state and rebuild the UI.',
    ),
  ];

  // Get all flashcards
  static List<Flashcard> getAllFlashcards() {
    return _flashcards.where((card) => !card.completed).toList();
  }

  // Get completed flashcards
  static List<Flashcard> getCompletedFlashcards() {
    return _flashcards.where((card) => card.completed).toList();
  }

  // Get cards sorted by priority (hard cards first, then by due date)
  static List<Flashcard> getStudyQueue() {
    final cards = _flashcards.where((card) => !card.completed).toList();
    cards.sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
    return cards;
  }

  // Get due cards only
  static List<Flashcard> getDueCards() {
    return _flashcards
        .where((card) => card.isDue && !card.completed)
        .toList()
      ..sort((a, b) => b.priorityScore.compareTo(a.priorityScore));
  }

  // Add new flashcard
  static void addFlashcard(Flashcard flashcard) {
    _flashcards.add(flashcard);
  }

  // Mark a card as completed
  static void markCardAsCompleted(String cardId) {
    final cardIndex = _flashcards.indexWhere((card) => card.id == cardId);
    if (cardIndex != -1) {
      _flashcards[cardIndex] = _flashcards[cardIndex].copyWith(completed: true);
    }
  }

  // Update flashcard after review using spaced repetition algorithm
  static void updateFlashcardAfterReview(
    String cardId,
    DifficultyLevel difficulty,
  ) {
    final cardIndex = _flashcards.indexWhere((card) => card.id == cardId);
    if (cardIndex == -1) return;

    final card = _flashcards[cardIndex];
    final now = DateTime.now();

    // Spaced repetition algorithm based on difficulty
    double newEaseFactor = card.easeFactor;
    int newInterval = card.intervalDays;

    switch (difficulty) {
      case DifficultyLevel.hard:
        // Hard: Reset interval, decrease ease factor
        newInterval = 1;
        newEaseFactor = (card.easeFactor - 0.15).clamp(1.3, 3.0);
        break;

      case DifficultyLevel.good:
        // Good: Normal progression
        if (card.reviewCount == 0) {
          newInterval = 1;
        } else if (card.reviewCount == 1) {
          newInterval = 6;
        } else {
          newInterval = (card.intervalDays * card.easeFactor).round();
        }
        break;

      case DifficultyLevel.easy:
        // Easy: Faster progression, increase ease factor
        if (card.reviewCount == 0) {
          newInterval = 4;
        } else if (card.reviewCount == 1) {
          newInterval = 10;
        } else {
          newInterval = (card.intervalDays * card.easeFactor * 1.3).round();
        }
        newEaseFactor = (card.easeFactor + 0.1).clamp(1.3, 3.0);
        break;
    }

    final nextReviewDate = now.add(Duration(days: newInterval));

    _flashcards[cardIndex] = card.copyWith(
      difficulty: difficulty,
      lastReviewed: now,
      reviewCount: card.reviewCount + 1,
      easeFactor: newEaseFactor,
      intervalDays: newInterval,
      nextReviewDate: nextReviewDate,
    );
  }

  // Get statistics
  static Map<String, int> getStatistics() {
    final total = _flashcards.length;
    final reviewed = _flashcards.where((c) => c.reviewCount > 0).length;
    final due = _flashcards.where((c) => c.isDue).length;
    final newCards = _flashcards.where((c) => c.reviewCount == 0).length;

    return {'total': total, 'reviewed': reviewed, 'due': due, 'new': newCards};
  }

  // Remove flashcard
  static void removeFlashcard(String cardId) {
    _flashcards.removeWhere((card) => card.id == cardId);
  }
}
