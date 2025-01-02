import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gatau/components/text_field.dart';
import 'package:gatau/components/wall_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add(
        {
          'UserEmail': currentUser.email,
          'Message': textController.text,
          'Timestamp': Timestamp.now(),
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "The Wall",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          //the wall
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .orderBy("Timestamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                // Cek error dulu
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                // Cek loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Cek data
                if (snapshot.hasData) {
                  // Cek jika tidak ada dokumen
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No posts yet'),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final post = snapshot.data!.docs[index];
                      return WallPost(
                        message: post['Message'],
                        user: post['UserEmail'],
                      );
                    },
                  );
                }

                // Default case
                return const Center(
                  child: Text('No data available'),
                );
              },
            ),
          ),
          //post message
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: textController,
                    obscureText: false,
                    hintText: "Write something on the wall..",
                  ),
                ),
                IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up))
              ],
            ),
          ),

          //logged in as
          Text("Logged in as: ${currentUser.email!}"),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
