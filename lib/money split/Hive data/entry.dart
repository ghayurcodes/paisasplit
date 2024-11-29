import 'package:hive/hive.dart';
part 'entry.g.dart'; // This tells Hive to generate the adapter code


@HiveType(typeId: 0) // Assign a unique typeId
class Entry {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late double amount;

  @HiveField(2)
  late DateTime time;

  Entry(this.name, this.amount, this.time); // Constructor
}