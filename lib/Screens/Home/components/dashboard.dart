import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unipay/Screens/Transactions/transactions.dart';
import '../../../components/constants.dart';
import '../../QR/scanner.dart';
import '../../Recieve/generate_qr_code.dart';
import '../../Send/sendmoney.dart';
import '../../Settings/settings.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String userEmail = "";
  String userName = "";
  int userBalance = 0;
  int _selectedIndex = 0;
  late PageController _pageController;
  late String greeting;
  late List<TransactionData> transactions = [];
  final int maxTransactionsToShow = 4; // Change this number as needed

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    fetchUserData();
    greeting = _getGreeting();
    fetchTransactions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? "Email not found";
        userName = user.displayName ?? "Name not found";
      });
    }

    final firestore = FirebaseFirestore.instance;
    final userBalanceDoc = firestore.collection('users').doc(user?.uid);

    try {
      final documentSnapshot = await userBalanceDoc.get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        final balance = data?['Balance'];
        setState(() {
          userBalance = (balance ?? 0) as int;
        });
      } else {
        print("Document does not exist.");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> fetchTransactions() async {
    try {
      // Clear the existing transactions list
      setState(() {
        transactions.clear();
      });

      // Fetch the current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the collection
      CollectionReference transactionsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('transactions');

      QuerySnapshot transactionSnapshot;
      DocumentSnapshot<Object?>? lastDocument;

      // Keep fetching transactions until there are no more documents
      do {
        // Fetch transactions with pagination
        Query query = lastDocument != null
            ? transactionsCollection.orderBy('Timestamp', descending: true).startAfterDocument(lastDocument).limit(10)
            : transactionsCollection.orderBy('Timestamp', descending: true).limit(10);

        transactionSnapshot = await query.get();

        print('Fetching transactions...');
        print('Last document: $lastDocument');
        print('Retrieved ${transactionSnapshot.docs.length} documents');

        if (transactionSnapshot.docs.isEmpty) {
          print('No more transactions found for the current user.');
          break;
        }

        // Iterate through each transaction document and fetch details
        for (DocumentSnapshot transactionDoc in transactionSnapshot.docs) {
          Map<String, dynamic>? data = transactionDoc.data() as Map<String, dynamic>?;

          if (data == null || data['Timestamp'] == null) {
            // Skip this transaction if DateTime field is null
            continue;
          }

          String name = data['Name'];
          String type = data['Type'];
          int amount = data['Amount'];
          Timestamp timestamp = data['Timestamp'];

          DateTime transactionTime = timestamp.toDate();

          // Create a TransactionData object and add it to the list
          TransactionData transaction = TransactionData(
            name: name,
            type: type,
            amount: amount,
            timestamp: transactionTime,
          );

          setState(() {
            transactions.add(transaction);
          });
        }

        // Update the last document to start after for the next pagination
        lastDocument = transactionSnapshot.docs.last;
      } while (transactionSnapshot.docs.length == 10); // Keep fetching until less than 10 documents are retrieved
    } catch (error) {
      print('Error fetching transactions: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color12,
      body: PageView(
        controller: _pageController,
        // physics: NeverScrollableScrollPhysics(), //remove comment to stop navigation by swiping left n right
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          _buildDashboard(),
          SendMoney(),
          Scanner(),// Replace these with appropriate pages
          GenerateQRCode(), // Replace these with appropriate pages
          SettingsScreen(), // Replace these with appropriate pages
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: color13),
          Icon(Icons.upload, size: 30, color: color13),
          Icon(Icons.qr_code, size: 30, color: color13),
          Icon(Icons.download, size: 30, color: color13),
          Icon(Icons.settings_rounded, size: 30, color: color13),
        ],
        color: color14, // Replace 'color14' with appropriate color
        buttonBackgroundColor: color14, // Replace 'color14' with appropriate color
        backgroundColor: color12, // Replace 'color12' with appropriate color
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: onTabTapped,
      ),
    );
  }

  Widget _buildDashboard() {
    return RefreshIndicator(
      onRefresh: () async {
        await fetchUserData(); // Refresh user data
        await fetchTransactions(); // Refresh transaction history
      },
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 340,
                child: _head(userEmail, userBalance),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transactions History',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 19,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TransactionScreen()),
                        );
                      },
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  if (index < transactions.length && index < maxTransactionsToShow) {
                    // Use appropriate icons based on transaction type
                    IconData iconData = transactions[index].type == 'Debited' ? Icons.arrow_downward : Icons.arrow_upward;
                    Color iconColor = transactions[index].type == 'Debited' ? Colors.red : Colors.green;
                    return ListTile(
                      leading: Icon(
                        iconData,
                        color: iconColor,
                      ),
                      title: Text(transactions[index].name),
                      subtitle: Text(
                        '${transactions[index].type}: \$${transactions[index].amount.toString()}',
                      ),
                      trailing: Text(
                        _formatDate(transactions[index].timestamp),
                      ),
                    );
                  } else {
                    return SizedBox(); // Return an empty SizedBox for the remaining items
                  }
                },
                childCount: transactions.length > maxTransactionsToShow ? maxTransactionsToShow : transactions.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _head(String userEmail, int userBalance) {
    return Stack(
      children: [
        Column(
          children: [
            //Name Card
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration( // Removed 'const' here
                color: color14,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 35,
                    left: 340,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: color15,
                        child: Icon(
                          Icons.verified_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 35, left: 10),
                    // Removed 'const' here
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color.fromARGB(255, 224, 223, 223),
                          ),
                        ),
                        Text(
                          '$userName',
                          // Displaying the userEmail (replace with Name later)
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),

        //Balance Card
        Positioned(
          top: 140,
          left: 37,
          child: Container(
            height: 170,
            width: 320,
            decoration: BoxDecoration( // Removed 'const' here
              boxShadow: [
                BoxShadow(
                  color: color12,
                  offset: Offset(0, 6),
                  blurRadius: 12,
                  spreadRadius: 6,
                ),
              ],
              color: color15,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                SizedBox(height: 20), //Add Space Above Total Balance
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Balance:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        '$userBalance',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),

                //Add things inside Balance Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Add your widgets here
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Add your widgets here
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getGreeting() {
    // Get current time
    DateTime now = DateTime.now();

    // Determine the period of the day
    String period = '';
    if (now.hour >= 0 && now.hour < 12) {
      period = 'Morning';
    } else if (now.hour >= 12 && now.hour < 18) {
      period = 'Afternoon';
    } else {
      period = 'Evening';
    }

    // Generate the greeting message
    return 'Good $period';
  }

  String _formatDate(DateTime dateTime) {
    // Format DateTime object to a human-readable string
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
