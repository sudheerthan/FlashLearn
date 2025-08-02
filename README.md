# FlashLearn

FlashLearn is a modern, intuitive flashcard application built with Flutter, designed to help you learn and memorize information effectively. It incorporates spaced repetition principles and offers a clean, user-friendly interface.

## Features

-   **Flashcard Management:** Add, view, and delete flashcards.
-   **Spaced Repetition:** Cards are prioritized based on your review performance (Hard, Good, Easy).
-   **Study Mode:**
    -   Swipe through flashcards to review.
    -   Mark cards as "Hard," "Good," or "Easy" to update their review priority.
    -   Option to mark cards as "Complete" to move them to a separate section.
-   **Bulk Add:** Quickly add multiple flashcards by pasting questions and answers in a simple format (Q,A per line).
-   **Active/Completed Sections:** Organize your flashcards into active study and completed sections.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

-   [Flutter SDK](https://flutter.dev/docs/get-started/install)
-   [Dart SDK](https://dart.dev/get-started)
-   A code editor like [VS Code](https://code.visualstudio.com/) with the Flutter and Dart extensions.

## Project Structure

```
flash_learn/
├── lib/
│   ├── main.dart             # Main application entry point
│   ├── models/               # Data models (e.g., flashcard.dart)
│   ├── screens/              # UI screens (e.g., home_screen.dart, study_screen.dart)
│   ├── services/             # Business logic and data handling (e.g., flashcard_service.dart)
│   └── widgets/              # Reusable UI components
├── test/                     # Unit and widget tests
├── pubspec.yaml              # Project dependencies and metadata
└── README.md                 # This file
```

## Contributing

Contributions are welcome! Please feel free to open issues or submit pull requests.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.