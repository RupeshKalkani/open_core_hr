import 'package:flutter/material.dart';

import '../../../main.dart';

class AttachmentBottomSheet extends StatelessWidget {
  final VoidCallback onCameraPick;
  final VoidCallback onImagePick;
  final VoidCallback onVideoPick;
  final VoidCallback onFilePick;
  final VoidCallback onAudioPick;
  final VoidCallback onLocationShare;

  const AttachmentBottomSheet({
    super.key,
    required this.onCameraPick,
    required this.onImagePick,
    required this.onVideoPick,
    required this.onFilePick,
    required this.onAudioPick,
    required this.onLocationShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appStore.scaffoldBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 5),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            language.lblAttach,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              _buildAttachmentOption(
                icon: Icons.camera_alt,
                label: language.lblCamera,
                color: Colors.deepPurple,
                onTap: onCameraPick,
              ),
              _buildAttachmentOption(
                icon: Icons.image,
                label: language.lblPhoto,
                color: Colors.pink,
                onTap: onImagePick,
              ),
              _buildAttachmentOption(
                icon: Icons.videocam,
                label: language.lblVideo,
                color: Colors.redAccent,
                onTap: onVideoPick,
              ),
              _buildAttachmentOption(
                icon: Icons.insert_drive_file,
                label: language.lblFile,
                color: Colors.blue,
                onTap: onFilePick,
              ),
              _buildAttachmentOption(
                icon: Icons.audiotrack,
                label: language.lblAudio,
                color: Colors.green,
                onTap: onAudioPick,
              ),
              _buildAttachmentOption(
                icon: Icons.location_on,
                label: language.lblLocation,
                color: Colors.orange,
                onTap: onLocationShare,
              ),
            ],
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              language.lblCancel,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
