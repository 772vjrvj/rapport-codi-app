class Member {
  final String? memberId;
  final String? memberNo;
  final String? memberNm;
  final String? genderNm;
  final String? birthDt;
  final String? phoneNo;
  final String? statusNm;

  Member({
    this.memberId,
    this.memberNo,
    this.memberNm,
    this.genderNm,
    this.birthDt,
    this.phoneNo,
    this.statusNm,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberId: json['memberId'],
      memberNo: json['memberNo'],
      memberNm: json['memberNm'],
      genderNm: json['genderNm'],
      birthDt: json['birthDt'],
      phoneNo: json['phoneNo'],
      statusNm: json['statusNm'],
    );
  }
}