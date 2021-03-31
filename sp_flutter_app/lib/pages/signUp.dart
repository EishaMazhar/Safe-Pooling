import 'package:flutter/material.dart';
// import 'package:login_signup/constants/constants.dart';
import '../widgets/customShape.dart';
import '../widgets/customAppBar.dart';
import '../widgets/responsiveUI.dart';
import '../widgets/textFormField.dart';
import 'logIn.dart';
import 'package:ReserveIt/screens/mainscreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ReserveIt/service/auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool checkBoxValue = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;
  String firstName,lastName,email,password,error;
  int phoneNo;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Material(
      child: Scaffold(
        body: Container(
          height: _height,
          width: _width,
          margin: EdgeInsets.only(bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Opacity(opacity: 0.88,child: CustomAppBar()),
                clipShape(),
                signUpform(),
                // acceptTermsTextRow(),
                SizedBox(height: _height/35,),
                button(),
                // infoTextRow(),
                // socialIconsRow(),
                signInTextRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget clipShape() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large? _height/8 : (_medium? _height/7 : _height/6.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff374ABE), Color(0xffffcc66)],
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large? _height/12 : (_medium? _height/11 : _height/10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff374ABE), Color(0xffffcc66)],
                ),
              ),
            ),
          ),
        ),
        Container(
          height: _height / 5.5,
          alignment: Alignment.center,
          // decoration: BoxDecoration(
          //   // boxShadow: [
          //   //   BoxShadow(
          //   //       spreadRadius: 0.0,
          //   //       color: Colors.black26,
          //   //       offset: Offset(1.0, 10.0),
          //   //       blurRadius: 20.0),
          //   // ],
          //   color: Colors.transparent,
          //   shape: BoxShape.circle,
          // ),
          child: Container(
            height:120,
            width: 110,
            child: Image.asset('assets/img/logo/logo.png',
          fit:BoxFit.fill ,),
          ),
          //  FlutterLogo(size: 100),
         
          //  GestureDetector(
          //     onTap: (){
          //       print('Adding photo');
          //     },

          //     child: Icon(Icons.add_a_photo, size: _large? 40: (_medium? 33: 31),color: Color(0xff374ABE),)
          //     ),
        ),
      ],
    );
  }

  Widget signUpform() {
    return Container(
      margin: EdgeInsets.only(
          left:_width/ 16.0,
          right: _width / 16.0,
          top: _height / 30.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            firstNameTextFormField(),
            SizedBox(height: _height / 60.0),
            lastNameTextFormField(),
            SizedBox(height: _height/ 60.0),
            emailTextFormField(),
            SizedBox(height: _height / 60.0),
            phoneTextFormField(),
            SizedBox(height: _height / 60.0),
            passwordTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget firstNameTextFormField() {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: _large? 14 : (_medium? 12 : 10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        cursorColor:  Color(0xffffcc66),
        obscureText: false,
        validator: (value){
          if(value.isEmpty){
            return "    Please enter your first name";
          }
          return null;
        },
        onChanged: (fname) {
          setState(() {
            this.firstName = fname;
          });
          },
        decoration: InputDecoration(
          prefixIcon: Icon( Icons.person, color: Color(0xff374ABE), size: 22),
          hintText: "First Name",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.white),
             ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
             ),
        ),
      ),
    );
  }

  Widget lastNameTextFormField() {
    return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: _large? 14 : (_medium? 12 : 10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        cursorColor:  Color(0xffffcc66),
        obscureText: false,
        validator: (value){
          if(value.isEmpty){
            return "    Please enter your last name";
          }
          return null;
        },
        onChanged: (value){
         setState(() {
            this.lastName = value;
         });
        },
        decoration: InputDecoration(
          prefixIcon: Icon( Icons.person, color: Color(0xff374ABE), size: 22),
          hintText: "Last Name",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.white),
             ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
             ),
        ),
      ),
    );
  }

  Widget emailTextFormField() {
     return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: _large? 14 : (_medium? 12 : 10),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        cursorColor:  Color(0xffffcc66),
        obscureText: false,
        validator: (value) => EmailValidator.validate(value)? null:"Invalid email address"
        //   if(value.isEmpty){
        //     return "    Please enter your email";
        //   }
        //   return null;
        // }
        ,
        onChanged: (email) {
          setState(() {
            this.email = email;
          });
          },
        decoration: InputDecoration(
          prefixIcon: Icon( Icons.email, color: Color(0xff374ABE), size: 22),
          hintText: "Email",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.white),
             ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
             ),
        ),
      ),
    );
  }

  Widget phoneTextFormField() {
     return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: _large? 14 : (_medium? 12 : 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        cursorColor:  Color(0xffffcc66),
        obscureText: false,
        validator: (value){
          if(value.isEmpty){
            return "    Please enter your phone no.";
          }
          return null;
        },
        onChanged: (phoneNumber){
          setState(() {
            this.phoneNo = int.parse(phoneNumber);
          });
        } ,
        decoration: InputDecoration(
          prefixIcon: Icon( Icons.phone, color: Color(0xff374ABE), size: 22),
          hintText: "Mobile Number",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.white),
             ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
             ),
        ),
      ),
    );
   }

  Widget passwordTextFormField() {
     return Material(
      borderRadius: BorderRadius.circular(30.0),
      elevation: _large? 14 : (_medium? 12 : 10),
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
        onChanged: (password) {
          setState(() {
            this.password = password;
          });
        } ,
        decoration: InputDecoration(
          prefixIcon: Icon( Icons.lock, color: Color(0xff374ABE), size: 22),
          hintText: "Password",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.white),
             ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
             ),
        ),
      ),
    );
  }

  // Widget acceptTermsTextRow() {
  //   return Container(
  //     margin: EdgeInsets.only(top: _height / 100.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Checkbox(
  //             activeColor: Colors.orange[200],
  //             value: checkBoxValue,
  //             onChanged: (bool newValue) {
  //               setState(() {
  //                 checkBoxValue = newValue;
  //               });
  //             }),
  //         Text(
  //           "I accept all terms and conditions",
  //           style: TextStyle(fontWeight: FontWeight.w400, fontSize: _large? 12: (_medium? 11: 10)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget button() {
    return Builder(
      builder: (context) => RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () async {
        print("Making your account");
        if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  print(this.firstName);
                  print(this.lastName);
                  print(this.email);
                  print(this.phoneNo);
                  print(this.password);
                  dynamic result = await _auth.registerWithEmailAndPassword(this.firstName, this.lastName, this.email, this.phoneNo, this.password);
                  print("yes");
                  if(result is String){
                    error = result.split(',')[1];
                    _displaySnackBar(context, error);
                  }
                  else{
                     Navigator.pop(context);
                  //    Navigator.push(context, 
                  //   PageRouteBuilder(
                  //     transitionDuration: Duration(seconds:2),
                  //     transitionsBuilder: (BuildContext context , Animation<double> animation , Animation<double> secAnimation , Widget child){
                  //       animation = CurvedAnimation(parent: animation, curve: Curves.bounceIn);
                  //       return ScaleTransition(
                  //         alignment: Alignment.center,
                  //         scale: animation,
                  //         child: child,
                  //         );
                  //     } ,
                  //     pageBuilder: (BuildContext context , Animation<double> animation , Animation<double> secAnimation){
                  //       return HomeScreen();
                  //     }
                  //     ));
                  }
                //   Scaffold.of(context)
                //       .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
       
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
         constraints: BoxConstraints( minHeight: 60.0),
//        height: _height / 20,
        width:_large? _width/2 : (_medium? _width/1.75: _width/1.5),
        // height: _height/14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Color(0xff374ABE), Color(0xffffcc66)],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text('SIGN UP', style: TextStyle(fontSize: _large? 20: (_medium? 18: 16)),),
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
  // Widget socialIconsRow() {
  //   return Container(
  //     margin: EdgeInsets.only(top: _height / 80.0),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         CircleAvatar(
  //           radius: 15,
  //           backgroundImage: AssetImage("assets/images/googlelogo.png"),
  //         ),
  //         SizedBox(
  //           width: 20,
  //         ),
  //         CircleAvatar(
  //           radius: 15,
  //           backgroundImage: AssetImage("assets/images/fblogo.jpg"),
  //         ),
  //         SizedBox(
  //           width: 20,
  //         ),
  //         CircleAvatar(
  //           radius: 15,
  //           backgroundImage: AssetImage("assets/images/twitterlogo.jpg"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget signInTextRow() {
    return Container(
      margin: EdgeInsets.only(top: _height / 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Already have an account?",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              // Navigator.of(context).pop(SIGN_IN);
              print("Routing to Sign in screen");
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              "Sign in",
              style: TextStyle(
                  fontWeight: FontWeight.w800, color: Color(0xff374ABE), fontSize: 19),
            ),
          )
        ],
      ),
    );
  }
}