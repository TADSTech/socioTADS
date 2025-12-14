import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GitHubService {
  final String owner = "TADSTech";
  final String repo = "socioTADS";
  final String path = "json/content.json";
  final String imagesPath = "images";
  
  String get token {
    try {
      return dotenv.env['GIT_PAT'] ?? "YOUR_PERSONAL_ACCESS_TOKEN";
    } catch (e) {
      // dotenv not initialized yet
      return "YOUR_PERSONAL_ACCESS_TOKEN";
    }
  }

  Map<String, String> get _headers => {
    'Authorization': 'token $token',
    'Accept': 'application/vnd.github.v3+json',
    'Content-Type': 'application/json',
  };

  /// Upload image from bytes (works on both web and desktop)
  Future<String> uploadImageBytes(Uint8List bytes, String fileName) async {
    try {
      final base64Content = base64Encode(bytes);
      final uniqueFileName = 'img_${DateTime.now().millisecondsSinceEpoch}_$fileName';
      
      final url = Uri.https(
        'api.github.com',
        '/repos/$owner/$repo/contents/.github/$imagesPath/$uniqueFileName',
      );

      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode({
          "message": "App: Uploaded image $uniqueFileName",
          "content": base64Content,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Upload timeout'),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content']['download_url'] ?? '';
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to upload image');
      }
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPosts() async {
    try {
      final fileData = await fetchCurrentFile();
      final List<dynamic> content = fileData['content'] ?? [];
      return List<Map<String, dynamic>>.from(content.map((post) => Map<String, dynamic>.from(post as Map)));
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  Future<Map<String, dynamic>> fetchCurrentFile() async {
    final url = Uri.https(
      'api.github.com',
      '/repos/$owner/$repo/contents/.github/$path',
    );

    try {
      final response = await http.get(url, headers: _headers).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 404) {
        return {'sha': null, 'content': []};
      }

      if (response.statusCode != 200) {
        throw Exception('GitHub API Error: ${response.statusCode} - ${response.body}');
      }

      final data = jsonDecode(response.body);
      final String base64Content = data['content'].replaceAll('\n', '');
      final String sha = data['sha'];

      final String rawJson = utf8.decode(base64Decode(base64Content));
      final List<dynamic> jsonList = jsonDecode(rawJson);

      return {
        'sha': sha,
        'content': jsonList,
      };
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> createPost(Map<String, dynamic> newPost) async {
    try {
      final fileData = await fetchCurrentFile();
      final String? currentSha = fileData['sha'];
      final List<dynamic> currentPosts = fileData['content'] ?? [];

      currentPosts.add(newPost);

      final String updatedJsonString = jsonEncode(currentPosts);
      final String base64Content = base64Encode(utf8.encode(updatedJsonString));

      final url = Uri.https(
        'api.github.com',
        '/repos/$owner/$repo/contents/.github/$path',
      );

      final Map<String, dynamic> bodyMap = {
        "message": "App: Created new post (ID: ${newPost['id']})",
        "content": base64Content,
      };

      if (currentSha != null) {
        bodyMap['sha'] = currentSha;
      }

      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(bodyMap),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorBody = jsonDecode(response.body);
        final message = errorBody['message'] ?? 'Unknown error';
        throw Exception('GitHub API Error: $message');
      }
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  /// Trigger a GitHub Actions workflow
  Future<void> triggerWorkflow(String workflowId, {Map<String, String>? inputs}) async {
    try {
      final url = Uri.https(
        'api.github.com',
        '/repos/$owner/$repo/actions/workflows/$workflowId/dispatches',
      );

      final Map<String, dynamic> body = {
        'ref': 'main',
      };

      if (inputs != null && inputs.isNotEmpty) {
        body['inputs'] = inputs;
      }

      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(body),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Request timeout'),
      );

      // 204 No Content is the success response for workflow dispatch
      if (response.statusCode != 204) {
        final errorBody = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        final message = errorBody['message'] ?? 'Failed to trigger workflow (Status: ${response.statusCode})';
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Failed to trigger workflow: $e');
    }
  }
}