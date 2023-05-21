import 'dart:convert';
import 'dart:math' as math;
import 'package:uuid/uuid.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:webinarprime/controllers/webinar_stream_controller.dart';
import 'package:webinarprime/models/question_model.dart';
import 'package:webinarprime/models/room_chat_answerModel.dart';
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

class _RoomPageState extends State<RoomPage> with TickerProviderStateMixin {
  //
  var chatcontroller = TextEditingController();
  List<ParticipantTrack> participantTracks = [];
  ParticipantTrack? currentScreenSharingParticipant;
  EventsListener<RoomEvent> get _listener => widget.listener;
  bool get fastConnection => widget.room.engine.fastConnectOptions != null;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  RxList<dynamic> chatMessages = [].obs;
  RxList<QuestionAnswerModel> questionMessages = <QuestionAnswerModel>[].obs;
  RxList<answerModel> answerMessages = <answerModel>[].obs;
  final IO.Socket socket = Get.find();
  late TabController _tabController;
  late TabController _tabController2;
  List<TextEditingController> answersControllers = [];
  var questionsController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String? currentDate;

  void messagedialogbox(String toMetadata, String toIdentity) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Message'),
            content: TextField(
              controller: chatcontroller,
              decoration: const InputDecoration(
                hintText: 'Enter your message',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (chatcontroller.text.trim().isEmpty) {
                    return;
                  }
                  Map<String, dynamic> newmesage = {
                    "message": chatcontroller.text.trim(),
                    "from": {
                      "identity": widget.room.localParticipant!.identity,
                      "metadata": widget.room.localParticipant!.metadata,
                    },
                    "timestamp": DateTime.now().millisecondsSinceEpoch,
                    "to": {
                      "identity": toIdentity,
                      "metadata": toMetadata,
                    }
                  };
                  await Get.find<WebinarStreamController>()
                      .sendMessageToRoomChat(widget.webinarRoomId, newmesage);

                  chatcontroller.clear();

                  //close keyboard
                  // print(chatMessages);
                  FocusScope.of(context).unfocus();
                  // socket.emit('streamRoomChatMessage', {
                  // 'message': chatcontroller.text,
                  // 'from': widget.room.localParticipant!.identity,
                  // 'timestamp': DateTime.now().millisecondsSinceEpoch,
                  // 'type': 'message'
                  // });
                  Navigator.pop(context);
                },
                child: const Text('Send'),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    socket.emit("joinStreamRoom", widget.webinarRoomId);
    socket.on('streamRoomChatMessage', (data) {
      print(data.runtimeType);
      print("identtity here+++++??>>>>> " + data['to']['identity']);
      if (data['to']['identity'] == 'all') {
        print("message received $data");
        print('=---------------------------');
        chatMessages.add(data);
      } else if (data['to']['identity'] ==
          widget.room.localParticipant!.identity) {
        print("message received $data");
        // data['message'] = data['from']['name'] + ' (private)';
        print('=---------------------------');
        chatMessages.add(data);
      } else {
        print("message received $data");
        // data['message'] = data['from']['name'] + ' (private)';
        print('=---------------------------');
        chatMessages.add(data);
      }
      // print('message received $data');
      // print('=---------------------------');

      // chatMessages.add(data);

      // print(jsonDecode(data));
    });
    socket.on('streamRoomQuestion', (question) {
      print('question received $question');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      });
      print(question.runtimeType);
      if (jsonDecode(widget.room.localParticipant!.metadata!)['role'] ==
          'organizer') {
        answersControllers.add(TextEditingController());
        print("controlleradded");
      }

      QuestionAnswerModel q1 = QuestionAnswerModel.fromJson(question);
      questionMessages.add(q1);
      print(questionMessages.length);
      print(q1.id);
      print(q1.answers);
    });
    socket.on('streamRoomAnswer', (answer) async {
      print('answer received $answer');
      print(answer.runtimeType);
      Answers a1 = Answers.fromJson(answer);
      print(a1.questionId);
      // print(a1.from!.metadata!.name);
      // print(a1.answer);

      for (var element in questionMessages) {
        if (element.id == a1.questionId) {
          print('found question');
          element.answers!.add(a1);

          break;
        }
      }
      questionMessages.refresh();
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController2 = TabController(length: 2, vsync: this);
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
      socket.dispose();
    })();
    super.dispose();
    _tabController.dispose();
    _tabController2.dispose();
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
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          // await widget.room.disconnect();
          scaffoldKey.currentState!.closeEndDrawer();
          scaffoldKey.currentState!.closeDrawer();
          // print('geeerr');
          // Get.off(() => WebinarDetailsScreen(
          // webinarDetails: WebinarManagementController.currentWebinar));

          return false;
        },
        child: Scaffold(
          drawer: Scaffold(
            backgroundColor: AppColors.DTbackGroundColor,
            appBar: AppBar(
              backgroundColor: AppColors.DTbackGroundColor,
              elevation: 0,
              toolbarHeight: 0,
              bottom: TabBar(
                  controller: _tabController2,
                  indicatorColor: AppColors.LTprimaryColor,
                  tabs: [
                    Tab(
                      child: Text(
                        'participants',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 20.sp, color: Colors.white),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'blocked',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 20.sp, color: Colors.white),
                      ),
                    ),
                  ]),
            ),
            body: TabBarView(
              controller: _tabController2,
              children: [
                ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // SizedBox(
                    //   height: 70.h,
                    //   child: DrawerHeader(
                    //     decoration: const BoxDecoration(
                    //       border: Border(
                    //         bottom: BorderSide(
                    //           color: Colors.white,
                    //           width: 1,
                    //         ),
                    //       ),
                    //     ),
                    //     child: Text(
                    //       'Participants',
                    //       style: TextStyle(
                    //         fontFamily: 'JosefinSans Regular',
                    //         color: Colors.white,
                    //         fontSize: 20.sp,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 0.7.sh,
                      child: ListView.builder(
                        itemCount: widget.room.participants.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == widget.room.participants.length) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: ListTile(
                                  subtitle: Text(
                                    jsonDecode(widget.room.localParticipant!
                                        .metadata!)['role'],
                                    style: listtileSubtitleStyle.copyWith(
                                        color: Colors.white),
                                  ),
                                  title: Text(
                                    jsonDecode(widget.room.localParticipant!
                                        .metadata!)['name'],
                                    style: TextStyle(
                                      color: widget
                                              .room.localParticipant!.isSpeaking
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
                                  trailing: SizedBox(
                                    width: 100.h,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: widget.room.localParticipant!
                                                  .isMuted
                                              ? const Icon(
                                                  Icons.mic_off,
                                                  color: Colors.red,
                                                )
                                              : const Icon(
                                                  Icons.mic,
                                                  color: Colors.green,
                                                ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: ListTile(
                                  subtitle: Text(
                                    jsonDecode(widget.room.participants.values
                                        .elementAt(index)
                                        .metadata!)['role'],
                                    style: listtileSubtitleStyle.copyWith(
                                        color: Colors.white),
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
                                      fontSize: 20.sp,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    radius: 20.r,
                                    backgroundImage: NetworkImage(
                                        AppConstants.baseURL +
                                            jsonDecode(widget
                                                .room.participants.values
                                                .elementAt(index)
                                                .metadata!)['profile_image']),
                                  ),
                                  trailing: SizedBox(
                                    width: 150.w,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            // mute participant

                                            print(widget.room.participants
                                                .values.first.isMuted);
                                            print(widget
                                                .room.participants[0]!.isMuted);
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
                                        ),
                                        if (jsonDecode(widget
                                                    .room
                                                    .localParticipant!
                                                    .metadata!)['role'] ==
                                                'organizer' &&
                                            jsonDecode(widget
                                                    .room.participants.values
                                                    .elementAt(index)
                                                    .metadata!)['role'] ==
                                                'attendee')
                                          PopupMenuButton<String>(
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Colors
                                                  .white, // Change the color here
                                            ),
                                            onSelected: (value) async {
                                              // Perform action based on selected option
                                              switch (value) {
                                                case 'remove':
                                                  print('remove');
                                                  String kickedparticipantId =
                                                      jsonDecode(widget.room
                                                          .participants.values
                                                          .elementAt(index)
                                                          .metadata!)['_id'];
                                                  print(jsonDecode(widget
                                                      .room.participants.values
                                                      .elementAt(index)
                                                      .metadata!));
                                                  print(
                                                      'person kicked from roster');
                                                  print(kickedparticipantId);
                                                  print(widget.webinarRoomId);

                                                  await Get.find<
                                                          WebinarStreamController>()
                                                      .kickparticipantFromWebinar(
                                                          kickedparticipantId,
                                                          widget.webinarRoomId);
                                                  // Handle "Remove Participant" option
                                                  break;
                                                case 'switch':
                                                  print('switch');
                                                  if (widget
                                                      .room.participants.values
                                                      .elementAt(index)
                                                      .permissions
                                                      .canPublish) {
                                                    print("swtich to attendee");
                                                    await Get.find<
                                                            WebinarStreamController>()
                                                        .swtichToattendee(
                                                            widget
                                                                .webinarRoomId,
                                                            jsonDecode(widget
                                                                    .room
                                                                    .participants
                                                                    .values
                                                                    .elementAt(
                                                                        index)
                                                                    .metadata!)[
                                                                '_id']);
                                                  } else {
                                                    await Get.find<
                                                            WebinarStreamController>()
                                                        .swtichToHost(
                                                            widget
                                                                .webinarRoomId,
                                                            jsonDecode(widget
                                                                    .room
                                                                    .participants
                                                                    .values
                                                                    .elementAt(
                                                                        index)
                                                                    .metadata!)[
                                                                '_id']);
                                                  }
                                                  // Handle "Switch to Host" option
                                                  break;
                                                case 'option3':
                                                  print('option3');
                                                  messagedialogbox(
                                                      widget.room.participants
                                                          .values
                                                          .elementAt(index)
                                                          .metadata!,
                                                      widget.room.participants
                                                          .values
                                                          .elementAt(index)
                                                          .identity);
                                                  print(widget
                                                      .room
                                                      .participants
                                                      .values
                                                      .first
                                                      .permissions
                                                      .canPublish);
                                                  break;
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry<String>>[
                                              const PopupMenuItem<String>(
                                                value: 'remove',
                                                child:
                                                    Text('Remove Participant'),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'switch',
                                                child: widget.room.participants
                                                        .values
                                                        .elementAt(index)
                                                        .permissions
                                                        .canPublish
                                                    ? const Text(
                                                        'Switch to Attendee')
                                                    : const Text(
                                                        'Switch to Host'),
                                              ),
                                              const PopupMenuItem<String>(
                                                value: 'option3',
                                                child: Text('Third Option'),
                                              ),
                                            ],
                                          )
                                        else if (jsonDecode(widget
                                                .room.participants.values
                                                .elementAt(index)
                                                .metadata!)['role'] ==
                                            'organizer')
                                          IconButton(
                                              onPressed: () {
                                                messagedialogbox(
                                                    widget.room.participants
                                                        .values
                                                        .elementAt(index)
                                                        .metadata!,
                                                    widget.room.participants
                                                        .values
                                                        .elementAt(index)
                                                        .identity);
                                              },
                                              icon: const Icon(
                                                Icons.message,
                                                color: Colors.white,
                                              ))
                                        // IconButton(
                                        //   onPressed: () async {
                                        //     String kickedparticipantId =
                                        //         jsonDecode(widget
                                        //             .room.participants.values
                                        //             .elementAt(index)
                                        //             .metadata!)['_id'];
                                        //     print(jsonDecode(widget
                                        //         .room.participants.values
                                        //         .elementAt(index)
                                        //         .metadata!));
                                        //     print(
                                        //         'person kicked from roster');
                                        //     print(kickedparticipantId);
                                        //     print(widget.webinarRoomId);

                                        //     await Get.find<
                                        //             WebinarStreamController>()
                                        //         .kickparticipantFromWebinar(
                                        //             kickedparticipantId,
                                        //             widget.webinarRoomId);
                                        //   },
                                        //   icon:
                                        //       const Icon(Icons.person_remove),
                                        //   color: Colors.red,
                                        // )
                                        else
                                          const SizedBox(),
                                      ],
                                    ),
                                  )),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                GetBuilder<WebinarStreamController>(builder: (controller) {
                  return ListView.builder(
                    itemCount: WebinarStreamController
                        .currentStreamBlockParticipants.length,
                    itemBuilder: (BuildContext context, int index) {
                      Get.find<WebinarStreamController>()
                          .getBlockedusersForWebinar(widget.room.name!);
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20.r,
                          backgroundImage: NetworkImage(AppConstants.baseURL +
                              WebinarStreamController
                                      .currentStreamBlockParticipants[index]
                                  ['profile_image']),
                        ),
                        title: Text(
                          WebinarStreamController
                              .currentStreamBlockParticipants[index]['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: TextButton(
                            child: Text(
                              'Unblock',
                              style: listtileSubtitleStyle.copyWith(
                                  color: Colors.white),
                            ),
                            onPressed: () {
                              Get.find<WebinarStreamController>()
                                  .unblockparticipantFromWebinar(
                                      WebinarStreamController
                                              .currentStreamBlockParticipants[
                                          index]['_id'],
                                      widget.room.name!);
                            }),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
          //chat drawer
          endDrawer: Drawer(
            //chat drawer,
            width: 1.sw,
            child: WillPopScope(
              onWillPop: () async {
                scaffoldKey.currentState!.closeEndDrawer();
                return false;
              },
              child: Scaffold(
                  backgroundColor: AppColors.DTbackGroundColor,
                  //onback

                  appBar: AppBar(
                    backgroundColor: AppColors.DTbackGroundColor,
                    elevation: 0,
                    toolbarHeight: 0,
                    bottom: TabBar(
                        controller: _tabController,
                        indicatorColor: AppColors.LTprimaryColor,
                        tabs: [
                          Tab(
                            child: Text(
                              'Chat',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontSize: 20.sp, color: Colors.white),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Questions',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontSize: 20.sp, color: Colors.white),
                            ),
                          ),
                        ]),
                  ),
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      // this is for chat tab
                      Container(
                        color: AppColors.DTbackGroundColor,
                        child: Column(
                          children: [
                            Expanded(
                              child: Obx(
                                () => ListView.builder(
                                  // reverse: true,

                                  itemCount: chatMessages.length,

                                  itemBuilder: (context, index) {
                                    bool insertDate = false;

                                    if (index == 0) {
                                      insertDate = true;
                                    } else if (currentDate !=
                                        DateFormat.jm().format(DateTime.parse(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    chatMessages[index]
                                                        ['timestamp'] as int)
                                                .toString()))) {
                                      insertDate = true;
                                    }

                                    currentDate = DateFormat.jm().format(
                                        DateTime.parse(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    chatMessages[index]
                                                        ['timestamp'] as int)
                                                .toString()));

                                    return Column(
                                      children: [
                                        Gap(10.h),
                                        insertDate
                                            ? Text(
                                                DateFormat.jm().format(DateTime.parse(
                                                    DateTime.fromMillisecondsSinceEpoch(
                                                            chatMessages[index][
                                                                    'timestamp']
                                                                as int)
                                                        .toString())),
                                                style: listtileSubtitleStyle
                                                    .copyWith(
                                                        color:
                                                            Colors.grey[400]),
                                              )
                                            : const SizedBox(),
                                        ListTile(
                                          leading: CircleAvatar(
                                            radius: 20.r,
                                            backgroundImage: NetworkImage(
                                                AppConstants.baseURL +
                                                    jsonDecode(
                                                            chatMessages[index]
                                                                    ['from']
                                                                ['metadata'])[
                                                        'profile_image']),
                                          ),
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                // "Name",
                                                jsonDecode(chatMessages[index]
                                                        ['from']
                                                    ['metadata'])['name'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .copyWith(fontSize: 20.sp)
                                                    .copyWith(
                                                        color: chatMessages[index]
                                                                        ['to'][
                                                                    'identity'] ==
                                                                widget
                                                                    .room
                                                                    .localParticipant!
                                                                    .identity
                                                            ? Colors.green
                                                            : Colors.white),
                                              ),
                                              Text(
                                                chatMessages[index]['from']
                                                                ['identity'] ==
                                                            widget
                                                                .room
                                                                .localParticipant!
                                                                .identity &&
                                                        chatMessages[index]
                                                                    ['to']
                                                                ['identity'] !=
                                                            'all'
                                                    // ? ' (You)'
                                                    ? "${" (to " + jsonDecode(chatMessages[index]['to']['metadata'])['name']})"
                                                    : "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .copyWith(fontSize: 15.sp)
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                              Text(
                                                chatMessages[index]['to']
                                                            ['identity'] ==
                                                        widget
                                                            .room
                                                            .localParticipant!
                                                            .identity
                                                    ? ' (You only)'
                                                    : "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .copyWith(fontSize: 15.sp)
                                                    .copyWith(
                                                        color: chatMessages[index]
                                                                        ['to'][
                                                                    'identity'] ==
                                                                widget
                                                                    .room
                                                                    .localParticipant!
                                                                    .identity
                                                            ? Colors.red
                                                            : Colors.white),
                                              ),
                                            ],
                                          ),
                                          subtitle: Text(
                                            chatMessages[index]['message'],
                                            style:
                                                listtileSubtitleStyle.copyWith(
                                                    color: Colors.grey[300],
                                                    letterSpacing: 1,
                                                    height: 1.5),
                                            textAlign: TextAlign.justify,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                    controller: chatcontroller,
                                    keyboardAppearance: Brightness.dark,
                                    keyboardType: TextInputType.text,
                                    minLines: 1,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      suffixIcon: Transform.rotate(
                                        angle: -45 * 3 / 180,
                                        child: IconButton(
                                          icon: const Icon(Icons.send),
                                          color: Colors.cyan,
                                          onPressed: () async {
                                            print(widget.webinarRoomId);
                                            // print(jsonDecode(chatMessages[0]['from']
                                            // ['metadata'])['name']);
                                            if (chatcontroller
                                                .text.isNotEmpty) {
                                              // widget.room.localParticipant?.publishMessage(
                                              // chatcontroller.text,
                                              // attributes: {'name': 'Amit'});
                                              Map<String, dynamic> newmesage = {
                                                "message":
                                                    chatcontroller.text.trim(),
                                                "from": {
                                                  "identity": widget
                                                      .room
                                                      .localParticipant!
                                                      .identity,
                                                  "metadata": widget
                                                      .room
                                                      .localParticipant!
                                                      .metadata,
                                                },
                                                "timestamp": DateTime.now()
                                                    .millisecondsSinceEpoch,
                                                "to": {
                                                  "identity": 'all',
                                                  "metadata":
                                                      {'name': 'all'}.toString()
                                                }
                                              };
                                              Map<String, dynamic> message = {
                                                'message':
                                                    chatcontroller.text.trim(),
                                                'from': jsonDecode(widget
                                                    .room
                                                    .localParticipant!
                                                    .metadata!)['name'],
                                                'profile_image': jsonDecode(
                                                        widget
                                                            .room
                                                            .localParticipant!
                                                            .metadata!)[
                                                    'profile_image'],
                                                'accountType': jsonDecode(widget
                                                    .room
                                                    .localParticipant!
                                                    .metadata!)['role'],
                                                'time':
                                                    DateTime.now().toString()
                                              };

                                              await Get.find<
                                                      WebinarStreamController>()
                                                  .sendMessageToRoomChat(
                                                      widget.webinarRoomId,
                                                      newmesage);

                                              chatcontroller.clear();

                                              //close keyboard
                                              // print(chatMessages);
                                              FocusScope.of(context).unfocus();
                                            }
                                          },
                                        ),
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
                          ],
                        ),
                      ),

                      // this is for question tab
                      Container(
                        color: AppColors.DTbackGroundColor,
                        child: Column(
                          children: [
                            Expanded(
                              child: Obx(
                                () => ListView.builder(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  controller: _scrollController,
                                  itemCount: questionMessages.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                        top: 20.h,
                                        left: 10.w,
                                        right: 10.w,
                                      ),
                                      decoration: listtileDecoration.copyWith(
                                        color: Colors.black54,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              // offset: const Offset(0, -1),
                                              blurRadius: 5,
                                              spreadRadius: 2),
                                          // BoxShadow(
                                          //     color: Colors.grey.withOpacity(0.1),
                                          //     // offset: const Offset(0, 1),
                                          //     blurRadius: 10,
                                          //     spreadRadius: 1),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: Text(
                                              questionMessages[index].question!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .copyWith(
                                                      height: 1.5,
                                                      color: Colors.white,
                                                      fontSize: 20.sp),
                                              textAlign: TextAlign.justify,
                                            ),
                                            trailing: Text(
                                                DateFormat.jm().format(
                                                    DateTime.parse(DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                                questionMessages[
                                                                        index]
                                                                    .timestamp!
                                                                    .toInt())
                                                        .toString())),
                                                style: listtileSubtitleStyle
                                                    .copyWith(
                                                        color: Colors.grey)),
                                          ),
                                          jsonDecode(widget
                                                      .room
                                                      .localParticipant!
                                                      .metadata!)['role'] ==
                                                  'organizer'
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10.w,
                                                      right: 10.w,
                                                      top: 10.h,
                                                      bottom: 10.h),
                                                  height: 50.h,
                                                  child: TextFormField(
                                                    controller:
                                                        answersControllers[
                                                            index],
                                                    style: listtileSubtitleStyle
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                    maxLines: 1,
                                                    keyboardAppearance:
                                                        Brightness.dark,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    decoration: InputDecoration(
                                                      enabled: true,
                                                      fillColor:
                                                          Colors.grey[800],
                                                      filled: true,
                                                      hintText:
                                                          "type answer here",
                                                      hintStyle: Theme.of(
                                                              context)
                                                          .textTheme
                                                          .displayMedium!
                                                          .copyWith(
                                                              color: Colors
                                                                  .grey[400]),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.r),
                                                      ),
                                                      suffixIcon:
                                                          Transform.rotate(
                                                        angle: -45 * 3 / 180,
                                                        child: IconButton(
                                                            icon: const Icon(
                                                                Icons.send),
                                                            color: AppColors
                                                                .LTsecondaryColor,
                                                            onPressed:
                                                                () async {
                                                              if (answersControllers[
                                                                      index]
                                                                  .text
                                                                  .isNotEmpty) {
                                                                Map<String,
                                                                        dynamic>
                                                                    answer = {
                                                                  "questionId":
                                                                      questionMessages[
                                                                              index]
                                                                          .id,
                                                                  "answer": answersControllers[
                                                                          index]
                                                                      .text
                                                                      .trim(),
                                                                  "from": {
                                                                    "identity": widget
                                                                        .room
                                                                        .localParticipant!
                                                                        .identity,
                                                                    "metadata": widget
                                                                        .room
                                                                        .localParticipant!
                                                                        .metadata,
                                                                  },
                                                                  "timestamp": DateTime
                                                                          .now()
                                                                      .millisecondsSinceEpoch,
                                                                };

                                                                await Get.find<
                                                                        WebinarStreamController>()
                                                                    .postAnswerToQuestion(
                                                                        widget
                                                                            .webinarRoomId,
                                                                        answer);
                                                                answersControllers[
                                                                        index]
                                                                    .clear();
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();
                                                              }
                                                            }),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          questionMessages[index]
                                                  .answers!
                                                  .isEmpty
                                              ? Container()
                                              : ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      questionMessages[index]
                                                          .answers!
                                                          .length,
                                                  itemBuilder:
                                                      (context, index2) {
                                                    return Container(
                                                      padding: EdgeInsets.only(
                                                          left: 20.w,
                                                          right: 20.w,
                                                          top: 10.h,
                                                          bottom: 10.h),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          ExpandableText(
                                                            expandText: '',
                                                            collapseOnTextTap:
                                                                true,
                                                            questionMessages[
                                                                    index]
                                                                .answers![
                                                                    index2]
                                                                .answer!,
                                                            expandOnTextTap:
                                                                true,
                                                            maxLines: 4,
                                                            style: listtileSubtitleStyle
                                                                .copyWith(
                                                                    fontSize:
                                                                        16.sp,
                                                                    height: 1.5,
                                                                    letterSpacing:
                                                                        1,
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            1)),
                                                            textAlign: TextAlign
                                                                .justify,
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                          Wrap(
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                questionMessages[
                                                                        index]
                                                                    .answers![
                                                                        index2]
                                                                    .from!
                                                                    .metadata!
                                                                    .name!,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displayMedium!
                                                                    .copyWith(
                                                                        letterSpacing:
                                                                            1,
                                                                        height:
                                                                            2,
                                                                        color: Colors
                                                                            .grey[600]),
                                                              ),
                                                              Text(
                                                                ' (${DateFormat.jm().format(DateTime.parse(DateTime.fromMillisecondsSinceEpoch(questionMessages[index].answers![index2].timestamp!.toInt()).toString()))})',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displayMedium!
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .grey[600]),
                                                              ),
                                                            ],
                                                          ),
                                                          const Divider(
                                                            color: Colors.grey,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                    controller: questionsController,
                                    keyboardAppearance: Brightness.dark,
                                    keyboardType: TextInputType.text,
                                    minLines: 1,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      suffixIcon: Transform.rotate(
                                        angle: -45 * 3 / 180,
                                        child: IconButton(
                                          icon: const Icon(Icons.send),
                                          color: Colors.cyan,
                                          onPressed: () async {
                                            print('questions filed');

                                            if (questionsController
                                                .text.isNotEmpty) {
                                              print(questionsController.text
                                                  .trim());
                                              String uuid = const Uuid().v4();
                                              Map<String, dynamic> question = {
                                                "id": uuid,
                                                "question": questionsController
                                                    .text
                                                    .trim(),
                                                "from": {
                                                  "identity": jsonDecode(widget
                                                      .room
                                                      .localParticipant!
                                                      .metadata!)['_id'],
                                                  "metadata": widget
                                                      .room
                                                      .localParticipant!
                                                      .metadata!
                                                },
                                                "timestamp": DateTime.now()
                                                    .millisecondsSinceEpoch,
                                                "answers": []
                                              };
                                              await WebinarStreamController()
                                                  .postQuestionToWebinarStream(
                                                      widget.webinarRoomId,
                                                      question);
                                              print(question);
                                              questionsController.clear();

                                              FocusScope.of(context).unfocus();
                                            }
                                          },
                                        ),
                                      ),
                                      fillColor: const Color(0xff262626),
                                      filled: true,
                                      hintText: "Type a Question",
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 17.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
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
                                        borderRadius:
                                            BorderRadius.circular(6.r),
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
                                        borderRadius:
                                            BorderRadius.circular(6.r),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                radius: 50.r,
                                                backgroundImage: NetworkImage(
                                                    AppConstants.baseURL +
                                                        jsonDecode(
                                                          widget
                                                              .room
                                                              .participants
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
        ),
      );
}
