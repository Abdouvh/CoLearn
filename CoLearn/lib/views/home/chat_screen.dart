import 'package:colearn/consts/consts.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String groupName;
  const ChatScreen({super.key, required this.groupName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();

  // Fake Messages List
  final List<Map<String, dynamic>> messages = [
    {"text": "Bonjour tout le monde !", "isMe": false, "sender": "Alice"},
    {"text": "Quelqu'un a fini le module 3 ?", "isMe": false, "sender": "Bob"},
    {"text": "Oui, c'était facile.", "isMe": true, "sender": "Moi"},
  ];

  void sendMessage() {
    if (_msgController.text.isNotEmpty) {
      setState(() {
        messages.add({
          "text": _msgController.text,
          "isMe": true,
          "sender": "Moi"
        });
      });
      _msgController.clear();

      // Simulate auto-reply after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            messages.add({
              "text": "Merci pour l'info !",
              "isMe": false,
              "sender": "Alice"
            });
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.groupName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // Chat List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg['isMe'] ? lightBlue : Colors.grey[800],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: msg['isMe'] ? const Radius.circular(12) : const Radius.circular(0),
                        bottomRight: msg['isMe'] ? const Radius.circular(0) : const Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!msg['isMe'])
                          Text(msg['sender'], style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                        Text(msg['text'], style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Field
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey[900],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Écrivez un message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: lightBlue),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}