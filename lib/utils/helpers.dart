import 'dart:convert';
import 'dart:math';

String generateBase64Auth(String username, String password) {
  // Concatenate username and password in the "username:password" format
  String credentials = '$username:$password';

  // Encode the credentials using Base64
  String encoded = base64Encode(utf8.encode(credentials));

  // Return the final Base64 string
  return encoded;
}

String generateCorrelationId() {
  Random random = Random();
  String correlationId = '';

  for (int i = 0; i < 13; i++) {
    correlationId +=
        random.nextInt(10).toString(); // Generate random digit between 0-9
  }

  return correlationId;
}
