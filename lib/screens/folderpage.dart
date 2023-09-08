import 'package:flutter/material.dart';
import 'package:note_app/model/notemodel.dart';
import 'package:note_app/screens/folderdetails.dart';
import 'package:note_app/services/databasehelper.dart';
import 'package:note_app/widgets/commonwidgets/customdialoguebox.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  final folderNameController = TextEditingController();
  final renameController = TextEditingController();

  @override
  void dispose() {
    folderNameController.dispose();
    renameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('All Folders'),
        centerTitle: true,
        backgroundColor: Colors.amber,
        actions: [
          //Create New Folder Button
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialogueBox(
                      controller: folderNameController,
                      title: 'New Folder Name',
                      onPressedSave: () {
                        Notes newFolder = Notes(category: folderNameController.text);
                        DatabaseHelper.addCategory(newFolder);
                        Navigator.pop(context);
                      },
                    );
                  },
                ).then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(Icons.create_new_folder)
          )
        ],
      ),

      body: Container(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Notes>?>(
          future: DatabaseHelper.getAllCategory(),
          builder: (context, AsyncSnapshot<List<Notes>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text(snapshot.hasError.toString());
            } else if (snapshot.hasData) {

              return snapshot.data!.isEmpty? const Center(child: Text('No Folder')):
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    childAspectRatio: 0.9),
                itemBuilder: (context, index) {
                  var folder = snapshot.data![index];
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                            FolderDetails(folderTitle: '${folder.category}'),)
                        );
                      },

                      child: Stack(children: [

                        //Folder Body
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/folders.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Text('${folder.category}',style: const TextStyle(fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Positioned(
                          right: 0,
                          bottom: 15,
                          child: PopupMenuButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            itemBuilder: (context) => [

                              // Rename Folder
                              PopupMenuItem(
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomDialogueBox(
                                            title: 'Update Folder Name',
                                            controller: renameController,
                                            controllerData: folder.category,
                                            onPressedSave: () {
                                              Notes renameFolder = Notes(id: folder.id, category: renameController.text, isStared: folder.isStared);
                                              DatabaseHelper.updateCategory(renameFolder);
                                              DatabaseHelper.updateStaredFolder(renameFolder);
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      ).then((value) {
                                        setState(() {});
                                      }).then((value) => Navigator.pop(context));
                                    },
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('Rename'),
                                        Icon(Icons.edit),
                                      ],
                                    ),
                                  )
                              ),


                              // Delete Folder
                              PopupMenuItem(
                                  child: InkWell(
                                    onTap: () {
                                      DatabaseHelper.deleteCategory(folder).then((value) {
                                        setState(() {});
                                      });
                                      DatabaseHelper.removeStaredFolder(folder);
                                      Navigator.pop(context);
                                    },
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('Delete'),
                                        Icon(Icons.delete),
                                      ],
                                    ),
                                  )
                              ),


                              // Stared Button
                              PopupMenuItem(
                                  child: InkWell(
                                    onTap: () {
                                      if (folder.isStared == null || folder.isStared == 0) {
                                        DatabaseHelper.isStaredFolder(folder, 1);
                                        DatabaseHelper.addStaredFolder(folder);
                                      } else {
                                        DatabaseHelper.isStaredFolder(folder, 0);
                                        DatabaseHelper.removeStaredFolder(folder);
                                      }
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(folder.isStared == 1 ? 'Unstared' : 'Stared'),
                                        Icon(folder.isStared == 1 ? Icons.star : Icons.star_border),
                                      ],
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),


                        //Stared Button
                        Positioned(
                            right: 10,
                            child: IconButton(
                                onPressed: () {
                                  if (folder.isStared == null || folder.isStared == 0) {
                                    DatabaseHelper.isStaredFolder(folder, 1);
                                    DatabaseHelper.addStaredFolder(folder);
                                  } else {
                                    DatabaseHelper.isStaredFolder(folder, 0);
                                    DatabaseHelper.removeStaredFolder(folder);
                                  }
                                  setState(() {});
                                },
                                icon: Icon(folder.isStared == 1 ? Icons.star : Icons.star_border)
                            )
                        ),
                        ],
                      )
                  );
                },
                itemCount: snapshot.data!.length,
              );
            } else {
              return const Center(child: Text('No Folders Found')
              );
            }
          },
        ),
      ),
    );
  }


}
