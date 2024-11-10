import 'package:flutter/material.dart';
import 'package:general_insurance_management/page/Head_Office.dart';
import 'package:general_insurance_management/page/User.dart';

class Home2 extends StatelessWidget {
  final List<String> cardNames = [
    'Fire Policy',
    'Fire Bill',
    'Fire Money Receipt',
    'Marine Policy',
    'Marine Bill',
    'Marine Money Receipt',
  ];

  final List<String> cardRoutes = [
    '/viewfirepolicy',
    '/viewfirebill',
    '/viewfiremoneyreceipt',
    '/viewmarinepolicy',
    '/viewmarinebill',
    '/viewmarinemoneyreceipt',
  ];

  final List<Color> cardColors = [
    Colors.redAccent,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  IconData _getIconForCard(String name) {
    switch (name) {
      case 'Fire Policy':
        return Icons.fire_extinguisher;
      case 'Fire Bill':
        return Icons.receipt_long;
      case 'Fire Money Receipt':
        return Icons.money;
      case 'Marine Policy':
        return Icons.sailing;
      case 'Marine Bill':
        return Icons.document_scanner;
      case 'Marine Money Receipt':
        return Icons.attach_money;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ইসলামী ইন্স্যুরেন্স কোম্পানী বাংলাদেশ লিমিটেড'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.blue, Colors.orange, Colors.purple],
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://avatars.githubusercontent.com/u/158472932?v=4&size=64'),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent,
                    Colors.greenAccent,
                    Colors.orangeAccent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        'https://media.licdn.com/media/AAYQAQSOAAgAAQAAAAAAAB-zrMZEDXI2T62PSuT6kpB6qg.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome, User!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'mdkutub150@example.com',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('App Details'),
              subtitle: Text('Version 1.0.0\nDeveloped by Kutub Uddin'),
              isThreeLine: true,
            ),
            _buildDrawerItem(context, Icons.home, 'Home', '/home'),
            _buildDrawerItem(context, Icons.person, 'Profile', '/profile'),
            _buildDrawerItem(context, Icons.contact_mail, 'Contact Us', '/contact'),
            _buildDrawerItem(context, Icons.settings, 'Settings', '/settings'),
            _buildDrawerItem(context, Icons.logout, 'Logout', '/login'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: cardNames.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, cardRoutes[index]);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getIconForCard(cardNames[index]),
                      size: 40,
                      color: cardColors[index % cardColors.length],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      cardNames[index],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: kBottomNavigationBarHeight,
          width: double.infinity,
          child: IconTheme(
            data: const IconThemeData(color: Colors.green),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Tooltip(
                  message: 'Head Office',
                  child: _buildBottomHeadOffice(context, Icons.business, '/headOffice'),
                ),
                Tooltip(
                  message: 'Local Office',
                  child: _buildBottomLocalOffice(context, Icons.location_city, '/localOffice'),
                ),
                Tooltip(
                  message: 'Home',
                  child: _buildBottomIconButton(context, Icons.home, '/home'),
                ),
                Tooltip(
                  message: 'Search',
                  child: _buildBottomIconButton(context, Icons.search, '/search'),
                ),
                Tooltip(
                  message: 'Notifications',
                  child: _buildBottomIconButton(context, Icons.notifications, '/notifications'),
                ),
                Tooltip(
                  message: 'Profile',
                  child: _buildBottomIconButton(context, Icons.account_circle, '/profile'),
                ),
                Tooltip(
                  message: 'Logout',
                  child: _buildBottomIconButton(context, Icons.login, '/login'),
                ),
                Tooltip(
                  message: 'Registration',
                  child: _buildBottomIconButton(context, Icons.app_registration, '/registration'),
                ),
                Tooltip(
                  message: 'Settings',
                  child: _buildBottomIconButton(context, Icons.settings, '/settings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }

  Widget _buildBottomIconButton(BuildContext context, IconData icon, String route) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}

Widget _buildBottomHeadOffice(BuildContext context, IconData icon, String route) {
  return IconButton(
    icon: Icon(icon),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HeadOffice()),
      );
    },
  );
}

Widget _buildBottomLocalOffice(BuildContext context, IconData icon, String route) {
  return IconButton(
    icon: Icon(icon),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => User()),
      );
    },
  );
}
