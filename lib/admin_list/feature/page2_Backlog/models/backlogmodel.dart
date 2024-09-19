class BacklogModel {
  final String Qname, Backlog;

  BacklogModel(this.Backlog, this.Qname);

  BacklogModel.fromjson(Map<String, dynamic> json)
      : Qname = json['Qname'],
        Backlog = json['Backlog'];
}
