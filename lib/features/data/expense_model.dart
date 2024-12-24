class Expense {
// Static counter to generate unique IDs
  final int? id;
  final String title;
  final String category;
  final double amount;
  final String date;

  Expense(
      {this.id,
      required this.title,
      required this.category,
      required this.amount,
      required this.date});
  // Generate a unique ID (this could also use UUID or similar)

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'date': date,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      amount: map['amount'],
      date: map['date'],
    );
  }
}
