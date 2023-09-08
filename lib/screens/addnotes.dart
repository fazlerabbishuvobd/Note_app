import 'package:flutter/material.dart';
import 'package:note_app/bottomnavbarpage.dart';
import 'package:note_app/model/notemodel.dart';
import 'package:note_app/services/databasehelper.dart';
import 'package:note_app/widgets/commonwidgets/customtextfield.dart';

class AddNotes extends StatefulWidget {
  final String? folderName;

  const AddNotes({super.key, this.folderName});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final TextEditingController _folderName;

  @override
  void initState() {
    _folderName = TextEditingController(text: widget.folderName);
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
      appBar: AppBar(
        title: const Text('Add New Note'),
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: [
          //Save Button
          IconButton(
              onPressed: () {
                Notes addNotes = Notes(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    dateTime: DateTime.now().toString(),
                    category: widget.folderName ?? 'No Category');

                //<-------------- add note function ------------->
                DatabaseHelper.addNote(addNotes);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                const BottomNavBarPage(),), (route) => false);
              },
              icon: const Icon(Icons.save)
          )
        ],
      ),

      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Note Title
              const Text('Title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              CustomTextField(controller: _titleController, hint: 'Title', line: 2),

              //Note Folder
              const Text('Folder', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1),
                    color: Colors.amber,
                  ),
                  child: Text(widget.folderName == null?'No Category':'${widget.folderName}')
              ),

              // Note Description
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
}
