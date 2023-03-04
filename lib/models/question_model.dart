import 'dart:convert';

class QuestionAnswerModel {
  String? id;
  String? question;
  From? from;
  int? timestamp;
  List<Answers>? answers;

  QuestionAnswerModel(
      {this.id, this.question, this.from, this.timestamp, this.answers});

  QuestionAnswerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    from = json['from'] != null ? From.fromJson(json['from']) : null;
    timestamp = json['timestamp'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    if (from != null) {
      data['from'] = from!.toJson();
    }
    data['timestamp'] = timestamp;
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
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

class Answers {
  String? questionId;
  String? answer;
  From? from;
  int? timestamp;

  Answers({this.questionId, this.answer, this.from, this.timestamp});

  Answers.fromJson(Map<String, dynamic> json) {
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
