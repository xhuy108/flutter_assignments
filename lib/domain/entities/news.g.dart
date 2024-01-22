// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewsAdapter extends TypeAdapter<News> {
  @override
  final int typeId = 0;

  @override
  News read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return News(
      id: fields[0] as int,
      title: fields[1] as String,
      summary: fields[2] as String,
      modifiedAt: fields[3] as String,
      image: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, News obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.summary)
      ..writeByte(3)
      ..write(obj.modifiedAt)
      ..writeByte(4)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
