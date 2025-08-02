import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import '../services/flashcard_service.dart';
import '../widgets/stats_widget.dart';
import '../widgets/empty_state_widget.dart';
import 'study_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Flashcard> activeFlashcards = [];
  List<Flashcard> completedFlashcards = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFlashcards();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadFlashcards() {
    setState(() {
      activeFlashcards = FlashcardService.getAllFlashcards();
      completedFlashcards = FlashcardService.getCompletedFlashcards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  Icons.flash_on,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 12)),
              TextSpan(
                text: 'FlashLearn',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showAddCardDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.add_to_photos_outlined),
            onPressed: () => _showBulkAddDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveFlashcardsView(),
          _buildCompletedFlashcardsView(),
        ],
      ),
    );
  }

  Widget _buildActiveFlashcardsView() {
    return activeFlashcards.isEmpty
        ? EmptyStateWidget(onAddCard: () => _showAddCardDialog())
        : Column(
            children: [
              const StatsWidget(),
              const SizedBox(height: 16),
              _buildCardsList(activeFlashcards, true),
            ],
          );
  }

  Widget _buildCompletedFlashcardsView() {
    return completedFlashcards.isEmpty
        ? const Center(child: Text('No completed cards yet.'))
        : _buildCardsList(completedFlashcards, false);
  }

  Widget _buildCardsList(List<Flashcard> flashcards, bool active) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: flashcards.length,
        itemBuilder: (context, index) {
          final card = flashcards[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: ListTile(
              onTap: active
                  ? () => _startStudySession(index)
                  : () => _showCompletedCardDialog(card),
              title: Text(
                card.front,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    card.back,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (active)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _showDeleteCardDialog(card.id),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  

  void _startStudySession(int startIndex) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudyScreen(
          startIndex: startIndex,
          onSessionComplete: _loadFlashcards,
        ),
      ),
    );

    if (result == true) {
      _loadFlashcards();
    }
  }

  void _showAddCardDialog() {
    final frontController = TextEditingController();
    final backController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: frontController,
              decoration: const InputDecoration(
                labelText: 'Front (Question)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: backController,
              decoration: const InputDecoration(
                labelText: 'Back (Answer)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (frontController.text.isNotEmpty &&
                  backController.text.isNotEmpty) {
                FlashcardService.addFlashcard(
                  Flashcard(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    front: frontController.text,
                    back: backController.text,
                  ),
                );
                _loadFlashcards();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showDeleteCardDialog(String cardId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Flashcard'),
        content: const Text('Are you sure you want to delete this flashcard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              FlashcardService.removeFlashcard(cardId);
              _loadFlashcards();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCompletedCardDialog(Flashcard card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(card.front),
        content: Text(card.back),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showBulkAddDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Add Flashcards'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Paste your questions and answers below, with each question and answer on a new line, separated by a comma.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Q1,A1\nQ2,A2',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final lines = controller.text.split('\n');
                for (final line in lines) {
                  final parts = line.split(',');
                  if (parts.length == 2) {
                    FlashcardService.addFlashcard(
                      Flashcard(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        front: parts[0].trim(),
                        back: parts[1].trim(),
                      ),
                    );
                  }
                }
                _loadFlashcards();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
