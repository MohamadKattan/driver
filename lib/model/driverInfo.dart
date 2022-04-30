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
  late String carImage;
  late String carModel;
  late String carType;
  late String earning;
  late String country;
  // late String history;
  DriverInfo(
      this.userId,
      this.country,
      this.status,
      this.firstName,
      this.lastName,
      this.idNo,
      this.phoneNumber,
      this.email,
      this.personImage,
      this.carBrand,
      this.carColor,
      this.carImage,
      this.carModel,
      this.carType,
      this.earning,
      // this.history
      );
  DriverInfo.fromMap(Map<String, dynamic> map) {
    userId = map["userId"];
    status = map["status"];
    country = map["country"];
    firstName = map["firstName"];
    lastName = map["lastName"];
    idNo = map["idNo"];
    phoneNumber = map["phoneNumber"];
    email = map["email"];
    personImage = map["personImage"];
    earning= map["earning"];
    carBrand = map["carInfo"]["carBrand"];
    carColor = map["carInfo"]["carColor"];
    carModel = map["carInfo"]["carModel"];
    carType = map["carInfo"]["carType"];
  }
}
