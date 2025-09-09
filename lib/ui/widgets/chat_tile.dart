import 'package:flutter/material.dart';
import 'package:kampus/shared/theme.dart';
import 'package:kampus/ui/widgets/chat_screen.dart';

class ChatTile extends StatelessWidget {
  final String chatId;
  final String lastMessage;
  final DateTime timestamp;
  final Map<String, dynamic> receiverData;

  const ChatTile(
      {super.key,
      required this.chatId,
      required this.lastMessage,
      required this.timestamp,
      required this.receiverData});

  @override
  Widget build(BuildContext context) {
    String _formatTimestamp(DateTime timestamp) {
      final now = DateTime.now();
      final nowDate = DateTime(now.year, now.month, now.day);
      final timestampDate =
          DateTime(timestamp.year, timestamp.month, timestamp.day);

      final differenceInDays = nowDate.difference(timestampDate).inDays;

      if (differenceInDays == 1) {
        return "Yesterday";
      } else if (differenceInDays > 1) {
        return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
      } else {
        return "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";
      }
    }

    return lastMessage != ""
        ? Container(
            color: whiteColor,
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(receiverData['imageUrl']),
              ),
              title: Text(receiverData['name']),
              subtitle: Text(lastMessage, maxLines: 2),
              // trailing: Text(
              //   '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
              //   style: greyDarkTextStyle.copyWith(fontSize: 12),
              // ),
              trailing: Text(
                _formatTimestamp(timestamp), // Fungsi untuk format timestamp
                style: greyDarkTextStyle.copyWith(fontSize: 12),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      chatId: chatId,
                      receiverId: receiverData['uid'],
                    ),
                  ),
                );
              },
            ),
          )
        : Container();
  }
}
