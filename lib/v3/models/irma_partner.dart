import 'package:hive/hive.dart';

part 'irma_partner.g.dart';

@HiveType(typeId: 30)
enum PartnerStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  connected,
  @HiveField(2)
  disconnected,
}

@HiveType(typeId: 31)
class IrmaPartner extends HiveObject {
  @HiveField(0)
  final String? id; // Supabase UID

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? inviteCode;

  @HiveField(3)
  final PartnerStatus status;

  @HiveField(4)
  final DateTime createdAt;

  IrmaPartner({
    this.id,
    required this.name,
    this.inviteCode,
    this.status = PartnerStatus.pending,
    required this.createdAt,
  });
}
