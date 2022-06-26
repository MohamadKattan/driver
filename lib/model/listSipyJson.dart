import 'package:driver/model/sipayjson.dart';

import 'package:json_annotation/json_annotation.dart';

part 'listSipyJson.g.dart';

@JsonSerializable()
class ListSiPayModel{
  List<SiPayModel>?siPayList;
  ListSiPayModel({this.siPayList});

  factory ListSiPayModel.fromJson(Map<String, dynamic> json) => _$ListSiPayModelFromJson(json);

  Map<String, dynamic> toJson() => _$ListSiPayModelToJson(this);
}