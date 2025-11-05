import 'package:flutter/material.dart';
import 'package:sudoku_app/board.dart';
import 'package:sudoku_app/common_app_bar.dart';
import 'package:sudoku_app/sudoku.dart';
import 'package:sudoku_app/services/bgm_service.dart';
import 'package:sudoku_app/services/sfx_service.dart';

enum BgmAction { bgm1, bgm2, bgm3, bgm4, disable }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BgmService.instance.init();
  await SfxService.instance.init();
  runApp(const SudokuApp());
}

class SudokuApp extends StatefulWidget {
  const SudokuApp({super.key});

  @override
  State<SudokuApp> createState() => _SudokuAppState();
}

class _SudokuAppState extends State<SudokuApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
          primary: Colors.black, // text color, line of board
          onPrimary: Colors.white, // board background
          secondary: Colors.blue, // selected text color
          onSecondary: Colors.grey.shade200, // fixed board background, select bar button background
          onSecondaryFixed: Colors.grey[400], // disabled button background
          onSecondaryContainer: Colors.amber, // selecetd button background
          error: Colors.red, // error text color
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
          primary: Colors.white,
          onPrimary: Colors.blueGrey,
          secondary: Colors.lightBlue,
          onSecondary: Colors.grey[1000],
          onSecondaryFixed: Colors.grey[800],
          onSecondaryContainer: Colors.amber[900],
          error: Colors.red,
        ),
      ),
      home: HomePage(onToggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}

class HomePage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final ThemeMode themeMode;

  const HomePage({super.key, required this.onToggleTheme, required this.themeMode});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BgmService.instance.selectAndPlay(0);
  }

  Widget _buildLevelButton(BuildContext context, Difficulty difficulty) {
    var levelBtnStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.lightBlue,
      minimumSize: const Size(300, 50),
      maximumSize: const Size(300, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    );
    var text = switch (difficulty) {
      Difficulty.easy => 'Easy',
      Difficulty.medium => 'Medium',
      Difficulty.hard => 'Hard',
      Difficulty.expert => 'Expert',
    };
    var textStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
    return ElevatedButton(
      key: Key(text),
      style: levelBtnStyle,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BoardPage(
              onToggleTheme: widget.onToggleTheme,
              themeMode: widget.themeMode,
              difficulty: difficulty,
            ),
          ),
        );
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: textStyle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Sudoku',
        onToggleTheme: widget.onToggleTheme,
        themeMode: widget.themeMode,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('Puzzles', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                _buildLevelButton(context, Difficulty.easy),
                const SizedBox(height: 16),
                _buildLevelButton(context, Difficulty.medium),
                const SizedBox(height: 16),
                _buildLevelButton(context, Difficulty.hard),
                const SizedBox(height: 16),
                _buildLevelButton(context, Difficulty.expert),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
