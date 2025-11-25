import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/Utils/app_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api/pdf_api.dart';
import '../../../main.dart';

class ViewPdfScreen extends StatefulWidget {
  final String title;
  final String url;
  const ViewPdfScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<ViewPdfScreen> createState() => _ViewPdfScreenState();
}

class _ViewPdfScreenState extends State<ViewPdfScreen> {
  bool isLoading = true;
  late PDFViewController controller;
  int pages = 0;
  int indexPage = 0;
  File? file;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      isLoading = true;
    });
    file = await PDFApi.loadNetwork(widget.url);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = '${indexPage + 1} of $pages';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.title} ($pages ${language.lblPages})",
          style: primaryTextStyle(color: black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              launchUrl(Uri.parse(widget.url),
                  mode: LaunchMode.externalApplication);
            },
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? loadingWidgetMaker()
            : file == null
                ? Text(language.lblUnableToGetFile)
                : Stack(
                    children: [
                      PDFView(
                        filePath: file!.path,
                        // autoSpacing: false,
                        swipeHorizontal: true,
                        /* pageSnap: false,
              pageFling: false,*/
                        onRender: (pages) =>
                            setState(() => this.pages = pages!),
                        onViewCreated: (controller) =>
                            setState(() => this.controller = controller),
                        onPageChanged: (indexPage, _) =>
                            setState(() => this.indexPage = indexPage!),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            text,
                            style: primaryTextStyle(color: black),
                          ),
                        ),
                      ),
                      if (pages >= 2)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: SizedBox(
                              width: 105,
                              child: Column(
                                children: [
                                  Card(
                                    child: SizedBox(
                                      width: 105,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.chevron_left,
                                                size: 32),
                                            onPressed: () {
                                              final page = indexPage == 0
                                                  ? pages
                                                  : indexPage - 1;
                                              controller.setPage(page);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.chevron_right,
                                                size: 32),
                                            onPressed: () {
                                              final page =
                                                  indexPage == pages - 1
                                                      ? 0
                                                      : indexPage + 1;
                                              controller.setPage(page);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
      ),
    );
  }
}
