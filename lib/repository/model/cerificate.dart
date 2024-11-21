class Certificate {
  String? certificateName;
  int ? status;
  String? certificateUrl;
  DateTime? createTime;
  DateTime? updateTime;

  Certificate({
    this.certificateName,
    this.status,
    this.certificateUrl,
    this.createTime,
    this.updateTime,
  });

  Certificate.fromJson(Map<String, dynamic> json) {
    certificateName = json['certificateName'];
    status = json['aiStatus'];
    certificateUrl = json['certificatePicUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      'certificateName': certificateName,
      'certificatePicUrl': certificateUrl,
      'ai_status': status,
    };
  }
}
