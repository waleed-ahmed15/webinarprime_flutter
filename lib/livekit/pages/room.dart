import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:webinarprime/controllers/webinar_stream_controller.dart';
import 'package:webinarprime/utils/app_constants.dart';
import 'package:webinarprime/utils/colors.dart';
import 'package:webinarprime/utils/styles.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../exts.dart';
import '../widgets/controls.dart';
import '../widgets/participant.dart';
import '../widgets/participant_info.dart';

class RoomPage extends StatefulWidget {
  //
  final Room room;
  final EventsListener<RoomEvent> listener;
  final webinarRoomId;
  const RoomPage(
    this.room,
    this.listener,
    this.webinarRoomId, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  //
  var chatcontroller = TextEditingController();
  List<ParticipantTrack> participantTracks = [];
  ParticipantTrack? currentScreenSharingParticipant;
  EventsListener<RoomEvent> get _listener => widget.listener;
  bool get fastConnection => widget.room.engine.fastConnectOptions != null;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  RxList<dynamic> chatMessages = [].obs;
  final IO.Socket socket = Get.find();

  @override
  void initState() {
    super.initState();
    socket.emit("joinStreamRoom", widget.webinarRoomId);
    socket.on('streamRoomChatMessage', (data) {
      print(data.runtimeType);
      chatMessages.add(data);
      print('message received $data');
      print('object111');
      // print(data['message']);
      // print(jsonDecode(data.toString()));
      // chatMessages.add(json.decode(data));
      // chatMessages.add(jsonDecode(data));
    });
    widget.room.addListener(_onRoomDidUpdate);
    _setUpListeners();
    _sortParticipants();
    WidgetsBindingCompatible.instance?.addPostFrameCallback((_) {
      if (!fastConnection) {
        _askPublish();
      }
    });
  }

  @override
  void dispose() {
    // always dispose listener
    (() async {
      widget.room.removeListener(_onRoomDidUpdate);
      await _listener.dispose();
      await widget.room.dispose();
    })();
    super.dispose();
  }

  void _setUpListeners() => _listener
    ..on<RoomDisconnectedEvent>((_) async {
      WidgetsBindingCompatible.instance
          ?.addPostFrameCallback((timeStamp) => Navigator.pop(context));
    })
    ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
    ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants())
    ..on<DataReceivedEvent>((event) {
      String decoded = 'Failed to decode';
      try {
        decoded = utf8.decode(event.data);
      } catch (_) {
        print('Failed to decode: $_');
      }
      context.showDataReceivedDialog(decoded);
      print('Received data: $decoded');
    });

  void _askPublish() async {
    final result = await context.showPublishDialog();
    if (result != true) return;
    // video will fail when running in ios simulator
    try {
      await widget.room.localParticipant?.setCameraEnabled(true);
    } catch (error) {
      print('could not publish video: $error');
      await context.showErrorDialog(error);
    }
    try {
      await widget.room.localParticipant?.setMicrophoneEnabled(true);
    } catch (error) {
      print('could not publish audio: $error');
      await context.showErrorDialog(error);
    }
  }

  void _onRoomDidUpdate() {
    _sortParticipants();
  }

  void _sortParticipants() {
    List<ParticipantTrack> userMediaTracks = [];
    List<ParticipantTrack> screenTracks = [];
    for (var participant in widget.room.participants.values) {
      for (var t in participant.videoTracks) {
        if (t.isScreenShare) {
          screenTracks.add(ParticipantTrack(
            participant: participant,
            videoTrack: t.track,
            isScreenShare: true,
          ));
        } else {
          userMediaTracks.add(ParticipantTrack(
            participant: participant,
            videoTrack: t.track,
            isScreenShare: false,
          ));
        }
      }
    }
    // sort speakers for the grid
    userMediaTracks.sort((a, b) {
      // loudest speaker first
      if (a.participant.isSpeaking && b.participant.isSpeaking) {
        if (a.participant.audioLevel > b.participant.audioLevel) {
          return -1;
        } else {
          return 1;
        }
      }

      // last spoken at
      final aSpokeAt = a.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
      final bSpokeAt = b.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;

      if (aSpokeAt != bSpokeAt) {
        return aSpokeAt > bSpokeAt ? -1 : 1;
      }

      // video on
      if (a.participant.hasVideo != b.participant.hasVideo) {
        return a.participant.hasVideo ? -1 : 1;
      }

      // joinedAt
      return a.participant.joinedAt.millisecondsSinceEpoch -
          b.participant.joinedAt.millisecondsSinceEpoch;
    });

    final localParticipantTracks = widget.room.localParticipant?.videoTracks;
    if (localParticipantTracks != null) {
      for (var t in localParticipantTracks) {
        if (t.isScreenShare) {
          screenTracks.add(ParticipantTrack(
            participant: widget.room.localParticipant!,
            videoTrack: t.track,
            isScreenShare: true,
          ));
        } else {
          userMediaTracks.add(ParticipantTrack(
            participant: widget.room.localParticipant!,
            videoTrack: t.track,
            isScreenShare: false,
          ));
        }
      }
    }
    setState(() {
      participantTracks = [...screenTracks, ...userMediaTracks];
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: Drawer(
          backgroundColor: AppColors.DTbackGroundColor,
          width: 1.sw,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: 70.h,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    'Participants',
                    style: TextStyle(
                      fontFamily: 'JosefinSans Regular',
                      color: Colors.white,
                      fontSize: 20.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 0.7.sh,
                child: ListView.builder(
                  itemCount: widget.room.participants.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return index == widget.room.participants.length
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: ListTile(
                                subtitle: Text(
                                  jsonDecode(widget.room.localParticipant!
                                      .metadata!)['accountType'],
                                  style: Mystyles.listtileSubtitleStyle
                                      .copyWith(color: Colors.white),
                                ),
                                title: Text(
                                  jsonDecode(widget.room.localParticipant!
                                      .metadata!)['name'],
                                  style: TextStyle(
                                    color:
                                        widget.room.localParticipant!.isSpeaking
                                            ? Colors.green
                                            : Colors.white,
                                    fontSize: 20,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                leading: CircleAvatar(
                                  radius: 20.r,
                                  backgroundImage: NetworkImage(
                                      AppConstants.baseURL +
                                          jsonDecode(widget
                                              .room
                                              .localParticipant!
                                              .metadata!)['profile_image']),
                                ),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: widget.room.localParticipant!.isMuted
                                      ? const Icon(
                                          Icons.mic_off,
                                          color: Colors.red,
                                        )
                                      : const Icon(
                                          Icons.mic,
                                          color: Colors.green,
                                        ),
                                )),
                          )
                        : Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: ListTile(
                                subtitle: Text(
                                  jsonDecode(widget.room.participants.values
                                      .elementAt(index)
                                      .metadata!)['accountType'],
                                  style: Mystyles.listtileSubtitleStyle
                                      .copyWith(color: Colors.white),
                                ),
                                title: Text(
                                  jsonDecode(widget.room.participants.values
                                      .elementAt(index)
                                      .metadata!)['name'],
                                  style: TextStyle(
                                    color: widget.room.participants.values
                                            .elementAt(index)
                                            .isSpeaking
                                        ? Colors.green
                                        : Colors.white,
                                    fontSize: 20,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                leading: CircleAvatar(
                                  radius: 20.r,
                                  backgroundImage: NetworkImage(AppConstants
                                          .baseURL +
                                      jsonDecode(widget.room.participants.values
                                          .elementAt(index)
                                          .metadata!)['profile_image']),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    // mute participant

                                    print(widget.room.participants.values.first
                                        .isMuted);
                                    print(widget.room.participants[0]!.isMuted);
                                  },
                                  icon: widget.room.participants.values
                                          .elementAt(index)
                                          .isMuted
                                      ? const Icon(
                                          Icons.mic_off,
                                          color: Colors.red,
                                        )
                                      : const Icon(
                                          Icons.mic,
                                          color: Colors.green,
                                        ),
                                )),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
        //chat drawer
        endDrawer: Drawer(
          //chat drawer,
          width: 1.sw,
          child: Container(
            color: AppColors.DTbackGroundColor,
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: chatMessages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Text(
                              chatMessages[index]['name'],
                              style: Mystyles.listtileTitleStyle
                                  .copyWith(fontSize: 20.sp)
                                  .copyWith(color: Colors.white),
                            ),
                            subtitle: Text(
                              chatMessages[index]['message'],
                              style: Mystyles.listtileSubtitleStyle
                                  .copyWith(color: Colors.white),
                            ),
                            trailing: Text(
                              DateFormat.jm().format(
                                  DateTime.parse(chatMessages[index]['time'])),
                              style: Mystyles.listtileSubtitleStyle
                                  .copyWith(color: Colors.white),
                            ));
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        style: Mystyles.listtileTitleStyle.copyWith(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                        controller: chatcontroller,
                        keyboardAppearance: Brightness.dark,
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            color: Colors.blue,
                            onPressed: () async {
                              print(widget.webinarRoomId);
                              if (chatcontroller.text.isNotEmpty) {
                                // widget.room.localParticipant?.publishMessage(
                                // chatcontroller.text,
                                // attributes: {'name': 'Amit'});
                                Map<String, dynamic> message = {
                                  'message': chatcontroller.text.trim(),
                                  'name': jsonDecode(widget.room
                                      .localParticipant!.metadata!)['name'],
                                  'profile_image': jsonDecode(widget
                                      .room
                                      .localParticipant!
                                      .metadata!)['profile_image'],
                                  'accountType': jsonDecode(widget
                                      .room
                                      .localParticipant!
                                      .metadata!)['accountType'],
                                  'time': DateTime.now().toString()
                                };

                                await Get.find<WebinarStreamController>()
                                    .sendMessageToRoomChat(
                                        widget.webinarRoomId, message);

                                chatcontroller.clear();

                                //close keyboard
                                // print(chatMessages);
                                FocusScope.of(context).unfocus();
                              }
                            },
                          ),
                          fillColor: const Color(0xff262626),
                          filled: true,
                          hintText: "Type a message",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        ),
        key: scaffoldKey,
        backgroundColor: AppColors.DTbackGroundColor,
        body: Column(
          children: [
            Expanded(
                child: participantTracks.isNotEmpty
                    ? ParticipantWidget.widgetFor(participantTracks.first)
                    : Center(
                        child: GestureDetector(
                        onTap: () {
                          print(widget.room.localParticipant!.isSpeaking);
                          print(widget.room.sid);
                          // var newval = jsonDecode(
                          //     widget.room.participants.values.first.metadata!);
                          // print(newval['name']);

                          // pri
                          // print(jsonDecode(
                          //     widget.room.localParticipant!.metadata!)['name']);
                        },
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: widget.room.participants.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            return index == widget.room.participants.length
                                ? Container(
                                    // this container is for the local participant
                                    margin: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.r),
                                      border: Border.all(
                                        color: widget.room.localParticipant!
                                                .isSpeaking
                                            ? Colors.green
                                            : Colors.grey,
                                        width: 1,
                                      ),
                                    ),

                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                              radius: 50.r,
                                              backgroundImage: NetworkImage(
                                                  AppConstants.baseURL +
                                                      jsonDecode(widget
                                                              .room
                                                              .localParticipant!
                                                              .metadata!)[
                                                          'profile_image'])),
                                        ),
                                        Center(
                                          child: Text(
                                            jsonDecode(widget
                                                    .room
                                                    .localParticipant!
                                                    .metadata!)['name'] +
                                                "(You)",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Gap(10.h),
                                        widget.room.localParticipant!.isMuted
                                            ? const Icon(
                                                Icons.mic_off,
                                                color: Colors.red,
                                              )
                                            : const Icon(
                                                Icons.mic,
                                                color: Colors.green,
                                              ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.r),
                                      border: Border.all(
                                        color: widget.room.participants.values
                                                .elementAt(index)
                                                .isSpeaking
                                            ? Colors.green
                                            : Colors.grey,
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircleAvatar(
                                              radius: 50.r,
                                              backgroundImage: NetworkImage(
                                                  AppConstants.baseURL +
                                                      jsonDecode(
                                                        widget.room.participants
                                                            .values
                                                            .elementAt(index)
                                                            .metadata!,
                                                      )['profile_image']),
                                            )),
                                        Center(
                                          child: Text(
                                            jsonDecode(
                                              widget.room.participants.values
                                                  .elementAt(index)
                                                  .metadata!,
                                            )['name'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.sp,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Gap(10.h),
                                        widget.room.participants.values
                                                .elementAt(index)
                                                .isMuted
                                            ? const Icon(
                                                Icons.mic_off,
                                                color: Colors.red,
                                              )
                                            : const Icon(
                                                Icons.mic,
                                                color: Colors.green,
                                              ),
                                      ],
                                    ),
                                  );
                          },
                        ), // child: const Text('click here',
                        //     style: TextStyle(
                        //         color: Colors.white, fontSize: 20)),
                      ))),
            SizedBox(
              height: 100.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: math.max(0, participantTracks.length - 1),
                itemBuilder: (BuildContext context, int index) => SizedBox(
                  width: 100.h,
                  height: 100.h,
                  child: GestureDetector(
                      onTap: () {
                        // print(
                        // participantTracks[index + 1].participant.identity);
                        // print("index value of participant is  $index");

                        // ======================this logic is for switching the screen sharing=========================
                        var newshare = participantTracks[index + 1];
                        var oldshare = participantTracks[0];
                        participantTracks[0] = newshare;
                        participantTracks[index + 1] = oldshare;
                        setState(() {});
                      },
                      child: ParticipantWidget.widgetFor(
                          participantTracks[index + 1])),
                ),
              ),
            ),
            if (widget.room.localParticipant != null)
              SafeArea(
                top: false,
                child: ControlsWidget(
                    scaffoldKey, widget.room, widget.room.localParticipant!),
              ),
          ],
        ),
      );
}
