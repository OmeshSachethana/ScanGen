class ScanHistory {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isGenerated; // true if generated, false if scanned
  final String? qrImagePath; // for generated QR codes

  ScanHistory({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isGenerated,
    this.qrImagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isGenerated': isGenerated ? 1 : 0,
      'qrImagePath': qrImagePath,
    };
  }

  factory ScanHistory.fromMap(Map<String, dynamic> map) {
    return ScanHistory(
      id: map['id'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
      isGenerated: map['isGenerated'] == 1,
      qrImagePath: map['qrImagePath'],
    );
  }
}