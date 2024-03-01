import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TotalPage extends StatefulWidget {
  const TotalPage({Key? key}) : super(key: key);

  @override
  _TotalPageState createState() => _TotalPageState();
}

class _TotalPageState extends State<TotalPage> {
  int totalIncome = 0;
  int totalExpense = 0;
  String filter = 'All';

  @override
  void initState() {
    super.initState();
    _fetchTotals();
  }

  void _fetchTotals() async {
    // Fetch total income and expense from Firestore
    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('totals').doc('total').get();

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

  Widget _buildHorizontalBarChart() {
    List<charts.Series<Expense, String>> series = [
      charts.Series(
        id: "Total",
        data: [
          Expense("Income", totalIncome),
          Expense("Expense", totalExpense),
        ],
        domainFn: (Expense expense, _) => expense.type,
        measureFn: (Expense expense, _) => expense.amount,
        colorFn: (Expense expense, _) => charts.ColorUtil.fromDartColor(
            expense.type == "Income" ? Colors.green : Colors.red),
        labelAccessorFn: (Expense expense, _) => '\₹${expense.amount}',
      ),
    ];

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SizedBox(
        height: 200.0,
        child: charts.BarChart(
          series,
          animate: true,
          vertical: false,
          barRendererDecorator: charts.BarLabelDecorator<String>(),
          domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool canReset = totalIncome != 0 || totalExpense != 0;
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Total"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHorizontalBarChart(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: h*0.025,
                          width: w*0.025,
                          decoration: BoxDecoration(
                              color: Colors.green.shade400,
                              borderRadius: BorderRadius.circular(30)
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          'Total Income: $totalIncome',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          height: h*0.025,
                          width: w*0.025,
                          decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(30)
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text(
                          'Total Expense: $totalExpense',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 30,),
                ElevatedButton(
                  onPressed: canReset ? _resetTotals : null,
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        filter = 'All';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: filter == 'All' ? Colors.blue : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text('All', style: TextStyle(fontSize: 16.0)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        filter = 'Income';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: filter == 'Income' ? Colors.green : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text('Income', style: TextStyle(fontSize: 16.0)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        filter = 'Expense';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: filter == 'Expense' ? Colors.red : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text('Expense', style: TextStyle(fontSize: 16.0)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            SizedBox(height: 30),
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
                    stream: FirebaseFirestore.instance
                        .collection('money')
                        .orderBy('timestamp', descending: true)
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

                      // Filter the transactions based on the selected filter
                      var filteredDocs = snapshot.data!.docs.where((doc) {
                        if (filter == 'All') {
                          return true;
                        } else if (filter == 'Income') {
                          return doc['category'] == 'Income';
                        } else {
                          return doc['category'] == 'Expense';
                        }
                      }).toList();

                      return ListView.builder(
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          var doc = filteredDocs[index];
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
      ),
    );
  }
}

class Expense {
  final String type;
  final int amount;

  Expense(this.type, this.amount);
}

void main() {
  runApp(MaterialApp(
    home: TotalPage(),
  ));
}
