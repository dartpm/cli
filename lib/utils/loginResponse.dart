class UserOrgs {
  final String id;

  @override
  String toString() {
    return '{"id": "$id"}';
  }

  UserOrgs.fromJson(Map<String, dynamic> json) : id = json['id'];
}

class LoginResponse {
  final String token;
  final Iterable<UserOrgs> orgs;

  LoginResponse.fromJson(Map<String, dynamic> json)
      : token = json['signedToken'],
        orgs = (json['userOrgs'] as List<dynamic>).map((e) => UserOrgs.fromJson(e));
}
