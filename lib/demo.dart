import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thexeasonapp/presentation/features/auth/pages/login_page.dart';
import 'package:thexeasonapp/presentation/features/auth/widgets/auth_button.dart';
import 'package:thexeasonapp/src/theme/spacer.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //Appbar
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('Xeason App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              // Navigate to settings page
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to settings page
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.chat_bubble_fill),  
            onPressed: () {
              // Navigate to settings page
            },
          ),
        ],
      ),
      //body
      body: _buildbody(),
    );
  }

  Widget _buildbody(){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 410,vertical: 10),
      child: Column(
        children: [
          //Top Navigation
          _buildTopNavigation(),
          SizedBox(height: 10),
          Text(MediaQuery.of(context).size.width.toString()),
          spacer,
          AuthButton(action: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoginPage()));
          }, title: "Login"),
          spacer,
          //dummy posts
         Expanded(
           child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context,index) {
            return _buildCard();
           }),
         )
          ],
      ),
    );
  }

  Widget _buildTopNavigation(){
    List<Widget>destinations = [
       NavigationDestination(
        icon: Icon(CupertinoIcons.home),
        label: 'Home',
        selectedIcon: Icon(CupertinoIcons.home),
      ),
      const NavigationDestination(
        icon: Icon(Icons.video_collection),
        label: 'Stories',
      ),
      const NavigationDestination(
        icon: Icon(Icons.notifications_none),
        label: 'Notifications',
      ),
      const NavigationDestination(
        icon: Icon(CupertinoIcons.settings),
        label: 'Settings',
      ),
    ];
    int currentIndex = 0;
    return NavigationBar(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      
    destinations: destinations, 
    selectedIndex: currentIndex,
    onDestinationSelected:(value) {
      setState(() {
        currentIndex = value;
      });
    },
    );
  }
  Widget _buildCard(){
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.album),
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
          Container(
            height: 200,
            color: Colors.grey,
            child: Center(
              child: Icon(
                Icons.play_circle_outline,
                size: 64,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart.',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('BUY TICKETS'),
              ),
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('LISTEN'),
              ),
            ],
          ),
        ],
      ),
    );
  }

}