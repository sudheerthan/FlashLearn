enum DifficultyLevel { easy, good, hard }

class Flashcard {
  final String id;
  final String front;
  final String back;
  DifficultyLevel difficulty;
  DateTime lastReviewed;
  int reviewCount;
  double easeFactor; // For spaced repetition algorithm
  int intervalDays; // Days until next review
  DateTime nextReviewDate;
  bool completed;

  Flashcard({
    required this.id,
    required this.front,
    required this.back,
    this.difficulty = DifficultyLevel.good,
    DateTime? lastReviewed,
    this.reviewCount = 0,
    this.easeFactor = 2.5,
    this.intervalDays = 1,
    DateTime? nextReviewDate,
    this.completed = false,
  }) : lastReviewed = lastReviewed ?? DateTime.now(),
       nextReviewDate = nextReviewDate ?? DateTime.now();

  // Create a copy with updated values
  Flashcard copyWith({
    String? id,
    String? front,
    String? back,
    DifficultyLevel? difficulty,
    DateTime? lastReviewed,
    int? reviewCount,
    double? easeFactor,
    int? intervalDays,
    DateTime? nextReviewDate,
    bool? completed,
  }) {
    return Flashcard(
      id: id ?? this.id,
      front: front ?? this.front,
      back: back ?? this.back,
      difficulty: difficulty ?? this.difficulty,
      lastReviewed: lastReviewed ?? this.lastReviewed,
      reviewCount: reviewCount ?? this.reviewCount,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
      completed: completed ?? this.completed,
    );
  }

  // Check if card is due for review
  bool get isDue {
    return DateTime.now().isAfter(nextReviewDate) ||
        DateTime.now().isAtSameMomentAs(nextReviewDate);
  }

  // Get priority score for sorting (higher = more urgent)
  double get priorityScore {
    final daysSinceReview = DateTime.now().difference(nextReviewDate).inDays;
    final difficultyMultiplier = difficulty == DifficultyLevel.hard
        ? 3.0
        : difficulty == DifficultyLevel.good
        ? 2.0
        : 1.0;
    return (daysSinceReview + 1) * difficultyMultiplier;
  }
}
