import 'package:flutter/material.dart';
import 'package:general_insurance_management/page/Logout.dart';
import 'package:general_insurance_management/service/Auth_Service.dart';

class HeadOffice extends StatefulWidget {
  const HeadOffice({Key? key}) : super(key: key);

  @override
  State<HeadOffice> createState() => _HeadOfficeState();
}

class _HeadOfficeState extends State<HeadOffice> {
  @override
  void initState() {
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'ইসলামী ইন্স্যুরেন্স কোম্পানী বাংলাদেশ লিমিটেড',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'mdkutub150@gmail.com, +8801763001787',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.blue, Colors.lightGreen, Colors.teal],
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQntUidjT9ib73xOZ_LYOvhZg9bSvlU9hOGjaWbTALttUeqeEjJUWKJHbT4r1UqjFM3caQ&usqp=CAU',
              ),
            ),
            tooltip: 'Open Drawer',
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Head Office',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ActionCard(
                  title: 'Manage Policies',
                  icon: Icons.policy,
                  color: Colors.purple,
                  onTap: () => Navigator.of(context).pushNamed('/home'),
                ),
                ActionCard(
                  title: ' Bill Reports',
                  icon: Icons.analytics,
                  color: Colors.cyan,
                  onTap: () => Navigator.of(context).pushNamed('/viewcombindreports'),
                ),

                ActionCard(
                  title: ' Money Receipt Reports',
                  icon: Icons.analytics,
                  color: Colors.pinkAccent,
                  onTap: () => Navigator.of(context).pushNamed('/viewcombindmoneyreports'),
                ),

                ActionCard(
                  title: 'Employee Directory',
                  icon: Icons.people,
                  color: Colors.teal,
                  onTap: () {
                    // Implement navigation or functionality
                  },
                ),
                ActionCard(
                  title: 'Settings',
                  icon: Icons.settings,
                  color: Colors.grey,
                  onTap: () {
                    // Implement navigation or functionality
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                // Perform logout
                await AuthService().logout();

                // Navigate to the Logout page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Logout()),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button background color
                foregroundColor: Colors.white, // Text and icon color
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ActionCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
