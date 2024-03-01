import 'package:construction_app/Screens/total.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add money page.dart';


class MoneyHome extends StatefulWidget {
  const MoneyHome({Key? key});

  @override
  State<MoneyHome> createState() => _MoneyHomeState();
}

class _MoneyHomeState extends State<MoneyHome> {
  String? uname;
  int _selectedIndex = 0;
  int totalIncome = 0;
  int totalExpense = 0;

  getudetails() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .get();
    setState(() {
      uname = ds.get('Username');
    });
  }

  void _fetchTotals() async {
    // Fetch total income and expense from Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('totals').doc('total').get();

    // Update total income and expense
    setState(() {
      totalIncome = snapshot['totalIncome'] ?? 0;
      totalExpense = snapshot['totalExpense'] ?? 0;
    });
  }

  void _resetTotals() {
    // Reset total income and expense to 0
    FirebaseFirestore.instance.collection('totals').doc('total').update({
      'totalIncome': 0,
      'totalExpense': 0,
    }).then((_) {
      // Update local state
      setState(() {
        totalIncome = 0;
        totalExpense = 0;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Totals reset successfully')),
      );
    }).catchError((error) {
      // Show error message if resetting totals fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset totals: $error')),
      );
    });
  }



  void _reloadTotalsData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('totals').doc('total').get();
      setState(() {
        totalIncome = snapshot['totalIncome'] ?? 0;
        totalExpense = snapshot['totalExpense'] ?? 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Total income and expense data reloaded')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reload total income and expense data: $error')),
      );
    }
  }



  void initState() {
    super.initState();
    _fetchTotals();
    getudetails();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Color(0xFFB7D9AE),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: h * 0.870,
                    width: w * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 10, right: 8),
                          child: Row(
                            children: [
                              Text(
                                'Hello,',
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 10, right: 8),
                          child: Row(
                            children: [
                              Text(
                                uname.toString(),
                                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: h * 0.3,
                          width: w * 0.845,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(top: 30,left: 20),
                                child: Row(
                                  children: [
                                    Container(
                                      height: h*0.03,
                                      width: w*0.03,
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade400,
                                        borderRadius: BorderRadius.circular(30)
                                      ),
                                    ),
                                    SizedBox(width: 8,),
                                    Text("Income"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child:
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total Income: $totalIncome',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30,left: 20),
                                child: Row(
                                  children: [
                                    Container(
                                      height: h*0.03,
                                      width: w*0.03,
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade400,
                                        borderRadius: BorderRadius.circular(30)
                                      ),
                                    ),SizedBox(width: 8,),
                                    Text("Expense"),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child:
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total Expense: $totalExpense',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: _reloadTotalsData,
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFB7D9AE), // Background color
                                        onPrimary: Colors.black, // Text color
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15), // Rounded corners
                                          side: BorderSide(color: Color(0xFFCDD9CB), width: 2), // Border
                                        ),
                                        elevation: 2, // Elevation
                                        minimumSize: Size(120, 40), // Button size
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Button padding
                                      ),
                                      child: Text(
                                        "Reload",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 30,),
                                    ElevatedButton(
                                      onPressed: _resetTotals,
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFFB7D9AE), // Background color
                                        onPrimary: Colors.black, // Text color
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15), // Rounded corners
                                          side: BorderSide(color: Color(0xFFCDD9CB), width: 2), // Border
                                        ),
                                        elevation: 2, // Elevation
                                        minimumSize: Size(120, 40), // Button size
                                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Button padding
                                      ),
                                      child: Text(
                                        "Reset data",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TotalPage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 25,top: 10,right: 25),
                            child: Row(
                              children: [
                                Text("See All Transection",style: GoogleFonts.laila(fontSize: 18,fontWeight: FontWeight.bold),),
                                Spacer(),
                                Icon(Icons.arrow_forward,size: 30,)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30, right: 10, left: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent, // Transparent background color
                                borderRadius: BorderRadius.circular(20), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.transparent, // Shadow color
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0, 2), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance.collection('money')
                                    .orderBy('timestamp', descending: true)
                                    .limit(4)
                                    .snapshots(),
                                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
                                  }
                                  if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  }
                                  if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                                    return Center(child: Text('No transactions found'));
                                  }

                                  // Snapshot data is already in the correct order, no need to reverse it

                                  return ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      var doc = snapshot.data!.docs[index];
                                      var amount = doc['amount'];
                                      var category = doc['category'];
                                      String name = doc['name'];
                                      var paymentType = doc['paymentType'];
                                      var timestamp = doc['timestamp'];

                                      return ListTile(
                                        title: Text(
                                          '$category',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.blue, // Title text color
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  name,
                                                  style: TextStyle(fontSize: 20),
                                                ),
                                                Spacer(),
                                                Text(
                                                  amount,
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              paymentType,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Text(
                                              'Timestamp: ${timestamp.toDate()}',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),

                            ),
                          ),
                        ),



                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10)),
                    child: buildNavBarItem(Icons.home, 0)),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10)),
                    child: buildNavBarItem(Icons.add, 1)),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10)),
                    child: buildNavBarItem(Icons.settings, 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          if (_selectedIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MoneyPage()),
            );
          } else if (_selectedIndex == 2) {
            // Navigate to the appropriate page

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TotalPage()),
            );
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: Color(0xFF0C0C3D),
        ),
      ),
    );
  }
}
