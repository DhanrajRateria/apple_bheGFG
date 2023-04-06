class Block {
  late String id;
  late String orderId;
  late String orderName;
  late String billType;
  late String value;
  late DateTime created;

  Block({
    required this.id,
    required this.created,
    required this.value,
    required this.orderId,
    required this.orderName,
    required this.billType,
  });

  Block.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        orderId = json['orderId'],
        orderName = json['orderName'],
        billType = json['billType'],
        value = json['value'],
        created = json['created'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": orderId,
        "body": orderName,
        "billType": billType,
        "value": value,
        "created": created.toIso8601String(),
      };
}
