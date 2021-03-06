import 'package:flutter/material.dart';
import 'openSalon.dart';
import 'salon_main.dart';
import 'main.dart';
import 'viewNotif.dart';
import 'ratingGraph.dart';
import 'empPerformance.dart';
class OwnerNavDrawer extends StatelessWidget {
  final String email;
  OwnerNavDrawer(this.email);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 300,
            child: DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              decoration: BoxDecoration(
                  color: Colors.deepPurple[500],
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      //colorFilter: new ColorFilter.mode(Colors.deepPurple[100].withOpacity(0.5), BlendMode.softLight),
                      image: AssetImage('assets/images/menuNavBar4.png'))),
            ),
          ),

          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),

          ListTile(
            leading: Icon(Icons.assignment_outlined),
            title: Text('View Appointments'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.person_search),
            title: Text('View Employee Performance'),
            onTap: () => {
              Navigator.push(context,MaterialPageRoute(builder: (_)=>openSalon(email))),
            },
          ),

          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
            Navigator.of(context).popUntil((route) => route.isFirst),
            },
          ),
        ],
      ),
    );
  }
}