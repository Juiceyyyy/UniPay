import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../components/constants.dart';

class TransactionData {
  final String name;
  final String type;
  final int amount;
  final DateTime timestamp;

  TransactionData({
    required this.name,
    required this.type,
    required this.amount,
    required this.timestamp,
  });
}

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late List<TransactionData> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
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

  Future<void> _refreshTransactions() async {
    setState(() {
      transactions.clear(); // Clear the existing transactions
    });
    await fetchTransactions(); // Fetch new transactions
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transactions',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: color14,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTransactions,
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            TransactionData transaction = transactions[index];
            Color iconColor = transaction.type == 'Debited' ? Colors.red : Colors.green;
            IconData iconData = transaction.type == 'Debited' ? Icons.arrow_downward : Icons.arrow_upward;
            return ListTile(
              leading: Icon(
                iconData,
                color: iconColor,
              ),
              title: Text(transaction.name),
              subtitle: Text(
                '${transaction.type}: \$${transaction.amount.toString()}',
              ),
              trailing: Text(
                '${_formatDate(transaction.timestamp)}',
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    // Format DateTime object to a human-readable string
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
