import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                _buildShowModalBottomSheet(context);
              },
              child: const CircleAvatar(
                radius: 90,
                backgroundColor: Colors.amber,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/images/fazlerabbi.jpg'),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _buildName(),
            _buildPosition(),
            _buildLocation(),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              height: MediaQuery.sizeOf(context).height * 0.16,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.amber),
                  ),
                  const Spacer(),
                  const Text(
                    'Choose Profile Picture From',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10)),
                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Camera'),
                            Icon(Icons.camera_alt_rounded)
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10)),
                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Gallery'),
                            Icon(Icons.image_rounded)
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height:
                        MediaQuery.sizeOf(context).height * 0.02,
                  )
                ],
              ),
            ),
        isDismissible: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15))
    );
  }

  Card _buildLocation() {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.black, width: 1)),
      color: Colors.amber,
      child: const SizedBox(
        height: 50,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.location_on),
              SizedBox(
                width: 10,
              ),
              Text('Location'),
              Spacer(),
              Text(
                'Dhaka, Bangladesh',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
  Card _buildPosition() {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.black, width: 1)),
      color: Colors.amber,
      child: const SizedBox(
        height: 50,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.work),
              SizedBox(
                width: 10,
              ),
              Text('Position'),
              Spacer(),
              Text('Flutter Developer',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
  Card _buildName() {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.black, width: 1)
      ),
      color: Colors.amber,
      child: const SizedBox(
        height: 50,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.person),
              SizedBox(
                width: 10,
              ),
              Text('Name'),
              Spacer(),
              Text('Fazle Rabbi',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Profile'),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.edit_note_rounded))
      ],
      backgroundColor: Colors.amber,
    );
  }
}
