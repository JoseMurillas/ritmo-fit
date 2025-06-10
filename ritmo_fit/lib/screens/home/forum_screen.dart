import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ritmo_fit/models/forum_model.dart';
import 'package:ritmo_fit/models/user_model.dart';
import 'package:ritmo_fit/providers/forum_provider.dart';
import 'package:ritmo_fit/services/database_service.dart';
import 'package:ritmo_fit/services/auth_service.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _replyController = TextEditingController();
  String? _selectedMessageId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ForumProvider>().loadMessages();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _showAddMessageDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Mensaje'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Contenido'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty &&
                  _contentController.text.isNotEmpty) {
                final userId = AuthService().currentUser?.id;
                if (userId != null) {
                  await context.read<ForumProvider>().addMessage(
                        userId: userId,
                        title: _titleController.text,
                        content: _contentController.text,
                      );
                  _titleController.clear();
                  _contentController.clear();
                  if (mounted) Navigator.pop(context);
                }
              }
            },
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showReplyDialog(String messageId) async {
    _selectedMessageId = messageId;
    _replyController.clear();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Responder'),
        content: TextField(
          controller: _replyController,
          decoration: const InputDecoration(labelText: 'Tu respuesta'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (_replyController.text.isNotEmpty) {
                final userId = AuthService().currentUser?.id;
                if (userId != null && _selectedMessageId != null) {
                  await context.read<ForumProvider>().addReply(
                        messageId: _selectedMessageId!,
                        userId: userId,
                        content: _replyController.text,
                      );
                  _replyController.clear();
                  if (mounted) Navigator.pop(context);
                }
              }
            },
            child: const Text('Responder'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddMessageDialog,
          ),
        ],
      ),
      body: Consumer<ForumProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          if (provider.messages.isEmpty) {
            return const Center(child: Text('No hay mensajes aún'));
          }

          return ListView.builder(
            itemCount: provider.messages.length,
            itemBuilder: (context, index) {
              final message = provider.messages[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.title,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                FutureBuilder<User?>(
                                  future: DatabaseService().getUser(message.userId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Text('Cargando...');
                                    }
                                    final userName = snapshot.data?.name ?? 'Usuario';
                                    return Text(
                                      'Por $userName - ${message.createdAt.toString().substring(0, 16)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (message.userId == AuthService().currentUser?.id)
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => provider.deleteMessage(message.id),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(message.content),
                      if (message.replies.isNotEmpty) ...[
                        const Divider(),
                        const Text('Respuestas:'),
                        ...message.replies.map((reply) {
                          return FutureBuilder<User?>(
                            future: DatabaseService().getUser(reply.userId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text('Cargando...');
                              }
                              final userName = snapshot.data?.name ?? 'Usuario';
                              return ListTile(
                                title: Text(reply.content),
                                subtitle: Text(
                                  'Por $userName - ${reply.createdAt.toString().substring(0, 16)}',
                                ),
                              );
                            },
                          );
                        }),
                      ],
                      TextButton(
                        onPressed: () => _showReplyDialog(message.id),
                        child: const Text('Responder'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 