import 'dart:convert';
import 'package:general_insurance_management/model/policy_model.dart';
import 'package:general_insurance_management/service/Auth_Service.dart';
import 'package:dio/dio.dart';

final Dio _dio = Dio();
final AuthService authService = AuthService();

class CreateFirePolicyService {
  final String apiUrl = 'http://localhost:8080/api/policy/save';

  Future<PolicyModel?> createFirePolicy(PolicyModel policy) async {
    final formData = FormData();
    formData.fields.add(MapEntry('policy', jsonEncode(policy.toJson())));

    final token = await authService.getToken();
    final headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await _dio.post(
        apiUrl, // No need to append 'save' here again
        data: formData,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return PolicyModel.fromJson(data);
      } else {
        print('Error creating policy: ${response.statusCode}');
        return null;
      }
    } on DioError catch (e) {
      print('Error creating policy: ${e.message}');
      return null;
    }
  }
}
