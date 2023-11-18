import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/providers/user_provider.dart';
import 'package:twitch_clone/resources/firestore_methods.dart';
import 'package:twitch_clone/screen/home_screen.dart';
import '../config/app_id.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

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
    /* _engine = ();
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
    _joinChannel();*/
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appID));
    _addListeners();
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadCast) {
      _engine.setClientRole(ClientRole.Broadcaster);
    } else {
      _engine.setClientRole(ClientRole.Audience);
    }
    _joinChannel();
  }

  void _joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.camera.request();
      await Permission.microphone.request();
    }
    await _engine.joinChannelWithUserAccount(
      tempToken,
      'testing123',
      Provider.of<UserProvider>(context, listen: false).user.uid,
    );
    /*await _engine.joinChannelWithUserAccount(
        token: tempToken,
        channelId: 'testing123',
        userAccount:
        Provider
            .of<UserProvider>(context, listen: false)
            .user
            .uid);*/
  }

  void _addListeners() {
    /*  _engine.registerEventHandler(
      RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint('joinChanel sucsess $connection - $elapsed');
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint('userJoiend: $connection - $remoteUid - $elapsed');
            setState(() {
              remotUid.add(remoteUid);
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            debugPrint("UserOffline $remoteUid - $reason");
            setState(
                  () {
                remotUid.removeWhere((element) => element == remoteUid);
              },
            );
          },
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            debugPrint('leaveChannel $stats');
            setState(() {
              remotUid.clear();
            });
          }),
    );*/
    _engine.setEventHandler(
      RtcEngineEventHandler(
        joinChannelSuccess: (channel, uid, elapsed) {
          debugPrint('joinChanel sucsess $channel - $uid - $elapsed');
        },
        userJoined: (uid, elapsed) {
          debugPrint('userJoined $uid $elapsed');
          setState(() {
            remotUid.add(uid);
          });
        },
        userOffline: (uid, reason) {
          debugPrint('userOffline $uid $reason');
          setState(() {
            remotUid.removeWhere((element) => element == uid);
          });
        },
        leaveChannel: (stats) {
          debugPrint('leave channel $stats');
          setState(() {
            remotUid.clear();
          });
        },
      ),
    );
  }

  _renderVideo(user) {
    String controlUid = user.uid + user.username;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: controlUid == widget.chanellID
          ? const RtcLocalView.SurfaceView(
              zOrderMediaOverlay: true,
              zOrderOnTop: true,
            )
          : remotUid.isNotEmpty
              ? kIsWeb
                  ? RtcRemoteView.SurfaceView(
                      uid: remotUid[0],
                      channelId: widget.chanellID,
                    )
                  : RtcRemoteView.TextureView(
                      uid: remotUid[0],
                      channelId: widget.chanellID,
                    )
              : Container(),
    );
  }

  _leaveChannal() async {
    print('tttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt');
    _engine.leaveChannel();
    print('bakkkk');
    print(Provider.of<UserProvider>(context, listen: false).user.username);
    print(widget.chanellID);
    if (Provider.of<UserProvider>(context, listen: false).user.username ==
        widget.chanellID) {
      await FireStoreMethods().endLiveStream(widget.chanellID);
    } else {
      await FireStoreMethods().updateViewCount(widget.chanellID, false);
    }
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return WillPopScope(
      onWillPop: () async {
        await _leaveChannal();
        return Future.value(false);
      },
      child: Scaffold(
        body: Column(
          children: [
            _renderVideo(user),
          ],
        ),
      ),
    );
  }
}
