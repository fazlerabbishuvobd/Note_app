import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:note_app/model/notemodel.dart';
import 'package:note_app/screens/addnotes.dart';
import 'package:note_app/screens/folderpage.dart';
import 'package:note_app/screens/homepage.dart';
import 'package:note_app/screens/profile.dart';
import 'package:note_app/screens/staredpage.dart';
import 'package:note_app/services/databasehelper.dart';
import 'package:note_app/widgets/commonwidgets/customdialoguebox.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  final folderNameController = TextEditingController();

  List<Widget> pages = [
    const HomePage(),
    const StaredPage(),
    const FolderPage(),
    const ProfilePage(),
  ];
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    folderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[index],
      floatingActionButton: const SizedBox(
        height: 60,
        width: 60,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        barColor: Theme.of(context).primaryColor,
        controller: FloatingBottomBarController(initialIndex: 0),
        bottomBar: [
          //Home
          BottomBarItem(
          icon: const Icon(Icons.home_filled, size: 30),
          iconSelected: const Icon(Icons.home_filled, color: Colors.red, size: 30),
          title: 'Home',
          dotColor: Colors.red,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
        ),

          //Stared
          BottomBarItem(
            icon: const Icon(Icons.star, size: 30),
            iconSelected: const Icon(Icons.star, color: Colors.red, size: 30),
            title: 'Stared',
            dotColor: Colors.red,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
          ),

          //Category
          BottomBarItem(
            icon: const Icon(Icons.folder_copy_rounded, size: 30),
            iconSelected: const Icon(Icons.folder_copy_rounded, color: Colors.red, size: 30),
            title: 'Folders',
            dotColor: Colors.red,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
          ),

          //Profile
          BottomBarItem(
            icon: const Icon(Icons.person, size: 30),
            iconSelected: const Icon(Icons.person, color: Colors.red, size: 30),
            title: 'Profile',
            dotColor: Colors.red,
            onTap: (value) {
              setState(() {
                index = value;
              });
            },
          ),
        ],
        bottomBarCenterModel: BottomBarCenterModel(
          centerBackgroundColor: Colors.red,
          centerIcon: const FloatingCenterButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          centerIconChild: [
            //Add Notes
            FloatingCenterButtonChild(
              child: const Icon(
                Icons.note_add,
                color: AppColors.white,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddNotes(),
                ));
              },
            ),

            //Add Folder
            FloatingCenterButtonChild(
              child: const Icon(
                Icons.create_new_folder,
                color: AppColors.white,
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomDialogueBox(
                      controller: folderNameController,
                      title: 'New Folder Name',
                      onPressedSave: () {
                        Notes newFolder = Notes(category: folderNameController.text);
                        DatabaseHelper.addCategory(newFolder);
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                          builder: (context) => const BottomNavBarPage(),), (route) => false);
                      },
                    );
                  },
                ).then((value) {
                  setState(() {});
                });
              },
            ),

            //Cancel
            FloatingCenterButtonChild(
              child: const Icon(
                Icons.cancel_outlined,
                color: AppColors.white,
              ),
              onTap: () => debugPrint('Cancel'),
            ),
          ],
        ),
      ),
    );
  }


}
