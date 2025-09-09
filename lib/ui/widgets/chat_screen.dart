import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kampus/services/chat_provider.dart';
import 'package:kampus/shared/theme.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String? chatId;
  final String? receiverId;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  User? loggedInUser;
  String? chatId;

  @override
  void initState() {
    super.initState();
    chatId = widget.chatId;
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final TextEditingController _textController = TextEditingController();

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(widget.receiverId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final receiverData = snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
            backgroundColor: const Color(0xFFEEEEEE),
            appBar: AppBar(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(receiverData['imageUrl']),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    receiverData['name'],
                    style: blackTextStyle.copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: chatId != null && chatId!.isNotEmpty
                      ? MessagesStream(chatId: chatId!)
                      : const Center(
                          child: Text('No Message'),
                        ),
                ),
                Container(
                  color: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            hintText: "Enter your message...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (_textController.text.isNotEmpty) {
                            if (chatId == null || chatId!.isEmpty) {
                              chatId = await chatProvider
                                  .createChatRoom(widget.receiverId!);
                            }
                            if (chatId != null) {
                              chatProvider.sendMessage(chatId!,
                                  _textController.text, widget.receiverId!);
                              _textController.clear();
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Color(0xFF3876FD),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class MessagesStream extends StatelessWidget {
  final String chatId;

  const MessagesStream({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    String _formatTimestamp(DateTime timestamp) {
      final now = DateTime.now();
      final nowDate = DateTime(now.year, now.month, now.day);
      final timestampDate =
          DateTime(timestamp.year, timestamp.month, timestamp.day);

      final differenceInDays = nowDate.difference(timestampDate).inDays;

      if (differenceInDays == 0) {
        return "Today";
      } else if (differenceInDays == 1) {
        return "Yesterday";
      } else {
        return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
      }
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final messages = snapshot.data!.docs;
        Map<String, List<MessageBubble>> groupedMessages = {};

        for (var message in messages) {
          final messageData = message.data() as Map<String, dynamic>;
          final messageText = messageData['messageBody'];
          final messageSender = messageData['senderId'];
          final timestampRaw = messageData['timestamp'];
          final timestamp = timestampRaw is Timestamp
              ? timestampRaw.toDate()
              : DateTime.now();

          final formattedDate = _formatTimestamp(timestamp);
          final formattedTime =
              "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";

          final currentUser = FirebaseAuth.instance.currentUser!.uid;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
            formattedTime: formattedTime,
          );

          if (groupedMessages.containsKey(formattedDate)) {
            groupedMessages[formattedDate]!.add(messageBubble);
          } else {
            groupedMessages[formattedDate] = [messageBubble];
          }
        }

        List<Widget> messageWidgets = [];
        groupedMessages.forEach((date, bubbles) {
          messageWidgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
          messageWidgets.addAll(bubbles);
        });

        return ListView(
          reverse: true,
          children: messageWidgets,
        );
      },
    );
  }
}

// class MessagesStream extends StatefulWidget {
//   final String chatId;

//   const MessagesStream({super.key, required this.chatId});

//   @override
//   _MessagesStreamState createState() => _MessagesStreamState();
// }

// class _MessagesStreamState extends State<MessagesStream> {
//   late ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     String _formatTimestamp(DateTime timestamp) {
//       final now = DateTime.now();
//       final nowDate = DateTime(now.year, now.month, now.day);
//       final timestampDate =
//           DateTime(timestamp.year, timestamp.month, timestamp.day);

//       final differenceInDays = nowDate.difference(timestampDate).inDays;

//       if (differenceInDays == 0) {
//         return "Today";
//       } else if (differenceInDays == 1) {
//         return "Yesterday";
//       } else {
//         return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
//       }
//     }

//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('chats')
//           .doc(widget.chatId)
//           .collection('messages')
//           .orderBy('timestamp',
//               descending: false)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         final messages = snapshot.data!.docs;

//         List<Widget> messageWidgets = [];
//         String? lastDateLabel;

//         for (var message in messages) {
//           final messageData = message.data() as Map<String, dynamic>;
//           final messageText = messageData['messageBody'];
//           final messageSender = messageData['senderId'];
//           final timestampRaw = messageData['timestamp'];
//           final timestamp = timestampRaw is Timestamp
//               ? timestampRaw.toDate()
//               : DateTime.now();

//           final formattedDate = _formatTimestamp(timestamp);
//           final formattedTime =
//               "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";

//           final currentUser = FirebaseAuth.instance.currentUser!.uid;

//           if (formattedDate != lastDateLabel) {
//             lastDateLabel = formattedDate;
//             messageWidgets.add(
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Center(
//                   child: Text(
//                     formattedDate,
//                     style: const TextStyle(
//                       color: Colors.grey,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }

//           messageWidgets.add(
//             MessageBubble(
//               sender: messageSender,
//               text: messageText,
//               isMe: currentUser == messageSender,
//               formattedTime: formattedTime,
//             ),
//           );
//         }

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (_scrollController.hasClients) {
//             _scrollController.animateTo(
//                 _scrollController.position.maxScrollExtent,
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeOut);
//           }
//         });

//         return ListView(
//           controller: _scrollController,
//           reverse: false,
//           children: messageWidgets,
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final String formattedTime;

  const MessageBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.isMe,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
              color: isMe ? const Color(0xFF3876FD) : Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black54,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
