
import 'package:ReserveIt/models/user.dart';
import 'package:ReserveIt/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class HistoryPage extends StatefulWidget{
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {


  final _formKey = GlobalKey<FormState>();
  String review ;
  double rate  = 0 ;
  DateTime _dateTime = DateTime.now() ;
  final DatabaseService _database = DatabaseService();
  
   Widget build (BuildContext context) {
     final user = Provider.of<User>(context);
    return StreamBuilder(
        stream: Firestore.instance.collection('Users').document(user.uid).collection('Reservations').snapshots(),
        builder: (context,snapshot){
          if(snapshot.data == null) return CircularProgressIndicator();
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,index) => makecard(context,snapshot.data.documents[index] , user),
            );
        },
    );
        }

Widget makecard(BuildContext context , DocumentSnapshot document , user){

 String tareekh = "${_dateTime.day}-${_dateTime.month}-${_dateTime.year}";
  var splittedTareekh = tareekh.split('-');
  var din_now = int.parse(splittedTareekh[0]);
  var maheena_now  = int.parse(splittedTareekh[1]);
  var saal_now  = int.parse(splittedTareekh[2]);
  var splittedDoc = document['Date'].split('-');
  var din = int.parse(splittedDoc[0]);
  var maheena = int.parse(splittedDoc[1]);
  var saal = int.parse(splittedDoc[2]);
  
    if( (document['Accepted'] == 0) && ( ( saal == saal_now && maheena < maheena_now ) || (saal == saal_now && maheena == maheena_now && din < din_now) )  ){
      return Padding(
      padding: EdgeInsets.only(left:18,right: 18,bottom:18 , top:10),
     child: Container(
       width: MediaQuery.of(context).size.width,
       height: 150,
       padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            // color: Colors.blue,
            gradient: LinearGradient(
                    colors: [Color(0xff374ABE), Color(0xffffcc66)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight), 
              boxShadow: [
                  BoxShadow(
                    color : Colors.grey,
                    blurRadius: 5,
                    offset : Offset(0,10)
                  )
                ]
          ),
        child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                      Expanded(child: Text(
                       document['RestaurantName'],
                        style: TextStyle(color: Colors.white , fontSize: 25, fontWeight: FontWeight.bold )
                      ), 
                      ),
                      SizedBox(width:25),
                      Icon(Icons.calendar_today,size: 25,color: Colors.white),
                      SizedBox(width:6),
                      Text(document['Date'],
                      style: TextStyle(
                        fontSize:20,
                        color: Colors.white
                      ),
                      ),                  
                  ],
                ),
                SizedBox(height: 20,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 70,
                        width:150,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.timer,size:25,color: Colors.white),
                       SizedBox(width:3),
                      Text(document['Time'],
                      style: TextStyle(
                        fontSize:20,
                        color: Colors.white
                      ),
                      ),
                     // SizedBox(width:110),
                              ],
                            ),
                          SizedBox(height: 6,),
                   Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.people,size:25,color: Colors.white),
                        SizedBox(width: 6,),
                        Text("People : ",
                        style: TextStyle(
                          fontSize:20 - (document['People'].length + 1).toDouble(),
                          color: Colors.white
                        ),
                        ),
                        Text(document['People'],
                        style: TextStyle(
                          fontSize:20 - (document['People'].length + 1).toDouble(),
                         // fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                        ),
                        //SizedBox(width: 75,),
                      
                      ],
                    ),
                          ]
                          )
                          ), 
                          SizedBox(width:38),
                          Container(
                            child:Center(
                child:RaisedButton(
                  onPressed: () {
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                              right: -40.0,
                              top: -40.0,
                              child: InkResponse(
                                onTap: () {
                                 Navigator.pop(context);
                                },
                                child: CircleAvatar(
                                  child: Icon(Icons.close),
                                  backgroundColor: Colors.black,
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Center(
                                    child: Text("Rate The Restaurant" , 
                                    style: TextStyle(color: Colors.black ,
                                    fontWeight: FontWeight.bold , 
                                    fontSize: 20),
                                    )
                                  ),
                                  SizedBox(height: 20,),
                                      SmoothStarRating(
              allowHalfRating: true,
              onRated: (v) {
                rate = v ;
               },
              starCount: 5,
              rating: rate,
              size: 40.0,
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              color: Colors.yellow,
              borderColor: Colors.yellow,
              spacing:0.0
    ),
                                  SizedBox(height: 20,),
                                  Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Container(
                                       decoration: BoxDecoration(
                                         border: Border.all(color: Colors.grey)
                                          ),
                                      height: 100,
                                      width: 320,
                                      child: TextFormField(
                                        decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "Write your comments here ...",
            contentPadding: const EdgeInsets.all(4.0)),
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        cursorColor:  Color(0xffffcc66),
                                        obscureText: false,
                                        onChanged: (value){
                              setState(() {
                                    this.review= value;
                                      });
                  },
                                      ),
                                    )
                                  ),
                                  SizedBox(height: 20,),          
                                    RaisedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                        }
                                        print(review);
                                        print(rate);
                                        final dynamic result = await _database.addReview(document['Restaurant ID'], user.uid , tareekh , rate , review);
                                        if (result is String)
                                        {
                                          String error = result.split(',')[1];
                                          print(result.split(',')[1]);
                                         _displaySnackBar(context, error);
                                          print("Shahzaib");
                                        }
                                        else{
                                          print("Review Written Successfully ...");
                                          rate = 0 ;
                                          Navigator.pop(context);
                                        }
                                      },
                                      elevation: 0,
                textColor: Colors.white,
                padding: EdgeInsets.all(0),
                                      child: Container(
                                         alignment: Alignment.center,
                    constraints: BoxConstraints( minHeight: 55.0),
                    width:240,
                    decoration: BoxDecoration(
                     // borderRadius: BorderRadius.circular(30.0),
                      gradient: LinearGradient(colors: <Color>[Color(0xff374ABE), Color(0xffffcc66)]
                      ),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Text(' SUBMIT ', style: TextStyle(fontSize: 18),
                  ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
                elevation: 0,
                textColor: Colors.white,
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36.0)),
              child: 
              Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.white, Colors.white],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(36.0),
                      ),
                      child: Container(
                        constraints: BoxConstraints(minWidth: 140.0, minHeight: 50.0),
                        alignment: Alignment.center,
                        child: Text("Write Review",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,),
                      ),
                      ),
                    ),
                ) 
                ,),
                          )   
                    ],
                  ),
                        
                  
              ],
            ),
     ),
     );

    }
 
     else{
       return Container();
     }
}

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
      


