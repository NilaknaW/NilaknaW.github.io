import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nilaknaw/helper/contact_form.dart';

Future<void> fillForm(WidgetTester tester) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 'Nilakna & Co');
  await tester.enterText(fields.at(1), 'visitor+test@example.com');
  await tester.enterText(fields.at(2), 'Hello & thanks!\nQuestion: A+B?');
}

Future<void> showForm(WidgetTester tester, http.Client client) =>
    tester.pumpWidget(MaterialApp(
      home: Scaffold(body: ContactForm(client: client)),
    ));

void main() {
  testWidgets('invalid fields do not send a request', (tester) async {
    var calls = 0;
    final client = MockClient((_) async {
      calls++;
      return http.Response('{}', 200);
    });
    await showForm(tester, client);
    await tester.tap(find.text('Send'));
    await tester.pump();
    expect(find.text('Please enter your name.'), findsOneWidget);
    expect(find.text('Please enter a valid email address.'), findsOneWidget);
    expect(find.text('Please enter a message.'), findsOneWidget);
    expect(calls, 0);
  });

  testWidgets(
      'posts encoded data, prevents duplicates and clears on acceptance',
      (tester) async {
    final pending = Completer<http.Response>();
    var calls = 0;
    final client = MockClient((request) {
      calls++;
      expect(request.method, 'POST');
      expect(request.url.toString(),
          'https://formsubmit.co/ajax/nilawarush@gmail.com');
      final data = jsonDecode(request.body);
      expect(data['name'], 'Nilakna & Co');
      expect(data['email'], 'visitor+test@example.com');
      expect(data['_replyto'], 'visitor+test@example.com');
      expect(data['message'], 'Hello & thanks!\nQuestion: A+B?');
      return pending.future;
    });
    await showForm(tester, client);
    await fillForm(tester);
    await tester.tap(find.text('Send'));
    await tester.pump();
    expect(find.text('Sending...'), findsOneWidget);
    expect(
        tester
            .widget<OutlinedButton>(
                find.byWidgetPredicate((widget) => widget is OutlinedButton))
            .onPressed,
        isNull);
    expect(calls, 1);
    pending.complete(http.Response('{"success":"true"}', 200));
    await tester.pumpAndSettle();
    expect(find.text('Message submitted. Thank you for reaching out!'),
        findsOneWidget);
    expect(find.text('Nilakna & Co'), findsNothing);
  });

  for (final response in [
    http.Response('{"success":false}', 200),
    http.Response('Unavailable', 503),
    http.Response(
        '{"success":true,"message":"This form needs Activation"}', 200),
  ]) {
    testWidgets('preserves message on rejection: ${response.body}',
        (tester) async {
      await showForm(tester, MockClient((_) async => response));
      await fillForm(tester);
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Your message could not be confirmed.'),
          findsOneWidget);
      expect(find.text('Email me directly'), findsOneWidget);
      expect(find.text('Hello & thanks!\nQuestion: A+B?'), findsOneWidget);
      expect(find.text('Send'), findsOneWidget);
    });
  }

  testWidgets('network failures retain the draft and allow retry',
      (tester) async {
    await showForm(tester, MockClient((_) async {
      throw http.ClientException('Network unavailable');
    }));
    await fillForm(tester);
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();
    expect(find.text('Hello & thanks!\nQuestion: A+B?'), findsOneWidget);
    expect(find.text('Email me directly'), findsOneWidget);
    expect(
        tester
            .widget<OutlinedButton>(
                find.byWidgetPredicate((widget) => widget is OutlinedButton))
            .onPressed,
        isNotNull);
  });
}
