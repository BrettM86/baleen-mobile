import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  static String getDomainFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return url;
    }
  }

  static Future<bool> launchUrl(String url) async {
    if (await canLaunch(url)) {
      return await launch(url);
    }
    return false;
  }
}
