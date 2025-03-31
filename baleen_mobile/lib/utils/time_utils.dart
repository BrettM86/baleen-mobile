class TimeUtils {
  static String getTimeAgo(DateTime published) {
    final now = DateTime.now();
    final difference = now.difference(published);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }
}
