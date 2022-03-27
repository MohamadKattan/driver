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
  late String driverLis;
  late String carLis;
  late String carBrand;
  late String carColor;
  late String carImage;
  late String carModel;
  late String carType;
  DriverInfo(
      this.userId,
      this.status,
      this.firstName,
      this.lastName,
      this.idNo,
      this.phoneNumber,
      this.email,
      this.driverLis,
      this.carLis,
      this.personImage,
      this.carBrand,
      this.carColor,
      this.carImage,
      this.carModel,
      this.carType);
  DriverInfo.fromMap(Map<String, dynamic> map) {
    userId = map["userId"];
    status = map["status"];
    firstName = map["firstName"];
    lastName = map["lastName"];
    idNo = map["idNo"];
    phoneNumber = map["phoneNumber"];
    email = map["email"];
    personImage = map["personImage"];
    driverLis = map["driverLis"];
    carLis = map["carLis"];
    carBrand = map["carInfo"]["carBrand"];
    carColor = map["carInfo"]["carColor"];
    carModel = map["carInfo"]["carModel"];
    carType = map["carInfo"]["carType"];
  }
}
