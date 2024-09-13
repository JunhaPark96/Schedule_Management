class TodoModel {
  final String? id;
  final String? userId;
  final String? title;
  final String? description;
  final bool? isCompleted;
  final String? createdAt;
  final String? updatedAt;

  TodoModel({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.isCompleted,
    this.createdAt,
    this.updatedAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json["id"],
      userId: json["userid"],
      title: json["title"],
      description: json["description"],
      isCompleted: json["iscompleted"].toString().toLowerCase() == "true",
      createdAt: json["createdat"],
      updatedAt: json["updatedat"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userid": userId,
      "title": title,
      "description": description,
      "iscompleted": isCompleted.toString(),
      "createdat": createdAt,
      "updatedat": updatedAt,
    };
  }
}
