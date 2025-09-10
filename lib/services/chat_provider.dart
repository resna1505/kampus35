import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  Stream<List<Map<String, dynamic>>> getChats(String userId) {
    // Return empty stream untuk sementara
    return Stream.value([]);
  }

  Stream<List<Map<String, dynamic>>> searchUsers(String query) {
    // Return empty stream
    return Stream.value([]);
  }

  Future<void> sendMessage(
    String chatId,
    String message,
    String receiverId,
  ) async {
    // Dummy send message - tidak melakukan apa-apa
    print('Dummy: Sending message: $message');
  }

  Future<String?> getChatRoom(String receiverId) async {
    // Return dummy chat room ID
    return "dummy_chat_room_id";
  }

  Future<String> createChatRoom(String receiverId) async {
    // Return dummy chat room ID
    return "dummy_chat_room_id";
  }
}
