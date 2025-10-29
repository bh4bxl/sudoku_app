import 'package:flutter/material.dart';
import 'package:sudoku_app/board.dart';
import 'package:sudoku_app/sudoku.dart';

void main() => runApp(const SudokuApp());

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
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
    var textStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);
    return ElevatedButton(
      key: Key(text),
      style: levelBtnStyle,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BoardPage(difficulty: difficulty)),
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
      appBar: AppBar(title: const Text('Sudoku')),
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
