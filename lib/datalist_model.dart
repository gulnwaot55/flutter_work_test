class DataListModel {
  String? id;
  final String? text;
  late final int? number;

  DataListModel({this.id = '', required this.text, required this.number});

  Map<String, dynamic> toJson() => {'id': id, 'text': text, 'number': number};

  static DataListModel fromJson(Map<String, dynamic> json) => DataListModel(
        id: json["id"],
        text: json['text'],
        number: json['number'],
      );
}
