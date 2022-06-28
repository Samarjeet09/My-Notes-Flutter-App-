import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notesapp/services/cloud/cloud_note.dart';
import 'package:notesapp/services/cloud/cloud_storage_constants.dart';
import 'package:notesapp/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  Future<Iterable<CloudNote>> getNote({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          ) //where returns a Query
          .get() //so we use get to get a future(query snapshot)
          .then(
            // -->use then to  return a future or sync option
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw ClouldNotGetAllException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    //snapshots() is stream of Query snapshots
    //yeh last function meri where was a Query and get made it a future query snapshot
    //now we use map to get all the change happening in the stream --> event
    //event is the Query snapshot
    //ok so Query snapshot sei mujhe document do
    //then usko map kiya for every cloud note using uska
    //consturctor jo humnei banya tha
    //jis pei we had added a where clause
    return notes.snapshots().map((event) => event.docs
        .map((doc) => CloudNote.fromSnapshot(doc))
        .where((note) => note.ownerUserId == ownerUserId));
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  //making it a shared instanxe-->singleton
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
