import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ReserveIt/widgets/textFormField.dart';
import '../widgets/responsiveUI.dart';
import 'package:ReserveIt/service/auth.dart';
import 'package:ReserveIt/pages/signUp.dart';
import 'package:ReserveIt/shared/loader.dart';
import 'package:ReserveIt/screens/mainscreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  String _email,_password,error;
  bool loader = false;

  @override
  Widget build(BuildContext context) {
     _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    if(loader){
      return Loader();
    }
    else{
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: new IconThemeData(color: Colors.black),
          elevation: 80 ,
        ),
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                height: 350,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 0.0,
                        color: Colors.black26,
                        offset: Offset(1.0, 10.0),
                        blurRadius: 20.0),
                  ],
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: 
                // FlutterLogo(size: 100),
                SvgPicture.asset('assets/img/signup.svg',
                fit:BoxFit.cover ,),
                 ),
                 SizedBox(
                  height: _height / 40.0
                  ),
                loginForm(),
                // acceptTermsTextRow(),
                SizedBox(height: 30),
                button(),

                signUpTextRow(),
                // // infoTextRow(),
                // // socialIconsRow(),
                // signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
    }
  }
  Widget loginForm(){
    return Container(
      margin:  EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top:  20.0),
      child: Form(
        key: _formKey,
        child: Column(
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.circular(30.0),
            elevation: _large? 12 : (_medium? 10 : 8),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              cursorColor:  Color(0xffffcc66),
              obscureText: false,
              validator: (value){
                if(value.isEmpty){
                  return "    Please enter your email";
                }
                return null;
              },
              onChanged: (value){
                setState(() {
                  this._email= value;
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: Color(0xff374ABE), size: 22),
                hintText: "Email",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.white)),
                 border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    ),
              ),
            ),
          ),
          SizedBox(
           height: _height / 40.0
          ),
           Material(
            borderRadius: BorderRadius.circular(30.0),
            elevation: _large? 12 : (_medium? 10 : 8),
            child: TextFormField(
              keyboardType: TextInputType.text,
              cursorColor:  Color(0xffffcc66),
              obscureText: true,
              validator: (value){
                if(value.length < 6){
                  return "    Length should be greater than 5";
                }
                return null;
              },
              onChanged: (value){
                setState(() {
                  this._password= value;
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline, color: Color(0xff374ABE), size: 22),
                hintText: "Password",
                 enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.white)),
                 border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget button(){
    return Builder(
                      builder: (context) =>RaisedButton(
      onPressed: () async {
         print("login pressed");
        print(this._password);
        print(this._email);
        if(_formKey.currentState.validate()){
          // setState(() {
          //   print("yesss");
          //   this.loader = true;
          // });
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Container(child: Loader(),);
            });
          final dynamic result = await _auth.signInWithEmailAndPassword(this._email, this._password);
          
          //  setState(() {
          //     print("Nooo");
          //   this.loader = false;
            
          //   // Navigator.pop(context);
          // });
          if(result is String){
            Navigator.pop(context);
            error = result.split(',')[1];
            print(result.split(',')[1]);
            _displaySnackBar(context, error);
            print("Shahzaib");
          }
          else{
           
          // Navigator.pop(context);
          int count = 0;
            Navigator.popUntil(context, (route) {
              return count++ == 2;
              // if (count++ == 2) {
              //   (route.settings.arguments as Map)['result'] = 'User';
              //   return true;
              //    } 
              //    else{
              //      return 
              //    }
            });
            
              // Navigator.push(context, 
              //       PageRouteBuilder(
              //         transitionDuration: Duration(seconds:2),
              //         transitionsBuilder: (BuildContext context , Animation<double> animation , Animation<double> secAnimation , Widget child){
              //           animation = CurvedAnimation(parent: animation, curve: Curves.bounceIn);
              //           return ScaleTransition(
              //             alignment: Alignment.center,
              //             scale: animation,
              //             child: child,
              //             );
              //         } ,
              //         pageBuilder: (BuildContext context , Animation<double> animation , Animation<double> secAnimation){
              //           return HomeScreen();
              //         }
              //         ));
          }
          
        }
       
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 0,
      textColor: Colors.white,
      padding: EdgeInsets.all(0),
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints( minHeight: 60.0),
        width:_large? _width/2 : (_medium? _width/1.75: _width/1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(colors: <Color>[Color(0xff374ABE), Color(0xffffcc66)]
          ),
        ),
         padding: const EdgeInsets.all(12.0),
         child: Text('Log In', style: TextStyle(fontSize: _large? 20: (_medium? 18: 16))),
  
      ),

    ),
    );

  }

    _displaySnackBar(BuildContext context, String error) {
    final snackBar = SnackBar(
      content: Text(
        error,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontStyle: FontStyle.normal,
        ),
      ),
      backgroundColor: Colors.red,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Widget signUpTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 47.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Don't have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              // Navigator.of(context).pop(SIGN_IN);
              print("Routing to Sign up screen");
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
            },
            child: Text(
              "Sign up",
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Color(0xff374ABE), fontSize: 19),
            ),
          )
        ],
      ),
    );
  }
}