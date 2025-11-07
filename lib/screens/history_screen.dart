import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scan_gen/screens/database/history_database.dart';
import 'package:scan_gen/screens/models/history_model.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/banner_ad_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ScanHistory> _historyList = [];
  final HistoryDatabase _database = HistoryDatabase.instance;
  final Set<String> _selectedItems = {};

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _database.getAllHistory();
    setState(() {
      _historyList = history;
    });
  }

  // 🔹 Group history by date
  Map<String, List<ScanHistory>> _groupByDate(List<ScanHistory> history) {
    final Map<String, List<ScanHistory>> grouped = {};
    final now = DateTime.now();

    for (final item in history) {
      final date = DateTime(item.timestamp.year, item.timestamp.month, item.timestamp.day);
      String label;

      if (date == DateTime(now.year, now.month, now.day)) {
        label = 'Today';
      } else if (date ==
          DateTime(now.year, now.month, now.day - 1)) {
        label = 'Yesterday';
      } else {
        label = DateFormat('MMMM dd, yyyy').format(date);
      }

      grouped.putIfAbsent(label, () => []).add(item);
    }

    return grouped;
  }

  void _deleteItem(String id) async {
    await _database.deleteHistory(id);
    _loadHistory();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item deleted')),
    );
  }

  void _clearAllHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _database.clearAllHistory();
      _loadHistory();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All history cleared')),
      );
    }
  }

  void _shareItem(ScanHistory history) {
    final String shareText = '''
QR & Barcode App - ${history.isGenerated ? 'Generated' : 'Scanned'} Content

Content: ${history.content}
Type: ${history.isGenerated ? 'Generated QR Code' : 'Scanned Code'}
Date: ${DateFormat('MMM dd, yyyy - HH:mm').format(history.timestamp)}

Shared via QR & Barcode App
''';
    Share.share(shareText, subject: 'QR/Barcode Content');
  }

  void _shareMultipleItems() {
    if (_selectedItems.isEmpty) return;

    final selectedHistory =
        _historyList.where((item) => _selectedItems.contains(item.id)).toList();

    final StringBuffer shareText = StringBuffer();
    shareText.writeln('QR & Barcode App - History Export');
    shareText.writeln('Exported ${selectedHistory.length} items');
    shareText.writeln('');

    for (final history in selectedHistory) {
      shareText.writeln('▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬');
      shareText.writeln('Content: ${history.content}');
      shareText.writeln(
          'Type: ${history.isGenerated ? 'Generated QR Code' : 'Scanned Code'}');
      shareText.writeln(
          'Date: ${DateFormat('MMM dd, yyyy - HH:mm').format(history.timestamp)}');
      shareText.writeln('');
    }

    shareText.writeln('Exported via QR & Barcode App');

    Share.share(shareText.toString(), subject: 'QR/Barcode History Export');
    _clearSelection();
  }

  void _exportAllHistory() {
    if (_historyList.isEmpty) return;

    final StringBuffer shareText = StringBuffer();
    shareText.writeln('QR & Barcode App - Complete History');
    shareText.writeln('Total items: ${_historyList.length}');
    shareText.writeln(
        'Export date: ${DateFormat('MMM dd, yyyy - HH:mm').format(DateTime.now())}');
    shareText.writeln('');

    for (final history in _historyList) {
      shareText.writeln('▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬');
      shareText.writeln('Content: ${history.content}');
      shareText.writeln(
          'Type: ${history.isGenerated ? 'Generated QR Code' : 'Scanned Code'}');
      shareText.writeln(
          'Date: ${DateFormat('MMM dd, yyyy - HH:mm').format(history.timestamp)}');
      shareText.writeln('');
    }

    Share.share(shareText.toString(), subject: 'Complete QR/Barcode History');
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedItems.contains(id)) {
        _selectedItems.remove(id);
      } else {
        _selectedItems.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedItems.clear();
    });
  }

  bool get _isSelectionMode => _selectedItems.isNotEmpty;

  void _showHistoryDetails(ScanHistory history) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  history.isGenerated ? Icons.qr_code_2 : Icons.qr_code_scanner,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  history.isGenerated ? 'Generated QR' : 'Scanned Code',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Content:',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[600])),
            const SizedBox(height: 8),
            SelectableText(history.content),
            const SizedBox(height: 16),
            Text(
              'Time: ${DateFormat('MMM dd, yyyy - HH:mm').format(history.timestamp)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _shareItem(history);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedHistory = _groupByDate(_historyList);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelectionMode
            ? 'Selected (${_selectedItems.length})'
            : 'History'),
        actions: [
          if (_historyList.isNotEmpty && !_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.ios_share),
              onPressed: _exportAllHistory,
              tooltip: 'Export All',
            ),
            IconButton(
              onPressed: () =>
                  setState(() => _selectedItems.addAll(_historyList.map((e) => e.id))),
              icon: const Icon(Icons.select_all),
              tooltip: 'Select All',
            ),
            IconButton(
              onPressed: _clearAllHistory,
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Clear All',
            ),
          ],
          if (_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareMultipleItems,
              tooltip: 'Share Selected',
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSelection,
              tooltip: 'Clear Selection',
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          if (_isSelectionMode)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedItems.length} items selected',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _shareMultipleItems,
                    child: const Text('SHARE'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _historyList.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No history yet',
                            style:
                                TextStyle(fontSize: 18, color: Colors.grey)),
                        SizedBox(height: 8),
                        Text(
                          'Scan or generate QR codes to see them here',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView(
                    children: groupedHistory.entries.map((entry) {
                      final dateLabel = entry.key;
                      final items = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Text(
                              dateLabel,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          ...items.map((history) {
                            final isSelected =
                                _selectedItems.contains(history.id);
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              color: isSelected ? Colors.blue.shade50 : null,
                              child: ListTile(
                                leading: _isSelectionMode
                                    ? Checkbox(
                                        value: isSelected,
                                        onChanged: (_) =>
                                            _toggleSelection(history.id),
                                      )
                                    : Icon(
                                        history.isGenerated
                                            ? Icons.qr_code_2
                                            : Icons.qr_code_scanner,
                                        color: Colors.blue,
                                      ),
                                title: Text(
                                  history.content.length > 50
                                      ? '${history.content.substring(0, 50)}...'
                                      : history.content,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  DateFormat('HH:mm')
                                      .format(history.timestamp),
                                ),
                                trailing: _isSelectionMode
                                    ? null
                                    : IconButton(
                                        icon: const Icon(Icons.share, size: 20),
                                        onPressed: () =>
                                            _shareItem(history),
                                        tooltip: 'Share',
                                      ),
                                onTap: () {
                                  if (_isSelectionMode) {
                                    _toggleSelection(history.id);
                                  } else {
                                    _showHistoryDetails(history);
                                  }
                                },
                                onLongPress: () =>
                                    _toggleSelection(history.id),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ),
          ),
          const BannerAdWidget(),
        ],
      ),
      floatingActionButton: _isSelectionMode
          ? FloatingActionButton.extended(
              onPressed: _shareMultipleItems,
              icon: const Icon(Icons.share),
              label: Text('Share (${_selectedItems.length})'),
            )
          : null,
    );
  }
}
