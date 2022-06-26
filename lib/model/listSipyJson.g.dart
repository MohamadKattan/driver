// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listSipyJson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListSiPayModel _$ListSiPayModelFromJson(Map<String, dynamic> json) =>
    ListSiPayModel(
      siPayList: (json['siPayList'] as List<dynamic>?)
          ?.map((e) => SiPayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListSiPayModelToJson(ListSiPayModel instance) =>
    <String, dynamic>{
      'siPayList': instance.siPayList,
    };
