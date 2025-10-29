import 'dart:math';
import 'dart:io';
import 'dart:developer' as developer;

enum Difficulty { easy, medium, hard, expert }

class Sudoku {
  late int size;
  late int boxSize;
  late Difficulty difficulty;
  late List<List<int>> puzzle;
  late List<List<int>> solution;

  Sudoku(this.size, this.boxSize, this.difficulty) {
    puzzle = List.generate(size, (_) => List.filled(size, 0));
    solution = List.generate(size, (_) => List.filled(size, 0));
  }

  void show() {
    stdout.write("Difficulty: ");
    switch (difficulty) {
      case Difficulty.easy:
        stdout.write("Easy");
      case Difficulty.hard:
        stdout.write("Hard");
      case Difficulty.expert:
        stdout.write("Expert");
      default:
        stdout.write("Medium");
    }
    developer.log('');
    developer.log("Puzzle:");
    showBoard(puzzle);
    developer.log("Solution:");
    showBoard(solution);
  }

  void showBoard(List<List<int>> board) {
    for (int i = 0; i < size; i++) {
      if (i % boxSize == 0) {
        stdout.write("+-------+-------+-------+");
      }
      for (int j = 0; j < size; j++) {
        if (j % boxSize == 0) {
          stdout.write("| ");
        }
        if (board[i][j] > 0 && board[i][j] <= 9) {
          stdout.write(board[i][j]);
          stdout.write(" ");
        } else {
          stdout.write(". ");
        }
      }
      stdout.write("|");
    }
    stdout.write("+-------+-------+-------+");
  }

  List<List<int>> _cloneBoard(List<List<int>> board) {
    List<List<int>> newBoard = List.filled(size, []);

    for (int row = 0; row < size; row++) {
      newBoard[row] = List.from(board[row]);
    }
    return newBoard;
  }

  List<List<int>> clonePuzzle() {
    return _cloneBoard(puzzle);
  }

  Sudoku clone() {
    var sudoku = Sudoku(size, boxSize, difficulty);
    sudoku.puzzle = _cloneBoard(puzzle);
    sudoku.solution = _cloneBoard(solution);

    return sudoku;
  }

  static Sudoku generate(Difficulty difficulty, int? seed) {
    Sudoku sudoku = Sudoku(9, 3, difficulty);
    var rng = Random(seed);

    sudoku._fillBoard(rng);

    sudoku._removeNums(rng);

    return sudoku;
  }

  void _fillBoard(Random rng) {
    var nums = List.generate(size, (i) => i + 1);
    for (int i = 0; i < size; i += boxSize) {
      nums.shuffle(rng);
      for (int r = 0; r < boxSize; r++) {
        for (int c = 0; c < boxSize; c++) {
          puzzle[i + r][i + c] = nums[r * boxSize + c];
        }
      }
    }

    var temp = clone();
    temp._solve();
    puzzle = _cloneBoard(temp.puzzle);
    solution = _cloneBoard(temp.puzzle);
  }

  bool _solve() {
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (puzzle[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (_isVaild(row, col, num)) {
              puzzle[row][col] = num;
              if (_solve()) {
                return true;
              }
              puzzle[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  bool _isVaild(int row, int col, int num) {
    for (int i = 0; i < size; i++) {
      if (puzzle[row][i] == num || puzzle[i][col] == num) return false;
    }
    int boxRow = row - row % boxSize;
    int boxCol = col - col % boxSize;
    for (int i = 0; i < boxSize; i++) {
      for (int j = 0; j < boxSize; j++) {
        if (puzzle[boxRow + i][boxCol + j] == num) return false;
      }
    }
    return true;
  }

  void _removeNums(Random rng) {
    var attempts = switch (difficulty) {
      Difficulty.easy => 5,
      Difficulty.medium => 10,
      Difficulty.hard => 30,
      Difficulty.expert => 50,
    };
    var removes = switch (difficulty) {
      Difficulty.easy => 35,
      Difficulty.medium => 40,
      Difficulty.hard => 50,
      Difficulty.expert => 65,
    };

    while (attempts > 0) {
      var row = rng.nextInt(size);
      var col = rng.nextInt(size);
      if (puzzle[row][col] != 0) {
        var backup = puzzle[row][col];
        puzzle[row][col] = 0;

        var copy = clone();
        List<int> count = List.filled(1, 0);
        copy._countSolutions(count);
        if (count[0] != 1) {
          puzzle[row][col] = backup;
          attempts--;
        }
        removes--;
      }
      if (removes == 0) {
        break;
      }
    }
  }

  bool _countSolutions(List<int> count) {
    for (int row = 0; row < size; row++) {
      for (int col = 0; col < size; col++) {
        if (puzzle[row][col] == 0) {
          for (int num = 1; num <= size; num++) {
            if (_isVaild(row, col, num)) {
              puzzle[row][col] = num;
              if (_countSolutions(count)) {
                return true;
              }
              puzzle[row][col] = 0;
            }
          }
          return false;
        }
      }
    }

    count[0]++;
    return count[0] >= 2;
  }

  bool checkCell(int row, int col, int num) {
    return solution[row][col] == num;
  }
}
