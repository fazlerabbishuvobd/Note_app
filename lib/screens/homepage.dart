import 'package:flutter/material.dart';
import 'package:note_app/model/notemodel.dart';
import 'package:note_app/screens/detailsnotes.dart';
import 'package:note_app/screens/folderdetails.dart';
import 'package:note_app/screens/folderpage.dart';
import 'package:note_app/screens/searchnote.dart';
import 'package:note_app/screens/updateNote.dart';
import 'package:note_app/services/databasehelper.dart';
import 'package:note_app/widgets/commonwidgets/customIconButton.dart';
import 'package:note_app/widgets/commonwidgets/customdialoguebox.dart';
import 'package:note_app/widgets/commonwidgets/notelisttile.dart';
import 'package:note_app/widgets/homepage/homepagewidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? totalFolders;
  int? totalNotes;

  final _renameFolderController = TextEditingController();

  @override
  void dispose() {
    _renameFolderController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Note App'),
        centerTitle: true,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        actions: [
          CustomIconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchNote())
              );
            }, icon: Icons.search,
          )
        ],
        backgroundColor: Colors.amber,
        toolbarHeight: height * 0.1,
      ),

      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Folder
              FutureBuilder<List<Notes>?>(
                future: DatabaseHelper.getAllCategory(),
                builder: (context, AsyncSnapshot<List<Notes>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text(snapshot.hasError.toString());
                  } else if (snapshot.hasData) {
                    totalFolders = snapshot.data!.length;

                    // Main Part ( Folder Title & Body )
                    return Column(
                      children: [
                        // Title
                        Row(
                          children: [
                            const Text('Folder',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10,),
                            Text(totalFolders == 0 ? '(0)' : '($totalFolders)',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                          ],
                        ),


                        //Body
                        Container(
                          padding: const EdgeInsets.all(5),
                          height: height * 0.12,
                          width: width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                //<-------- Initialized Variable --------->
                                var data = snapshot.data![index];

                                //<-------- Folder List Structure --------->
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => FolderDetails(folderTitle: '${data.category}'))
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      //body
                                      Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(5),
                                          width: width * 0.3,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage('assets/images/folders.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Text('${data.category}',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                      ),

                                      //Pop Menu Button
                                      Positioned(
                                        right: 5,
                                        bottom: 0,
                                        child: PopupMenuButton(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          itemBuilder: (context) => [
                                            //Rename Folder
                                            PopupMenuItem(
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return CustomDialogueBox(
                                                          title: 'Update Folder Name',
                                                          controller: _renameFolderController,
                                                          controllerData: data.category,
                                                          onPressedSave: () {
                                                            Notes renameFolder = Notes(id: data.id, category: _renameFolderController.text, isStared: data.isStared);
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

                                            //Delete Folder
                                            PopupMenuItem(
                                                child: InkWell(
                                                  onTap: () {
                                                    DatabaseHelper.deleteCategory(data).then((value) {
                                                      setState(() {});
                                                    });
                                                    DatabaseHelper.removeStaredFolder(data);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
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
                                                    if (data.isStared == null || data.isStared == 0) {
                                                      DatabaseHelper.isStaredFolder(data, 1);
                                                      DatabaseHelper.addStaredFolder(data);
                                                    } else {
                                                      DatabaseHelper.isStaredFolder(data, 0);
                                                      DatabaseHelper.removeStaredFolder(data);
                                                    }
                                                    setState(() {});
                                                    Navigator.pop(context);
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Text(data.isStared == 1 ? 'Unstared' : 'Stared'),
                                                      Icon(data.isStared == 1 ? Icons.star : Icons.star_border),
                                                    ],
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                      ),

                                      Positioned(
                                          left: width * 0.02,
                                          child: IconButton(
                                              onPressed: () {
                                                if (data.isStared == null || data.isStared == 0) {
                                                  DatabaseHelper.isStaredFolder(data, 1);
                                                  DatabaseHelper.addStaredFolder(data);
                                                } else {
                                                  DatabaseHelper.isStaredFolder(data, 0);
                                                  DatabaseHelper.removeStaredFolder(data);
                                                }
                                                setState(() {});
                                              },
                                              icon: Icon(data.isStared == 1 ? Icons.star : Icons.star_border)
                                          )
                                      ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: snapshot.data!.length),
                        ),
                      ],
                    );
                  } else {

                    // If Folder is Empty
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const FolderPage(),
                        ));
                      },
                      child: AddFolderIcon(width: width, height: height),
                    );
                  }
                },
              ),
              const SizedBox(height: 10,),



              //Note part
              FutureBuilder<List<Notes>?>(
                future: DatabaseHelper.getAllNotes(),
                builder: (context, AsyncSnapshot<List<Notes>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(),);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.hasError.toString());
                  } else if (snapshot.hasData) {
                    totalNotes = snapshot.data!.length;

                    // Main Part of Notes
                    return Column(
                      children: [

                        //Note Tile
                        Row(
                          children: [
                            const Text('Notes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            const SizedBox(width: 10,),
                            Text(totalNotes == null ? '(0)' : '($totalNotes)',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),

                        //Note Body
                        SizedBox(
                            height: height * 0.5,
                            width: width,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: ListView.builder(
                                  reverse: true,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var data = snapshot.data![index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => DetailsNotes(
                                            id: data.id!,
                                            title: data.title!,
                                            description: data.description,
                                            folderName: data.category,
                                            time: data.dateTime,
                                            isStared: data.isStared,
                                          ),
                                        ));
                                      },
                                      child: Stack(
                                        children: [

                                          //Note List Body
                                          Container(
                                            margin: const EdgeInsets.symmetric(vertical: 5),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                border: Border.all(color: Colors.amber, width: 1)
                                            ),
                                            height: height * 0.12,
                                            width: width,
                                            child: ListTile(
                                                leading: CircleAvatar(
                                                    radius: 30,
                                                    child: Image.asset('assets/images/note.png', fit: BoxFit.cover,)
                                                ),
                                                title: Text(data.title!, overflow: TextOverflow.ellipsis,),
                                                subtitle: Text(data.dateTime.toString().split(' ')[0]),
                                                trailing: _buildNotesPopupMenuButton(data)
                                            ),
                                          ),

                                          //Notes Right Side Category Badge
                                          CategoryBadge(height: height, width: width, data: data, colorSerial: index % 10),

                                          //Notes Left Side Design
                                          ListLeadingDesign(colorSerial: index % 10),

                                          //Index Number
                                          Positioned(
                                              child: CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor: Colors.amber,
                                                  child: Text('${index + 1}',
                                                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                                  )
                                              )
                                          ),


                                          //Stared Button
                                          Positioned(
                                              bottom: 0,
                                              right: 1,
                                              child: IconButton(
                                                  onPressed: () async {
                                                    if (data.isStared == null || data.isStared == 0) {
                                                      DatabaseHelper.isStaredNote(data, 1);
                                                      DatabaseHelper.addStaredNote(data);
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: const Text('Folder Mark as Stared Successfully',
                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                          duration: const Duration(milliseconds: 1500),
                                                          action: SnackBarAction(label: 'Close', onPressed: (){}),
                                                        ),
                                                      );
                                                    } else {
                                                      DatabaseHelper.isStaredNote(data, 0);
                                                      DatabaseHelper.removeStaredNote(data);

                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: const Text('Folder UnMark as Stared Successfully',
                                                              style: TextStyle(fontWeight: FontWeight.bold)),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                            duration: const Duration(milliseconds: 1500),
                                                            action: SnackBarAction(label: 'Close', onPressed: (){})
                                                          )
                                                      );
                                                    }
                                                    setState(() {});
                                                  },
                                                  icon: Icon(data.isStared == 1 ? Icons.star : Icons.star_border)
                                              )
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: snapshot.data!.length),
                            )
                        ),
                      ],
                    );
                  } else {
                    //<-------- if Notes Not Exits Then Show Massages --------->
                    return NoNotesFound(height: height, width: width,message: 'Empty Notes',);
                  }
                },
              ),

            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }




  PopupMenuButton<dynamic> _buildNotesPopupMenuButton(Notes data) {
    return PopupMenuButton(color: Colors.amber,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    itemBuilder: (context) => [

      //Edit Note
      _buildPopMenuItemEditNote(context, data),

      //Delete Note
      _buildPopMenuItemDeleteNote(data, context),

      //Stared Note
      _buildPopMenuItemStaredNote(data, context),
    ],
  );
  }

  PopupMenuItem<dynamic> _buildPopMenuItemStaredNote(Notes data, BuildContext context) {
    return PopupMenuItem(
        child: InkWell(
        onTap: () {
          if (data.isStared == null || data.isStared == 0) {
            DatabaseHelper.isStaredNote(data, 1);
            DatabaseHelper.addStaredNote(data);
          } else {
            DatabaseHelper.isStaredNote(data, 0);
            DatabaseHelper.removeStaredNote(data);
          }
          setState(() {});
          Navigator.pop(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(data.isStared == 1 ? 'UnStared' : 'Stared'),
            Icon(data.isStared == 1 ? Icons.star : Icons.star_border),
          ],
        ),
      )
    );
  }

  PopupMenuItem<dynamic> _buildPopMenuItemDeleteNote(Notes data, BuildContext context) {
    return PopupMenuItem(
        child: InkWell(
        onTap: () {
          DatabaseHelper.deleteNote(data).then((value) {
            setState(() {});
          });
          DatabaseHelper.removeStaredNote(data);
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
    );
  }

  PopupMenuItem<dynamic> _buildPopMenuItemEditNote(BuildContext context, Notes data) {
    return PopupMenuItem(
      child: InkWell(
      onTap: () {
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
          UpdateNotes(
                  id: data.id!,
                  title: data.title,
                  folderName: data.category,
                  description: data.description,
                  isStared: data.isStared))).then((value) {
                    setState(() {});
                  });
      },
        child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Edit'),
          Icon(Icons.edit),
        ],
      ),
       )
    );
  }


}
