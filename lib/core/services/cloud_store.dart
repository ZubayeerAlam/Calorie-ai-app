import 'package:cloud_firestore/cloud_firestore.dart';

/// Where a signed-in user's data is backed up. Each user only reaches
/// their own data (`users/{uid}/…`, enforced by the Firestore rules).
///
/// - `users/{uid}/data/{storageKey}`: `{ value: <string or bool> }`, a copy
///   of one local storage value (profile, goals, logs…).
/// - `users/{uid}/<collection>/{id}`: one document per entry, for lists
///   saved by id: `food_entries` and `workout_sessions`.
abstract class CloudStore {
  /// Every stored value by storage key; empty for a new account.
  Future<Map<String, Object>> readValues(String uid);

  /// Saves [value] (a String or bool) under [key]; null deletes it.
  Future<void> writeValue(String uid, String key, Object? value);

  /// Every entry of [collection] (as JSON) by id.
  Future<Map<String, Map<String, dynamic>>> readEntries(
    String uid,
    String collection,
  );

  /// Saves [entry] under its `id`.
  Future<void> writeEntry(
    String uid,
    String collection,
    Map<String, dynamic> entry,
  );

  Future<void> deleteEntry(String uid, String collection, String id);
}

/// [CloudStore] on Cloud Firestore. Firestore keeps writes made offline
/// and sends them when the connection is back.
class FirestoreCloudStore implements CloudStore {
  FirestoreCloudStore([FirebaseFirestore? firestore])
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _user(String uid) =>
      _db.collection('users').doc(uid);

  @override
  Future<Map<String, Object>> readValues(String uid) async {
    final snapshot = await _user(uid).collection('data').get();
    return {
      for (final doc in snapshot.docs)
        if (doc.data()['value'] case final Object value) doc.id: value,
    };
  }

  @override
  Future<void> writeValue(String uid, String key, Object? value) {
    final doc = _user(uid).collection('data').doc(key);
    if (value == null) return doc.delete();
    return doc.set({'value': value, 'updatedAt': FieldValue.serverTimestamp()});
  }

  @override
  Future<Map<String, Map<String, dynamic>>> readEntries(
    String uid,
    String collection,
  ) async {
    final snapshot = await _user(uid).collection(collection).get();
    return {for (final doc in snapshot.docs) doc.id: doc.data()};
  }

  @override
  Future<void> writeEntry(
    String uid,
    String collection,
    Map<String, dynamic> entry,
  ) => _user(uid).collection(collection).doc(entry['id'] as String).set(entry);

  @override
  Future<void> deleteEntry(String uid, String collection, String id) =>
      _user(uid).collection(collection).doc(id).delete();
}

/// No cloud; the default until Firestore is passed in (never used while
/// accounts are unavailable).
class UnavailableCloudStore implements CloudStore {
  const UnavailableCloudStore();

  static Never _fail() => throw StateError('Cloud backup is not set up');

  @override
  Future<Map<String, Object>> readValues(String uid) async => _fail();

  @override
  Future<void> writeValue(String uid, String key, Object? value) async =>
      _fail();

  @override
  Future<Map<String, Map<String, dynamic>>> readEntries(
    String uid,
    String collection,
  ) async => _fail();

  @override
  Future<void> writeEntry(
    String uid,
    String collection,
    Map<String, dynamic> entry,
  ) async => _fail();

  @override
  Future<void> deleteEntry(String uid, String collection, String id) async =>
      _fail();
}
