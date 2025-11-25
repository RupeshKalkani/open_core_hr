import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart'
    as gmaps;
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/screens/Chat/widgets/attachment_bottom_sheet.dart';
import 'package:open_core_hr/screens/Chat/widgets/video_full_screen.dart';
import 'package:open_core_hr/screens/GroupInfo/group_info_screen.dart';
import 'package:open_core_hr/screens/UserProfile/user_profile_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waveform_recorder/waveform_recorder.dart';

import '../../Utils/app_constants.dart';
import '../../main.dart';
import '../../models/Chat/chat_list_model.dart';
import '../../models/chat_response.dart';
import '../../models/maps_address_result_model.dart';
import '../../service/map_helper.dart';
import '../../utils/app_widgets.dart';
import '../Maps/map_screen.dart';
import '../Task/task_update_screen/view_pdf_screen.dart';
import 'chat_store.dart';
import 'widgets/audio_player_widget.dart';
import 'widgets/image_full_screen.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatStore _store = ChatStore();
  final TextEditingController _messageController = TextEditingController();
  bool _isTextEmpty = true;
  final WaveformRecorderController _waveController =
      WaveformRecorderController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _store.chatId = widget.chat.id;
    _store.pagingController.addPageRequestListener((pageKey) async {
      await _store.fetchMessages(pageKey, widget.chat.id);
    });
    _store.startPollingForMessages();
  }

  @override
  void dispose() {
    _store.pagingController.dispose();
    _store.stopPolling();
    _waveController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    sharedHelper.vibrate();
    if (_waveController.isRecording) {
      await _waveController.stopRecording();
      setState(() {
        _isRecording = false;
      });
      _onRecordingStopped();
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _waveController.startRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _onRecordingStopped() async {
    final file = _waveController.file;
    if (file == null) return;

    setState(() {
      _audioPath = file.path;
    });

    var extension = file.path.split('.').last;

    await _store.sendAttachment(widget.chat.id, _audioPath!, extension);
  }

  Future<void> _pickFile({FileType fileType = FileType.any}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: fileType,
      allowMultiple: false,
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      String extension = result.files.single.extension ?? 'file';

      await _store.sendAttachment(widget.chat.id, filePath, extension);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source, imageQuality: 50);

    if (image != null) {
      var extension = image.path.split('.').last;
      await _store.sendAttachment(widget.chat.id, image.path, extension);
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      var extension = video.path.split('.').last;
      await _store.sendAttachment(widget.chat.id, video.path, extension);
    }
  }

  Future<void> _pickLocation() async {
    var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    MapsAddressResultModel result = await showGoogleMapLocationPicker(
      pinWidget: const Icon(Icons.location_pin, color: Colors.red, size: 55),
      pinColor: Colors.blue,
      context: context,
      addressPlaceHolder: language.lblPickALocation,
      addressTitle: "${language.lblAddress}:",
      apiKey: mapsKey,
      appBarTitle: language.lblPickAddress,
      confirmButtonColor: Colors.blue,
      confirmButtonText: language.lblConfirm,
      confirmButtonTextColor: Colors.black,
      country: "in",
      language: "en-us",
      searchHint: language.lblSearchHere,
      initialLocation: LatLng(position.latitude, position.longitude),
    );

    Map info = {
      'latitude': result.latlng.latitude,
      'longitude': result.latlng.longitude,
      'address': result.address,
    };
    await _store.sendMessage(
      widget.chat.id,
      jsonEncode(info),
      type: 'location',
    );
  }

  Future<void> _forwardMessage(ChatMessage message) async {
    final selectedChat = await showModalBottomSheet<Chat?>(
      context: context,
      builder: (context) => Column(
        children: [
          20.height,
          Text(language.lblSelectChatToForwardTo, style: primaryTextStyle()),
          5.height,
          Expanded(child: _selectChatForForwarding()),
        ],
      ),
    );

    if (selectedChat != null) {
      if (message.messageType == 'text' || message.messageType == 'location') {
        await _store.sendMessage(
          selectedChat.id,
          message.content,
          type: message.messageType,
          isForward: true,
        );
      } else {
        await _store.forwardFile(selectedChat.id, message.id);
      }
      toast(language.lblMessageForwardedSuccessfully);
    }
  }

  Widget _selectChatForForwarding() {
    return FutureBuilder<List<Chat>>(
      future: apiService.getChats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(language.lblNoChatsAvailableToForward));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            if (snapshot.data![index].id == widget.chat.id) {
              return SizedBox();
            }
            final chat = snapshot.data![index];
            return _buildChatListItem(chat).onTap(() {
              Navigator.pop(context, chat);
            });
          },
        );
      },
    );
  }

  Future<void> _shareMessage(ChatMessage message) async {
    String contentToShare = '';

    if (message.messageType == 'text') {
      contentToShare = message.content;
    } else if (message.messageType == 'location') {
      Map info = jsonDecode(message.content);
      contentToShare =
          'https://maps.google.com/?q=${info['latitude']},${info['longitude']}';
    } else {
      var networkPath = message.file!.filePath;
      var filePath = await _store.downloadFile(networkPath);

      XFile? xFile = XFile(filePath);

      Share.shareXFiles([
        xFile,
      ], text: '${language.lblSharedFrom} $mainAppName');
    }

    await Share.share(contentToShare);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            finish(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: boxDecorationWithRoundedCorners(
              backgroundColor: context.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Icon(Icons.arrow_back, color: appStore.textPrimaryColor),
          ),
        ),
        titleSpacing: 0,
        title: !widget.chat.isGroupChat
            ? buildUserHeader(
                widget.chat.name,
                imageUrl: widget.chat.avatar,
                hideStatus: true,
              ).onTap(() {
                UserProfileScreen(userId: widget.chat.userId!).launch(context);
              })
            : Row(
                children: [
                  userProfileWidget(
                    widget.chat.name,
                    hideStatus: true,
                    size: 15,
                  ),
                  8.width,
                  Text(widget.chat.name),
                ],
              ).onTap(() {
                GroupInfoScreen(chat: widget.chat).launch(context);
              }),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Observer(
                builder: (_) => PagedListView<int, ChatMessage>(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  pagingController: _store.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<ChatMessage>(
                    noItemsFoundIndicatorBuilder: (context) =>
                        noDataWidget(message: language.lblNoMessagesYet),
                    itemBuilder: (context, history, index) {
                      ChatMessage? nextMessage =
                          index < _store.pagingController.itemList!.length - 1
                          ? _store.pagingController.itemList![index + 1]
                          : null;
                      return _buildChatBubble(history, nextMessage);
                    },
                  ),
                ),
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message, ChatMessage? previousMessage) {
    final isMe = message.userId == appStore.userId;
    final bool showDateSeparator = _shouldShowDateSeparator(
      message,
      previousMessage,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showDateSeparator) _buildDateSeparator(message.createdAt),
        GestureDetector(
          onLongPress: () {
            /*    if (message.messageType == 'text') {
              Clipboard.setData(ClipboardData(text: message.content));
            }*/
            showModalBottomSheet(
              context: context,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.forward,
                        color: appStore.appColorPrimary,
                      ),
                      title: Text(language.lblForward),
                      onTap: () {
                        Navigator.pop(context);
                        _forwardMessage(message);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.share,
                        color: appStore.appColorPrimary,
                      ),
                      title: Text(language.lblShare),
                      onTap: () {
                        Navigator.pop(context);
                        _shareMessage(message);
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.copy,
                        color: appStore.appColorPrimary,
                      ),
                      title: Text(language.lblCopy),
                      onTap: () {
                        Navigator.pop(context);
                        Clipboard.setData(ClipboardData(text: message.content));
                        toast(language.lblMessageCopied);
                      },
                    ),
                    20.height,
                  ],
                ),
              ),
            );
          },
          child: Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: isMe
                  ? const EdgeInsets.only(
                      left: 100,
                      right: 8,
                      top: 8,
                      bottom: 8,
                    )
                  : const EdgeInsets.only(
                      left: 8,
                      right: 100,
                      top: 8,
                      bottom: 8,
                    ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.chat.isGroupChat
                      ? Text(
                          isMe ? '' : message.userName,
                          style: secondaryTextStyle(size: 12),
                        )
                      : SizedBox(),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe
                          ? appStore.appColorPrimary.withOpacity(0.1)
                          : appStore.isDarkModeOn
                          ? Colors.grey.shade800
                          : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isMe ? 12 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.messageType == 'loading') ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 4,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: appStore.appColorPrimary,
                                  ),
                                ),
                                8.width,
                                Text(
                                  message.content,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: appStore.appColorPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (message.messageType == 'gif')
                          Image.network(
                            message.file!.filePath,
                            width: 200,
                            height: 200,
                          ),
                        if (message.messageType == 'location')
                          GestureDetector(
                            onTap: () {
                              Map info = jsonDecode(message.content);
                              MapHelper helper = MapHelper();
                              helper.launchMap(
                                context,
                                info['latitude'],
                                info['longitude'],
                                info['address'],
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  language.lblLocation,
                                  style: primaryTextStyle(size: 14),
                                ),
                                4.height,
                                gmaps.StaticMap(
                                  googleApiKey: mapsKey,
                                  width: context.width(),
                                  height: 200,
                                  scaleToDevicePixelRatio: true,
                                  zoom: 14,
                                  markers: [
                                    gmaps.Marker(
                                      color: appStore.appColorPrimary,
                                      locations: [
                                        gmaps.GeocodedLocation.latLng(
                                          jsonDecode(
                                            message.content,
                                          )['latitude'],
                                          jsonDecode(
                                            message.content,
                                          )['longitude'],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                5.height,
                                Text(
                                  jsonDecode(message.content)['address'],
                                  style: secondaryTextStyle(size: 14),
                                ),
                              ],
                            ),
                          ),
                        if (message.messageType == 'document' ||
                            message.messageType == 'spreadsheet' ||
                            message.messageType == 'presentation' ||
                            message.messageType == 'txt' &&
                                message.file != null) ...[
                          GestureDetector(
                            onTap: () {
                              if (message.file!.fileExtension == 'pdf') {
                                ViewPdfScreen(
                                  title: message.file!.fileName,
                                  url: message.file!.filePath,
                                ).launch(context);
                              } else {
                                launchUrl(Uri.parse(message.file!.filePath));
                              }
                            },
                            child: Row(
                              children: [
                                message.file!.fileExtension == 'pdf'
                                    ? Image.asset(
                                        'images/file_type_icons/pdf.png',
                                        height: 30,
                                      )
                                    : message.file!.fileType == 'spreadsheet'
                                    ? Image.asset(
                                        'images/file_type_icons/excel.png',
                                        height: 30,
                                      )
                                    : message.file!.fileType == 'presentation'
                                    ? Image.asset(
                                        'images/file_type_icons/ppt.png',
                                        height: 30,
                                      )
                                    : message.file!.fileType == 'txt'
                                    ? Image.asset(
                                        'images/file_type_icons/txt.png',
                                        height: 30,
                                      )
                                    : Icon(
                                        Icons.insert_drive_file,
                                        color: appStore.appColorPrimary,
                                        size: 30,
                                      ),
                                8.width,
                                Expanded(
                                  child: Text(
                                    message.file!.filePath.split('/').last,
                                    maxLines: 3,
                                    style: secondaryTextStyle(
                                      size: 14,
                                      color: appStore.appColorPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          4.height,
                        ],
                        if (message.messageType == 'video' &&
                            message.file != null) ...[
                          GestureDetector(
                            onTap: () {
                              VideoFullScreen(
                                videoUrl: message.file!.filePath,
                                chatMessage: message,
                                shareAction: () => _shareMessage(message),
                                forwardAction: () => _forwardMessage(message),
                              ).launch(context);
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    color: Colors.grey.shade200,
                                    child: SizedBox(),
                                  ),
                                ),
                                Icon(
                                  Icons.play_circle_fill,
                                  size: 50,
                                  color: appStore.appColorPrimary,
                                ),
                              ],
                            ),
                          ),
                          4.height,
                        ],
                        if (message.messageType == 'audio' &&
                            message.file != null) ...[
                          AudioPlayerWidget(url: message.file!.filePath),
                        ],
                        if (message.messageType == 'text') ...[
                          Text(
                            message.content,
                            style: primaryTextStyle(size: 14),
                          ),
                          4.height,
                        ],
                        if (message.messageType == 'image' &&
                            message.file != null) ...[
                          GestureDetector(
                            onTap: () {
                              ImageFullScreen(
                                chatMessage: message,
                                imageUrl: message.file!.filePath,
                                shareAction: () {
                                  _shareMessage(message);
                                },
                                forwardAction: () {
                                  _forwardMessage(message);
                                },
                              ).launch(context);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                message.file!.filePath,
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Text(language.lblFailedToLoadImage);
                                },
                              ),
                            ),
                          ),
                          4.height,
                        ],
                        if (message.messageType == 'file' &&
                            message.file != null) ...[
                          GestureDetector(
                            onTap: () =>
                                launchUrl(Uri.parse(message.file!.filePath)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.insert_drive_file,
                                  color: appStore.appColorPrimary,
                                  size: 30,
                                ),
                                8.width,
                                Expanded(
                                  child: Text(
                                    message.file!.filePath.split('/').last,
                                    maxLines: 3,
                                    style: secondaryTextStyle(
                                      size: 14,
                                      color: appStore.appColorPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          4.height,
                        ],
                        Text(message.time, style: secondaryTextStyle(size: 10)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _shouldShowDateSeparator(ChatMessage current, ChatMessage? previous) {
    if (previous == null) return true; // Always show for the first message

    DateTime currentDate = dateTimeFormatter.parse(current.createdAt).toLocal();
    DateTime previousDate = dateTimeFormatter
        .parse(previous.createdAt)
        .toLocal();

    return currentDate.year != previousDate.year ||
        currentDate.month != previousDate.month ||
        currentDate.day != previousDate.day;
  }

  Widget _buildDateSeparator(String createdAt) {
    DateTime date = DateFormat('dd-MM-yyyy hh:mm a').parse(createdAt);
    String formattedDate = _formatDate(date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 0.5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              formattedDate,
              style: secondaryTextStyle(size: 12, color: Colors.grey),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey.shade300, thickness: 0.5)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return language.lblToday;
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return language.lblYesterday;
    } else {
      return formatter.format(date);
    }
  }

  Widget _buildMessageInput() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Chat Input Row
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: appStore.appColorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: appStore.appColorPrimary, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text Field
                  Expanded(
                    child: _isRecording
                        ? Column(
                            children: [
                              SizedBox(
                                height: 50,
                                child: WaveformRecorder(
                                  height: 50,
                                  waveColor: appStore.appColorPrimary,
                                  durationTextStyle: secondaryTextStyle(
                                    size: 12,
                                    color: appStore.appColorPrimary,
                                  ),
                                  controller: _waveController,
                                ),
                              ),
                            ],
                          )
                        : TextField(
                            controller: _messageController,
                            textInputAction: TextInputAction.newline,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 5,
                            onChanged: (value) {
                              setState(() {
                                _isTextEmpty = value.trim().isEmpty;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: language.lblTypeAMessage,
                              hintStyle: secondaryTextStyle(size: 14),
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                  ),
                  5.width,
                  if (!_isRecording)
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => AttachmentBottomSheet(
                            onCameraPick: () {
                              finish(context);
                              _pickImage(ImageSource.camera);
                            },
                            onImagePick: () {
                              finish(context);
                              _pickImage(ImageSource.gallery);
                            },
                            onVideoPick: () {
                              finish(context);
                              _pickVideo();
                            },
                            onFilePick: () {
                              finish(context);
                              _pickFile();
                            },
                            onAudioPick: () {
                              finish(context);
                              _pickFile(fileType: FileType.audio);
                            },
                            onLocationShare: () {
                              finish(context);
                              _pickLocation();
                            },
                          ),
                        );
                      },
                      child: Icon(Icons.attach_file, color: Colors.grey),
                    ),
                  // Camera Icon
                  if (_isTextEmpty && !_isRecording)
                    IconButton(
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      },
                    ),

                  5.width,
                ],
              ),
            ),
          ),
        ),
        if (_isRecording)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: appStore.appColorPrimary,
            ),
            child: IconButton(
              icon: const Icon(Icons.stop, color: Colors.white),
              onPressed: () {
                _toggleRecording();
              },
            ),
          )
        else if (!_isTextEmpty)
          Container(
            decoration: _isTextEmpty
                ? null
                : BoxDecoration(
                    shape: BoxShape.circle,
                    color: appStore.appColorPrimary,
                  ),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: _isTextEmpty
                    ? Colors.grey
                    : Colors.white, // Disable when empty
              ),
              onPressed: _isTextEmpty
                  ? null
                  : () {
                      _store.sendMessage(
                        widget.chat.id,
                        _messageController.text,
                      );
                      _messageController.clear();
                      setState(() {
                        _isTextEmpty = true;
                      });
                    },
            ),
          )
        else
          GestureDetector(
            onLongPress: () {
              _toggleRecording();
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: appStore.appColorPrimary,
              ),
              child: IconButton(
                icon: const Icon(Icons.mic, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
        10.width,
      ],
    );
  }

  Widget _buildChatListItem(Chat chat) {
    return ListTile(
      leading: userProfileWidget(
        chat.name,
        hideStatus: true,
        imageUrl: chat.avatar,
      ),
      title: Text(chat.name, style: primaryTextStyle(size: 16)),
      subtitle: Text(
        chat.lastMessage ?? language.lblNoMessagesYet,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: secondaryTextStyle(size: 12),
      ),
      trailing: Text(chat.updatedAt, style: secondaryTextStyle(size: 10)),
    );
  }
}
