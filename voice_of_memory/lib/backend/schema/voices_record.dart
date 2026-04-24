import 'dart:async';
import 'package:collection/collection.dart';
import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VoicesRecord extends FirestoreRecord {
  VoicesRecord._(DocumentReference reference, Map<String, dynamic> data)
      : super(reference, data) {
    _initializeFields();
  }

  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  String? _url;
  String get url => _url ?? '';
  bool hasUrl() => _url != null;

  String? _narrator;
  String get narrator => _narrator ?? '';
  bool hasNarrator() => _narrator != null;

  List<String>? _tags;
  List<String> get tags => _tags ?? [];
  bool hasTags() => _tags != null;

  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  bool hasCreatedAt() => _createdAt != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _url = snapshotData['url'] as String?;
    _narrator = snapshotData['narrator'] as String?;
    _tags = getDataList(snapshotData['tags']);
    _createdAt = snapshotData['createdAt'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('voices');

  static Stream<VoicesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => VoicesRecord.fromSnapshot(s));

  static Future<VoicesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => VoicesRecord.fromSnapshot(s));

  static VoicesRecord fromSnapshot(DocumentSnapshot snapshot) => VoicesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static VoicesRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      VoicesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'VoicesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is VoicesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createVoicesRecordData({
  String? name,
  String? url,
  String? narrator,
  List<String>? tags,
  DateTime? createdAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'url': url,
      'narrator': narrator,
      'tags': tags,
      'createdAt': createdAt,
    }.withoutNulls,
  );
  return firestoreData;
}

class VoicesRecordDocumentEquality implements Equality<VoicesRecord> {
  const VoicesRecordDocumentEquality();
  @override
  bool equals(VoicesRecord? e1, VoicesRecord? e2) {
    return e1?.name == e2?.name &&
        e1?.url == e2?.url &&
        e1?.narrator == e2?.narrator &&
        e1?.createdAt == e2?.createdAt;
  }

  @override
  int hash(VoicesRecord? e) =>
      const ListEquality().hash([e?.name, e?.url, e?.narrator, e?.createdAt]);

  @override
  bool isValidKey(Object? o) => o is VoicesRecord;
}
