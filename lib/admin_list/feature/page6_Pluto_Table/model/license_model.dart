class LicenseModel {
  final int id;
  final dynamic lname;
  final dynamic category;
  final dynamic hostname;
  final dynamic ip;
  final dynamic rank;
  final dynamic cnt;
  final dynamic pl;
  final dynamic nuprac;
  final dynamic nup;
  final dynamic rac;
  final dynamic version;
  final dynamic exp_date;
  final int index;

  LicenseModel({
    required this.id,
    required this.lname,
    required this.category,
    required this.hostname,
    required this.ip,
    required this.rank,
    required this.cnt,
    required this.pl,
    required this.nuprac,
    required this.nup,
    required this.rac,
    required this.version,
    required this.exp_date,
    required this.index,
  });

  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    return LicenseModel(
      id: json["id"],
      lname: json["lname"],
      category: json["category"],
      hostname: json["hostname"],
      ip: json["ip"],
      rank: json["rank"],
      cnt: json["cnt"],
      pl: json["pl"],
      nuprac: json["nuprac"],
      nup: json["nup"],
      rac: json["rac"],
      version: json["version"],
      exp_date: json["exp_date"],
      index: json["index"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "lname": lname,
      "category": category,
      "hostname": hostname,
      "ip": ip,
      "rank": rank,
      "cnt": cnt,
      "pl": pl,
      "nuprac": nuprac,
      "nup": nup,
      "rac": rac,
      "version": version,
      "exp_date": exp_date,
      "index": index,
    };
  }
}
