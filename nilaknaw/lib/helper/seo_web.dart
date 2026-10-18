import 'dart:convert';
import 'package:web/web.dart' as web;

void updateSeo(String title, String description, String canonical) {
  void meta(String attribute, String name, String value) {
    final element = web.document.querySelector('meta[$attribute="$name"]') ??
        web.document.createElement('meta');
    element.setAttribute(attribute, name);
    element.setAttribute('content', value);
    if (element.parentNode == null) web.document.head!.append(element);
  }

  meta('name', 'description', description);
  meta('property', 'og:title', title);
  meta('property', 'og:description', description);
  meta('property', 'og:url', canonical);
  meta('name', 'twitter:title', title);
  meta('name', 'twitter:description', description);
  final link = web.document.querySelector('link[rel="canonical"]') ??
      web.document.createElement('link');
  link.setAttribute('rel', 'canonical');
  link.setAttribute('href', canonical);
  if (link.parentNode == null) web.document.head!.append(link);
  final schema = web.document.querySelector('#page-schema') ??
      web.document.createElement('script');
  schema.setAttribute('id', 'page-schema');
  schema.setAttribute('type', 'application/ld+json');
  schema.textContent = jsonEncode({
    '@context': 'https://schema.org',
    '@type': 'WebPage',
    'name': title,
    'description': description,
    'url': canonical,
    'about': {'@id': 'https://nilaknaw.github.io/#person'},
  });
  if (schema.parentNode == null) web.document.head!.append(schema);
}
