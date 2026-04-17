class UserModel {
  bool? success;
  String? message;
  Data? data;

  UserModel({this.success, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Profile? profile;

  Data({this.profile});

  Data.fromJson(Map<String, dynamic> json) {
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? sId;
  String? email;
  String? name;
  RoleId? roleId;
  OrganizationId? organizationId;
  OrganizationId? branchId;
  Null? warehouseId;
  String? phone;
  bool? isActive;
  String? lastLogin;
  String? createdAt;
  String? updatedAt;
  int? iV;
  CreatedBy? createdBy;

  Profile(
      {this.sId,
      this.email,
      this.name,
      this.roleId,
      this.organizationId,
      this.branchId,
      this.warehouseId,
      this.phone,
      this.isActive,
      this.lastLogin,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.createdBy});

  Profile.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
    roleId =
        json['roleId'] != null ? new RoleId.fromJson(json['roleId']) : null;
    organizationId = json['organizationId'] != null
        ? new OrganizationId.fromJson(json['organizationId'])
        : null;
    branchId = json['branchId'] != null
        ? new OrganizationId.fromJson(json['branchId'])
        : null;
    warehouseId = json['warehouseId'];
    phone = json['phone'];
    isActive = json['isActive'];
    lastLogin = json['lastLogin'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    createdBy = json['createdBy'] != null
        ? new CreatedBy.fromJson(json['createdBy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['name'] = this.name;
    if (this.roleId != null) {
      data['roleId'] = this.roleId!.toJson();
    }
    if (this.organizationId != null) {
      data['organizationId'] = this.organizationId!.toJson();
    }
    if (this.branchId != null) {
      data['branchId'] = this.branchId!.toJson();
    }
    data['warehouseId'] = this.warehouseId;
    data['phone'] = this.phone;
    data['isActive'] = this.isActive;
    data['lastLogin'] = this.lastLogin;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.createdBy != null) {
      data['createdBy'] = this.createdBy!.toJson();
    }
    return data;
  }
}

class RoleId {
  String? name;
  String? description;
  List<String>? permissions;

  RoleId({this.name, this.description, this.permissions});

  RoleId.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    permissions = json['permissions'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['permissions'] = this.permissions;
    return data;
  }
}

class OrganizationId {
  Contact? contact;
  String? name;
  String? address;

  OrganizationId({this.contact, this.name, this.address});

  OrganizationId.fromJson(Map<String, dynamic> json) {
    contact =
        json['contact'] != null ? new Contact.fromJson(json['contact']) : null;
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contact != null) {
      data['contact'] = this.contact!.toJson();
    }
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }
}

class Contact {
  String? phone;
  String? email;

  Contact({this.phone, this.email});

  Contact.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['email'] = this.email;
    return data;
  }
}

class CreatedBy {
  String? email;
  String? name;

  CreatedBy({this.email, this.name});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    return data;
  }
}
