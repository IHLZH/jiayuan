class StandardPrice {
  double? referencePrice; // 标准价格

  double? lowestPrice; // 最低价格

  int? typeId;

  StandardPrice({
    required this.referencePrice,
    required this.lowestPrice,
    required int typeId,
  });

  StandardPrice.fromJson(Map<String, dynamic> json) {
    referencePrice = json['averagePrice'];
    lowestPrice = json['minPrice'];
    typeId = json['serviceId'];
  }
}
