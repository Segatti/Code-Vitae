import '../../interactor/enums/type_reward.dart';

class QuestProgressModel {
  final String id;
  final String title;
  final int targetCount;
  final int progressCount;
  final int rewardAmount;
  final TypeRewards rewardType;
  final bool isCompleted;
  final bool isClaimed;

  const QuestProgressModel({
    required this.id,
    required this.title,
    required this.targetCount,
    required this.progressCount,
    required this.rewardAmount,
    required this.rewardType,
    required this.isCompleted,
    required this.isClaimed,
  });

  bool get canClaim => isCompleted && !isClaimed;

  factory QuestProgressModel.fromMap(Map<String, dynamic> map) {
    return QuestProgressModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      targetCount: (map['targetCount'] as num?)?.toInt() ?? 0,
      progressCount: (map['progressCount'] as num?)?.toInt() ?? 0,
      rewardAmount: (map['rewardAmount'] as num?)?.toInt() ?? 0,
      rewardType: TypeRewards.getType(map['rewardType']?.toString() ?? ''),
      isCompleted: map['isCompleted'] == true,
      isClaimed: map['isClaimed'] == true,
    );
  }
}
