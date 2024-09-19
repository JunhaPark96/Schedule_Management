class L3GroupModel {
  final int group_seq;
  final String? L3, adminUser, adminLeader, description;

  L3GroupModel({
    required this.group_seq,
    this.L3,
    this.adminUser,
    this.adminLeader,
    this.description,
  });

  factory L3GroupModel.fromJson(Map<String, dynamic> json) {
    return L3GroupModel(
      group_seq: json["group_seq"],
      L3: json["l3"],
      adminUser: json["admin_user"],
      adminLeader: json["admin_leader"],
      description: json["description"],
    );
  }

  // //update
  // Map<String, dynamic> toJson() {
  //   return {
  //     "group_seq": group_seq,
  //     "l3": L3,
  //     "admin_user": adminUser,
  //     "admin_leader": adminLeader,
  //     "description": description
  //   };
  // }
}
