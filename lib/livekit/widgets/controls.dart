import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_background/flutter_background.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../exts.dart';

class ControlsWidget extends StatefulWidget {
  //
  final Room room;
  final LocalParticipant participant;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ControlsWidget(
    this.scaffoldKey,
    this.room,
    this.participant, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ControlsWidgetState();
}

class _ControlsWidgetState extends State<ControlsWidget> {
  //
  CameraPosition position = CameraPosition.front;

  List<MediaDevice>? _audioInputs;
  List<MediaDevice>? _audioOutputs;
  List<MediaDevice>? _videoInputs;
  MediaDevice? _selectedVideoInput;

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    participant.addListener(_onChange);
    _subscription = Hardware.instance.onDeviceChange.stream
        .listen((List<MediaDevice> devices) {
      _loadDevices(devices);
    });
    Hardware.instance.enumerateDevices().then(_loadDevices);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    participant.removeListener(_onChange);
    super.dispose();
  }

  LocalParticipant get participant => widget.participant;

  void _loadDevices(List<MediaDevice> devices) async {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
    _audioOutputs = devices.where((d) => d.kind == 'audiooutput').toList();
    _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();
    _selectedVideoInput = _videoInputs?.first;
    setState(() {});
  }

  void _onChange() {
    // trigger refresh
    setState(() {});
  }

  void _unpublishAll() async {
    final result = await context.showUnPublishDialog();
    if (result == true) await participant.unpublishAllTracks();
  }

  bool get isMuted => participant.isMuted;

  void _disableAudio() async {
    await participant.setMicrophoneEnabled(false);
  }

  Future<void> _enableAudio() async {
    await participant.setMicrophoneEnabled(true);
  }

  void _disableVideo() async {
    await participant.setCameraEnabled(false);
  }

  void _enableVideo() async {
    await participant.setCameraEnabled(true);
  }

  void _selectAudioOutput(MediaDevice device) async {
    await Hardware.instance.selectAudioOutput(device);
    setState(() {});
  }

  void _selectAudioInput(MediaDevice device) async {
    await Hardware.instance.selectAudioInput(device);
    setState(() {});
  }

  void _selectVideoInput(MediaDevice device) async {
    final track = participant.videoTracks.firstOrNull?.track;
    if (track == null) return;
    if (_selectedVideoInput?.deviceId != device.deviceId) {
      await track.switchCamera(device.deviceId);
      _selectedVideoInput = device;
      setState(() {});
    }
  }

  void _toggleCamera() async {
    //
    final track = participant.videoTracks.firstOrNull?.track;
    if (track == null) return;

    try {
      final newPosition = position.switched();
      await track.setCameraPosition(newPosition);
      setState(() {
        position = newPosition;
      });
    } catch (error) {
      print('could not restart track: $error');
      return;
    }
  }

  void _enableScreenShare() async {
    if (WebRTC.platformIsDesktop) {
      try {
        final source = await showDialog<DesktopCapturerSource>(
          context: context,
          builder: (context) => ScreenSelectDialog(),
        );
        if (source == null) {
          print('cancelled screenshare');
          return;
        }
        print('DesktopCapturerSource: ${source.id}');
        var track = await LocalVideoTrack.createScreenShareTrack(
          ScreenShareCaptureOptions(
            sourceId: source.id,
            maxFrameRate: 15.0,
          ),
        );
        await participant.publishVideoTrack(track);
      } catch (e) {
        print('could not publish video: $e');
      }
      return;
    }
    if (WebRTC.platformIsAndroid) {
      // Android specific
      requestBackgroundPermission([bool isRetry = false]) async {
        // Required for android screenshare.
        try {
          bool hasPermissions = await FlutterBackground.hasPermissions;
          if (!isRetry) {
            const androidConfig = FlutterBackgroundAndroidConfig(
              notificationTitle: 'Screen Sharing',
              notificationText: 'LiveKit Example is sharing the screen.',
              notificationImportance: AndroidNotificationImportance.Default,
              notificationIcon: AndroidResource(
                  name: 'livekit_ic_launcher', defType: 'mipmap'),
            );
            hasPermissions = await FlutterBackground.initialize(
                androidConfig: androidConfig);
          }
          if (hasPermissions &&
              !FlutterBackground.isBackgroundExecutionEnabled) {
            await FlutterBackground.enableBackgroundExecution();
          }
        } catch (e) {
          if (!isRetry) {
            return await Future<void>.delayed(const Duration(seconds: 1),
                () => requestBackgroundPermission(true));
          }
          print('could not publish video: $e');
        }
      }

      await requestBackgroundPermission();
    }
    if (WebRTC.platformIsIOS) {
      var track = await LocalVideoTrack.createScreenShareTrack(
        const ScreenShareCaptureOptions(
          useiOSBroadcastExtension: true,
          maxFrameRate: 15.0,
        ),
      );
      await participant.publishVideoTrack(track);
      return;
    }
    await participant.setScreenShareEnabled(true, captureScreenAudio: true);
  }

  void _disableScreenShare() async {
    await participant.setScreenShareEnabled(false);
    if (Platform.isAndroid) {
      // Android specific
      try {
        //   await FlutterBackground.disableBackgroundExecution();
      } catch (error) {
        print('error disabling screen share: $error');
      }
    }
  }

  void _onTapDisconnect() async {
    final result = await context.showDisconnectDialog();
    if (result == true) await widget.room.disconnect();
  }

  void _onTapUpdateSubscribePermission() async {
    final result = await context.showSubscribePermissionDialog();
    if (result != null) {
      try {
        widget.room.localParticipant?.setTrackSubscriptionPermissions(
          allParticipantsAllowed: result,
        );
      } catch (error) {
        await context.showErrorDialog(error);
      }
    }
  }

  void _onTapSimulateScenario() async {
    final result = await context.showSimulateScenarioDialog();
    if (result != null) {
      print('$result');
      await widget.room.sendSimulateScenario(
        signalReconnect:
            result == SimulateScenarioResult.signalReconnect ? true : null,
        nodeFailure: result == SimulateScenarioResult.nodeFailure ? true : null,
        migration: result == SimulateScenarioResult.migration ? true : null,
        serverLeave: result == SimulateScenarioResult.serverLeave ? true : null,
        switchCandidate:
            result == SimulateScenarioResult.switchCandidate ? true : null,
      );
    }
  }

  void _onTapSendData() async {
    final result = await context.showSendDataDialog();
    if (result == true) {
      await widget.participant.publishData(
        utf8.encode('This is a sample data message'),
      );
      var data = utf8.encode('This is a sample data message');
      print(data);
      print(const Utf8Decoder().convert(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(8.0),
      color: const Color(0xff0A2647),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (participant.isMicrophoneEnabled())
                IconButton(
                  onPressed: _disableAudio,
                  icon: const Icon(
                    EvaIcons.mic,
                    color: Colors.green,
                  ),
                  tooltip: 'Mute Microphone',
                )
              else
                IconButton(
                  onPressed: _enableAudio,
                  icon: const Icon(
                    EvaIcons.micOff,
                    color: Colors.red,
                  ),
                  tooltip: 'Unmute Microphone',
                ),
              PopupMenuButton<MediaDevice>(
                icon: const Icon(
                  Icons.volume_up,
                  color: Colors.white,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<MediaDevice>(
                      value: null,
                      child: ListTile(
                        leading: Icon(
                          EvaIcons.speaker,
                          color: Colors.black,
                        ),
                        title: Text('Select Audio Output'),
                      ),
                    ),
                    if (_audioOutputs != null)
                      ..._audioOutputs!.map((device) {
                        return PopupMenuItem<MediaDevice>(
                          value: device,
                          child: Container(
                            child: ListTile(
                              leading: (device.deviceId ==
                                      Hardware.instance.selectedAudioOutput
                                          ?.deviceId)
                                  ? const Icon(
                                      EvaIcons.checkmarkSquare,
                                      color: Colors.black,
                                    )
                                  : const Icon(
                                      EvaIcons.square,
                                      color: Colors.black,
                                    ),
                              title: Text(device.label),
                            ),
                          ),
                          onTap: () => _selectAudioOutput(device),
                        );
                      }).toList()
                  ];
                },
              ),
              if (participant.isCameraEnabled())
                PopupMenuButton<MediaDevice>(
                  icon: const Icon(
                    EvaIcons.video,
                    color: Colors.white,
                  ),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<MediaDevice>(
                        value: null,
                        onTap: () {
                          _disableVideo();
                        },
                        child: const ListTile(
                          leading: Icon(
                            EvaIcons.videoOff,
                            color: Colors.black,
                          ),
                          title: Text('Disable Camera'),
                        ),
                      ),
                      if (_videoInputs != null)
                        ..._videoInputs!.map((device) {
                          return PopupMenuItem<MediaDevice>(
                            value: device,
                            child: ListTile(
                              leading: (device.deviceId ==
                                      _selectedVideoInput?.deviceId)
                                  ? const Icon(
                                      EvaIcons.checkmarkSquare,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      EvaIcons.square,
                                      color: Colors.white,
                                    ),
                              title: Text(device.label),
                            ),
                            onTap: () => _selectVideoInput(device),
                          );
                        }).toList()
                    ];
                  },
                )
              else
                IconButton(
                  onPressed: _enableVideo,
                  icon: const Icon(
                    EvaIcons.videoOff,
                    color: Colors.white,
                  ),
                  tooltip: 'un-mute video',
                ),
              // IconButton(
              //   icon: Icon(position == CameraPosition.back
              //       ? EvaIcons.cameraOutline
              //       : EvaIcons.person),
              //   onPressed: () => _toggleCamera(),
              //   tooltip: 'toggle camera',
              // ),
              IconButton(
                onPressed: () {
                  print('chat button');
                  print(widget.room.localParticipant!.identity);
                  widget.scaffoldKey.currentState!.openEndDrawer();
                },
                icon: const Icon(
                  Icons.chat,
                  color: Colors.white,
                ),
              ),
              IconButton(
                  onPressed: () {
                    widget.scaffoldKey.currentState!.openDrawer();

                    print('participants');
                  },
                  icon: const Icon(
                    Icons.group,
                    color: Colors.white,
                  )),
              if (participant.isScreenShareEnabled())
                IconButton(
                  icon: const Icon(
                    Icons.disabled_by_default_outlined,
                    color: Colors.red,
                  ),
                  onPressed: () => _disableScreenShare(),
                  tooltip: 'unshare screen (experimental)',
                )
              else
                IconButton(
                  icon: const Icon(
                    Icons.monitor,
                    color: Colors.white,
                  ),
                  onPressed: () => _enableScreenShare(),
                  tooltip: 'share screen (experimental)',
                ),
            ],
          ),
          TextButton(
            style: TextButton.styleFrom(
              fixedSize: Size(1.sw, 30),
              backgroundColor: Colors.red,
            ),
            onPressed: _onTapDisconnect,
            child: const Text(
              'End',
              style: TextStyle(
                  fontFamily: 'JosefinSans Bold',
                  color: Colors.white,
                  backgroundColor: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
