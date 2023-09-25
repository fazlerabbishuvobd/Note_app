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
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
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
            const CustomCard(
              icon: Icons.person,
              title: 'Name',
              details: 'Fazle Rabbi',
            ),


            const CustomCard(
              icon: Icons.work_history_outlined,
              title: 'Position',
              details: 'Flutter Developer',
            ),

            const CustomCard(
              icon: Icons.location_on,
              title: 'Location',
              details: 'Mohammadpur,Dhaka',
            ),
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
                        color: Colors.amber
                    ),
                  ),
                  const Spacer(),

                  const Text('Choose Profile Picture From',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            borderRadius: BorderRadius.circular(15)
        )
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.icon,
    required this.title,
    required this.details,
  });

  final IconData icon;
  final String title,details;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.black, width: 1)
      ),
      color: Colors.amber,
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(width: 10),

              Text(title),
              const Spacer(),

              Text(details, style: const TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}
