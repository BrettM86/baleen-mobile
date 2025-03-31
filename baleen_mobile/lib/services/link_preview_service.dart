import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class LinkPreviewService {
  final Map<String, dynamic> _linkPreviews = {};
  final Map<String, bool> _loadingStates = {};

  Map<String, dynamic> get linkPreviews => _linkPreviews;
  Map<String, bool> get loadingStates => _loadingStates;

  Future<void> fetchLinkPreview(String url) async {
    if (_loadingStates[url] == true) return; // Already loading
    
    _loadingStates[url] = true;

    try {
      // Check if it's a Lemmy image via pictrs usage
      if (url.contains('pictrs')) {
        _linkPreviews[url] = {
          'imageUrl': url,
          'isLemmyImage': true,
        };
        _loadingStates[url] = false;
        return;
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final title = document.querySelector('title')?.text ?? '';
        final description = document.querySelector('meta[name="description"]')?.attributes['content'] ?? '';
        final imageUrl = document.querySelector('meta[property="og:image"]')?.attributes['content'] ??
                        document.querySelector('meta[name="twitter:image"]')?.attributes['content'];

        _linkPreviews[url] = {
          'title': title,
          'description': description,
          'imageUrl': imageUrl,
          'isLemmyImage': false,
        };
        _loadingStates[url] = false;
      } else {
        _linkPreviews[url] = {
          'isLemmyImage': false,
          'error': true,
        };
        _loadingStates[url] = false;
      }
    } catch (e) {
      _linkPreviews[url] = {
        'isLemmyImage': false,
        'error': true,
      };
      _loadingStates[url] = false;
    }
  }
}
