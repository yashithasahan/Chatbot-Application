import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model.dart';

class ChatPage extends StatefulWidget {
  final String character;

  const ChatPage({
    super.key,
    required this.character,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  late final OpenAI _openAI;
  late bool _isLoading;

  final TextEditingController _textController = TextEditingController();
  late List<ChatMessage> _messages;

  @override
  void initState() {
    _messages = [];
    _isLoading = false;

    _openAI = OpenAI.instance.build(
        token: "",
        baseOption: HttpSetup(
          receiveTimeout: const Duration(seconds: 30),
        ));

    _handleInitialMessage(
      'You are a ${widget.character.toLowerCase()}.Please send a super short intro message. Your organization is exploring emerging markets in fintech. It does research and development in marketing, finance, etc., while this app called DgMentor was developed by Emerging Market Fintech PTE LTD, and you are working as a part of the DgMentor team based on your role as manager, salesperson, developer, or customer care. the next info for the answering the further question you recived plese DOT in clude them in the your intoduction.It is an educational platform that can be used by any company to train its employees (something like Moodle; please do not mention it). It is built with Flutter and can be used on Android as well as the web. Use this additional information to answer the further question you received.',
    );

    super.initState();
  }

  Future<void> _handleInitialMessage(String character) async {
    setState(() {
      _isLoading = true;
    });

    final request = ChatCompleteText(
        model: kChatGptTurbo0301Model,
        messages: [
          Map.of({"role": "assistant", "content": character})
        ],
        maxToken: 200);

    final response = await _openAI.onChatCompletion(request: request);

    ChatMessage message = ChatMessage(
        text:
            response!.choices.first.message.content.trim().replaceAll('"', ''),
        isSentByMe: false,
        timestamp: DateTime.now());

    setState(() {
      _messages.insert(0, message);
      _isLoading = false;
    });
  }

  Future<void> _handleSubmit(String text) async {
    setState(() {
      _isLoading = true;
    });
    _textController.clear();

    // Add the user sent message to the thread
    ChatMessage prompt = ChatMessage(
      text: text,
      isSentByMe: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.insert(0, prompt);
    });

    // Handle ChatGPT request and response
    final request = ChatCompleteText(
      messages: [
        Map.of({"role": "user", "content": text})
      ],
      maxToken: 200,
      model: kChatGptTurbo0301Model,
    );
    final response = await _openAI.onChatCompletion(request: request);

    // Add the user received message to the thread
    ChatMessage message = ChatMessage(
      text: response!.choices.first.message.content.trim(),
      isSentByMe: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.insert(0, message);
      _isLoading = false;
    });
    // Handle prompt submission here
  }

  Widget _buildChatList() {
    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        reverse: true,
        itemCount: _messages.length,
        itemBuilder: (_, int index) {
          ChatMessage message = _messages[index];
          return _buildChatBubble(message);
        },
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    final isSentByMe = message.isSentByMe;
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Container(
              margin: isSentByMe
                  ? const EdgeInsets.only(left: 100)
                  : const EdgeInsets.only(right: 100),
              decoration: BoxDecoration(
                color: isSentByMe ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12.0),
                  topRight: const Radius.circular(12.0),
                  bottomLeft: isSentByMe
                      ? const Radius.circular(12.0)
                      : const Radius.circular(0.0),
                  bottomRight: isSentByMe
                      ? const Radius.circular(0.0)
                      : const Radius.circular(12.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSentByMe
                        ? 'You'
                        : '@DgMentor_${widget.character.toString().replaceAll(' ', '')}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSentByMe ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isSentByMe ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${dateFormat.format(message.timestamp)} at ${timeFormat.format(message.timestamp)}',
                    style: TextStyle(
                      color: isSentByMe ? Colors.white : Colors.black87,
                      fontSize: 8,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration.collapsed(
                hintText: 'Ask me anything',
                enabled: !_isLoading,
              ),
              // Add this to handle submission when user presses done
              onSubmitted: _isLoading ? null : _handleSubmit,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            // Add this to handle submission when user presses the send icon
            onPressed:
                _isLoading ? null : () => _handleSubmit(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
          ),
        ),
        title: const Text(
          'DgMentor Assist',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Stack(
          children: [
            Column(
              children: [
                _buildChatList(),
                const Divider(height: 1.0),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                  child: _buildChatComposer(),
                ),
              ],
            ),
            if (_isLoading)
              Center(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: const CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
