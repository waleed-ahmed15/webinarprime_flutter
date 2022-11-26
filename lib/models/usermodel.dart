class UserModel {
  String? name;
  String? email;
  String? password;
  String? profileImage;
  bool? organizer;
  String? birthdate;
  String? registrationNumber;
  List<String>? interests;

  UserModel(
      {this.name,
      this.email,
      this.password,
      this.profileImage,
      this.organizer,
      this.birthdate,
      this.registrationNumber,
      this.interests});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    profileImage = json['profile_image'];
    organizer = json['organizer'];
    birthdate = json['birthdate'];
    registrationNumber = json['registration_number'];
    interests = json['interests'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['profile_image'] = this.profileImage;
    data['organizer'] = this.organizer;
    data['birthdate'] = this.birthdate;
    data['registration_number'] = this.registrationNumber;
    data['interests'] = this.interests;
    return data;
  }
}
