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

  factory PlayByPlay.fromJson(Map<String, dynamic> json) {
    return PlayByPlay(
      gameId: json['GameID'] as String,
      playId: json['PlayID'] as int,
      qtr: json['QTR'] as int,
      drive: json['Drive'] as int,
      down: json['Down'] as int?,
      shotgun: json['Shotgun'] == "1", //Loads in as string, convert to boolean
      noHuddle: json['NoHuddle'] == "1",
      qbDropback: json['QbDropback'] == "1",
      qbScramble: json['QbScramble'] == "1",
      completePass: json['CompletePass'] == "1",
      incompletePass: json['IncompletePass'] == "1",
      passingYards: json['PassingYards'] as double?,
      airYards: json['AirYards'] as double?,
      yardsAfterCatch: json['YardsAfterCatch'] as double?,
      firstDownPass: json['FirstDownPass'] == "1",
      passingTouchdown: json['PassingTouchdown'] == "1",
      receivingYards: json['ReceivingYards'] as double?,
      interception: json['Interception'] == "1",
      fumble: json['Fumble'] == "1",
      sack: json['Sack'] == "1",
      rushAttempt: json['RushAttempt'] == "1",
      rushingYards: json['RushingYards'] as double?,
      rushingTouchdown: json['RushingTouchdown'] == "1",
      firstDownRush: json['FirstDownRush'] == "1",
      fieldGoalAttempt: json['FieldGoalAttempt'] == "1",
      extraPointAttempt: json['ExtraPointAttempt'] == "1",
      puntAttempt: json['PuntAttempt'] == "1",
      kickoffAttempt: json['KickoffAttempt'] == "1",
      fieldGoalResult: json['FieldGoalResult'] == "1",
      extraPointResult: json['ExtraPointResult'] == "1",
      safety: json['Safety'] == "1",
      penalty: json['Penalty'] == "1",
      week: json['Week'] as int?,
      passerPlayerId: json['PasserPlayerID'] as String?,
      receiverPlayerId: json['ReceiverPlayerID'] as String?,
      rusherPlayerId: json['RusherPlayerID'] as String?,
      kickerPlayerId: json['KickerPlayerID'] as String?,
    );
  }

}
