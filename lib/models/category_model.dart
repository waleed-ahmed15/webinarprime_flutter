class CategoryModel {
  String? name;
  String? image;
  String? slug;
  String? id;

  CategoryModel({this.name, this.image, this.slug});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    slug = json['slug'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = image;
    data['slug'] = slug;
    data['_id'] = id;
    return data;
  }
}
