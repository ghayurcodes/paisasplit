class Entry {
  String name;
  double amount;
  DateTime dateTime;

  Entry(this.name, this.amount, this.dateTime);

  // Convert Entry to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // Convert JSON to Entry
  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      json['name'],
      json['amount'],
      DateTime.parse(json['dateTime']),
    );
  }
}
