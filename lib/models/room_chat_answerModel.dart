import 'dart:convert';

class answerModel {
  String? questionId;
  String? answer;
  From? from;
  int? timestamp;

  answerModel({this.questionId, this.answer, this.from, this.timestamp});

  answerModel.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    answer = json['answer'];
    from = json['from'] != null ? From.fromJson(json['from']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['questionId'] = questionId;
    data['answer'] = answer;
    if (from != null) {
      data['from'] = from!.toJson();
    }
    data['timestamp'] = timestamp;
    return data;
  }
}

class From {
  String? identity;
  Metadata? metadata;

  From({this.identity, this.metadata});

  From.fromJson(Map<String, dynamic> json) {
    identity = json['identity'];
    metadata = json['metadata'] != null
        ? Metadata.fromJson(jsonDecode(json['metadata']))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identity'] = identity;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    return data;
  }
}

class Metadata {
  String? sId;
  String? name;
  String? profileImage;
  String? accountType;

  Metadata({this.sId, this.name, this.profileImage, this.accountType});

  Metadata.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImage = json['profile_image'];
    accountType = json['accountType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['profile_image'] = profileImage;
    data['accountType'] = accountType;
    return data;
  }
}
