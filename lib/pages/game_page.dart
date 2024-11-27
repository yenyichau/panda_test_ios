import '../imports.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        body: Container(
          color: Colors.white,
          child: const Center(
            child: AppText("Game Page"),
          ),
        ),
      ),
    );
  }
}
