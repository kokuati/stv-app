import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';

class AWSSignature {
  Map<String, String> call(
    String host,
    String path,
    DateTime time,
    String region,
    String service,
    String accessKey,
    String secretKey,
  ) {
    final datetime = _generateDatetime(time);
    final payload = _getPayload('');
    const method = 'GET';
    List<Map> headers = [
      {'host': host},
      {'x-amz-content-sha256': payload},
      {'x-amz-date': datetime}
    ];
    final canonicalRequest =
        _getCanonicalRequest(method, path, headers, payload);
    final credentialScope = _getCredentialScope(datetime, region, service);
    final signedheaders = _getSignedheaders(headers);
    final signature = _getSignature(datetime, credentialScope, canonicalRequest,
        region, service, secretKey);

    final authorization =
        'AWS4-HMAC-SHA256 Credential=$accessKey/$credentialScope, SignedHeaders=$signedheaders, Signature=$signature';
    return {
      'Authorization': authorization,
      'X-Amz-Content-Sha256': payload,
      'X-Amz-Date': datetime,
      'Host': host,
    };
  }

  String _getSignature(
    String datetime,
    String credentialScope,
    String canonicalRequest,
    String region,
    String service,
    String secretKey,
  ) {
    final stringToSign =
        'AWS4-HMAC-SHA256\n$datetime\n$credentialScope\n$canonicalRequest';
    final kDate =
        _sign(utf8.encode('AWS4$secretKey'), datetime.substring(0, 8));
    final kRegion = _sign(kDate, region);
    final kService = _sign(kRegion, service);
    final kSigning = _sign(kService, "aws4_request");

    final signatureHMAC = _sign(kSigning, stringToSign);
    return HEX.encode(signatureHMAC);
  }

  String _generateDatetime(DateTime time) {
    return time
        .toUtc()
        .toString()
        .replaceAll(RegExp(r'\.\d*Z$'), 'Z')
        .replaceAll(RegExp(r'[:-]|\.\d{3}'), '')
        .split(' ')
        .join('T');
  }

  String _getheadersString(List<Map> headers) {
    String text = '';
    for (var element in headers) {
      String key = element.keys.elementAt(0).toLowerCase();
      String value = element.values.elementAt(0);
      text = '$text$key:$value\n';
    }
    return text;
  }

  String _getSignedheaders(List<Map> headers) {
    String text = '';
    for (var element in headers) {
      String key = element.keys.elementAt(0).toLowerCase();
      if (text.isEmpty) {
        text = key;
      } else {
        text = '$text;$key';
      }
    }
    return text;
  }

  String _getCanonicalRequest(
      String method, String uri, List<Map> headers, String payload) {
    String headersString = _getheadersString(headers);
    String signedheaders = _getSignedheaders(headers);

    String canonical =
        '$method\n$uri\n\n$headersString\n$signedheaders\n$payload';

    return sha256.convert(utf8.encode(canonical)).toString();
  }

  String _getCredentialScope(String datetime, String region, String service) {
    return '${datetime.substring(0, 8)}/$region/$service/aws4_request';
  }

  String _getPayload(String payload) {
    return sha256.convert(utf8.encode(payload)).toString();
  }

  List<int> _sign(List<int> key, String message) {
    final hmac = Hmac(sha256, key);
    final dig = hmac.convert(utf8.encode(message));
    return dig.bytes;
  }
}
