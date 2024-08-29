import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:running/components/comment_button.dart';
import 'package:running/components/comment.dart';
import 'package:running/helper/helper_methods.dart';

import 'accept_button.dart';

class Post extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> accepted;

  const Post(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.accepted, required this.time});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isAccepted = false;
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isAccepted = widget.accepted.contains(currentUser.email);
  }

  void toggleAccepted() {
    setState(() {
      isAccepted = !isAccepted;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Posts').doc(widget.postId);

    if (isAccepted) {
      postRef.update({
        'Accepted': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Accepted': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Comment this run"),
        content: TextField(
          controller: _commentTextController,
          decoration:
              const InputDecoration(hintText: "Say something about this run..."),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                _commentTextController.clear();
              },
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: const Text("Comment"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.message),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(widget.user, style: const TextStyle(color: Colors.grey)),
                  const Text(" . ", style: TextStyle(color: Colors.grey)),
                  Text(widget.time, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  AcceptButton(
                    isAccepted: isAccepted,
                    onTap: toggleAccepted,
                  ),
                  const SizedBox(height: 5),
                  Text(widget.accepted.length.toString()),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  CommentButton(
                    onTap: showCommentDialog,
                  ),
                  const SizedBox(height: 5),
                  Text(widget.accepted.length.toString()),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),

          const SizedBox(height: 20),

          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .orderBy("CommentTime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    final commentData = doc.data() as Map<String, dynamic>;

                    return Comment (
                        text: commentData["CommentText"],
                        user: commentData["CommentedBy"],
                        time: formatDate(commentData["CommentTime"]));
                  }).toList(),
                );
              },
          )
        ],
      ),
    );
  }
}
