import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/custom_exception.dart';
import '../model/image_generation_model.dart';
import 'image_generation_remote_data_source.dart';

class ImageGenerationRemoteDataSourceImpl
    implements ImageGenerationRemoteDataSource {
  final http.Client httpClient;

  ImageGenerationRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<ImageGenerationModel> getGenerateImages(String query) async {
    const String _endPoint = "images/generations";

    // ['256x256', '512x512', '1024x1024']
    Map<String, dynamic> rowParams = {
      "n": 10,
      "size": "256x256",
      "prompt": query,
    };

    final encodedParams = json.encode(rowParams);

    final response = await httpClient.post(
      Uri.parse((_endPoint)),
      body: encodedParams,
      // headers: (OPEN_AI_KEY),
    );

    if (response.statusCode == 200) {
      return ImageGenerationModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: "Image Generation Server Exception");
    }
  }
}
