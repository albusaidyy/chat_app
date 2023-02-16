import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((message) {
      print(message);
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
      return;
    });
    fbm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ChatApp'),
          actions: [
            DropdownButton(
              underline: Container(),
              icon: const Icon(Icons.more_vert),
              iconEnabledColor: Theme.of(context).primaryIconTheme.color,
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Logout')
                    ],
                  ),
                ),
              ],
              onChanged: (itemIdetifier) {
                if (itemIdetifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          ],
        ),
        body: Column(
          children: const [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        )

        // floatingActionButton: FloatingActionButton(
        //   child: const Icon(Icons.add),
        //   onPressed: () {
        //     FirebaseFirestore.instance
        //         .collection('chats/Yprn3ZoHQ1TlJZEITZWF/messages')
        //         .add({'text': 'Added by Button'});
        //   },
        // ),
        );
  }
}
