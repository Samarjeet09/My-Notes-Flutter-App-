import 'package:flutter/material.dart';
import 'package:notesapp/constants/bottom_bar_text.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:notesapp/utilities/generics/get_arguments.dart';
import 'package:notesapp/services/cloud/cloud_note.dart';

import 'package:notesapp/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNotIfTextNotEmpty() async {
    final note = _note;

    if (_textController.text.isNotEmpty && note != null) {
      await _notesService.updateNote(
        documentId: note.documentId,
        text: _textController.text,
      );
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

//overriding the dispose function
  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNotIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_sharp),
            onPressed: () async {
              final text = _textController.text;
              if (text.isEmpty || _note == null) {
                await cannotShareEmptyNoteDialog(context);
              } else {
                Share.share(text);
              }
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return Scaffold(
                body: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Start Typing Your Note....",
                  ),
                ),
                bottomNavigationBar: const BottomAppBar(
                  elevation: 1,
                  child: Text(
                    bottomBarText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 22,
                    ),
                  ),
                ),
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
