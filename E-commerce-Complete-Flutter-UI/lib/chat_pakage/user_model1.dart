class UserModel {
  String firstName;
  String lastName;
  String verified;
  String imageUrl;
  String email;
  String address;
  String phone;
  String password;
  String name;
  String id;

  UserModel(
      {this.verified,
      this.id,
      this.firstName,
      this.lastName,
      this.address,
      this.imageUrl,
      this.email,
      this.phone,
      this.password,
      this.name});
}
