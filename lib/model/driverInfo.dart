// this class for save all driver info+car+status came from data base

class DriverInfo {
  late String userId;
  late String status;
  late String firstName;
  late String lastName;
  late String idNo;
  late String phoneNumber;
  late String email;
  late String personImage;
  late String carBrand;
  late String carColor;
  late String carModel;
  late String carType;
  late String earning;
  late String country;
  late String city;
  late int exPlan;
  late bool update;
  late String tok;
  DriverInfo(
    this.userId,
    this.country,
    this.city,
    this.status,
    this.firstName,
    this.lastName,
    this.idNo,
    this.phoneNumber,
    this.email,
    this.personImage,
    this.carBrand,
    this.carColor,
    this.carModel,
    this.carType,
    this.earning,
    this.exPlan,
    this.update,
    this.tok,
  );
  DriverInfo.fromMap(Map<String, dynamic> map) {
    userId = map["userId"];
    status = map["status"];
    country = map["country"];
    city = map["city"];
    exPlan = map["exPlan"];
    update = map["update"];
    firstName = map["firstName"];
    lastName = map["lastName"];
    idNo = map["idNo"];
    phoneNumber = map["phoneNumber"];
    email = map["email"];
    personImage = map["personImage"];
    earning = map["earning"];
    tok = map["token"];
    carBrand = map["carInfo"]["carBrand"];
    carColor = map["carInfo"]["carColor"];
    carModel = map["carInfo"]["carModel"];
    carType = map["carInfo"]["carType"];
  }
}
