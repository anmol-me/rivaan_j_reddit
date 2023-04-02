import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivaan_j_reddit/core/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rivaan_j_reddit/core/constants/firebase_constants.dart';
import 'package:rivaan_j_reddit/core/providers/firebase_providers.dart';
import 'package:rivaan_j_reddit/core/type_defs.dart';
import 'package:rivaan_j_reddit/models/community_model.dart';

/// Providers
final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

/// Class
class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _communitiesCollection =>
      _firestore.collection(FirebaseConstants.communitiesCollection);

  CollectionReference get _postsCollection =>
      _firestore.collection(FirebaseConstants.postsCollection);

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communitiesCollection.doc(community.name).get();

      if (communityDoc.exists) {
        throw 'Community with the same name already exists';
      }
      return right(
          _communitiesCollection.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      log('CreateCommFireErr: ${e.message}');
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure('CreateCommErr: ${e}'));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communitiesCollection
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<Community> communities = [];

      for (var doc in event.docs) {
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  Stream<Community> getCommunityByName(String name) {
    return _communitiesCollection.doc(name).snapshots().map(
        (event) => Community.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid editCommunity(Community community) async {
    try {
      return right(
        _communitiesCollection.doc(community.name).update(community.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
