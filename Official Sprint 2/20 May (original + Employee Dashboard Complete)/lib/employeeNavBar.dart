import 'package:flutter/material.dart';
import 'EmployeeDashboard.dart';
import 'main.dart';
import 'viewNotif.dart';
class EmpNavDrawer extends StatelessWidget {
  final String uname;
  final String salonname;
  EmpNavDrawer(this.uname, this.salonname);
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
            onTap: () => {Navigator.push(context,
            MaterialPageRoute(builder: (_) => employeeDashboard(this.uname,this.salonname)))},
          ),

          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => { Navigator.push(context,
                MaterialPageRoute(builder: (_) => MyApp())),
            },
          ),
        ],
      ),
    );
  }
}