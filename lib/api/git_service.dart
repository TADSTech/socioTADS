import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHubService {
  // ---------------- CONFIGURATION ----------------
  final String owner = "YOUR_GITHUB_USER";
  final String repo = "YOUR_REPO_NAME";
  final String path = ".github/json/content.json"; // Path inside the repo
  
  // ⚠️ SECURITY: On Web, use a proxy. On Desktop, env vars are better.
  final String token = "YOUR_PERSONAL_ACCESS_TOKEN"; 
  // -----------------------------------------------

  // Helper to get headers
  Map<String, String> get _headers => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/vnd.github.v3+json',
    'Content-Type': 'application/json',
  };

  /// 1. READ the current schedule from GitHub
  Future<Map<String, dynamic>> fetchCurrentFile() async {
    final url = Uri.parse('https://api.github.com/repos/$owner/$repo/contents/$path');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 404) {
      // File doesn't exist yet, return empty defaults
      return {'sha': null, 'content': []};
    }

    if (response.statusCode != 200) {
      throw Exception('GitHub API Error: ${response.statusCode} - ${response.body}');
    }

    final data = jsonDecode(response.body);
    final String base64Content = data['content'].replaceAll('\n', ''); // Clean newlines
    final String sha = data['sha'];

    // Decode Base64 -> String -> JSON List
    final String rawJson = utf8.decode(base64Decode(base64Content));
    final List<dynamic> jsonList = jsonDecode(rawJson);

    return {
      'sha': sha,
      'content': jsonList,
    };
  }

  /// 2. UPDATE & PUSH (Commit) the new schedule
  Future<void> pushNewPost(Map<String, dynamic> newPost) async {
    // A. Fetch current data to get the latest SHA (Optimistic Locking)
    final fileData = await fetchCurrentFile();
    final String? currentSha = fileData['sha'];
    final List<dynamic> currentPosts = fileData['content'];

    // B. Append your new post
    currentPosts.add(newPost);

    // C. Encode back to Base64
    final String updatedJsonString = jsonEncode(currentPosts); // Pretty print optional
    final String base64Content = base64Encode(utf8.encode(updatedJsonString));

    // D. The "Commit" Request
    final url = Uri.parse('https://api.github.com/repos/$owner/$repo/contents/$path');
    final body = jsonEncode({
      "message": "📱 App: Scheduled new post (ID: ${newPost['id']})", // Commit message
      "content": base64Content,
      "sha": currentSha // Required so you don't overwrite someone else's work
    });

    // If file didn't exist (sha is null), remove 'sha' field from body for initial create
    final Map<String, dynamic> bodyMap = jsonDecode(body);
    if (currentSha == null) bodyMap.remove('sha');

    final response = await http.put(
      url, 
      headers: _headers, 
      body: jsonEncode(bodyMap)
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Successfully committed to GitHub!");
    } else {
      throw Exception("❌ Failed to push: ${response.body}");
    }
  }
}