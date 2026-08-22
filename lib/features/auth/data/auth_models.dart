class MobileLoginResponse {
  final String tokenType;
  final String accessToken;
  final String refreshToken;
  final int accessTokenExpiresIn;
  final int refreshTokenExpiresIn;

  final String userId;
  final String companyId;
  final String loginId;
  final String userNm;

  final String? roleId;
  final String? roleCd;
  final String? roleNm;
  final String? passwordInitYn;

  const MobileLoginResponse({
    required this.tokenType,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresIn,
    required this.refreshTokenExpiresIn,
    required this.userId,
    required this.companyId,
    required this.loginId,
    required this.userNm,
    this.roleId,
    this.roleCd,
    this.roleNm,
    this.passwordInitYn,
  });

  factory MobileLoginResponse.fromJson(Map<String, dynamic> json) {
    return MobileLoginResponse(
      tokenType: json['tokenType']?.toString() ?? 'Bearer',
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      accessTokenExpiresIn: _toInt(json['accessTokenExpiresIn']),
      refreshTokenExpiresIn: _toInt(json['refreshTokenExpiresIn']),
      userId: json['userId']?.toString() ?? '',
      companyId: json['companyId']?.toString() ?? '',
      loginId: json['loginId']?.toString() ?? '',
      userNm: json['userNm']?.toString() ?? '',
      roleId: json['roleId']?.toString(),
      roleCd: json['roleCd']?.toString(),
      roleNm: json['roleNm']?.toString(),
      passwordInitYn: json['passwordInitYn']?.toString(),
    );
  }
}

class MobileRefreshResponse {
  final String tokenType;
  final String accessToken;
  final int accessTokenExpiresIn;

  const MobileRefreshResponse({
    required this.tokenType,
    required this.accessToken,
    required this.accessTokenExpiresIn,
  });

  factory MobileRefreshResponse.fromJson(Map<String, dynamic> json) {
    return MobileRefreshResponse(
      tokenType: json['tokenType']?.toString() ?? 'Bearer',
      accessToken: json['accessToken']?.toString() ?? '',
      accessTokenExpiresIn: _toInt(json['accessTokenExpiresIn']),
    );
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
