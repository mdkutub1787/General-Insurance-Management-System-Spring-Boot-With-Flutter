import 'dart:async';
import 'package:flutter/material.dart';
import 'package:general_insurance_management/page/Head_Office.dart';
import 'package:general_insurance_management/page/Local_Office.dart';
import 'package:general_insurance_management/page/User.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _carouselIndex = 0;
  late PageController _pageController;
  Timer? _timer;
  int _hoverIndex = -1;
  late AnimationController _animationController;

  static const List<String> _images = [
    'https://www.shutterstock.com/image-photo/family-house-car-protected-by-260nw-1502368643.jpg',
    'https://www.shutterstock.com/image-photo/insurer-protecting-family-house-car-260nw-1295560780.jpg',
    'https://png.pngtree.com/template/20220516/ourmid/pngtree-insurance-policy-banner-template-flat-design-illustration-editable-of-square-background-image_1571396.jpg',
  ];

  static const List<String> _texts = [
    'সবার চোখের সামনেই তাদের ভবিষ্যত থাকে',
    'এটাকে শুধু পরিকল্পনা অনুযায়ী সাজিয়ে নিতে হয়',
    'জীবনে অনেক কাজে আসতে পারে ',
  ];

  static const List<Color> _colors = [
    Colors.purple,
    Colors.green,
    Colors.lime,
  ];

  final List<Map<String, String>> myItems = [
    {
      "img": "https://cdn-icons-png.flaticon.com/128/1973/1973100.png",
      "title": "Fire Policy"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/128/1861/1861925.png",
      "title": "Fire Bill"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/128/3705/3705833.png",
      "title": "Fire Money Receipt"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/128/2485/2485104.png",
      "title": "Marine Policy"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/128/14173/14173808.png",
      "title": "Marine Bill"
    },
    {
      "img": "https://cdn-icons-png.flaticon.com/128/9721/9721335.png",
      "title": "Marine Money Receipt"
    },
  ];

  final List<String> cardRoutes = [
    '/viewfirepolicy',
    '/viewfirebill',
    '/viewfiremoneyreceipt',
    '/viewmarinepolicy',
    '/viewmarinebill',
    '/viewmarinemoneyreceipt',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPageChange();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.95,
      upperBound: 1.05,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startAutoPageChange() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _carouselIndex = (_carouselIndex + 1) % _images.length;
      });
      _pageController.animateToPage(
        _carouselIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'mdkutub150@gmail.com, +8801763001787',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green,
                Colors.blue,
                Colors.lightGreen,
                Colors.teal
              ],
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQntUidjT9ib73xOZ_LYOvhZg9bSvlU9hOGjaWbTALttUeqeEjJUWKJHbT4r1UqjFM3caQ&usqp=CAU',
              ),
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
                  colors: [Colors.blueAccent, Colors.greenAccent, Colors.orangeAccent],
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
                        'https://avatars.githubusercontent.com/u/158472932?v=4&size=64'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome, User!',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'mdkutub150@example.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(context, Icons.person, 'Profile', '/profile'),
            _buildDrawerItem(context, Icons.contact_mail, 'Contact Us', '/contact'),
            _buildDrawerItem(context, Icons.business, 'Head Office', '/headOffice'),
            _buildDrawerItem(context, Icons.location_city, 'Local Office', '/localOffice'),
            _buildDrawerItem(context, Icons.settings, 'Settings', '/settings'),
            Divider(),  // Add a divider to separate login/logout from other items
            _buildDrawerItem(context, Icons.login, 'Login', '/login'),
            _buildDrawerItem(context, Icons.logout, 'Logout', '/login'),
          ],
        ),
      ),



    body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                height: 160,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _carouselIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      color: _colors[index],
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            _images[index],
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Text(
                              _texts[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                backgroundColor: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.2,
                ),
                itemCount: myItems.length,
                itemBuilder: (context, index) {
                  return MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _hoverIndex = index;
                      });
                      _animationController.forward();
                    },
                    onExit: (_) {
                      setState(() {
                        _hoverIndex = -1;
                      });
                      _animationController.reverse();
                    },
                    child: ScaleTransition(
                      scale: _hoverIndex == index
                          ? _animationController
                          : const AlwaysStoppedAnimation(1),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, cardRoutes[index]);
                        },
                        child: Card(
                          color: Colors.amber[50],
                          elevation: _hoverIndex == index ? 10 : 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: NetworkImage(myItems[index]["img"]!),
                                    fit: BoxFit.contain,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.5),
                                      spreadRadius:
                                          _hoverIndex == index ? 2 : 0,
                                      blurRadius: _hoverIndex == index ? 6 : 0,
                                      offset: Offset(
                                          0, _hoverIndex == index ? 9 : 0),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                myItems[index]["title"]!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
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
          ],
        ),
      ),


      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // Use pushReplacement for the Head Office button
              IconButton(
                icon: Icon(Icons.business, color: Colors.blue),
                tooltip: 'Head Office',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HeadOffice()),
                  );
                },
              ),

              IconButton(
                icon: Icon(Icons.business, color: Colors.blue),
                tooltip: 'Local Office',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => User()),
                  );
                },
              ),
              _buildBottomIconButton(context, Icons.home, '/home', 'Home'),
              _buildBottomIconButton(context, Icons.search, '/search', 'Search'),
              _buildBottomIconButton(context, Icons.notifications, '/notifications', 'Notifications'),
            ],
          ),
        ),
      ),

    );
  }



  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }

  Widget _buildBottomIconButton(
      BuildContext context, IconData icon, String route, String label) {
    return IconButton(
      icon: Icon(icon),
      color: Colors.blue, // Set the icon color to green
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      tooltip: label,
    );
  }
}
