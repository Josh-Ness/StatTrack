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
}
