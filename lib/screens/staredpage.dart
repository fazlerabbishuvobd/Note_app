import 'package:flutter/material.dart';
import 'package:note_app/model/notemodel.dart';
import 'package:note_app/screens/detailsnotes.dart';
import 'package:note_app/screens/folderdetails.dart';
import 'package:note_app/services/databasehelper.dart';
import 'package:note_app/widgets/commonwidgets/notelisttile.dart';
import 'package:note_app/widgets/homepage/homepagewidget.dart';

class StaredPage extends StatefulWidget {
  const StaredPage({super.key});

  @override
  State<StaredPage> createState() => _StaredPageState();
}

class _StaredPageState extends State<StaredPage> {
  int? folderAmount;
  int? noteAmount;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: _buildAppBar(height),

      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //<------------ Folder ---------------------->
            FutureBuilder<List<Notes>?>(
              future: DatabaseHelper.getAllStaredFolder(),
              builder: (context, AsyncSnapshot<List<Notes>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text(snapshot.hasError.toString());
                } else if (snapshot.hasData) {
                  //<-------- Main Part --------->

                  folderAmount = snapshot.data!.length;
                  return Column(
                    children: [
                      //<-------------- Folder Title ------------->
                      _buildFolderTitle(),

                      //<-------------- Folder Main Body ------------->
                      Container(
                        padding: const EdgeInsets.all(5),
                        height: height * 0.12,
                        width: width,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {

                              //<-------- Initialized Variable --------->
                              var data = snapshot.data![index];
                              folderAmount = snapshot.data!.length;

                              //<-------- Folder List Structure --------->
                              return GestureDetector(
                                onTap: () {
                                  debugPrint('Details of Folder $index');
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FolderDetails(folderTitle: '${data.category}'),));
                                },
                                child: Stack(
                                  children: [
                                    _buildFolderBody(width, data),

                                    //<-------------- Stared Button ------------->
                                    _buildFolderStaredButton(width, data, context),
                                  ],
                                ),
                              );
                            },
                            itemCount: snapshot.data!.length),
                      ),
                    ],
                  );
                } else {
                  //<-------- If Folder is Empty --------->
                  return SizedBox(
                      height: height * 0.1,
                      child: const Center(child: Text('Empty Stared Folder')));
                }
              },
            ),

            //<------------ All Notes ---------------------->
            FutureBuilder<List<Notes>?>(
              future: DatabaseHelper.getAllStaredNotes(),
              builder: (context, AsyncSnapshot<List<Notes>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.hasError.toString());
                } else if (snapshot.hasData) {

                  //<-------- Main Part --------->
                  noteAmount = snapshot.data!.length;

                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),

                      _buildNoteTitle(),

                      //<-------------- Note Main Body ------------->
                      SizedBox(
                          height: height * 0.6,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                //<-------- Initialized Variable ---------
                                // >
                                var data = snapshot.data![index];
                                noteAmount = snapshot.data!.length;

                                return GestureDetector(
                                  onTap: () {
                                    debugPrint('Details of Notes $index');
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                        DetailsNotes(
                                        id: data.id!,
                                        title: data.title,
                                        description: data.description,
                                        folderName: data.category,
                                        time: data.dateTime,
                                        isStared: data.isStared,
                                      ),
                                    ));
                                  },
                                  child: Stack(
                                    children: [
                                      _buildNoteBody(height, width, data, context),

                                      //<-------- Notes Right Side Category Badge --------->
                                      CategoryBadge(
                                        height: height,
                                        width: width,
                                        data: data,
                                        colorSerial: index % 10,
                                      ),

                                      //<-------- Notes Left Side Design --------->
                                      ListLeadingDesign(
                                        colorSerial: index % 10,
                                      ),

                                      //<-------------- Index Number ------------->
                                      _buildNoteIndexNumber(index),
                                    ],
                                  ),
                                );
                              },
                              itemCount: snapshot.data!.length)
                      ),
                    ],
                  );
                } else {
                  //<-------- if Notes Not Exits Then Show Massages --------->
                  return NoNotesFound(
                    height: height,
                    width: width,
                    message: 'Empty Stared Notes',
                  );
                }
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Positioned _buildNoteIndexNumber(int index) {
    return Positioned(
      child: CircleAvatar(
          radius: 12,
          backgroundColor: Colors.amber,
          child: Text('${index + 1}',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          )
      )
  );
  }

  Container _buildNoteBody(double height, double width, Notes data, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.amber, width: 1)),
      height: height * 0.12,
      width: width,
      child: ListTile(
        leading: CircleAvatar(
            radius: 30,
            child: Image.asset('assets/images/note.png',
              fit: BoxFit.cover,
            )),
        title: Text(data.title!, overflow: TextOverflow.ellipsis,),
        subtitle: Text(data.dateTime.toString().split(' ')[0]),
        trailing: _buildNoteStaredButton(data, context),
      ),
    );
  }

  IconButton _buildNoteStaredButton(Notes data, BuildContext context) {
    return IconButton(
      onPressed: () {
        DatabaseHelper.isStaredNote(data, 0);
        DatabaseHelper.removeStaredNote(data).then((value) {
          setState(() {});
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Remove Notes From Stared Successfully')));
        });
      },
      icon: const Icon(Icons.star)
    );
  }

  Row _buildNoteTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('All Stared Notes',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(noteAmount == null ? '(0)' : '($noteAmount)',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ],
    );
  }

  Positioned _buildFolderStaredButton(double width, Notes data, BuildContext context) {
    return Positioned(
      left: width * 0.01,
      child: IconButton(
          onPressed: () {
            DatabaseHelper.isStaredFolder(data, 0);
            DatabaseHelper.removeStaredFolder(data).then((value) {
              setState(() {});
            }).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Remove Folder From Stared Successfully')));
            });
          },
          icon: const Icon(Icons.star)),
    );
  }

  Container _buildFolderBody(double width, Notes data) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5),
      width: width * 0.3,
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/folders.png'), fit: BoxFit.cover)
      ),
      child: Text('${data.category}',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        overflow: TextOverflow.ellipsis,
      )
  );
  }

  Row _buildFolderTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('All Stared Folder',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          folderAmount == null ? '(0)' : '($folderAmount)',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ],
    );
  }

  AppBar _buildAppBar(double height) {
    return AppBar(
      title: const Text('Stared'),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh)),
      ],
      backgroundColor: Colors.amber,
      toolbarHeight: height * 0.1,
    );
  }
}
