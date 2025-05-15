import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class QueryPage extends StatefulWidget {
  @override
  _QueryPageState createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {
  final TextEditingController _questionController = TextEditingController();

  String getUserName() {
    final email = FirebaseAuth.instance.currentUser?.email ?? 'anonymous@example.com';
    return email.split('@')[0];
  }

  String getUserEmailFromDoc(DocumentSnapshot doc) {
    if (doc.data() != null && (doc.data() as Map).containsKey('userEmail')) {
      return doc['userEmail'];
    } else {
      return 'Anonymous';
    }
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final dateTime = timestamp.toDate();
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  void _showPostQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Post a Question'),
          content: TextField(
            controller: _questionController,
            decoration: InputDecoration(hintText: 'Type your question here...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _questionController.clear();
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final questionText = _questionController.text.trim();
                if (questionText.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('questions').add({
                    'title': questionText,
                    'userEmail': getUserName(),
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  _questionController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text('Post'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommentsSection(String questionId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('questions')
          .doc(questionId)
          .collection('comments')
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final comments = snapshot.data!.docs;

        if (comments.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No comments yet. Be the first one!', style: TextStyle(fontStyle: FontStyle.italic)),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return Padding(
              padding: const EdgeInsets.only(left: 15),
              child: ListTile(
                title: Container(
                  height: 35,
                  decoration: BoxDecoration(color: Colors.grey,
                  borderRadius: BorderRadius.circular(12)
                  
                  ),

                  child: Center(
                    child: Text(
                      '${getUserEmailFromDoc(comment)} · ${formatTimestamp(comment['timestamp'])}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                subtitle:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(comment['text'], style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAddCommentSection(String questionId) {
    final TextEditingController commentController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () async {
              final commentText = commentController.text.trim();
              if (commentText.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('questions')
                    .doc(questionId)
                    .collection('comments')
                    .add({
                  'text': commentText,
                  'userEmail': getUserName(),
                  'timestamp': FieldValue.serverTimestamp(),
                });
                commentController.clear();
                setState(() {}); // Refresh UI after posting comment
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussion Portal', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: _showPostQuestionDialog,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('questions')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final questions = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];

              return Card(
                color: Colors.grey[300],
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  title: Text(
                    question['title'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color:  Colors.blue),
                  ),
                  subtitle: Text(
                    '${getUserEmailFromDoc(question)} · ${formatTimestamp(question['timestamp'])}',
                    style: TextStyle(fontSize: 10),
                  ),
                  children: [
                    _buildCommentsSection(question.id),
                    _buildAddCommentSection(question.id),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
