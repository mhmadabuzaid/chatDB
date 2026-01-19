import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final String _roomId = 'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';

  @override
  Widget build(BuildContext context) {
    final messagesAsyncValue = ref.watch(messagesProvider);
    final myUserId = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      // WhatsApp Background Color (Light Grey/Beige)
      backgroundColor: const Color(0xFFECE5DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54), // WhatsApp Dark Green
        title: const Text('Group Chat', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Supabase.instance.client.auth.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsyncValue.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(child: Text('No messages yet!'));
                }
                // Reverse the list so the newest message (last in list)
                // is at index 0 for the reversed ListView
                final reversedMessages = messages.reversed.toList();

                return ListView.builder(
                  reverse: true, // Start from the bottom
                  itemCount: reversedMessages.length,
                  itemBuilder: (context, index) {
                    final message = reversedMessages[index];
                    final isMe = message['sender_id'] == myUserId;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        decoration: BoxDecoration(
                          // WhatsApp Message Colors
                          color: isMe ? const Color(0xFFDCF8C6) : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isMe
                                ? const Radius.circular(12)
                                : Radius.zero,
                            bottomRight: isMe
                                ? Radius.zero
                                : const Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        child: Text(
                          message['content'] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                );
              },
              error: (err, stack) => Center(child: Text('Error: $err')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF075E54),
                  radius: 24,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: () async {
                      final text = _messageController.text.trim();
                      if (text.isEmpty) return;

                      try {
                        await Supabase.instance.client.from('messages').insert({
                          'content': text,
                          'room_id': _roomId,
                          'sender_id': myUserId,
                        });
                        _messageController.clear();
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
