class AugmentedNotification {
  final String notificationId;
  final String? title;
  final String? body;
  final Map<String, dynamic>? additionalData;
  final String? launchUrl;

  AugmentedNotification(
      {required this.notificationId,
      this.title,
      this.body,
      this.additionalData,
      this.launchUrl});

  @override
  String toString() {
    return 'AugmentedNotification('
        'notificationId: $notificationId,'
        'title: $title,'
        'body: $body,'
        'additionalData: $additionalData,'
        'launchUrl: $launchUrl'
        ')';
  }
}
