import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:running/components/drawer.dart';
import 'package:running/components/post.dart';
import 'package:running/components/text_field.dart';
import 'package:running/helper/helper_methods.dart';
import 'package:running/pages/profile_page.dart';
import 'package:running/pages/netiquette_quiz.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  int _score = 0; // Inicijalni broj bodova

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Accepted': [],
      });
    }

    setState(() {
      textController.clear();
    });
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  void _updateScore(int newScore) {
    setState(() {
      _score = newScore;
    });
  }

  void goToNetiquetteQuiz() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NetiquetteQuizScreen(initialScore: _score),
      ),
    );

    if (result != null) {
      _updateScore(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
        actions: [IconButton(onPressed: signOut, icon: const Icon(Icons.logout))],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
        onQuizTap: goToNetiquetteQuiz,
        currentScore: _score, // Prosljeđivanje trenutnog broja bodova u drawer
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Runs")
                      .orderBy(
                    "TimeStamp",
                    descending: false,
                  )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final post = snapshot.data!.docs[index];
                            return Post(
                              message: post['Message'],
                              user: post['UserEmail'],
                              postId: post.id,
                              accepted:
                              List<String>.from(post['Accepted'] ?? []),
                              time: formatDate(post['TimeStamp']),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error:${snapshot.error}'),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: "Dare someone to run your pace...",
                      obsecureText: false,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: postMessage,
                icon: const Icon(Icons.arrow_circle_up)),
            Text("Logged in as ${currentUser.email!}"),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
