// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyItem _$MyItemFromJson(Map<String, dynamic> json) => MyItem(
      userId: json['userId'] as String,
      title: json['title'] as String,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$MyItemToJson(MyItem instance) => <String, dynamic>{
      'userId': instance.userId,
      'title': instance.title,
      'timestamp': instance.timestamp?.toIso8601String(),
    };
