class StandardPrice {
  double? referencePrice; // 标准价格

  double? lowestPrice; // 最低价格

  int? typeId;

  StandardPrice({
    required this.referencePrice,
    required this.lowestPrice,
    required int typeId,
  });
}
