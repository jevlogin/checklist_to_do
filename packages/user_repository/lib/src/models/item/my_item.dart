import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_item.g.dart';

@JsonSerializable()
class MyItem extends Equatable {
  final String userId;
  final String title;
  final DateTime? timestamp;

  const MyItem(
      {required this.userId, required this.title, required this.timestamp});

  static const empty = MyItem(
    userId: '',
    title: '',
    timestamp: null,
  );

  MyItem copyWith({
    String? userId,
    String? title,
    DateTime? timestamp,
  }) {
    return MyItem(
        userId: userId ?? this.userId,
        title: title ?? this.title,
        timestamp: timestamp ?? this.timestamp);
  }

  factory MyItem.fromJson(Map<String, dynamic> json) => _$MyItemFromJson(json);

  Map<String, dynamic> toJson() => _$MyItemToJson(this);

  @override
  List<Object?> get props => [userId, title, timestamp];
}
