import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:note_app/screens/updateNote.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class DetailsNotes extends StatefulWidget {
  final int id;
  final String? title;
  final String? description;
  final String? folderName;
  final String? time;
  final int? isStared;

 const DetailsNotes({
    super.key,
    required this.id,
    this.title,
    this.description,
    this.folderName,
    this.time,
    this.isStared
  });

  @override
  State<DetailsNotes> createState() => _DetailsNotesState();
}

class _DetailsNotesState extends State<DetailsNotes> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(widget.folderName == null ? 'Folder: Unknown' : '${widget.folderName}'),
          centerTitle: true,
          actions: [
            _buildShareButton(context)
          ],
        ),

        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //Note Title
                  RichText(
                  text: TextSpan(text: 'Title: ',
                      style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: widget.title,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal))
                      ])
                  ),

                  const Divider(),

                  Text(widget.description ?? 'Write Description')
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          color: Theme.of(context).primaryColor,
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(widget.isStared != 1 ? Icons.star_border : Icons.star),

              //Edit Note Button
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdateNotes(
                        id: widget.id,
                        title: widget.title,
                        folderName: widget.folderName,
                        description: widget.description,
                        isStared: widget.isStared != 1 ? 0 : 1,
                      ),
                    ));
                  },
                  icon: const Icon(Icons.edit)
              ),

              //Time
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Created Time: ${widget.time.toString().split(' ')[1].split('.')[0]}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  IconButton _buildShareButton(BuildContext context) {
    return IconButton(
        onPressed: () {
            showModalBottomSheet(
                context: context, builder: (context) =>
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                height: MediaQuery.sizeOf(context).height * 0.17,
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Container(
                      height: 10,
                      width: 100,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.amber),
                    ),
                    const Spacer(),

                    const Text('Choose Notes Sharing Method',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Spacer(),

                    //Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        /// Share Notes as Text Button
                        MaterialButton(
                          onPressed: () async {
                            await Share.share('Title: ${widget.title}\nDetails: ${widget.description}\nTime: ${widget.time.toString().split(' ')[1].split('.')[0]}\nDate: ${widget.time.toString().split(' ')[0]}');
                            debugPrint('Print');
                          },
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Text'),
                              Icon(Icons.text_fields_outlined)
                            ],
                          ),
                        ),

                        /// Share as Screenshots Button
                        MaterialButton(
                          onPressed: () async {
                            final tempDir = await getTemporaryDirectory();
                            final tempPath = tempDir.path;
                            final tempFile = File('$tempPath/${widget.title}.png');
                            final Uint8List? imageBytes = await _screenshotController.capture();
                            await tempFile.writeAsBytes(imageBytes!);
                            await Share.shareXFiles([XFile(tempFile.path)]);
                          },
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Screenshot'),
                              Icon(Icons.image)
                            ],
                          ),
                        )

                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.01,
                    )
                  ],
                ),
              ),
            isDismissible: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)));
        },
        icon: const Icon(Icons.share)
    );
  }
}
