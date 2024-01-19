class PlayByPlay {
  final String gameId;
  final int playId;
  final int qtr;
  final int drive;
  final int? down;
  final bool? shotgun;
  final bool? noHuddle;
  final bool? qbDropback;
  final bool? qbScramble;
  final bool? completePass;
  final bool? incompletePass;
  final double? passingYards;
  final double? airYards;
  final double? yardsAfterCatch;
  final bool? firstDownPass;
  final bool? passingTouchdown;
  final double? receivingYards;
  final bool? interception;
  final bool? fumble;
  final bool? sack;
  final bool? rushAttempt;
  final double? rushingYards;
  final bool? rushingTouchdown;
  final bool? firstDownRush;
  final bool? fieldGoalAttempt;
  final bool? extraPointAttempt;
  final bool? puntAttempt;
  final bool? kickoffAttempt;
  final bool? fieldGoalResult;
  final bool? extraPointResult;
  final bool? safety;
  final bool? penalty;
  final int? week;
  final String? passerPlayerId;
  final String? receiverPlayerId;
  final String? rusherPlayerId;
  final String? kickerPlayerId;

  PlayByPlay({
    required this.gameId,
    required this.playId,
    required this.qtr,
    required this.drive,
    this.down,
    this.shotgun,
    this.noHuddle,
    this.qbDropback,
    this.qbScramble,
    this.completePass,
    this.incompletePass,
    this.passingYards,
    this.airYards,
    this.yardsAfterCatch,
    this.firstDownPass,
    this.passingTouchdown,
    this.receivingYards,
    this.interception,
    this.fumble,
    this.sack,
    this.rushAttempt,
    this.rushingYards,
    this.rushingTouchdown,
    this.firstDownRush,
    this.fieldGoalAttempt,
    this.extraPointAttempt,
    this.puntAttempt,
    this.kickoffAttempt,
    this.fieldGoalResult,
    this.extraPointResult,
    this.safety,
    this.penalty,
    this.week,
    this.passerPlayerId,
    this.receiverPlayerId,
    this.rusherPlayerId,
    this.kickerPlayerId,
  });
}
