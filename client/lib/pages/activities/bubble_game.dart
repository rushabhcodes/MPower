import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:client/utils/colors.dart';
import 'package:client/utils/widgets/widget_support.dart';

class BubbleGamePage extends StatefulWidget {
  const BubbleGamePage({super.key});

  @override
  State<BubbleGamePage> createState() => _BubbleGamePageState();
}

class _BubbleGamePageState extends State<BubbleGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: deepPurple,
        scrolledUnderElevation: 0.0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.17,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://img.freepik.com/free-vector/skull-gaming-with-joy-stick-emblem-modern-style_32991-492.jpg?size=626&ext=jpg"),
                    radius: MediaQuery.of(context).size.height * 0.055,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Bubble Game",
                          style: AppWidget.boldTextStyle().copyWith(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.028,
                              color: Colors.white)),

                      // IconButton(onPressed: () {
                      //   sendMessageNotification("Please Recieve the call", name);
                      //   final senderId = auth.currentUser!.uid;
                      //   List<String> userIds = [senderId, widget.recieverId];
                      //   userIds.sort();
                      //   String videoCallId = userIds.join("_");
                      //   Navigator.push(context, MaterialPageRoute(
                      //       builder: (context) =>CallPage(callID: videoCallId)));
                      // }, icon: Icon(Icons.call, color: Colors.white60, size: 30,))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        leading: Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new, size: 30),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.image_search,
                  size: 35,
                  color: Colors.white60,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 6,
            children: <Widget>[
              for (int i = 0; i < 60; i++) BubbleWidget(),
            ],
          ))
        ],
      ),
    );
  }
}

class BubbleWidget extends StatefulWidget {
  const BubbleWidget({
    super.key,
  });

  @override
  State<BubbleWidget> createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget> {
  final player = AudioPlayer();
  bool popped = false;

  Future<void> playSound() async {
    try {
      await player.play(AssetSource(
        "assets/images/bubble-sound-43207.mp3)",
      ));
    } catch (e) {
      print("Error playing sound: $e");
      print("Error playing sound: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        popped = true;
        print(popped);
        HapticFeedback.vibrate();

        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: popped
                    ? AssetImage("assets/images/pop-the-bubble-md.png")
                    : AssetImage("assets/images/bubble.png")
                // image:
                )),
      ),
    );
  }
}
