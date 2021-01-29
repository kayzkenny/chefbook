import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  /// Writes the [data] to the document at this [path]
  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  /// Updates the [data] of the document at this [path]
  Future<void> updateData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.update(data);
  }

  /// Deletes the [data] to the document at this [path]
  Future<void> deleteData({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  /// Deletes the [field] to the document at the [path]
  Future<void> deleteField({@required String path, String fieldName}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.update({fieldName: FieldValue.delete()});
  }

  /// Adds the [data] to the collection at this [path]
  Future<void> addData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.collection(path);
    await reference.add(data);
  }

  /// Adds the [data] to the array at this [path]
  Future<void> arrayToArray({
    @required String path,
    @required dynamic data,
    @required String fieldName,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.update({
      fieldName: FieldValue.arrayUnion([data])
    });
  }

  /// Remove the [data] from the array at this [path]
  Future<void> removeFromArray({
    @required String path,
    @required dynamic data,
    @required String fieldName,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.update({
      fieldName: FieldValue.arrayRemove([data])
    });
  }

  /// A stream of the collection at this [path]
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  /// A stream of the document at this [path]
  Stream<T> documentStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> documentSnapshot = reference.snapshots();
    return documentSnapshot
        .map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  /// A stream of the document at this [path]
  Future<T> documentFuture<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Future<DocumentSnapshot> documentSnapshot = reference.get();
    return documentSnapshot
        .then((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  /// A list of the documents filtered from the collection at this [path]
  Future<List<T>> filteredCollectionList<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    @required List<String> ids,
  }) async {
    List<DocumentSnapshot> snapshots = [];
    await Future.forEach(ids, (id) async {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.doc(path + '/$id').get();
      snapshots.add(snapshot);
    });
    return snapshots
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList();
  }

  static DocumentSnapshot lastDocument;

  /// A list of the documents in the collection at this [path]
  Future<List<T>> collectionList<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) async {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final QuerySnapshot querySnapshots = await query.get();
    if (querySnapshots.docs.isNotEmpty) {
      lastDocument = querySnapshots.docs.last;
    }
    final result = querySnapshots.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .where((value) => value != null)
        .toList();
    if (sort != null) {
      result.sort(sort);
    }
    if (result.length < 10) {
      lastDocument = null;
    }
    return result;
  }

  /// A list of the documents in the collection at this [path]
  Future<List<T>> paginatedCollectionList<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, String documentID),
    Query queryBuilder(Query query),
    int sort(T lhs, T rhs),
  }) async {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final QuerySnapshot querySnapshots = lastDocument != null
        ? await query.startAfterDocument(lastDocument).get()
        : await query.get();
    if (querySnapshots.docs.isNotEmpty) {
      lastDocument = querySnapshots.docs.last;
    }
    final result = querySnapshots.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .where((value) => value != null)
        .toList();
    if (sort != null) {
      result.sort(sort);
    }
    if (result.length < 10) {
      lastDocument = null;
    }
    return result;
  }
}
