import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';

import '../../main.dart';
import '../../models/Client/client_model.dart';

class ClientSearch extends StatefulWidget {
  const ClientSearch({Key? key}) : super(key: key);

  @override
  _ClientSearchState createState() => _ClientSearchState();
}

class _ClientSearchState extends State<ClientSearch> {
  List<ClientModel> _clients = [];
  String _query = '';
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  void _fetchClients(String query) async {
    setState(() {
      _isLoading = true;
      _query = query;
    });

    try {
      final results = await apiService.searchClients(query);
      setState(() {
        _clients = results;
      });
    } catch (e) {
      toast('Failed to fetch clients: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: language.lblSearch,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
                autofocus: true,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    _fetchClients(value);
                  } else {
                    setState(() {
                      _clients.clear();
                    });
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _clients.clear();
                  _query = '';
                });
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Loading Indicator
          if (_isLoading) loadingWidgetMaker(),
          // Client List
          Expanded(
            child: _clients.isEmpty
                ? Center(
                    child: Text(
                      _query.isEmpty
                          ? language.lblTypeToSearchClients
                          : '${language.lblNoClientsFoundFor} "$_query"',
                      style: primaryTextStyle(),
                    ),
                  )
                : ListView.builder(
                    itemCount: _clients.length,
                    itemBuilder: (context, index) {
                      final client = _clients[index];
                      return ListTile(
                        title: Text(client.name ?? ''),
                        subtitle: Text(client.phoneNumber ?? ''),
                        trailing: Text(client.city ?? ''),
                        onTap: () {
                          Navigator.pop(
                              context, client); // Return the selected client
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
