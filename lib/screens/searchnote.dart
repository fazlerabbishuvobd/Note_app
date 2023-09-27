import 'package:flutter/material.dart';
import 'package:note_app/model/notemodel.dart';
import 'package:note_app/screens/detailsnotes.dart';
import 'package:note_app/services/databasehelper.dart';
import 'package:note_app/widgets/commonwidgets/customIconButton.dart';
import 'package:note_app/widgets/commonwidgets/notelisttile.dart';

class SearchNote extends StatefulWidget {
  const SearchNote({super.key});

  @override
  State<SearchNote> createState() => _SearchNoteState();
}

class _SearchNoteState extends State<SearchNote> {
  final _searchNoteController = TextEditingController();
  String searchWord = '';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: const Text(''),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                //<-------------- Back Button ------------->
                CustomIconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icons.arrow_circle_left_outlined,
                ),

                //<-------------- Search Bar ------------->
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).disabledColor,
                      border: Border.all(color: Colors.black, width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchNoteController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.search),
                            border: InputBorder.none,
                            hintText: 'Search notes',
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchWord = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),

      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 10,),

            FutureBuilder<List<Notes>?>(
              future: DatabaseHelper.getAllNotes(),
              builder: (context, AsyncSnapshot<List<Notes>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.hasError.toString());
                } else if (snapshot.hasData) {

                  //********** Search Result Filter ***************
                  List<Notes> searchNote = snapshot.data!.where((element) => element.title!.toLowerCase().contains(searchWord.toLowerCase())).toList();

                  return searchNote.isEmpty ? const Text('No Result Found') : _buildNoteList(searchNote, height, width);
                } else {
                  return const Center(child: Text('No Notes Found',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildNoteList(List<Notes> searchNote, double height, double width) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) {
          //var data = snapshot.data![index];
          var data = searchNote[index];
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
                Container(
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
                          child: Image.asset('assets/images/note.png', fit: BoxFit.cover)
                      ),
                      title: Text(data.title!, overflow: TextOverflow.ellipsis,),
                      subtitle: Text(data.dateTime.toString().split(' ')[0]),
                      trailing: _buildPopUpMenuButton(data)
                  ),
                ),

                //************* Notes Right Side Category Badge **************
                CategoryBadge(
                    height: height,
                    width: width,
                    data: data,
                    colorSerial: index % 10
                ),

                //**************** Notes Left Side Design ****************
                ListLeadingDesign(colorSerial: index % 10),

                //**************** Index Number ****************
                Positioned(
                    child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.amber,
                        child: Text('${index + 1}',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        )
                    )
                ),

                //**************** Stared Button ****************
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
        itemCount: searchNote.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10,),
      ),
    );
  }

  PopupMenuButton<dynamic> _buildPopUpMenuButton(Notes data) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      itemBuilder: (context) => [

        //************** Edit Button ******************
        PopupMenuItem(
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Edit'),
                  Icon(Icons.edit),
                ],
              ),
            )
        ),

        //************* Delete Button *****************
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

        //************* Stared Button *****************
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
        )
      ],
    );
  }

}
