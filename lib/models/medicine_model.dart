class MedicineModel {
  String? sId;
  String? name;
  OrganizationId? organizationId;
  String? genericName;
  String? dosageForm;
  String? strength;
  String? unit;
  double? unitPrice;
  int? unitsPerStrip;
  double? stripPrice;
  bool? isPrescriptionRequired;
  double? taxRate;
  OrganizationId? categoryId;
  OrganizationId? brandId;
  OrganizationId? createdBy;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? iV;

  MedicineModel(
      {this.sId,
      this.name,
      this.organizationId,
      this.genericName,
      this.dosageForm,
      this.strength,
      this.unit,
      this.unitPrice,
      this.unitsPerStrip,
      this.stripPrice,
      this.isPrescriptionRequired,
      this.taxRate,
      this.categoryId,
      this.brandId,
      this.createdBy,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.iV});

  MedicineModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    organizationId = json['organizationId'] != null
        ? new OrganizationId.fromJson(json['organizationId'])
        : null;
    genericName = json['genericName'];
    dosageForm = json['dosageForm'];
    strength = json['strength'];
    unit = json['unit'];
    unitPrice = json['unitPrice'].toDouble();
    unitsPerStrip = json['unitsPerStrip'];
    stripPrice = json['stripPrice'].toDouble();
    isPrescriptionRequired = json['isPrescriptionRequired'];
    taxRate = json['taxRate'].toDouble();
    categoryId = json['categoryId'] != null
        ? new OrganizationId.fromJson(json['categoryId'])
        : null;
    brandId = json['brandId'] != null
        ? new OrganizationId.fromJson(json['brandId'])
        : null;
    createdBy = json['createdBy'] != null
        ? new OrganizationId.fromJson(json['createdBy'])
        : null;
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    if (this.organizationId != null) {
      data['organizationId'] = this.organizationId!.toJson();
    }
    data['genericName'] = this.genericName;
    data['dosageForm'] = this.dosageForm;
    data['strength'] = this.strength;
    data['unit'] = this.unit;
    data['unitPrice'] = this.unitPrice;
    data['unitsPerStrip'] = this.unitsPerStrip;
    data['stripPrice'] = this.stripPrice;
    data['isPrescriptionRequired'] = this.isPrescriptionRequired;
    data['taxRate'] = this.taxRate;
    if (this.categoryId != null) {
      data['categoryId'] = this.categoryId!.toJson();
    }
    if (this.brandId != null) {
      data['brandId'] = this.brandId!.toJson();
    }
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy!.toJson();
    }
    data['isActive'] = this.isActive;
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
