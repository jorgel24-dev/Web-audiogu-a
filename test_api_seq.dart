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

  for (int i = 0; i < 20; i++) {
    final bodyJson = {
      'name': 'Test Monumento Sequence ${i}',
      'description': [],
      "coordenates": {"lon": -4.0321, "lat": 37.7214},
      'accessibility': false,
      'isActive': true,
      'maps_url': 'https://www.google.com/maps?q=37.7214,-4.0321',
      'tag': {'id': 1},
      "picture": [],
      'audio': [
        {
          "url": "https://example.com/audio${i}.mp3",
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

    print('Attempt ${i+1}: Status: ${response.statusCode}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Success!');
      break;
    }
  }
}
