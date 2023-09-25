import 'package:flutter/material.dart';
import 'package:note_app/model/notemodel.dart';
import 'package:note_app/screens/addnotes.dart';
import 'package:note_app/screens/updateNote.dart';
import 'package:note_app/services/databasehelper.dart';
import 'package:note_app/widgets/commonwidgets/notelisttile.dart';
import 'detailsnotes.dart';

class FolderDetails extends StatefulWidget {
  final String folderTitle;

  const FolderDetails({super.key, required this.folderTitle});

  @override
  State<FolderDetails> createState() => _FolderDetailsState();
}

class _FolderDetailsState extends State<FolderDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Folder: ${widget.folderTitle}'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),

      body: FutureBuilder<List<Notes>?>(
        future: DatabaseHelper.getAllNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);

          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.hasError.toString()),);
          } else if (snapshot.hasData) {

            // Category Wise Filtering
            List<Notes> filteredItems = snapshot.data!.where((note) => note.category!.contains(widget.folderTitle)).toList();

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: filteredItems.isNotEmpty ?
                    ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var data = filteredItems[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DetailsNotes(
                                  id: index,
                                  title: data.title.toString(),
                                  description: data.description,
                                  folderName: data.category,
                                  time: data.dateTime,
                                  isStared: data.isStared,
                                ),
                              ));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.amber, width: 1)
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.13,
                                  width: double.infinity,

                                  //Folder Body
                                  child: ListTile(
                                    leading: CircleAvatar(
                                        radius: 30,
                                        child: Image.asset('assets/images/note.png', fit: BoxFit.cover)
                                    ),
                                    title: Text(data.title.toString(), overflow: TextOverflow.ellipsis),
                                    subtitle: Text(DateTime.now().toString().split(' ')[0]),
                                    trailing: PopupMenuButton(
                                      color: Colors.amber,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      itemBuilder: (context) => [
                                        //Edit
                                        PopupMenuItem(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                    UpdateNotes(id: data.id!, title: data.title, folderName: data.category, description: data.description, isStared: data.isStared),
                                                ));
                                              },
                                              child: const Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text('Edit'),
                                                  Icon(Icons.edit),
                                                ],
                                              ),
                                            )

                                        ),

                                        //Delete
                                        PopupMenuItem(
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
                                        ),

                                        //Stared
                                        PopupMenuItem(
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
                                                  Text(data.isStared == 1 ? 'Unstared' : 'Stared'),
                                                  Icon(data.isStared == 1 ? Icons.star : Icons.star_border),
                                                ],
                                              ),
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                                //Category Badge
                                CategoryBadge(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width * 0.9,
                                    data: data,
                                    colorSerial: index % 10
                                ),


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

                                //Star Button
                                Positioned(
                                    bottom: 0,
                                    right: 1,
                                    child: IconButton(
                                        onPressed: () async {
                                          if (data.isStared == null || data.isStared == 0) {
                                            DatabaseHelper.isStaredNote(data, 1);
                                            DatabaseHelper.addStaredNote(data);
                                          } else {
                                            DatabaseHelper.isStaredNote(data, 0);
                                            DatabaseHelper.removeStaredNote(data);
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

                        itemCount: filteredItems.length) : Center(child: Text('Empty ${widget.folderTitle} Folder'),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No Notes Found'));
        },
      ),

      //Floating Button
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddNotes(folderName: widget.folderTitle))
        ),
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }


}
