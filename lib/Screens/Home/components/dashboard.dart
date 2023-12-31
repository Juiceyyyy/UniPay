import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../components/constants.dart';
import '../../Transfer/sendmoney.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String userEmail = "";
  int userBalance = 0;
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    fetchUserData();
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
          Container(color: Colors.green), // Replace these with appropriate pages
          Container(color: Colors.yellow), // Replace these with appropriate pages
          Container(color: Colors.red), // Replace these with appropriate pages
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        items: <Widget>[
          Icon(Icons.home, size: 30, color: color13),
          Icon(Icons.upload, size: 30, color: color13),
          Icon(Icons.qr_code, size: 30, color: color13),
          Icon(Icons.download, size: 30, color: color13),
          Icon(Icons.person, size: 30, color: color13),
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
        onRefresh: fetchUserData,
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
                  Text(
                    'See all',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Other Slivers and your UI here
        ],
      ),
    )
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
                          'Good Morning',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color.fromARGB(255, 224, 223, 223),
                          ),
                        ),
                        Text(
                          '$userEmail',
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
}
