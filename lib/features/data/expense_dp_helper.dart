import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'expense_model.dart';

class ExpenseDBHelper {
  static final ExpenseDBHelper instance = ExpenseDBHelper._init();
  static Database? _database;

  ExpenseDBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('DROP TABLE IF EXISTS expense'); // Drop old table
      await _createDB(db, newVersion); // Recreate the table
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS expense');
    const expenseTable = '''
    CREATE TABLE expense (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      category TEXT NOT NULL,
      amount REAL NOT NULL,
      date TEXT NOT NULL
    )
    ''';
    await db.execute(expenseTable);
  }

  Future<List<Expense>> getExpenses() async {
    final db = await instance.database;
    final result = await db.query('expense');
    return result.map((map) => Expense.fromMap(map)).toList();
  }

  Future<int> addExpense(Expense expense) async {
    final db = await instance.database;
    return await db.insert('expense', expense.toMap());
  }

  Future<int> deleteExpense(int id) async {
    final db = await instance.database;
    return await db.delete('expense', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getMonthlyExpenses() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
    SELECT strftime('%Y-%m', date) AS month, SUM(amount) AS total
    FROM expense
    GROUP BY month
    ORDER BY month ASC
  ''');
    return result;
  }
}
