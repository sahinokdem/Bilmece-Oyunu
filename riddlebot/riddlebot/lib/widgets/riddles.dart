import 'package:flutter/material.dart';

import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

import 'startpage.dart';

import 'messages.dart';
import '/models/chatmessage.dart';
import 'result.dart';

class Riddles extends StatefulWidget {
  const Riddles({super.key});

  @override
  State<Riddles> createState() => _RiddlesState();
}

class _RiddlesState extends State<Riddles> {
  final _ansController = TextEditingController();
  int _score = 0;

  int attempt = 3;
  final List<ChatMessage> _messages = [];
  final List<String> _usermessages = [];
  final List<Map> _pairList = [];
  int index = 1;
  int charIndex = 0;
  int contNum = 1;

  void _askRiddle() async {
    String tempanswer = "";
    int b;
    final response =
        await http.get(Uri.parse("https://www.guvenlicocuk.org.tr/bilmece"));
    var document = parse(response.body);

    for (int a = 0; a < document.getElementsByTagName("summary").length; a++) {
      if (a == 0 ||
          a == 2 ||
          a == 3 ||
          a == 5 ||
          a == 10 ||
          a == 12 ||
          a == 18 ||
          a == 19 ||
          a == 21 ||
          a == 25 ||
          a == 26 ||
          a == 27 ||
          a == 29 ||
          a == 30 ||
          a == 35 ||
          a == 36 ||
          a == 38 ||
          a == 41 ||
          a == 42 ||
          a == 43 ||
          a == 46 ||
          a == 52) {
        continue;
      }
      tempanswer = document.getElementsByClassName("bilmece")[a].text;
      b = tempanswer.indexOf(".");
      if (b < 0) {
        b = tempanswer.indexOf("?");
      }

      _pairList.add({
        "riddle": document.getElementsByTagName("summary")[a].text.trim(),
        "answer": tempanswer.substring(b + 1).toString().trim().toLowerCase()
      });
    }

    _messages.add(ChatMessage(
        messageContent: _pairList[0]["riddle"], messageType: "bot"));

    setState(() {});
  }

  void _getRiddle() {
    if (index < _pairList.length) {
      attempt = 3;
      setState(() {
        _messages.add(ChatMessage(
            messageContent: _pairList[index]["riddle"], messageType: "bot"));
      });
    } else {
      setState(() {});
    }
    index++;
    charIndex = 0;
    contNum = 1;
  }

  void _submitAnswer() {
    if (_ansController.text.isEmpty) {
      return;
    }
    setState(() {
      final userMessage = ChatMessage(
        messageContent: _ansController.text,
        messageType: "user",
      );
      _messages.add(userMessage);
      _usermessages.add(userMessage.messageContent);
      _correctAnswer();
    });

    _ansController.clear();
    Navigator.of(context).pop();
  }

  void _correctAnswer() {
    String answer = _pairList[index - 1]["answer"];

    if (attempt > 0 && answer == _usermessages.last.trim().toLowerCase()) {
      _score++;
      _messages.insert(
          _messages.length,
          ChatMessage(
              messageContent: "Tebrikler! Doğru Cevap. Skorun $_score",
              messageType: "bot"));
      attempt = 0;
    } else if (attempt > 1) {
      attempt--;
      _messages.insert(
          _messages.length,
          ChatMessage(
              messageContent: "Yanlış cevap $attempt hakkın kaldı",
              messageType: "bot"));
    } else if (index > _pairList.length - 1) {
      attempt--;
      _messages.insert(
          _messages.length,
          ChatMessage(
              messageContent:
                  "Maalesef başka hakkın kalmadı. Doğru cevap $answer. Bugünlük bu kadar bilmece yeter.",
              messageType: "bot"));
      print(index);
      print(_pairList.length);
    } else {
      attempt--;
      _messages.insert(
          _messages.length,
          ChatMessage(
              messageContent:
                  "Maalesef başka hakkın kalmadı. Doğru cevap $answer. Bilmecelere devam edebilirsin",
              messageType: "bot"));
    }
  }

  void _enterAnswer(BuildContext ctx) {
    if (attempt > 0) {
      setState(() {
        showModalBottomSheet(
          context: ctx,
          builder: (_) {
            return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Card(
                elevation: 5,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextField(
                        decoration: const InputDecoration(labelText: "Cevap"),
                        controller: _ansController,
                        onSubmitted: (_) => _submitAnswer(),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      });
    }
  }

  void _askHint() {
    setState(() {
      if (attempt > 0 && contNum > 0) {
        String answer = _pairList[index - 1]["answer"].toString().toUpperCase();
        if (charIndex >= answer.length) {
          _messages.insert(
              _messages.length,
              ChatMessage(
                  messageContent: "Şşş cevabı bilmen gerek artık sanırım...",
                  messageType: "bot"));
          contNum = 0;
        } else {
          var char = answer[charIndex];
          int charOrder = charIndex + 1;
          _messages.insert(
              _messages.length,
              ChatMessage(
                  messageContent: "$charOrder. harfimiz $char",
                  messageType: "bot"));

          charIndex++;
        }
      }
    });
  }

  void _openStartPage() {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const StartPage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _askRiddle();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
        child: index <= _pairList.length
            ? Container(
                color: Colors.pinkAccent,
                height: 500,
                child: Stack(children: <Widget>[
                  SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Messages(messages: _messages),
                      ElevatedButton(
                        onPressed: () => _getRiddle(),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: index < _pairList.length
                            ? const Text("Yeni Bilmece")
                            : const Text("        Bitir        "),
                      ),
                      ElevatedButton(
                        onPressed: () => _enterAnswer(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: const Text("    Cevapla     "),
                      ),
                      ElevatedButton(
                        onPressed: () => _askHint(),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orange,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: const Text("      İpucu       "),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                          onPressed: () {
                            _openStartPage();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  )),
                ]))
            : _messages.isNotEmpty
                ? Result(
                    score: _score,
                    restartApp: _openStartPage,
                  )
                : const SizedBox());
  }
}
