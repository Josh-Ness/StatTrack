class Injury {
  final int season;
  final int week;
  final String gsisId;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? gameType;
  final String team;
  final String position;
  final String? reportPrimaryInjury;
  final String? reportSecondaryInjury;
  final String? reportStatus;
  final String? practicePrimaryInjury;
  final String? practiceSecondaryInjury;
  final String? practiceStatus;
  final DateTime dateModified;

  Injury({
    required this.season,
    required this.week,
    required this.gsisId,
    this.firstName,
    this.lastName,
    this.fullName,
    this.gameType,
    required this.team,
    required this.position,
    this.reportPrimaryInjury,
    this.reportSecondaryInjury,
    this.reportStatus,
    this.practicePrimaryInjury,
    this.practiceSecondaryInjury,
    this.practiceStatus,
    required this.dateModified,
  });
}
