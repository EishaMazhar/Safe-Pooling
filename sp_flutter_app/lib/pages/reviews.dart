import 'package:ReserveIt/models/user.dart';
import 'package:ReserveIt/service/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';

class ReviewPage extends StatefulWidget{
  final String id;
  ReviewPage({
    this.id,
  });
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<ReviewPage> {

  String review ;
  double rate  = 0 ;


  bool userinfo = false;
var userData;
  void getUser(String uid) async {
    userData = await DatabaseService(uid: uid).getUserInfo();
    setState(() {
      userinfo = true;
    });
  }

  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
  if(!userinfo){
      print(" getting userinfo ");
      getUser(user.uid);
      return Container();
    }
    else{
      return Scaffold(
        body: SingleChildScrollView(
        child: Container(
                  child: Column(
            children: <Widget> [
               StreamBuilder (
              stream: Firestore.instance.collection('Restaurants').document(widget.id).collection('Reviews').snapshots(),
              builder: (context,snapshot){
                if (snapshot.hasData && snapshot.data.documents.length > 0) {
                  print("length : ");
                  print(snapshot.data.documents.length);
                   return ListView.builder(
                                shrinkWrap: true,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context,index) => makecard(context,snapshot.data.documents[index]),
                   );
                }
              else{
                return Container();
              }
              }
             ), 
            ]
          ),
        ),
    ),
      ); 
    }
  }

  Widget makecard(BuildContext context , DocumentSnapshot doc){
    print(doc);
    print(2);
    return StreamBuilder(
      stream : Firestore.instance.collection('Users').document(doc['User ID']).snapshots(),
      builder: (context , snapshot){
       var data = snapshot.data; 
         return Padding(
      padding: EdgeInsets.all(18),
     child: Container(
       width: MediaQuery.of(context).size.width,
       height: 190,
        //  padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(
              color: Colors.grey,
            ),
            gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              boxShadow: [
                  BoxShadow(
                    color : Colors.grey,
                    blurRadius: 6,
                    offset : Offset(0,8)
                  )
                ]
          ),
        child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                     SizedBox(width: 10,),
                     Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(60.0),
                          boxShadow: [
                              BoxShadow(
                                  blurRadius: 3.0,
                                  offset: Offset(0, 4.0),
                                  color: Colors.black38),
                            ],
                            image: DecorationImage(
                              image: NetworkImage(data['image']),
                              fit: BoxFit.fill,
                            ),
                          ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                       "${data['firstName']} " + "${data['lastName']}", 
                        style: TextStyle(color: Colors.black , fontSize: 18, fontWeight: FontWeight.bold )
                      ),
                      SizedBox(width:48),
                      Icon(Icons.star,
                      color: Colors.yellow),
                      Text(doc['Rating'].toString() , style: TextStyle(color: Colors.black , fontSize: 18,)
                      ),
                          ],
                        ), 
                      Text(
                       doc['Date'],
                        style: TextStyle(color: Colors.black , fontSize: 15,  ),
                        textAlign: TextAlign.left,
                      ),
                      ],
                    ),                   
                  ],
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: EdgeInsets.only(top:5 , bottom: 5 , left: 30 , right: 30 ),
                  child: Divider(),
                ),
                SizedBox(height: 5,),
                  Container(
                    padding: EdgeInsets.only(right:20, left:20),
                    width:MediaQuery.of(context).size.width,
                    height: 70,
                    child: Text(doc['Review'],
                      style: TextStyle(
                        fontSize:18,
                        color: Colors.black
                      ),
                      textAlign: TextAlign.left,
                      ),
                  ),
                  
                  
              ],
              
            ),
     ),
     );
      }
    ); 
     
}

 Widget rating (ratee) {

    return RatingBar.readOnly(
                    initialRating: ratee,
                    isHalfAllowed: true,
                    halfFilledIcon: Icons.star_half,
                    filledIcon: Icons.star,
                    emptyIcon: Icons.star_border,
                    filledColor: Colors.yellow,
                    emptyColor: Colors.yellowAccent,
                    halfFilledColor: Colors.yellow,
                    size: 20,
                      );
  }

}
