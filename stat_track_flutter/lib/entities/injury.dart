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

  factory Injury.fromJson(Map<String, dynamic> json) {
    return Injury(
      season: json['Season'] as int,
      week: json['Week'] as int,
      gsisId: json['GsisID'] as String,
      firstName: json['FirstName'] as String?,
      lastName: json['LastName'] as String?,
      fullName: json['FullName'] as String?,
      gameType: json['GameType'] as String?,
      team: json['Team'] as String,
      position: json['Position'] as String,
      reportPrimaryInjury: json['ReportPrimaryInjury'] as String?,
      reportSecondaryInjury: json['ReportSecondaryInjury'] as String?,
      reportStatus: json['ReportStatus'] as String?,
      practicePrimaryInjury: json['PracticePrimaryInjury'] as String?,
      practiceSecondaryInjury: json['PracticeSecondaryInjury'] as String?,
      practiceStatus: json['PracticeStatus'] as String?,
      dateModified: DateTime.parse(json['DateModified'] as String),
    );
  }

}
