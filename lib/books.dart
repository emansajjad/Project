import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfsScreen extends StatefulWidget {
  const PdfsScreen({super.key});

  @override
  State<PdfsScreen> createState() => _PdfsScreenState();
}

class _PdfsScreenState extends State<PdfsScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<Map<String, String>> _pdfList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdfs();
  }

  Future<void> _loadPdfs() async {
    try {
      final ListResult result = await _storage.ref('pdfs').listAll();

      for (var item in result.items) {
        if (item.name.endsWith('.pdf')) {
          final url = await item.getDownloadURL();
          _pdfList.add({'name': item.name, 'url': url});
        }
      }
    } catch (e) {
      print('❌ Error loading PDFs: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading PDFs: $e')),
        );
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _openPdf(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open PDF')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pdfList.isEmpty
          ? const Center(child: Text('No PDFs found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pdfList.length,
        itemBuilder: (context, index) {
          final pdf = _pdfList[index];
          return ListTile(
            title: Text(pdf['name']!),
            trailing: const Icon(Icons.picture_as_pdf),
            onTap: () => _openPdf(pdf['url']!),
          );
        },
      ),
    );
  }
}
