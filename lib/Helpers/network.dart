import 'package:http/http.dart' as http;

// network call will contain all http methods

class Network {
  static Future get(url) async {
    try {
      final uri = Uri.parse(url);
      final result = await http.get(
        uri,
      );
      return result;
    } catch (e) {
      print("Error From get method helper function");
      rethrow;
    }
  }
}
