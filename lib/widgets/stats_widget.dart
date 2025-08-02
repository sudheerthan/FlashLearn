import 'package:flutter/material.dart';
import '../services/flashcard_service.dart';

class StatsWidget extends StatelessWidget {
  const StatsWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final stats = FlashcardService.getStatistics();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Total',
            stats['total'].toString(),
            Icons.collections_bookmark,
            const Color(0xFF64B5F6),
          ),
          _buildStatItem(
            'Due',
            stats['due'].toString(),
            Icons.schedule,
            const Color(0xFFFF8A65),
          ),
          _buildStatItem(
            'Reviewed',
            stats['reviewed'].toString(),
            Icons.check_circle,
            const Color(0xFF81C784),
          ),
          _buildStatItem(
            'New',
            stats['new'].toString(),
            Icons.fiber_new,
            const Color(0xFFFFD54F),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
