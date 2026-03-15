import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../theme/irma_theme.dart';
import '../widgets/irma_nav_bar.dart';
import '../services/irma_community_service.dart';

class IrmaCommunityThreadScreen extends StatelessWidget {
  final IrmaCommunityPost post;
  const IrmaCommunityThreadScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: IrmaTheme.pureWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 80, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. ORIGINAL POST
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Hero(
                            tag: "avatar_${post.id}",
                            child: Container(
                              width: 40,
                              height: 40,
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
                                style: IrmaTheme.outfit.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "${post.createdAt.hour}h ago • ${post.category}",
                                style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Hero(
                        tag: "title_${post.id}",
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            post.title,
                            style: IrmaTheme.outfit.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        post.content,
                        style: IrmaTheme.inter.copyWith(color: IrmaTheme.textMain, height: 1.6, fontSize: 16),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          _buildActionTile(Iconsax.heart, "Like", post.likes.toString()),
                          const SizedBox(width: 16),
                          _buildActionTile(Iconsax.archive_add, "Save", ""),
                          const Spacer(),
                          Text(
                            "${post.comments} Comments",
                            style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
                const Divider(height: 1, color: IrmaTheme.borderLight),
                const SizedBox(height: 24),

                // 2. COMMENTS SECTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "Discussion",
                    style: IrmaTheme.outfit.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                _buildMockComment("Emily D.", "This is so helpful! I've been struggling with the same thing.", "1h ago"),
                _buildMockComment("Jessica L.", "Have you consulted a specialist? Sometimes magnesium deficiency plays a role too.", "45m ago"),
              ],
            ),
          ),

          // TOP NAV
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IrmaNavigationBar(
              title: "Thread",
              showBackButton: true,
            ),
          ),

          // COMMENT INPUT
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCommentInput(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: IrmaTheme.borderLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(IrmaTheme.radiusCardSmall),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: IrmaTheme.textMain),
          if (value.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(value, style: IrmaTheme.inter.copyWith(fontWeight: FontWeight.bold)),
          ],
        ],
      ),
    );
  }

  Widget _buildMockComment(String name, String text, String time) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(color: IrmaTheme.ovulation, shape: BoxShape.circle),
            child: Center(child: Text(name[0], style: const TextStyle(color: Colors.white))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: IrmaTheme.outfit.copyWith(fontWeight: FontWeight.bold)),
                    Text(time, style: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(text, style: IrmaTheme.inter.copyWith(color: IrmaTheme.textMain, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      decoration: BoxDecoration(
        color: IrmaTheme.pureWhite,
        boxShadow: [
          BoxShadow(
            color: IrmaTheme.pureBlack.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: IrmaTheme.borderLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(IrmaTheme.radiusAction),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Add a comment...",
                  hintStyle: IrmaTheme.inter.copyWith(color: IrmaTheme.textSub),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Iconsax.send_1, color: IrmaTheme.follicular, size: 28),
        ],
      ),
    );
  }
}
