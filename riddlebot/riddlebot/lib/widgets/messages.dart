import 'package:flutter/material.dart';
import 'package:riddlebot/models/chatmessage.dart';

class Messages extends StatelessWidget {
  final List<ChatMessage> messages;

  const Messages({super.key, required this.messages});

  

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding:
              const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          child: Align(
            alignment: (messages[index].messageType == "bot"
                ? Alignment.topLeft
                : Alignment.topRight),
            child: Container(
              width: messages[index].messageType == "bot"
                  ? MediaQuery.of(context).size.width * 0.6
                  : MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (messages[index].messageType == "bot"
                    ? Colors.grey.shade200
                    : Colors.blue[200]),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                messages[index].messageContent,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        );
      },
    );
  }
}
