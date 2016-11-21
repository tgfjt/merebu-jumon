import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

main() async {
  final url = 'http://www.tv-tokyo.co.jp/yoshihiko/cast/merebu.html';

  getHtml(url).then((doc) {
    List list = doc.querySelectorAll('.jumon a').map((el) => {
          'name': el.querySelector('dt').text,
          'description': el.querySelector('dd').text
        });
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');

    File file = new File('${Directory.current.path}/jumon.json');
    file
        .writeAsString(encoder.convert(list.toList()))
        .then((file) => print("write: ${file.path}"))
        .catchError((e) => exit(2))
        .whenComplete(() => exit(0));
  });
}

Future<Document> getHtml(String url) async => await new HttpClient()
    .getUrl(Uri.parse(url))
    .then((HttpClientRequest req) => req.close())
    .then((HttpClientResponse res) =>
        res.asyncExpand((bytes) => new Stream.fromIterable(bytes)).toList())
    .then((bytes) => parse(bytes, sourceUrl: url));
