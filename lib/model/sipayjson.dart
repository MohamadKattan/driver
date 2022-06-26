import 'package:json_annotation/json_annotation.dart';

part 'sipayjson.g.dart';

@JsonSerializable()

class SiPayModel {
  String? ccHolderName;
  String? ccNo;
  int? expiryMonth;
  int? expiryYear;
  int? cvv;
  String? currencyCode;
  int? installmentsNumber;
  int? invoiceId;
  String? invoiceDescription;
  String? name;
  String? surname;
  double? total;
  String? merchantKey;
  String? items;
  String? cancelUrl;
  String? returnUrl;
  String? hashKey;
  int? orderType;

  SiPayModel(
      { this.ccHolderName,
        this.ccNo,
        this.expiryMonth,
        this.expiryYear,
        this.cvv,
        this.currencyCode,
        this.installmentsNumber,
        this.invoiceId,
        this.invoiceDescription,
        this.name,
        this.surname,
        this.total,
        this.merchantKey,
        this.items,
        this.cancelUrl,
        this.returnUrl,
        this.hashKey,
        this.orderType,
      });

  factory SiPayModel.fromJson(Map<String, dynamic> json) => _$SiPayModelFromJson(json);

  Map<String, dynamic> toJson() => _$SiPayModelToJson(this);

//   // Autogenerated.fromJson(Map<String, dynamic> json) {
//   //   ccHolderName = json['cc_holder_name'];
//   //   ccNo = json['cc_no'];
//   //   expiryMonth = json['expiry_month'];
//   //   expiryYear = json['expiry_year'];
//   //   cvv = json['cvv'];
//   //   currencyCode = json['currency_code'];
//   //   installmentsNumber = json['installments_number'];
//   //   invoiceId = json['invoice_id'];
//   //   invoiceDescription = json['invoice_description'];
//   //   name = json['name'];
//   //   surname = json['surname'];
//   //   total = json['total'];
//   //   merchantKey = json['merchant_key'];
//   //   items = json['items'];
//   //   cancelUrl = json['cancel_url'];
//   //   returnUrl = json['return_url'];
//   //   hashKey = json['hash_key'];
//   //   orderType = json['order_type'];
//   // }
//
//   // factory Autogenerated.fromJson(Map<String,dynamic>json)=>_$AutogeneratedFromJson(json);
// // Map<String, dynamic>toJson()=>_$AutogeneratedToJson(this);
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['cc_holder_name'] = ccHolderName;
//     data['cc_no'] = ccNo;
//     data['expiry_month'] = expiryMonth;
//     data['expiry_year'] = expiryYear;
//     data['cvv'] = cvv;
//     data['currency_code'] = currencyCode;
//     data['installments_number'] = installmentsNumber;
//     data['invoice_id'] = invoiceId;
//     data['invoice_description'] = invoiceDescription;
//     data['name'] = name;
//     data['surname'] = surname;
//     data['total'] = total;
//     data['merchant_key'] = merchantKey;
//     data['items'] = items;
//     data['cancel_url'] = cancelUrl;
//     data['return_url'] = returnUrl;
//     data['hash_key'] = hashKey;
//     data['order_type'] = orderType;
//     return data;
//   }
}




