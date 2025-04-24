// ignore: unused_import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Books extends StatefulWidget {
  const Books({super.key});

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  List<Map<String, String>> pdfList = []; // List to store PDF titles and links
  bool isLoading = true; // To show a loader while fetching data

  @override
  void initState() {
    super.initState();
    _fetchPdfs(); // Fetch PDFs when the screen initializes
  }

  Future<void> _fetchPdfs() async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child("pdfs");
      final ListResult result = await storageRef.listAll();

      // Extract URLs and titles
      for (var ref in result.items) {
        final String url = await ref.getDownloadURL();
        final String name = ref.name;
        pdfList.add({"title": name, "link": url});
      }

      setState(() {
        isLoading = false; // Stop loader once data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching PDFs: $e")),
      );
    }
  }

  Future<void> _openPdf(String url, String fileName) async {
    final bool isGranted = await _checkPermission();
    if (!isGranted) return;

    // Show a confirmation dialog before downloading
    bool? downloadConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Download PDF"),
          content: Text("Do you want to download the PDF '$fileName'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Download"),
            ),
          ],
        );
      },
    );

    if (downloadConfirmed == true) {
      await _downloadFile(url, fileName);
    }
  }

  Future<bool> _checkPermission() async {
    PermissionStatus status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> _downloadFile(String url, String fileName) async {
    try {
      final directory = await getExternalStorageDirectory();
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        savedDir: directory!.path,
        fileName: fileName,
        showNotification: true,
        openFileFromNotification: true,
      );

      print("Download started: $taskId");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error downloading file: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pdfList.isEmpty
              ? const Center(child: Text("No PDFs available"))
              : ListView.builder(
                  itemCount: pdfList.length,
                  itemBuilder: (context, index) {
                    final pdf = pdfList[index];
                    return ListTile(
                      title: Text(pdf["title"]!),
                      trailing: const Icon(Icons.picture_as_pdf),
                      onTap: () => _openPdf(pdf["link"]!, pdf["title"]!),
                    );
                  },
                ),
    );
  }
}
