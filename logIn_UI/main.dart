import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool isRememberMe=false;
  Widget buildEmail(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget>[
        Text(
          'Email',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight:FontWeight.bold
          ),
        ),
        SizedBox(height:10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color:Colors.white,
              borderRadius:BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38,
                    blurRadius:6,
                    offset: Offset(0,2)
                )
              ]
          ),
          height:60,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                color: Colors.black38
            ),
            decoration: InputDecoration(
                border:InputBorder.none,
                contentPadding: EdgeInsets.only(top:14),
                prefixIcon: Icon(
                    Icons.email,
                    color: Color(0xffb19cd9)
                ),
                hintText: 'Email',
                hintStyle:TextStyle(
                    color: Colors.black38
                )
            ),
          ),
        ),

      ],
    );

  }
  Widget buildPassword(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget>[
        Text(
          'Password',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight:FontWeight.bold
          ),
        ),
        SizedBox(height:10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color:Colors.white,
              borderRadius:BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38,
                    blurRadius:6,
                    offset: Offset(0,2)
                )
              ]
          ),
          height:60,
          child: TextField(
            obscureText: true,
            style: TextStyle(
                color: Colors.black38
            ),
            decoration: InputDecoration(
                border:InputBorder.none,
                contentPadding: EdgeInsets.only(top:14),
                prefixIcon: Icon(
                    Icons.lock,
                    color: Color(0xffb19cd9)
                ),
                hintText: 'Password',
                hintStyle:TextStyle(
                    color: Colors.black38
                )
            ),
          ),
        ),

      ],
    );

  }
  Widget forgotPassword(){
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print("FORGOT PASSWORD WAS PRESSED"),
       // padding: EdgeInsets.only(right:0),
        child: Text('Forgot Password?',
          style: TextStyle(
            color:Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),

      ),

    );
  }
  Widget googlebutton(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children:<Widget>[
          GestureDetector(
              onTap: ()=> print("LOG IN WITH GOOGLE ACCOUNT"),
              child: Container(
                height: 40.0,
                width:60.0,
                decoration: BoxDecoration(
                  shape:BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26,
                      offset: Offset(0,2),
                      blurRadius: 6.0,

                    ),
                  ],
                  image: DecorationImage(
                      image: AssetImage('assets/google.jpg')
                  ),
                ),
              )
          ),




        ],
      ),
    );

  }
  Widget buildRememberme(){
    return Container(
      height:20,
      child: Row(
          children:<Widget>[
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: isRememberMe,
                checkColor: Color(0xffb19cd9),
                activeColor: Colors.white,
                onChanged: (value){
                  setState(() {
                    isRememberMe=value;
                  });
                },
              ),

            ),
            Text(
              'Remember Me',
              style:TextStyle(
                color:Colors.white,
                fontWeight: FontWeight.normal
              ),
            ),
          ],
      ),
    );
  }

  Widget createLoginButton(){
    return Container(
      padding: EdgeInsets.symmetric(vertical:10.0),
      child:RaisedButton(
        elevation: 5.0,
        onPressed: ()=>print("LOG IN BUTTON CLICKED"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),

        ),
          color: Colors.white,
          padding:EdgeInsets.all(15.0),
          child: Text(
          'LOG IN',
          style: TextStyle(
            color:Color(0xffb19cd9),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,


      ),
      ),

      ),

    );
}
Widget or(){
  return Container(
      child:
          Text(
           " OR",
           style: TextStyle(
              color:Colors.white,
              fontWeight: FontWeight.normal,
           ),
      ),
  );
  }
Widget createSignup(){
  return GestureDetector(
    onTap:() => print("SIGN UP WAS CLICKED"),
    child:
    new Text(
    " Don't have an account? SIGN UP",
    style: TextStyle(
    color:Colors.white,
    fontWeight: FontWeight.normal,
    ),
    ),
  );
  }
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceInOut,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        new Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x60b19cd9),
                    Color(0x99b19cd9),
                    Color(0xCCb19cd9),
                    Color(0xffb19cd9),
                  ]
              )
          ),
          width: 250,
          height: 250,

        ),
        new Theme(
          data: new ThemeData(
              brightness: Brightness.dark,
              inputDecorationTheme: new InputDecorationTheme(
                // hintStyle: new TextStyle(color: Colors.blue, fontSize: 20.0),
                labelStyle:
                    new TextStyle(color: Colors.tealAccent, fontSize: 25.0),
              )),

          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal:40,
              vertical: 30,
            ),
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[



                new Image(
                  image: new AssetImage("assets/logo3-8.png"),
                  width: _iconAnimation.value * 200.0,
                  height: _iconAnimation.value * 100.0,

                ),
                  Text(
                      'Sign In',
                      style:TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight:FontWeight.bold
                      )
                  ),
                SizedBox(height:10),
                buildEmail(),
                  SizedBox(height:5),
                  buildPassword(),
                  forgotPassword(),
                  buildRememberme(),
                  createLoginButton(),
                  or(),
                  googlebutton(),
                  createSignup(),

              ],
            ),
          ),
        ),
      ]),
    );
  }
}

