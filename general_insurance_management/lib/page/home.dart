import 'package:flutter/material.dart';

class Home extends StatelessWidget {
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
    Colors.red,
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.blue, Colors.orange, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text(
              "ইসলামী ইন্স্যুরেন্স কোম্পানী বাংলাদেশ লিমিটেড",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
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
                  const CircleAvatar(
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
              return Card(
                elevation: 3.0,
                color: cardColors[index % cardColors.length],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, cardRoutes[index]);
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getIconForCard(cardNames[index]),
                            size: 40,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            cardNames[index],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.blue, Colors.orange],
            ),
          ),
          child: IconTheme(
            data: const IconThemeData(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildBottomIconButton(context, Icons.home, '/home'),
                _buildBottomIconButton(context, Icons.search, '/search'),
                _buildBottomIconButton(context, Icons.notifications, '/notifications'),
                _buildBottomIconButton(context, Icons.account_circle, '/profile'),
                _buildBottomIconButton(context, Icons.login, '/login'),
                _buildBottomIconButton(context, Icons.app_registration, '/registration'),
                _buildBottomIconButton(context, Icons.settings, '/settings'),
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
