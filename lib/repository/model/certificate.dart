class Certificate {
  String?  certName;
  String? imageUrl;
  int? status;
  DateTime? createdTime;
  DateTime? updatedTime;
  Certificate({this.certName, this.imageUrl, this.status,this.createdTime,this.updatedTime});

  Certificate.fromJson(Map<String, dynamic> json) {
    certName = json['certificateName'];
    imageUrl = (json['certificatePicUrl']?.cast<String>() ?? [])[0];
    status = json['aiStatus'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['certificateName'] = this.certName;
    data['certificatePicUrl'] = [this.imageUrl];
    data['aiStatus'] = this.status;
    data['createdTime'] = this.createdTime;
    data['updatedTime'] = this.updatedTime;
    return data;
  }
}
