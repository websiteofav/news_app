class ErrorModel {
  final String? status;
  final String? message;
  final String? code;

  ErrorModel({
    this.status,
    this.message,
    this.code,
  });

  static ErrorModel fromJson(Map<String, dynamic> json) => ErrorModel(
      code: json['code'] as String,
      message: json['message'] as String,
      status: json['status'] as String);
}
