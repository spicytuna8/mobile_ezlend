class ResponsePackageIndex {
  final int status;
  final DataPackageIndex data;

  ResponsePackageIndex({
    required this.status,
    required this.data,
  });

  factory ResponsePackageIndex.fromJson(Map<String, dynamic> json) {
    return ResponsePackageIndex(
      status: json['status'],
      data: DataPackageIndex.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class DataPackageIndex {
  final List<ItemPackageIndex> items;
  final Pagination pagination;

  DataPackageIndex({
    required this.items,
    required this.pagination,
  });

  factory DataPackageIndex.fromJson(Map<String, dynamic> json) {
    return DataPackageIndex(
      items: List<ItemPackageIndex>.from(
        json['items'].map((item) => ItemPackageIndex.fromJson(item)),
      ),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class ItemPackageIndex {
  final int id;
  final String name;
  final String amount;
  final DateTime createdAt;
  final int createdBy;
  final DateTime updatedAt;
  final int updatedBy;
  final int status;
  final String remark;
  final String rate;
  final int returnDay;

  ItemPackageIndex({
    required this.id,
    required this.name,
    required this.amount,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.status,
    required this.remark,
    required this.rate,
    required this.returnDay,
  });

  factory ItemPackageIndex.fromJson(Map<String, dynamic> json) {
    return ItemPackageIndex(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      createdAt: DateTime.parse(json['created_at']),
      createdBy: json['created_by'],
      updatedAt: DateTime.parse(json['updated_at']),
      updatedBy: json['updated_by'],
      status: json['status'],
      remark: json['remark'],
      rate: json['rate'],
      returnDay: json['return_day'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'created_at': createdAt.toIso8601String(),
      'created_by': createdBy,
      'updated_at': updatedAt.toIso8601String(),
      'updated_by': updatedBy,
      'status': status,
      'remark': remark,
      'rate': rate,
      'return_day': returnDay,
    };
  }
}

class Pagination {
  final int totalCount;
  final int pageCount;
  final dynamic currentPage;
  final dynamic perPage;

  Pagination({
    required this.totalCount,
    required this.pageCount,
    required this.currentPage,
    required this.perPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalCount: json['total_count'],
      pageCount: json['page_count'],
      currentPage: json['current_page'],
      perPage: json['per_page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_count': totalCount,
      'page_count': pageCount,
      'current_page': currentPage,
      'per_page': perPage,
    };
  }
}
