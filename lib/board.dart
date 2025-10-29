import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sudoku_app/sudoku.dart';

import 'dart:developer' as developer;

class BoardPage extends StatefulWidget {
  final Difficulty difficulty;
  const BoardPage({super.key, required this.difficulty});
  @override
  State<BoardPage> createState() => _BoardPageState();
}

// configuration
const int maxErrors = 3;

class _BoardPageState extends State<BoardPage> {
  late Sudoku _sudoku;
  late List<List<int>> _user;
  int _selectNumber = 0;
  late List<int> _usedNumbers;
  int _errotCount = 0;
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  String _timeStr = '00:00';

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    _sudoku = Sudoku.generate(widget.difficulty, null);
    _user = _sudoku.clonePuzzle();
    _usedNumbers = List.filled(_sudoku.size, 0);
    for (int i = 0; i < _sudoku.size; i++) {
      for (int j = 0; j < _sudoku.size; j++) {
        if (_sudoku.puzzle[i][j] > 0 && _sudoku.puzzle[i][j] <= _sudoku.size) {
          _usedNumbers[_sudoku.puzzle[i][j] - 1]++;
        }
      }
    }
    _errotCount = 0;
    _selectNumber = 0;
    _stopwatch.reset();
    _stopwatch.start();
    _timeStr = '00:00';
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeStr =
            '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}'
            ':${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  void _onNumberTap(int number) {
    setState(() {
      if (_selectNumber == number || _usedNumbers[number - 1] >= _sudoku.size) {
        _selectNumber = 0;
      } else {
        _selectNumber = number;
      }
    });
  }

  Widget _buildCell(int r, int c) {
    bool given = _sudoku.puzzle[r][c] != 0;
    int val = _user[r][c];
    bool isHighlighted = _user[r][c] == _selectNumber;
    return GestureDetector(
      onTap: () async {
        if (given) return;
        if (_selectNumber == 0) {
          return;
        } else {
          if (_user[r][c] == _sudoku.solution[r][c]) {
            return;
          }
          setState(() {
            if (_user[r][c] != 0) {
              _usedNumbers[_user[r][c] - 1]--;
              if (_user[r][c] == _selectNumber) {
                _user[r][c] = 0;
                return;
              }
            }
            _user[r][c] = _selectNumber;
            _usedNumbers[_selectNumber - 1]++;
            if (_usedNumbers[_selectNumber - 1] == _sudoku.size) {
              _selectNumber = 0;
            }
            if (_sudoku.solution[r][c] != _user[r][c]) {
              _errotCount++;
              developer.log('Errors: $_errotCount');
              if (_errotCount >= maxErrors) {
                _timer.cancel();
                _stopwatch.stop();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AlertDialog(
                    title: Text('Game Over'),
                    content: Text('Too many errors.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('Back to main menu'),
                      ),
                      TextButton(
                        onPressed: () {
                          _initGame();
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
            }
            for (int i = 0; i < _sudoku.size; i++) {
              if (_usedNumbers[i] != _sudoku.size) {
                return;
              }
            }
            _timer.cancel();
            _stopwatch.stop();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                title: Text('Congratulations!'),
                content: Text('You won!\nLevel: ${widget.difficulty.name}\nTime: $_timeStr'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Back to main menu'),
                  ),
                  TextButton(
                    onPressed: () {
                      _initGame();
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text('New Game'),
                  ),
                ],
              ),
            );
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: r % _sudoku.boxSize == 0 ? 2 : 0.5, color: Colors.black),
            left: BorderSide(width: c % _sudoku.boxSize == 0 ? 2 : 0.5, color: Colors.black),
            right: BorderSide(width: (c + 1) % _sudoku.boxSize == 0 ? 2 : 0.5, color: Colors.black),
            bottom: BorderSide(
              width: (r + 1) % _sudoku.boxSize == 0 ? 2 : 0.5,
              color: Colors.black,
            ),
          ),
          color: given ? Colors.grey.shade200 : Colors.white,
        ),
        alignment: Alignment.center,
        child: Text(
          val == 0 ? '' : val.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: given ? FontWeight.bold : FontWeight.w400,
            color: val != _sudoku.solution[r][c]
                ? Colors.red
                : isHighlighted
                ? Colors.blue
                : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildBoard() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(border: Border.all(width: 2, color: Colors.black)),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
            itemCount: _sudoku.size * _sudoku.size,
            itemBuilder: (context, index) {
              int r = index ~/ _sudoku.size;
              int c = index % _sudoku.size;
              return _buildCell(r, c);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNumsBar() {
    return SizedBox(
      height: 80, // adjust for spacing
      width: 360,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 9,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: _sudoku.size,
        itemBuilder: (context, index) {
          int number = index + 1;
          bool isSelected = number == _selectNumber;
          return GestureDetector(
            onTap: () => _onNumberTap(number),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.amber
                    : _usedNumbers[number - 1] == _sudoku.size
                    ? Colors.grey
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black87, width: 1),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: number.toString(),
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.top,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Text(
                            (9 - _usedNumbers[number - 1]).toString(),
                            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var diffText = switch (widget.difficulty) {
      Difficulty.easy => 'Easy',
      Difficulty.medium => 'Medium',
      Difficulty.hard => 'Hard',
      Difficulty.expert => 'Expert',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku - $diffText'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Errors: $_errotCount               Time: $_timeStr',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            _buildBoard(),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Center(child: _buildNumsBar())],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
