import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/models/chat_response.dart';

import '../../../main.dart';

class ImageFullScreen extends StatelessWidget {
  final ChatMessage chatMessage;
  final VoidCallback shareAction;
  final VoidCallback forwardAction;
  final String imageUrl;

  const ImageFullScreen({
    Key? key,
    required this.imageUrl,
    required this.shareAction,
    required this.forwardAction,
    required this.chatMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Display Image with Zoom Capability
          Center(
            child: InteractiveViewer(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      language.lblFailedToLoadImage,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),

          // Close Button (Top-Left)
          Positioned(
            top: 40,
            left: 16,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      chatMessage.userName ?? '',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      chatMessage.createdAtHuman,
                      style: secondaryTextStyle(color: white),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Share Button (Top-Right)
          Positioned(
            top: 40,
            right: 16,
            child: GestureDetector(
              onTap: shareAction,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    language.lblShare,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Icon(Icons.share, color: Colors.white, size: 28)
                ],
              ).paddingOnly(top: 10),
            ),
          ),

          //Bottom Right Forward
          Positioned(
            bottom: 40,
            right: 16,
            child: GestureDetector(
              onTap: forwardAction,
              child: Row(
                children: [
                  Text(
                    language.lblForward,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Icon(Iconsax.arrow_right_3, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
