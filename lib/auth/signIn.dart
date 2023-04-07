import 'package:flutter/material.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import '../globals.dart';

Future<User?> signInUsingEmailPassword({required String email, required String password}) async {
  // This URL is an endpoint that's provided by the authorization server. It's
// usually included in the server's documentation of its OAuth2 API.
  final authorizationEndpoint = Uri.https('test-api1.zebra.com','/v1/user/token');
// The authorization server may issue each client a separate client
// identifier and secret, which allows the server to tell which client
// is accessing it. Some servers may also have an anonymous
// identifier/secret pair that any client may use.
//
// Some servers don't require the client to authenticate itself, in which case
// these should be omitted.
  final identifier = 'GDkrGSAXqZ06lNgJlPe5aIgn1tVQgiga';
  final secret = 'DcQ8AlTTG2bMGGUf';

// Make a request to the authorization endpoint that will produce the fully
// authenticated Client.
  var client = await oauth2.resourceOwnerPasswordGrant(
      authorizationEndpoint, email, password,
      identifier: identifier, secret: secret);

// Once you have the client, you can use it just like any other HTTP client.
  //var result = await client.read('http://example.com/protected-resources.txt');

// Once we're done with the client, save the credentials file. This will allow
// us to re-use the credentials and avoid storing the username and password
// directly.
  //File('~/.myapp/credentials.json').writeAsString(client.credentials.toJson());

  print(client);
  return User('','');
}