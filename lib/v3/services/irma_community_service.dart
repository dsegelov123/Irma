import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- MODELS ---

class IrmaCommunityPost {
  final String id;
  final String author;
  final String title;
  final String content;
  final String category;
  final int likes;
  final int comments;
  final DateTime createdAt;
  final bool isSaved;
  final String? imageUrl;

  IrmaCommunityPost({
    required this.id,
    required this.author,
    required this.title,
    required this.content,
    required this.category,
    this.likes = 0,
    this.comments = 0,
    required this.createdAt,
    this.isSaved = false,
    this.imageUrl,
  });
}

// --- SERVICE ---

final irmaCommunityServiceProvider = Provider((ref) => IrmaCommunityService());

class IrmaCommunityService {
  final List<String> categories = ["All", "Wellness", "Cycle Sync", "Nutrition", "Self-Care", "Hormones"];

  Future<List<IrmaCommunityPost>> fetchPosts({String? category}) async {
    // Mocking a delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final allPosts = [
      IrmaCommunityPost(
        id: "1",
        author: "Sarah J.",
        title: "Seed Cycling 101",
        content: "I started seed cycling last month and my cramps have significantly decreased. Anyone else tried this?",
        category: "Nutrition",
        likes: 24,
        comments: 12,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      IrmaCommunityPost(
        id: "2",
        author: "Emma W.",
        title: "Luteal Phase Anxiety",
        content: "Does anyone else feel a massive spike in anxiety right before their period? Looking for natural management tips.",
        category: "Wellness",
        likes: 56,
        comments: 34,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      IrmaCommunityPost(
        id: "3",
        author: "Elena R.",
        title: "Magnesium for Sleep",
        content: "Taking magnesium glycinate before bed has been a game changer for my sleep quality during menstruation.",
        category: "Self-Care",
        likes: 112,
        comments: 18,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    if (category == null || category == "All") {
      return allPosts;
    }
    return allPosts.where((p) => p.category == category).toList();
  }
}

// --- STATE MANAGEMENT ---

final irmaCommunityCategoryProvider = StateProvider<String>((ref) => "All");

final irmaPostsProvider = FutureProvider<List<IrmaCommunityPost>>((ref) async {
  final service = ref.watch(irmaCommunityServiceProvider);
  final category = ref.watch(irmaCommunityCategoryProvider);
  return await service.fetchPosts(category: category);
});
