import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key, this.client});

  final http.Client? client;

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  static const recipient = 'nilawarush@gmail.com';
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  late final http.Client _client = widget.client ?? http.Client();
  bool _sending = false;
  bool _success = false;
  String? _status;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    if (widget.client == null) _client.close();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_sending || !_formKey.currentState!.validate()) return;
    setState(() {
      _sending = true;
      _status = null;
      _success = false;
    });
    try {
      final response = await _client
          .post(
            Uri.parse('https://formsubmit.co/ajax/$recipient'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'name': _name.text.trim(),
              'email': _email.text.trim(),
              'message': _message.text.trim(),
              '_replyto': _email.text.trim(),
              '_subject': 'Portfolio contact message',
              '_template': 'table',
              '_url': 'https://nilaknaw.github.io/',
            }),
          )
          .timeout(const Duration(seconds: 20));
      final data = jsonDecode(response.body);
      final accepted = response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data is Map &&
          (data['success'] == true || data['success'] == 'true') &&
          !RegExp(r'activat|confirm.*email', caseSensitive: false)
              .hasMatch('${data['message']}');
      if (!accepted) throw const FormatException('Submission not accepted');
      if (!mounted) return;
      _formKey.currentState!.reset();
      _name.clear();
      _email.clear();
      _message.clear();
      setState(() {
        _success = true;
        _status = 'Message submitted. Thank you for reaching out!';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _status = 'Your message could not be confirmed. Please '
            'email me directly.';
      });
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Send a Message',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
              TextFormField(
                controller: _name,
                enabled: !_sending,
                autofillHints: const [AutofillHints.name],
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Your Name'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter your name.'
                    : null,
              ),
              TextFormField(
                controller: _email,
                enabled: !_sending,
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Your Email'),
                validator: (value) => !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                        .hasMatch(value?.trim() ?? '')
                    ? 'Please enter a valid email address.'
                    : null,
              ),
              TextFormField(
                controller: _message,
                enabled: !_sending,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Message'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter a message.'
                    : null,
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _sending ? null : _submit,
                icon: _sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(_sending ? 'Sending...' : 'Send'),
              ),
              if (_status != null) ...[
                const SizedBox(height: 12),
                Semantics(
                  liveRegion: true,
                  child: Text(_status!,
                      style: TextStyle(
                          color: _success
                              ? Colors.teal.shade800
                              : Theme.of(context).colorScheme.error)),
                ),
                if (!_success)
                  TextButton(
                    onPressed: () => launchUrl(Uri(
                      scheme: 'mailto',
                      path: recipient,
                      query:
                          'subject=${Uri.encodeComponent('Portfolio contact')}'
                          '&body=${Uri.encodeComponent('${_name.text}\n${_email.text}\n\n${_message.text}')}',
                    )),
                    child: const Text('Email me directly'),
                  ),
              ],
            ],
          ),
        ),
      );
}
