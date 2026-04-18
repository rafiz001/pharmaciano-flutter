class BatchModel {
  String? sId;
  OrganizationId? organizationId;
  OrganizationId? branchId;
  String? medicineName;
  MedicineId? medicineId;
  String? batchNo;
  String? expiryDate;
  int? quantity;
  double? purchasePrice;
  OrganizationId? warehouseId;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  BatchModel({
    this.sId,
    this.organizationId,
    this.branchId,
    this.medicineName,
    this.medicineId,
    this.batchNo,
    this.expiryDate,
    this.quantity,
    this.purchasePrice,
    this.warehouseId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  BatchModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    organizationId = json['organizationId'] != null
        ? new OrganizationId.fromJson(json['organizationId'])
        : null;
    branchId = json['branchId'] != null
        ? new OrganizationId.fromJson(json['branchId'])
        : null;
    medicineName = json['medicineName'];
    medicineId = json['medicineId'] != null
        ? new MedicineId.fromJson(json['medicineId'])
        : null;
    batchNo = json['batchNo'];
    expiryDate = json['expiryDate'];
    quantity = json['quantity'];
    purchasePrice = json['purchasePrice'].toDouble();
    warehouseId = json['warehouseId'] != null
        ? new OrganizationId.fromJson(json['warehouseId'])
        : null;
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.organizationId != null) {
      data['organizationId'] = this.organizationId!.toJson();
    }
    if (this.branchId != null) {
      data['branchId'] = this.branchId!.toJson();
    }
    data['medicineName'] = this.medicineName;
    if (this.medicineId != null) {
      data['medicineId'] = this.medicineId!.toJson();
    }
    data['batchNo'] = this.batchNo;
    data['expiryDate'] = this.expiryDate;
    data['quantity'] = this.quantity;
    data['purchasePrice'] = this.purchasePrice;
    if (this.warehouseId != null) {
      data['warehouseId'] = this.warehouseId!.toJson();
    }
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class OrganizationId {
  String? sId;
  String? name;

  OrganizationId({this.sId, this.name});

  OrganizationId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class MedicineId {
  String? sId;
  String? name;
  String? strength;
  String? unit;

  MedicineId({this.sId, this.name, this.strength, this.unit});

  MedicineId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    strength = json['strength'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['strength'] = this.strength;
    data['unit'] = this.unit;
    return data;
  }
}
