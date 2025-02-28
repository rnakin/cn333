import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatConnection>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () => chatProvider.switchUser(),
            tooltip: 'Switch User',
          ),
        ],
      ),

      // The main part
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatConnection>(
              builder: (context, chat, child) {
                return ListView.builder(
                  itemCount: chat.messages.length,
                  itemBuilder: (context, index) {
                    final msg = chat.messages[index];
                    final isMe = msg.user.id == chat.currentUser.id;

                    return Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: isMe ? EdgeInsets.symmetric(vertical: 2, horizontal: 24) : EdgeInsets.symmetric(vertical: 2, horizontal: 56),
                          child: Text(
                            msg.user.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: isMe ? EdgeInsets.symmetric(vertical: 4, horizontal: 24) : EdgeInsets.symmetric(vertical: 4, horizontal: 56),
                            padding: EdgeInsets.all(10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.6, 
                            ),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blueAccent : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              msg.text,
                              style: TextStyle(color: isMe ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),


          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    chatProvider.sendMessage(_controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}