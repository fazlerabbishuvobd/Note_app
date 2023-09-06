import 'package:flutter/material.dart';
import 'package:note_app/bottomnavbarpage.dart';
import 'package:note_app/model/notemodel.dart';
import 'package:note_app/services/databasehelper.dart';
import 'package:note_app/widgets/commonwidgets/customtextfield.dart';

class UpdateNotes extends StatefulWidget {
  final int id;
  final String? folderName;
  final int? isStared;
  final String? title;
  final String? description;

  const UpdateNotes(
      {super.key,
      required this.id,
      this.title,
      this.folderName,
      this.description,
      this.isStared});

  @override
  State<UpdateNotes> createState() => _UpdateNotesState();
}

class _UpdateNotesState extends State<UpdateNotes> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _folderName;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.title);
    _folderName = TextEditingController(text: widget.folderName);
    _descriptionController = TextEditingController(text: widget.description);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _folderName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //<------------ Note Title -------------------->
              const Text('Title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              CustomTextField(controller: _titleController, hint: 'Title', line: 2),

              //<------------ Note Folder -------------------->
              const Text('Folder', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1),
                    color: Colors.amber,
                  ),
                  child: Text('${widget.folderName}')
              ),

              //<------------ Note Description -------------------->
              const SizedBox(
                height: 20,
              ),
              const Text('Description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              CustomTextField(
                  controller: _descriptionController,
                  hint: 'Write descriptions....',
                  line: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Update Your Note'),
      centerTitle: true,
      backgroundColor: Colors.amber,
      actions: [
        //Update Note Button
        _buildUpdateNoteButton(context)
      ],
    );
  }

  IconButton _buildUpdateNoteButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Notes updateNotes = Notes(
          id: widget.id,
          title: _titleController.text,
          description: _descriptionController.text,
          dateTime: DateTime.now().toString(),
          category: widget.folderName ?? 'No Category',
          isStared: widget.isStared,
        );
        DatabaseHelper.updateNote(updateNotes);
        DatabaseHelper.updateStaredNote(updateNotes);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const BottomNavBarPage(),), (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Note Updated Successfully'),
          action: SnackBarAction(label: 'Close', onPressed: () {}),
        )
        );
      },
      icon: const Icon(Icons.save)
    );
  }
}
