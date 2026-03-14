import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import '../services/irma_community_service.dart';
import 'community_thread_screen.dart';

class IrmaCommunityScreen extends ConsumerWidget {
  const IrmaCommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(irmaPostsProvider);
    final selectedCategory = ref.watch(irmaCommunityCategoryProvider);
    final service = ref.watch(irmaCommunityServiceProvider);

    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 140), // Top nav spacer
              
              // 1. SEARCH BAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: IrmaTheme.borderLight.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(Iconsax.search_normal, color: IrmaTheme.textSub, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search topics...",
                            hintStyle: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 2. CATEGORIES
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: service.categories.length,
                  itemBuilder: (context, index) {
                    final category = service.categories[index];
                    final isSelected = selectedCategory == category;
                    return GestureDetector(
                      onTap: () => ref.read(irmaCommunityCategoryProvider.notifier).state = category,
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? IrmaTheme.follicular : IrmaTheme.pureWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? IrmaTheme.follicular : IrmaTheme.borderLight,
                          ),
                        ),
                        child: Text(
                          category,
                          style: IrmaTheme.outfit.copyWith(
                            color: isSelected ? IrmaTheme.pureWhite : IrmaTheme.textMain,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // 3. POSTS FEED
              Expanded(
                child: postsAsync.when(
                  data: (posts) => ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return CommunityPostCard(post: posts[index]);
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator(color: IrmaTheme.follicular)),
                  error: (err, _) => Center(child: Text("Error: ${err.toString()}")),
                ),
              ),
            ],
          ),

          // TOP NAV
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IrmaNavigationBar(
              title: "Community",
              showBackButton: false,
            ),
          ),

          // ADD POST BUTTON
          Positioned(
            bottom: 120,
            right: 24,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: IrmaTheme.follicular,
              child: const Icon(Iconsax.add, color: IrmaTheme.pureWhite),
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityPostCard extends StatelessWidget {
  final IrmaCommunityPost post;
  const CommunityPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IrmaCommunityThreadScreen(post: post),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: IrmaTheme.pureWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: IrmaTheme.borderLight),
          boxShadow: [
            BoxShadow(
              color: IrmaTheme.pureBlack.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Hero(
                  tag: "avatar_${post.id}",
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: IrmaTheme.luteal,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        post.author[0],
                        style: IrmaTheme.outfit.copyWith(color: IrmaTheme.pureWhite, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: IrmaTheme.outfit.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      "${post.createdAt.hour}h ago • ${post.category}",
                      style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Hero(
              tag: "title_${post.id}",
              child: Material(
                color: Colors.transparent,
                child: Text(
                  post.title,
                  style: IrmaTheme.outfit.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub, height: 1.5),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildMetric(Iconsax.heart, post.likes.toString()),
                const SizedBox(width: 24),
                _buildMetric(Iconsax.message_text, post.comments.toString()),
                const Spacer(),
                const Icon(Iconsax.archive_add, color: IrmaTheme.textSub, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: IrmaTheme.textSub, size: 20),
        const SizedBox(width: 8),
        Text(value, style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
