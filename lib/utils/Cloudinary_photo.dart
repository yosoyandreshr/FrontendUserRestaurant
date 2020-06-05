import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class Cloudinary {
  Future<String> uploadPhoto(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/sclents22/image/upload?upload_preset=iatmssmo');
    final mimeType = mime(image.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print(resp.body);
      return null;
    }

    final respData = jsonDecode(resp.body);
    //print(respData);
    return respData['secure_url'];
  }
}
