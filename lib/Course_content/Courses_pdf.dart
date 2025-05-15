import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Pdf_viewer.dart';

class HecScreen extends StatefulWidget {
  const HecScreen({Key? key}) : super(key: key);

  @override
  State<HecScreen> createState() => _HecScreenState();
}

class _HecScreenState extends State<HecScreen> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<Map<String, String>> _pdfs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHecPDFs();
  }

  Future<void> _loadHecPDFs() async {
    try {
      final ListResult result = await _storage.ref('HEC').listAll();

      print("Checking folder: HEC");
      print("Number of items: ${result.items.length}");

      if (result.items.isEmpty) {
        print("No PDFs found in HEC folder!");
      }

      for (var item in result.items) {
        final url = await item.getDownloadURL();
        print("PDF found: ${item.name} at $url");

        _pdfs.add({
          'name': item.name,
          'url': url,
        });
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

  void _openPDF(String name, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PDFViewerScreen(url: url, title: name),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HEC Courses Outline'),
        titleTextStyle: TextStyle(color: Colors.white,fontSize: 15),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pdfs.isEmpty
          ? const Center(child: Text('No PDFs found.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pdfs.length,
        itemBuilder: (context, index) {
          final pdf = _pdfs[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text(pdf['name'] ?? 'No name'),
              onTap: () => _openPDF(pdf['name'] ?? 'PDF', pdf['url'] ?? ''),

            ),
          );
        },
      ),
    );
  }
}
