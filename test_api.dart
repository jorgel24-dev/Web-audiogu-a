import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Basic YWRtaW46YWRtaW4xMjM=',
    'Access-Control-Allow-Origin': '*',
  };

  final uri = Uri.parse('https://backend-tfg.fly.dev/api/v1/admin/monuments');

  final bodyJson = {
    'name': 'Test Monumento with Audio 4',
    'description': [],
    "coordenates": {"lon": -4.0321, "lat": 37.7214},
    'accessibility': false,
    'isActive': true,
    'maps_url': 'https://www.google.com/maps?q=37.7214,-4.0321',
    'tag': {'id': 1},
    "picture": [],
    'audio': [
      {
        "id": 1,
        "url": "https://example.com/audio.mp3",
        "kids": false,
        "language": "es"
      }
    ],
    'localidad_id': 1,
    'NLikes': 142,
  };

  final response = await http.post(
    uri,
    headers: _headers,
    body: jsonEncode(bodyJson),
  );

  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');
}
