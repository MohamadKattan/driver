// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sipayjson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SiPayModel _$SiPayModelFromJson(Map<String, dynamic> json) => SiPayModel(
      ccHolderName: json['ccHolderName'] as String?,
      ccNo: json['ccNo'] as String?,
      expiryMonth: json['expiryMonth'] as int?,
      expiryYear: json['expiryYear'] as int?,
      cvv: json['cvv'] as int?,
      currencyCode: json['currencyCode'] as String?,
      installmentsNumber: json['installmentsNumber'] as int?,
      invoiceId: json['invoiceId'] as int?,
      invoiceDescription: json['invoiceDescription'] as String?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      total: (json['total'] as num?)?.toDouble(),
      merchantKey: json['merchantKey'] as String?,
      items: json['items'] as String?,
      cancelUrl: json['cancelUrl'] as String?,
      returnUrl: json['returnUrl'] as String?,
      hashKey: json['hashKey'] as String?,
      orderType: json['orderType'] as int?,
    );

Map<String, dynamic> _$SiPayModelToJson(SiPayModel instance) =>
    <String, dynamic>{
      'ccHolderName': instance.ccHolderName,
      'ccNo': instance.ccNo,
      'expiryMonth': instance.expiryMonth,
      'expiryYear': instance.expiryYear,
      'cvv': instance.cvv,
      'currencyCode': instance.currencyCode,
      'installmentsNumber': instance.installmentsNumber,
      'invoiceId': instance.invoiceId,
      'invoiceDescription': instance.invoiceDescription,
      'name': instance.name,
      'surname': instance.surname,
      'total': instance.total,
      'merchantKey': instance.merchantKey,
      'items': instance.items,
      'cancelUrl': instance.cancelUrl,
      'returnUrl': instance.returnUrl,
      'hashKey': instance.hashKey,
      'orderType': instance.orderType,
    };
