import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ritmo_fit/providers/forum_provider.dart';
import 'package:ritmo_fit/providers/profile_provider.dart';
import 'package:ritmo_fit/models/forum_model.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _loadPosts();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  void _loadPosts() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final forumProvider = Provider.of<ForumProvider>(context, listen: false);
      forumProvider.loadPosts();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _postController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Consumer<ForumProvider>(
                  builder: (context, forumProvider, child) {
                    if (forumProvider.isLoading) {
                      return _buildLoadingState();
                    }

                    if (forumProvider.posts.isEmpty) {
                      return _buildEmptyState();
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await forumProvider.loadPosts();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: forumProvider.posts.length,
                        itemBuilder: (context, index) {
                          final post = forumProvider.posts[index];
                          return _buildPostCard(post, forumProvider);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildCreatePostFAB(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF805AD5),
            Color(0xFF9F7AEA),
            Color(0xFFD53F8C),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.forum_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Foro Comunitario',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Comparte tu experiencia fitness',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF805AD5)),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando publicaciones...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF805AD5).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.forum_outlined,
                size: 60,
                color: Color(0xFF805AD5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '¡Sé el primero en publicar!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Comparte tus logros, consejos y experiencias\ncon la comunidad RitmoFit',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: const Color(0xFF718096),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _showCreatePostDialog,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Crear Publicación',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF805AD5),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(ForumPost post, ForumProvider forumProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostHeader(post),
          _buildPostContent(post),
          _buildPostActions(post, forumProvider),
          if (post.comments.isNotEmpty) _buildComments(post, forumProvider),
        ],
      ),
    );
  }

  Widget _buildPostHeader(ForumPost post) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF805AD5),
            child: Text(
              post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : 'A',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.authorName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(post.createdAt),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF718096)),
            onPressed: () {
              // Opciones del post
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(ForumPost post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Text(
        post.content,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: const Color(0xFF2D3748),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildPostActions(ForumPost post, ForumProvider forumProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          _buildActionButton(
            icon: post.likes.contains('current_user') 
                ? Icons.favorite 
                : Icons.favorite_border,
            label: '${post.likes.length}',
            color: post.likes.contains('current_user') 
                ? Colors.red 
                : const Color(0xFF718096),
            onTap: () {
              // forumProvider.toggleLike(post.id);
            },
          ),
          const SizedBox(width: 24),
          _buildActionButton(
            icon: Icons.comment_outlined,
            label: '${post.comments.length}',
            color: const Color(0xFF718096),
            onTap: () {
              _showCommentsDialog(post, forumProvider);
            },
          ),
          const Spacer(),
          _buildActionButton(
            icon: Icons.share_outlined,
            label: 'Compartir',
            color: const Color(0xFF718096),
            onTap: () {
              // Compartir post
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComments(ForumPost post, ForumProvider forumProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comentarios',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          ...post.comments.take(2).map((comment) => _buildCommentItem(comment)),
          if (post.comments.length > 2)
            TextButton(
              onPressed: () {
                _showCommentsDialog(post, forumProvider);
              },
              child: Text(
                'Ver los ${post.comments.length - 2} comentarios restantes',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF805AD5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF805AD5).withOpacity(0.1),
            child: Text(
              comment.authorName.isNotEmpty ? comment.authorName[0].toUpperCase() : 'A',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF805AD5),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: comment.authorName,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      TextSpan(
                        text: ' ${comment.content}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(comment.createdAt),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreatePostFAB() {
    return FloatingActionButton.extended(
      onPressed: _showCreatePostDialog,
      backgroundColor: const Color(0xFF805AD5),
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add),
      label: const Text(
        'Publicar',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Nueva Publicación',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: _postController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: '¿Qué quieres compartir con la comunidad?',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _createPost();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF805AD5),
              foregroundColor: Colors.white,
            ),
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }

  void _showCommentsDialog(ForumPost post, ForumProvider forumProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Comentarios',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                itemCount: post.comments.length,
                itemBuilder: (context, index) {
                  return _buildCommentItem(post.comments[index]);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un comentario...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
                      _addComment(post);
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xFF805AD5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createPost() {
    final forumProvider = Provider.of<ForumProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    
    if (_postController.text.trim().isNotEmpty) {
      forumProvider.createPost(
        content: _postController.text.trim(),
        authorName: profileProvider.selectedProfile?.name ?? 'Usuario Anónimo',
      );
      _postController.clear();
    }
  }

  void _addComment(ForumPost post) {
    final forumProvider = Provider.of<ForumProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    
    if (_commentController.text.trim().isNotEmpty) {
      forumProvider.addComment(
        postId: post.id,
        content: _commentController.text.trim(),
        authorName: profileProvider.selectedProfile?.name ?? 'Usuario Anónimo',
      );
      _commentController.clear();
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Ahora';
    }
  }
} 