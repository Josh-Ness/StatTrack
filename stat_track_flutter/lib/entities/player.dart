class Player {
  final String playerId;
  final String firstName;
  final String lastName;
  final String fullName;
  final int? jerseyNumber;
  final String? status;
  final String? team;
  final String? position;
  final String? ngsPosition;
  final String? depthChartPosition;
  final int? age;
  final int? yearsExp;
  final DateTime? birthDate;
  final int? height;
  final int? weight;
  final String? college;
  final int? draftNumber;
  final String? draftClub;
  final int? entryYear;
  final int? rookieYear;
  final String? headshotUrl;
  final String? footballName;
  final String? statusDescriptionAbbr;
  final int? season;
  final int? week;
  final String? gameType;
  final DateTime? startDate;

  Player({
    required this.playerId,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.jerseyNumber,
    this.status,
    this.team,
    this.position,
    this.ngsPosition,
    this.depthChartPosition,
    this.age,
    this.yearsExp,
    this.birthDate,
    this.height,
    this.weight,
    this.college,
    this.draftNumber,
    this.draftClub,
    this.entryYear,
    this.rookieYear,
    this.headshotUrl,
    this.footballName,
    this.statusDescriptionAbbr,
    this.season,
    this.week,
    this.gameType,
    this.startDate,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      playerId: json['PlayerID'] as String,
      firstName: json['FirstName'] as String,
      lastName: json['LastName'] as String,
      fullName: json['FullName'] as String,
      jerseyNumber: json['JerseyNumber'] as int?,
      status: json['Status'] as String?,
      team: json['Team'] as String?,
      position: json['Position'] as String?,
      ngsPosition: json['NgsPosition'] as String?,
      depthChartPosition: json['DepthChartPosition'] as String?,
      age: json['Age'] as int?,
      yearsExp: json['YearsExp'] as int?,
      birthDate: json['BirthDate'] != null ? DateTime.parse(json['BirthDate'] as String) : null,
      height: json['Height'] as int?,
      weight: json['Weight'] as int?,
      college: json['College'] as String?,
      draftNumber: json['DraftNumber'] as int?,
      draftClub: json['DraftClub'] as String?,
      entryYear: json['EntryYear'] as int?,
      rookieYear: json['RookieYear'] as int?,
      headshotUrl: json['HeadshotUrl'] as String?,
      footballName: json['FootballName'] as String?,
      statusDescriptionAbbr: json['StatusDescriptionAbbr'] as String?,
      season: json['Season'] as int?,
      week: json['Week'] as int?,
      gameType: json['GameType'] as String?,
      startDate: json['StartDate'] != null ? DateTime.parse(json['StartDate'] as String) : null,
    );
  }
}
