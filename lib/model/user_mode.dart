class UserModel {
  final String? id ;
  final String firstName;
  final String email;
  final String phoneNo;

  const UserModel({
    this.id,
    required this.firstName,
    required this.email,
    required this.phoneNo,
  });

  toJason(){
    return{
      "FirstName" : firstName,
      "Email" : email,
      "Phone" : phoneNo,
    };
  }
}