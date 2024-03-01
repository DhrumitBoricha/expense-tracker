import 'package:construction_app/Screens/total.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoneyPage extends StatefulWidget {
  const MoneyPage({Key? key}) : super(key: key);

  @override
  _MoneyPageState createState() => _MoneyPageState();
}

class _MoneyPageState extends State<MoneyPage> {
  late TextEditingController _amountController;
  late TextEditingController _nameController;
  String _category = "Income"; // Default category
  String _paymentType = "Cash"; // Default payment type

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Widget _customRadioButton({
    required String title,
    required String value,
    required String groupValue,
    required Function onChanged,
  }) {
    bool isSelected = groupValue == value;
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: isSelected ? Colors.blue : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.blue.withOpacity(0.5) : Colors.transparent,
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    // Extract form data
    String amount = _amountController.text;
    String name = _nameController.text;

    // Determine whether the entry is income or expense
    bool isExpense = _category == 'Expense';

    // Calculate the amount to be added or subtracted from total income
    int amountToAddToIncome = isExpense ? -int.parse(amount) : int.parse(amount);

    // Calculate the amount to be added to total expense
    int amountToAddToExpense = isExpense ? int.parse(amount) : 0;

    // Upload data to Firestore
    FirebaseFirestore.instance.collection('money').add({
      'amount': amount,
      'category': _category,
      'name': name,
      'paymentType': _paymentType,
      'timestamp': Timestamp.now(),
    }).then((_) {
      // Reset form after successful submission
      _amountController.clear();
      _nameController.clear();
      setState(() {
        _category = "Income"; // Reset category to default
        _paymentType = "Cash"; // Reset payment type to default
      });

      // Update total income by adding or subtracting the amount based on the category
      FirebaseFirestore.instance.collection('totals').doc('total').update({
        'totalIncome': FieldValue.increment(amountToAddToIncome),
        'totalExpense': FieldValue.increment(amountToAddToExpense),
      }).then((_) {
        // Navigate to TotalPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TotalPage()),
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully')),
        );
      }).catchError((error) {
        // Show error message if updating totals fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update totals: $error')),
        );
      });

    }).catchError((error) {
      // Show error message if submission fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit form: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Money Page"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Money',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(0xFFD3E1D0),
              ),
              child: TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  hintText: 'Amount',
                  border: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(0xFFD3E1D0),
              ),
              child: DropdownButtonFormField<String>(
                value: _category,
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
                items: <String>['Income', 'Expense']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 18.0)),
                  );
                }).toList(),
                decoration: InputDecoration(
                  hintText: 'Category',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
              )
            ),
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Color(0xFFD3E1D0),
              ),
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(height: 16.0),
            Text('Payment Type', style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 8.0),
            Wrap(
              spacing: 16.0,
              children: [
                _customRadioButton(
                  title: 'Cash',
                  value: 'Cash',
                  groupValue: _paymentType,
                  onChanged: (value) {
                    setState(() {
                      _paymentType = value;
                    });
                  },
                ),
                _customRadioButton(
                  title: 'Online',
                  value: 'Online',
                  groupValue: _paymentType,
                  onChanged: (value) {
                    setState(() {
                      _paymentType = value;
                    });
                  },
                ),
                _customRadioButton(
                  title: 'Card',
                  value: 'Card',
                  groupValue: _paymentType,
                  onChanged: (value) {
                    setState(() {
                      _paymentType = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFB7D9AE), // Background color
                    onPrimary: Colors.black, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Rounded corners
                      side: BorderSide(color: Color(0xFFCDD9CB), width: 2), // Border
                    ),
                    elevation: 2, // Elevation
                    minimumSize: Size(180, 60), // Increased button size
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Button padding
                  ),
                  child: Text(
                    "ADD",
                    style: TextStyle(
                      fontSize: 16, // Increased font size
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
