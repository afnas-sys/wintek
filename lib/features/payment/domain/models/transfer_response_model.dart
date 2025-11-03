class TransferResponseModel {
  final String status;
  final String message;
  final Map<String, dynamic>? data;

  TransferResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory TransferResponseModel.fromJson(Map<String, dynamic> json) {
    return TransferResponseModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (data != null) 'data': data,
    };
  }
}
