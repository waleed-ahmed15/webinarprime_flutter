class MessageModel {
  Conversation? conversation;
  Messages? message;

  MessageModel({this.conversation, this.message});

  MessageModel.fromJson(Map<String, dynamic> json) {
    conversation = json['conversation'] != null
        ? Conversation.fromJson(json['conversation'])
        : null;
    message =
        json['message'] != null ? Messages.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (conversation != null) {
      data['conversation'] = conversation!.toJson();
    }
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Conversation {
  String? sId;
  List<Users>? users;
  List<Messages>? messages;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Conversation(
      {this.sId,
      this.users,
      this.messages,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Conversation.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(Messages.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Users {
  List<String>? bannedChats;
  String? sId;
  String? name;
  String? profileImage;
  String? accountType;

  Users(
      {this.bannedChats,
      this.sId,
      this.name,
      this.profileImage,
      this.accountType});

  Users.fromJson(Map<String, dynamic> json) {
    bannedChats = json['bannedChats'].cast<String>();
    sId = json['_id'];
    name = json['name'];
    profileImage = json['profile_image'];
    accountType = json['accountType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bannedChats'] = bannedChats;
    data['_id'] = sId;
    data['name'] = name;
    data['profile_image'] = profileImage;
    data['accountType'] = accountType;
    return data;
  }
}

class Messages {
  String? sId;
  From? from;
  String? text;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Messages(
      {this.sId,
      this.from,
      this.text,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Messages.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    from = json['from'] != null ? From.fromJson(json['from']) : null;
    text = json['text'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (from != null) {
      data['from'] = from!.toJson();
    }
    data['text'] = text;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class From {
  String? sId;
  String? name;
  String? profileImage;

  From({this.sId, this.name, this.profileImage});

  From.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['profile_image'] = profileImage;
    return data;
  }
}
