import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_constants.dart';
import 'package:open_core_hr/dialog/client_details_dialog.dart';
import 'package:open_core_hr/models/Client/client_model.dart';

import '../../main.dart';
import '../../utils/app_widgets.dart';
import 'add_client_screen.dart';
import 'client_store.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final ClientStore _store = ClientStore();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await _store.init();
  }

  @override
  void dispose() {
    _store.pagingController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _store.setSearchQuery(_store.searchController.text);
      _store.pagingController.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, language.lblClients),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _store.searchController,
              onChanged: (_) => _onSearchChanged(),
              decoration:
                  newEditTextDecoration(Icons.search, language.lblSearch),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  Future.sync(() => _store.pagingController.refresh()),
              child: PagedListView(
                pagingController: _store.pagingController,
                builderDelegate: PagedChildBuilderDelegate<ClientModel>(
                  noItemsFoundIndicatorBuilder: (context) => Center(
                      child: noDataWidget(message: language.lblNoClientsFound)),
                  itemBuilder: (context, client, index) =>
                      _buildClientCard(client, index),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: appStore.appColorPrimary,
        onPressed: () async {
          await const AddClientScreen().launch(context);
          _store.pagingController.refresh();
        },
        label: Row(
          children: [
            Icon(Icons.add, color: white),
            5.width,
            Text(
              language.lblAddClient,
              style: TextStyle(color: white),
            ),
          ],
        ),
      ),
    );
  }

  // Modernized Client Card
  Widget _buildClientCard(ClientModel client, int index) {
    return Container(
      decoration: cardDecoration(),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return ClientDetails(client: client); //
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Leading Circle Avatar
              CircleAvatar(
                backgroundColor: appStore.appColorPrimary.withOpacity(0.2),
                radius: 30,
                child: Text(
                  client.name!.substring(0, 1).toUpperCase(),
                  style:
                      boldTextStyle(size: 20, color: appStore.appColorPrimary),
                ),
              ),
              12.width,

              // Client Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      client.name!,
                      style: boldTextStyle(size: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    6.height,
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 14, color: Colors.grey),
                        4.width,
                        Text(
                          getStringAsync(appCountryPhoneCodePref) +
                              (client.phoneNumber ?? 'N/A'),
                          style: secondaryTextStyle(size: 13),
                        ),
                      ],
                    ),
                    6.height,
                    Row(
                      children: [
                        const Icon(Icons.location_city,
                            size: 14, color: Colors.grey),
                        4.width,
                        Text(
                          client.city ?? 'N/A',
                          style: secondaryTextStyle(size: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Icon (Details)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
