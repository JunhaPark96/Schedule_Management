class ServerModel {
  final String? serviceGroupName;
  final String? networkConnection;
  final String? environment;
  final String? department;
  final String? serverType;
  final String? osType;
  final String? hostName;
  final String? serviceName;
  final String? ip;
  final String? adminAccount;
  final String? osVersion;
  final DateTime? eoslDate;

  ServerModel({
    this.serviceGroupName,
    this.networkConnection,
    this.environment,
    this.department,
    this.serverType,
    this.osType,
    this.hostName,
    this.serviceName,
    this.ip,
    this.adminAccount,
    this.osVersion,
    this.eoslDate,
  });

  factory ServerModel.fromMap(Map<String, dynamic> map) {
    return ServerModel(
      serviceGroupName: map['service_group_name'],
      networkConnection: map['network_connection'],
      environment: map['environment'],
      department: map['department'],
      serverType: map['server_type'],
      osType: map['os_type'],
      hostName: map['host_name'],
      serviceName: map['service_name'],
      ip: map['ip'],
      adminAccount: map['admin_account'],
      osVersion: map['os_version'],
      eoslDate:
          map['eosl_date'] != null ? DateTime.parse(map['eosl_date']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'service_group_name': serviceGroupName,
      'network_connection': networkConnection,
      'environment': environment,
      'department': department,
      'server_type': serverType,
      'os_type': osType,
      'host_name': hostName,
      'service_name': serviceName,
      'ip': ip,
      'admin_account': adminAccount,
      'os_version': osVersion,
      'eosl_date': eoslDate?.toIso8601String(),
    };
  }
}
