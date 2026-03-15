import 'package:hive/hive.dart';

part 'irma_user.g.dart';

@HiveType(typeId: 13)
class IrmaUser extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final DateTime? dob;

  @HiveField(2)
  final List<String> goals;

  IrmaUser({
    this.name = '',
    this.dob,
    this.goals = const [],
  });

  IrmaUser copyWith({
    String? name,
    DateTime? dob,
    List<String>? goals,
  }) {
    return IrmaUser(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      goals: goals ?? this.goals,
    );
  }
}
