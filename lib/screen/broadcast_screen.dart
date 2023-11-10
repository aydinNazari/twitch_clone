import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/providers/user_provider.dart';
import '../config/app_id.dart';


class BroadScreen extends StatefulWidget {
  const BroadScreen(
      {Key? key, required this.isBroadCast, required this.chanellID})
      : super(key: key);
  final bool isBroadCast;
  final String chanellID;

  @override
  State<BroadScreen> createState() => _BroadScreenState();
}

class _BroadScreenState extends State<BroadScreen> {
  late final RtcEngine _engine;

  List<int> remotUid = [];

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  void _initEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: appID,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    _addListeners();
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine
        .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
    if (widget.isBroadCast) {
      _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    } else {
      _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    }
    _joinChannel();
  }

  void _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.camera.request();
      await Permission.microphone.request();
    }
    await _engine.joinChannelWithUserAccount(
        token: tempToken,
        channelId: 'testing123',
        userAccount:
            Provider.of<UserProvider>(context, listen: false).user.uid);
  }

  void _addListeners() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        debugPrint('joinChanel sucsess $connection - $elapsed');
      }, onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        debugPrint('userJoiend: $connection - $remoteUid - $elapsed');
        setState(() {
          remotUid.add(remoteUid);
        });
      }, onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
        debugPrint("UserOffline $remoteUid - $reason");
        setState(
          () {
            remotUid.removeWhere((element) => element == remoteUid);
          },
        );
      }, onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        debugPrint('leaveChannel $stats');
        setState(() {
          remotUid.clear();
        });
      }),
    );
  }

  _renderVideo(user) {
    String controlUid=user.uid+user.username;
    return const AspectRatio(aspectRatio: 16 / 9,child: controlUid == widget.chanellID ?  ,);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      body: Column(
        children: [
          _renderVideo(user),
        ],
      ),
    );
  }
}
