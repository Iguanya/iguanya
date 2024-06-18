// lib/screens/accounts.dart

import 'package:flutter/material.dart';
import '../models/account.dart';
import '../services/sync.dart';

class AccountListScreen extends StatefulWidget {
  final SyncService syncService;

  const AccountListScreen({super.key, required this.syncService});

  @override
  _AccountListScreenState createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  late Future<List<Account>> accounts;

  @override
  void initState() {
    super.initState();
    accounts = widget.syncService.localStorageService.getAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await widget.syncService.syncData();
              setState(() {
                accounts = widget.syncService.localStorageService.getAccounts();
              });
            },
          )
        ],
      ),
      body: FutureBuilder<List<Account>>(
        future: accounts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No accounts available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Account account = snapshot.data![index];
                return ListTile(
                  title: Text(account.name),
                  subtitle: Text('Balance: ${account.balance}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
