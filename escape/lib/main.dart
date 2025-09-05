import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui'; // Import dart:ui to access ImageFilter

void main() {
  runApp(EscapeRoomApp());
}

class EscapeRoomApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Builder(
        builder: (context) {
          return StartGamePage();
        },
      ),
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            Positioned(
              top: 20.0,
              right: 20.0,
              child: TimerOverlay(
                  600, navigatorKey), // Replace with your actual timer value
            ),
          ],
        );
      },
    );
  }
}

class TimerOverlay extends StatefulWidget {
  final int durationInSeconds;
  final GlobalKey<NavigatorState> navigatorKey;

  TimerOverlay(this.durationInSeconds, this.navigatorKey);

  @override
  _TimerOverlayState createState() => _TimerOverlayState();
}

class _TimerOverlayState extends State<TimerOverlay> {
  late int _currentSeconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentSeconds = widget.durationInSeconds;
    _startTimer();
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_currentSeconds == 0) {
            timer.cancel();
            widget.navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => TimeUpPage(),
              ),
            );
          } else {
            _currentSeconds = _currentSeconds - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = (_currentSeconds / 60).floor();
    int seconds = _currentSeconds % 60;
    String timeLeft = '$minutes:${seconds.toString().padLeft(2, '0')}';

    return Container(
      width: 150,
      height: 50,
      padding: EdgeInsets.all(4.0),
      // Adjust the padding as desired
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius:
            BorderRadius.circular(5.0), // Adjust the border radius as desired
      ),
      child: Text(
        'Time Left: $timeLeft',
        style: TextStyle(
            color: Colors.white, fontSize: 20, decoration: TextDecoration.none),
      ),
    );
  }
}

class TimeUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Time\'s Up!'),
      ),
      body: Center(
        child: Text(
          'You couldn\'t escape. Try again next time!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class StartGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 84, 90, 85),
        title: Text('Escape Room'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 84, 90, 85),
              ),
              child: Text(
                'Escape Room Game Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help'),
              onTap: () {
                _showHelpDialog(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://as2.ftcdn.net/v2/jpg/06/23/90/75/1000_F_623907558_3KizC8lm6uX2KOXlCDRpVHICXzNzeCDc.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  // Container for the text
                  padding: EdgeInsets.all(16), // Add padding
                  color: Color.fromARGB(
                      255, 161, 161, 161), // Brown background color
                  child: Text(
                    'Welcome to the escape room.. enter at your own risk',
                    style: TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.none,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RoomOne(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 78, 46, 26),
                  ),
                  child: Text(
                    'Start the Escape',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Basic Rules of the Game'),
          content: Text(
              'Welcome to the Escape Room Game! To proceed, solve puzzles in each room. Enter the correct answer to unlock the next room. Enjoy the game!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class RoomOne extends StatefulWidget {
  @override
  _RoomOneState createState() => _RoomOneState();
}

class _RoomOneState extends State<RoomOne> {
  final String question = 'What has keys but can\'t open locks?';
  final String correctAnswer = 'piano';
  int wrongAnswerCount = 0;

  void _showHintDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hint'),
          content: Text('Think of musical instruments'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Got It!'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 20, 14),
        title: Text('Room 1'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://www.trbimg.com/img-5a9276b5/turbine/la-1519548078-1lnkhgv82o-snap-image'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                  // Container for the text
                  padding: EdgeInsets.all(16), // Add padding
                  color: const Color.fromARGB(
                      255, 37, 20, 14), // Brown background color
                  child: Text(
                    'You have entered Room 1, where you stand face to face with a coded door, that presents you with a riddle:',
                    style: TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.none,
                      color: Color.fromARGB(255, 232, 192, 165),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showQuestionDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 139, 63, 12),
                  ),
                  child: Text(
                    'Click here to answer the question and move to the Next Room',
                    style: TextStyle(decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 70,
            right: 16,
            child: wrongAnswerCount >= 2
                ? FloatingActionButton(
                    onPressed: () {
                      _showHintDialog(context);
                    },
                    child: Icon(Icons.help),
                    backgroundColor: Color.fromARGB(255, 139, 63, 12),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  void _showAdditionalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('The Letter: "F"'),
          content: Text(
              'You answered the question correctly, the door in turn gave this letter, what might it signify? '),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the additional dialog
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FindKeyPage(),
                  ),
                );
              },
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _showQuestionDialog(BuildContext context) {
    String userAnswer = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Answer the question'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(question),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  userAnswer = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (userAnswer.toLowerCase() == correctAnswer) {
                  Navigator.of(context).pop(); // Close the question dialog
                  _showAdditionalDialog(context); // Show the additional dialog
                } else {
                  wrongAnswerCount++;
                  Navigator.of(context).pop();
                  _showErrorDialog(context);
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incorrect Answer'),
          content: Text('Please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (wrongAnswerCount >= 2) {
                  _showHintDialog(context);
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

void _showHintDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Hint'),
        content: Text('Look near the windows'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Got It!'),
          ),
        ],
      );
    },
  );
}

class FindKeyPage extends StatefulWidget {
  @override
  _FindKeyPageState createState() => _FindKeyPageState();
}

class _FindKeyPageState extends State<FindKeyPage> {
  bool _keyFound = false;

  void _handleTap() {
    setState(() {
      _keyFound = true;
      print('Key Found');
    });

    if (_keyFound) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('The letter: "R"'),
            content: Text(
                'You\'ve discovered the key, and upon closer inspection, you notice something written on it.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => RoomThree(),
                    ),
                  );
                },
                child: Text('Continue'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 139, 63, 12),
        title: Text('Room 2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://i2-prod.mirror.co.uk/incoming/article10586342.ece/ALTERNATES/s1227b/PAY-Haunted-Manor.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top:
                        170, // Adjust this value to position the key icon vertically
                    left:
                        190, // Adjust this value to position the key icon horizontally
                    child: GestureDetector(
                      onTap: _handleTap,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.vpn_key,
                          size: 18,
                          color: Color.fromARGB(255, 255, 253, 253),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Find the Key',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'calibri',
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 139, 63, 12),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showHintDialog(context);
        },
        child: Icon(Icons.help),
        backgroundColor: Color.fromARGB(255, 139, 63, 12),
      ),
    );
  }
}

// ... (rest of the code remains unchanged)

// Add the list of questions, answers, and images for rooms 3 to 5

class RoomThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Code for the maze game in Room 3
    return MazeGame();
  }
}

class MazeGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MazeScreen(),
    );
  }
}

class MazeIcon {
  final double x;
  final double y;
  bool collected = false;
  final String message;
  final CustomIconPainter iconPainter;

  MazeIcon(this.x, this.y, this.message, this.iconPainter);
}

abstract class CustomIconPainter {
  void paint(Canvas canvas, Offset offset, double size);
}

class CustomTriangleIconPainter extends CustomIconPainter {
  @override
  void paint(Canvas canvas, Offset offset, double size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(offset.dx + size / 2, offset.dy - size / 2)
      ..lineTo(offset.dx + size, offset.dy + size / 2)
      ..lineTo(offset.dx, offset.dy + size / 2)
      ..close();

    canvas.drawPath(path, paint);
  }
}

class CustomRectIconPainter extends CustomIconPainter {
  @override
  void paint(Canvas canvas, Offset offset, double size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawRect(offset & Size(size, size), paint);
  }
}

class CustomCircleIconPainter extends CustomIconPainter {
  @override
  void paint(Canvas canvas, Offset offset, double size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    canvas.drawCircle(offset, size / 2, paint);
  }
}

class MazeScreen extends StatefulWidget {
  @override
  _MazeScreenState createState() => _MazeScreenState();
}

class _MazeScreenState extends State<MazeScreen> {
  double playerX = 0.0;
  double playerY = 0.0;
  double playerSize = 20.0;
  bool showCongratsMessage = false;
  bool showIntroDialog = true;

  List<MazeIcon> icons = [
    MazeIcon(100, 100, "a couple of coins...is it enough for a coffee?",
        CustomCircleIconPainter()),
    MazeIcon(
        200,
        150,
        "JACKPOT! YOU HAVE WON!\n Along with a few trinkets and an exit that leads to outside, you found a letter, yet again.\n The letter: \"E\"",
        CustomRectIconPainter()),
    MazeIcon(50, 250, "a broken mirror", CustomTriangleIconPainter()),
    MazeIcon(150, 200, "a gum packet", CustomCircleIconPainter()),
    MazeIcon(220, 70, "*cough* *cough*...only dust", CustomRectIconPainter()),
    MazeIcon(250, 200, "a sock!", CustomTriangleIconPainter()),
  ];

  bool isObstacle(double x, double y) {
    // Define the obstacle areas
    List<Rect> obstacles = [
      Rect.fromPoints(Offset(50, 50), Offset(150, 100)),
      Rect.fromPoints(Offset(100, 150), Offset(200, 200)),
      Rect.fromPoints(Offset(250, 50), Offset(300, 100)),
      Rect.fromPoints(Offset(150, 250), Offset(200, 300)),
      Rect.fromPoints(Offset(50, 200), Offset(100, 250)),
      Rect.fromPoints(Offset(200, 100), Offset(250, 150)),
      Rect.fromPoints(Offset(100, 50), Offset(150, 100)),
      Rect.fromPoints(Offset(200, 250), Offset(250, 300)),
      Rect.fromPoints(Offset(50, 150), Offset(100, 200)),
      Rect.fromPoints(Offset(150, 50), Offset(200, 100)),
      Rect.fromPoints(Offset(200, 100), Offset(250, 150)),
      Rect.fromPoints(Offset(250, 50), Offset(300, 100)),
      Rect.fromPoints(Offset(250, 150), Offset(300, 200)),
      // Add more obstacle rectangles as needed
    ];
    for (var obstacle in obstacles) {
      if (obstacle.contains(Offset(x, y))) {
        return true;
      }
    }
    return false;
  }

  void navigateToAnotherScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Room4Screen()),
    );
  }

  void showCongratulatoryDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dialog from being closed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You have Discovered:'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (message ==
                    "JACKPOT! YOU HAVE WON!\n Along with a few trinkets and an exit that leads to outside, you found a letter, yet again.\n The letter: \"E\"") {
                  navigateToAnotherScreen(context);
                }
              },
              child: Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void checkIconCollision() {
    for (var icon in icons) {
      if (!icon.collected &&
          playerX >= icon.x &&
          playerX <= icon.x + playerSize &&
          playerY >= icon.y &&
          playerY <= icon.y + playerSize) {
        setState(() {
          icon.collected = true;

          if (icon.message == "YOU HAVE WON!") {
            showCongratulatoryDialog(context, icon.message);
          } else {
            showCongratulatoryDialog(context, icon.message);
          }
        });
      }
    }
  }

  void movePlayer(double dx, double dy) {
    setState(() {
      double newX = playerX + dx;
      double newY = playerY + dy;

      if (!isObstacle(newX, newY) &&
          newX >= 0 &&
          newX <= 300 - playerSize &&
          newY >= 0 &&
          newY <= 300 - playerSize) {
        playerX = newX;
        playerY = newY;
        checkIconCollision();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color.fromARGB(255, 102, 62, 62);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 69, 53, 53),
        title: Text(
          'Room 3',
          style: TextStyle(color: Color.fromARGB(255, 166, 141, 141)),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://pbs.twimg.com/media/FzC5C2KaQAAomqt.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: CustomPaint(
                size: Size(300, 300),
                painter: MazePainter(playerX, playerY, playerSize, icons),
              ),
            ),
          ),
          if (showIntroDialog)
            Center(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "You've delved into the labyrinth's depths, in search of hidden sacred relics.\nSeek the guiding light.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showIntroDialog = false;
                        });
                      },
                      child: Text('Continue'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 69, 53, 53),
        padding: EdgeInsets.only(bottom: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_circle_up_outlined,
                color: Color.fromARGB(255, 166, 141, 141),
              ),
              iconSize: 40,
              onPressed: () {
                movePlayer(0, -playerSize);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_circle_down_outlined,
                color: Color.fromARGB(255, 166, 141, 141),
              ),
              iconSize: 40,
              onPressed: () {
                movePlayer(0, playerSize);
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_circle_left_outlined,
                  color: Color.fromARGB(255, 166, 141, 141)),
              iconSize: 40,
              onPressed: () {
                movePlayer(-playerSize, 0);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.arrow_circle_right_outlined,
                color: Color.fromARGB(255, 166, 141, 141),
              ),
              iconSize: 40,
              onPressed: () {
                movePlayer(playerSize, 0);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MazePainter extends CustomPainter {
  final double playerX;
  final double playerY;
  final double playerSize;
  final List<MazeIcon> icons;

  MazePainter(this.playerX, this.playerY, this.playerSize, this.icons);

  @override
  void paint(Canvas canvas, Size size) {
    final mazePaint = Paint()
      ..color = Color.fromARGB(95, 79, 29, 29) // Set the color to transparent
      ..style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, mazePaint);

    // Add a black border to the maze boundary
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final borderRect = Offset.zero & size;
    canvas.drawRect(borderRect, borderPaint);

    final obstaclePaint = Paint()
      ..color = Color.fromARGB(255, 47, 34, 34)
      ..style = PaintingStyle.fill;
    final obstacles = [
      Rect.fromPoints(Offset(50, 50), Offset(150, 100)),
      Rect.fromPoints(Offset(100, 150), Offset(200, 200)),
      Rect.fromPoints(Offset(250, 50), Offset(300, 100)),
      Rect.fromPoints(Offset(150, 250), Offset(200, 300)),
      Rect.fromPoints(Offset(50, 200), Offset(100, 250)),
      Rect.fromPoints(Offset(200, 100), Offset(250, 150)),
      Rect.fromPoints(Offset(100, 50), Offset(150, 100)),
      Rect.fromPoints(Offset(200, 250), Offset(250, 300)),
      Rect.fromPoints(Offset(50, 150), Offset(100, 200)),
      Rect.fromPoints(Offset(150, 50), Offset(200, 100)),
      Rect.fromPoints(Offset(200, 100), Offset(250, 150)),
      Rect.fromPoints(Offset(250, 50), Offset(300, 100)),
      Rect.fromPoints(Offset(250, 150), Offset(300, 200)),
    ];

    for (var obstacle in obstacles) {
      canvas.drawRect(obstacle, obstaclePaint);
    }

    final playerPaint = Paint()
      ..color = Color.fromARGB(255, 243, 219,
          0) // Set the player color to yellow or any color you prefer
      ..style = PaintingStyle.fill // Change to fill to make it visible
      ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, 5); // Apply the glowing effect
    final playerRect = Rect.fromPoints(
      Offset(playerX, playerY),
      Offset(playerX + playerSize, playerY + playerSize),
    );
    canvas.drawOval(playerRect, playerPaint);

    for (var icon in icons) {
      if (!icon.collected) {
        final iconSize = 6.0;
        icon.iconPainter.paint(canvas, Offset(icon.x, icon.y), iconSize);
      }
    }
    for (var icon in icons) {
      if (!icon.collected) {
        final iconSize = 12.0;
        icon.iconPainter.paint(canvas, Offset(icon.x, icon.y), iconSize);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// Existing code for the maze game

class RoomFive extends StatelessWidget {
  final List<String> roomQuestions;
  final List<String> roomAnswers;
  final List<String> roomImages;

  RoomFive(
      {required this.roomQuestions,
      required this.roomAnswers,
      required this.roomImages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(roomImages[2]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Room 5',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Text(
                  'Answer the question to proceed.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showQuestionDialog(context, 2);
                  },
                  child: Text('Next Room'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showQuestionDialog(BuildContext context, int index) {
    String userAnswer = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Answer the question'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(roomQuestions[index]),
              SizedBox(height: 10),
              TextFormField(
                onChanged: (value) {
                  userAnswer = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                if (userAnswer.toLowerCase() == roomAnswers[index]) {
                  // Implement the final logic for the end of the game here
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EscapeRoomGame(),
                    ),
                  );
                } else {
                  Navigator.of(context).pop();
                  _showErrorDialog(context);
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incorrect Answer'),
          content: Text('Please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class EscapeRoomGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Escape Room Game',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StartGamePage(),
                ),
              );
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }
}

class Room4Screen extends StatefulWidget {
  @override
  _Room4ScreenState createState() => _Room4ScreenState();
}

class _Room4ScreenState extends State<Room4Screen> {
  double rotationAngle1 = 60.0;
  double lightBeamLength1 = 0.0;

  double rotationAngle2 = 45.0;
  double lightBeamLength2 = 0.0;

  double rotationAngle3 = 60.0;
  double lightBeamLength3 = 0.0;

  double rotationAngle4 = 60.0;
  double lightBeamLength4 = 0.0;

  bool allConditionsMet = false;
  double triangleSize = 50.0;
  double starSize = 23.0;
  bool showWelcomeDialog = true; // Control whether to show the welcome dialog

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      if (showWelcomeDialog) {
        _showWelcomeDialog();
      }
    });
  }

  // ... (other methods) ...

  void _showWelcomeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Welcome to Room 4!"),
          content: Text(
            "You have now entered a room where a puzzle that resembles a constellation lies, only when finished, will a pathway to the exit open up.\n"
            "Instructions:\n\n"
            "1. Align the triangles by rotating them to form the constellation.\n"
            "2. Once all triangles are correctly aligned, you will complete the constellation.\n"
            "3. Click the 'Finish' button when you're done.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Continue"),
            ),
          ],
        );
      },
    );
  }

  void _rotateLeft1() {
    setState(() {
      rotationAngle1 -= 60.0;
      final double screenHeight = MediaQuery.of(context).size.height;
      final double screenWidth = MediaQuery.of(context).size.width;

      // Check the rotation angle and set the light beam length accordingly for the first triangle
      if (rotationAngle1 == -60.0 || rotationAngle1 == -420.0) {
        lightBeamLength1 =
            0.3 * screenHeight; // Show the beam for the first triangle
      } else {
        lightBeamLength1 = 0.0; // Hide the beam for the first triangle
        // Reset the light beam length for the second triangle
        lightBeamLength2 = 0.0;
        lightBeamLength3 = 0.0;
      }
    });
  }

  void _resetRotation1() {
    setState(() {
      final double screenHeight = MediaQuery.of(context).size.height;
      final double screenWidth = MediaQuery.of(context).size.width;
      rotationAngle1 =
          60.0; // Reset to the initial rotation angle for the first triangle
      lightBeamLength1 =
          0.0; // Reset light beam length when resetting rotation for the first triangle
      // Reset the light beam length for the second triangle
      lightBeamLength2 = 0.0;
      lightBeamLength3 = 0.0;
    });
  }

  void _rotateLeft2() {
    setState(() {
      rotationAngle2 -= 45.0;
      final double screenHeight = MediaQuery.of(context).size.height;
      final double screenWidth = MediaQuery.of(context).size.width;
      // Check the rotation angle of both triangles and set the light beam length accordingly for the second triangle
      if ((rotationAngle1 == -60.0 || rotationAngle1 == -420.0) &&
          (rotationAngle2 == -90 || rotationAngle2 == -450)) {
        lightBeamLength2 =
            0.4 * screenHeight; // Show the beam when both conditions are met
      } else {
        lightBeamLength2 = 0.0; // Hide the beam when any condition is not met
        // Reset the light beam length for the third triangle
        lightBeamLength3 = 0.0;
      }
    });
  }

  void _resetRotation2() {
    setState(() {
      final double screenHeight = MediaQuery.of(context).size.height;
      final double screenWidth = MediaQuery.of(context).size.width;
      rotationAngle2 =
          45.0; // Reset to the initial rotation angle for the second triangle
      lightBeamLength2 =
          0.0; // Reset light beam length when resetting rotation for the second triangle
      // Reset the light beam length for the third triangle
      lightBeamLength3 = 0.0;
    });
  }

  void _rotateLeft3() {
    setState(() {
      rotationAngle3 -= 60.0;
      final double screenHeight = MediaQuery.of(context).size.height;
      final double screenWidth = MediaQuery.of(context).size.width;
      // Check the rotation angle of both the third and second triangles
      // and set the light beam length accordingly for the third triangle
      if ((rotationAngle2 == -90 || rotationAngle2 == -450) &&
          (rotationAngle3 == -60.0 || rotationAngle3 == -420.0)) {
        lightBeamLength3 =
            0.184 * screenHeight; // Show the beam when both conditions are met
      } else {
        lightBeamLength3 = 0.0; // Hide the beam when any condition is not met
      }
    });
  }

  void _resetRotation3() {
    setState(() {
      final double screenHeight = MediaQuery.of(context).size.height;
      final double screenWidth = MediaQuery.of(context).size.width;
      rotationAngle3 =
          60.0; // Reset to the initial rotation angle for the third triangle
      lightBeamLength3 =
          0.0; // Reset light beam length when resetting rotation for the third triangle
    });
  }

  void _rotateLeft4() {
    setState(() {
      final double screenHeight = MediaQuery.of(context).size.height;
      final double screenWidth = MediaQuery.of(context).size.width;
      rotationAngle4 -= 60.0;

      // Check the rotation angle and set the light beam length accordingly for the first triangle
      if (rotationAngle4 == -240.0 || rotationAngle4 == -600) {
        lightBeamLength4 =
            0.54 * screenHeight; // Show the beam for the first triangle
      } else {
        lightBeamLength4 = 0.0; // Hide the beam for the first triangle
        // Reset the light beam length for the fivth triangle
      }
    });
  }

  void _resetRotation4() {
    setState(() {
      final double screenHeight = MediaQuery.of(context).size.height;
      final double screenWidth = MediaQuery.of(context).size.width;
      rotationAngle4 =
          60.0; // Reset to the initial rotation angle for the fourth triangle
      lightBeamLength4 =
          0.0; // Reset light beam length when resetting rotation for the fourth triangle
    });
  }

  void checkConditions() {
    final screenHeight = MediaQuery.of(context).size.height;
    final tolerance = 10.0; // A tolerance for approximate equality

    // Check if the light beam lengths are approximately equal to expected values
    if ((lightBeamLength1 - 0.3 * screenHeight).abs() < tolerance &&
        (lightBeamLength2 - 0.4 * screenHeight).abs() < tolerance &&
        (lightBeamLength3 - 0.184 * screenHeight).abs() < tolerance &&
        (lightBeamLength4 - 0.54 * screenHeight).abs() < tolerance) {
      // Show the congratulatory dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('You\'ve completed the constellation!'),
            content: Text(
                'After completing the constellation, the brightest star amongst them all, triggered a mechanism of some sort by a moving wall that further led to a pathway.\n This star on observing, had some sort of marking on it.\n The letter: "E" '),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Room5(),
                  ));
                },
                child: Text("Continue to Room 5"),
              ),
            ],
          );
        },
      );
    } else {
      // Show the "complete the constellation" dialog if conditions are not met
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Complete the Constellation!"),
            content: Text(
                "You need to align all triangles to complete the constellation."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // Calculate positions based on screen dimensions
    final double star1Left = 0.325 * screenWidth;
    final double star1Top = 0.47 * screenHeight;

    final double star2Left = 0.45 * screenWidth;
    final double star2Top = 0.36 * screenHeight;

    final double triangle1Right = 0.12 * screenWidth;
    final double triangle1Bottom = 0.133 * screenHeight;

    final double triangle2Left = 0.65 * screenWidth;
    final double triangle2Bottom = 0.3 * screenHeight;

    final double triangle3Left = 0.4 * screenWidth;
    final double triangle3Bottom = 0.310 * screenHeight;

    final double triangle4Left = 0.35 * screenWidth;
    final double triangle4Bottom = 0.6 * screenHeight;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 37, 38, 75),
        title: Text('Room 4'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://farm4.staticflickr.com/3360/3523427336_b8e9a4e93d_o.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 126, 122, 104), // Border color
                    width: 2.0, // Border width
                  ),
                ),
                child: Image.network(
                  'https://media.istockphoto.com/photos/taurus-constellation-star-zodiac-picture-id905412958?k=6&m=905412958&s=612x612&w=0&h=dN-lH4-FoUQlghvP__IInBLtEGtb2xuoC8zTOkplr9U=',
                  width: 400,
                  height: 200,
                ),
              ),
            ),

            Positioned(
              right: triangle1Right,
              bottom: triangle1Bottom,
              child: MouseRegion(
                onEnter: (_) {},
                onExit: (_) {},
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: rotationAngle1 * pi / 180,
                      child: Transform.translate(
                        offset: Offset(0, 0),
                        child: CustomPaint(
                          size: Size(triangleSize, triangleSize),
                          painter: TrianglePainter(
                            lightBeamLength: lightBeamLength1,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _rotateLeft1,
                          child: Text('Rotate Left',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                        GestureDetector(
                          onTap: _resetRotation1,
                          child: Text('Reset Rotation',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Second triangle
            Positioned(
              left: triangle2Left,
              bottom: triangle2Bottom,
              child: MouseRegion(
                onEnter: (_) {},
                onExit: (_) {},
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: rotationAngle2 * pi / 180,
                      child: Transform.translate(
                        offset: Offset(0, 0),
                        child: CustomPaint(
                          size: Size(triangleSize, triangleSize),
                          painter: TrianglePainter(
                            lightBeamLength: lightBeamLength2,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _rotateLeft2,
                          child: Text('Rotate Left',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                        GestureDetector(
                          onTap: _resetRotation2,
                          child: Text('Reset Rotation',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Third triangle
            Positioned(
              left: triangle3Left,
              bottom: triangle3Bottom,
              child: MouseRegion(
                onEnter: (_) {},
                onExit: (_) {},
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: rotationAngle3 * pi / 180,
                      child: Transform.translate(
                        offset: Offset(0, 0),
                        child: CustomPaint(
                          size: Size(triangleSize, triangleSize),
                          painter: TrianglePainter(
                            lightBeamLength: lightBeamLength3,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _rotateLeft3,
                          child: Text('Rotate Left',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                        GestureDetector(
                          onTap: _resetRotation3,
                          child: Text('Reset Rotation',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Fourth triangle
            Positioned(
              left: triangle4Left,
              bottom: triangle4Bottom,
              child: MouseRegion(
                onEnter: (_) {},
                onExit: (_) {},
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.rotate(
                      angle: rotationAngle4 * pi / 180,
                      child: Transform.translate(
                        offset: Offset(0, 0),
                        child: CustomPaint(
                          size: Size(triangleSize, triangleSize),
                          painter: TrianglePainter(
                            lightBeamLength: lightBeamLength4,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _rotateLeft4,
                          child: Text('Rotate Left',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                        GestureDetector(
                          onTap: _resetRotation4,
                          child: Text('Reset Rotation',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Star 1
            Positioned(
              left: star1Left,
              top: star1Top,
              child: CustomPaint(
                size: Size(starSize, starSize),
                painter: StarPainter(starSize: starSize),
              ),
            ),

            // Star 2
            Positioned(
              left: star2Left,
              top: star2Top,
              child: CustomPaint(
                size: Size(starSize, starSize),
                painter: StarPainter(starSize: starSize),
              ),
            ),

            // ... Add more triangles and stars here

            Positioned(
              left: 80,
              top: 20,
              child: ElevatedButton(
                onPressed: checkConditions,
                child: Text("Finish"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  final double starSize;

  StarPainter({required this.starSize});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Define the points for a 5-pointed star
    final double radians = 72.0 * (pi / 180.0);
    final double radius = starSize / 2;
    final List<Offset> starPoints = List.generate(10, (i) {
      final double r = (i.isEven) ? radius : radius / 2;
      final double x = centerX + r * cos(i * radians);
      final double y = centerY + r * sin(i * radians);
      return Offset(x, y);
    });

    final Path path = Path();
    path.addPolygon(starPoints, true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class Room5 extends StatefulWidget {
  final String correctPasscode =
      "FREE"; // Replace with your desired letter passcode

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class TrianglePainter extends CustomPainter {
  final double lightBeamLength; // Length of the light beam

  TrianglePainter({required this.lightBeamLength});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, 0)
      ..close();

    canvas.drawPath(path, paint);

    // Draw the light beam starting from the top corner of the triangle
    if (lightBeamLength > 0) {
      final double beamWidth = 3.0;
      final Paint beamPaint = Paint()
        ..color = Color.fromARGB(255, 255, 230, 0)
        ..style = PaintingStyle.fill
        ..strokeWidth = beamWidth;

      // Start the beam at the top corner of the triangle
      final Offset beamStart = Offset(size.width / 2, 0);

      // Calculate the end point of the beam, which extends upward from the triangle's top corner
      final Offset beamEnd = Offset(size.width / 2, -lightBeamLength);

      // Apply a Gaussian blur filter to the light beam
      final MaskFilter blurFilter = MaskFilter.blur(BlurStyle.normal, 3.0);
      beamPaint.maskFilter = blurFilter;

      canvas.drawLine(beamStart, beamEnd, beamPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class _PasscodeScreenState extends State<Room5> {
  String enteredPasscode = "";
  bool isPasscodeVisible = false;
  bool isDialogOpen = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showPasscodeDialog(); // Show the passcode dialog when the screen opens.
    });
  }

  Future<void> _showPasscodeDialog() async {
    setState(() {
      isDialogOpen = true;
    });

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text("You have now reached the final door that leads to outside"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Crack the code to find what awaits you:"),
              PasscodeInput(
                enteredPasscode: enteredPasscode,
                onKeyTapped: _handleKey,
                isPasscodeVisible: isPasscodeVisible,
                togglePasscodeVisibility: _togglePasscodeVisibility,
              ),
            ],
          ),
        );
      },
    ).then((_) {
      setState(() {
        isDialogOpen = false;
      });
    });
  }

  void _handleKey(String key) {
    setState(() {
      enteredPasscode += key;
    });
    if (enteredPasscode.length == 4) {
      if (enteredPasscode == widget.correctPasscode) {
        Navigator.pop(
            context); // Close the passcode dialog when the correct passcode is entered.
        // You can navigate to the next screen here.
      } else {
        // Passcode is incorrect, show an error message.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Incorrect passcode. Try again."),
        ));
        setState(() {
          enteredPasscode = "";
        });
      }
    }
  }

  void _togglePasscodeVisibility() {
    setState(() {
      isPasscodeVisible = !isPasscodeVisible;
    });
  }

  Future<void> _openYouTubeLink() async {
    const url =
        'https://youtu.be/dQw4w9WgXcQ?si=PxhHgh6h16lHyC7J'; // Replace with your YouTube link
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Room 5"),
        flexibleSpace: Image.network(
          "https://static.pexels.com/photos/7504/night-clouds-trees-stars.jpg",
          fit: BoxFit.cover,
        ),
      ),
      body: Stack(
        children: <Widget>[
          // Background content
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://as1.ftcdn.net/v2/jpg/06/24/46/40/1000_F_624464054_MPK5Nq76bl470u2hiE4GcDTiyQDWGcXS.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 10.0, left: 500),
                child: Text(
                  "CONGRATULATIONS!!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 30.0, left: 500),
                child: Text(
                  "You have broken out of the escape room!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _openYouTubeLink();
                },
                child: Text("Reward"),
              ),
            ],
          ),
          if (isDialogOpen)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: const Color.fromARGB(255, 7, 7, 7).withOpacity(1.0),
              ),
            ),
        ],
      ),
    );
  }
}

class PasscodeInput extends StatelessWidget {
  final String enteredPasscode;
  final Function(String) onKeyTapped;
  final bool isPasscodeVisible;
  final Function() togglePasscodeVisibility;

  PasscodeInput({
    required this.enteredPasscode,
    required this.onKeyTapped,
    required this.isPasscodeVisible,
    required this.togglePasscodeVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          obscureText: !isPasscodeVisible,
          enableSuggestions: false,
          autocorrect: false,
          maxLength: 4,
          decoration: InputDecoration(
            hintText: "Passcode",
            suffix: GestureDetector(
              onTap: togglePasscodeVisibility,
              child: isPasscodeVisible
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off),
            ),
          ),
          onChanged: (value) {
            if (value.length == 4) {
              onKeyTapped(value);
            }
          },
        ),
      ],
    );
  }
}
