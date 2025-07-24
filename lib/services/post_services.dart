import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gradmate_core/models/post_model.dart';

final firestore = FirebaseFirestore.instance;

Future<List<Post>> fetchPosts() async {
  final List<Post> posts = [];

  // Fetch Countdown Posts
  final countdownSnap = await firestore
      .collection('posts')
      .doc('countdownPosts')
      .collection('items')
      .get();

  for (var doc in countdownSnap.docs) {
    posts.add(
      CountdownPost(
        id: doc.id,
        message: doc['message'],
        endDate: (doc['endDate'] as Timestamp).toDate(),
        timestamp: (doc['timestamp'] as Timestamp).toDate(),
      ),
    );
  }

  // Fetch Notice Posts
  final noticeSnap = await firestore
      .collection('posts')
      .doc('noticePosts')
      .collection('items')
      .get();

  for (var doc in noticeSnap.docs) {
    posts.add(
      NoticePost(
        id: doc.id,
        title: doc['title'],
        subtitle: doc['subtitle'],
        content: doc['content'],
        timestamp: (doc['timestamp'] as Timestamp).toDate(),
      ),
    );
  }

  // Add today's birthdays only
  final birthdayPosts = await fetchBirthdayPosts();
  posts.addAll(birthdayPosts);

  // Optional: sort by timestamp
  posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

  return posts;
}

Future<List<BirthdayPost>> fetchBirthdayPosts() async {
  final today = DateTime.now();
  final List<BirthdayPost> birthdayPosts = [];

  final userSnap = await firestore.collection('users').get();

  for (var doc in userSnap.docs) {
    final data = doc.data();
    final String name = data['name'] ?? 'Unknown';
    final Timestamp? birthday = (data['birthday'] as Timestamp?);
    final String? profilePic = data['profilePicture'];

    if (birthday == null) continue;
    final bday = birthday.toDate();

    // Only add if birthday is today (ignore year)
    if (bday.month == today.month && bday.day == today.day) {
      birthdayPosts.add(
        BirthdayPost(
          name: name,
          birthday: bday,
          timestamp: DateTime(today.year, bday.month, bday.day),
          photoURL: profilePic,
        ),
      );
    }
  }

  return birthdayPosts;
}

Future<bool> uploadPosts(Post post) async {
  final jsonData = post.toJson();
  switch (post.type) {
    case 'countdown':
      final docRef = await firestore
          .collection('posts')
          .doc('countdownPosts')
          .collection('items')
          .add(jsonData);
      docRef.update({'id': docRef.id});
      return true;
    case 'notice':
      final docRef = await firestore
          .collection('posts')
          .doc('noticePosts')
          .collection('items')
          .add(jsonData);
      docRef.update({'id': docRef.id});
      return true;
    default:
      return false;
  }
}

Future<bool> updatePost(Post post) async {
  final jsonData = post.toJson();
  switch (post.type) {
    case 'countdown':
      await firestore
          .collection('posts')
          .doc('countdownPosts')
          .collection('items')
          .doc(post.id)
          .update(jsonData);
      return true;
    case 'notice':
      await firestore
          .collection('posts')
          .doc('noticePosts')
          .collection('items')
          .doc(post.id)
          .update(jsonData);
      return true;
    default:
      return false;
  }
}

Future<bool> deletePost(Post post) async {
  switch (post.type) {
    case 'countdown':
      final docRef = firestore
          .collection('posts')
          .doc('countdownPosts')
          .collection('items')
          .doc(post.id);
      final docSnap = await docRef.get();

      if (!docSnap.exists) {
        return false;
      }

      await docRef.delete();

      return true;
    case 'notice':
      await firestore
          .collection('posts')
          .doc('noticePosts')
          .collection('items')
          .doc(post.id)
          .delete();
      return true;
    default:
      return false;
  }
}
