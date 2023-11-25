import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:twitch_clone/providers/user_provider.dart';
import 'package:twitch_clone/resources/firestore_methods.dart';
import 'package:twitch_clone/screen/home_screen.dart';
import 'package:twitch_clone/widgets/chatWidget.dart';
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
  bool switchCamera = true;
  bool isMute = false;

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  void _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((error) {
      debugPrint('switch camera $error');
    });
  }

  Future<void> onToggleMute() async {
    setState(() {
      isMute = !isMute;
    });
    await _engine.muteLocalAudioStream(isMute);
  }

  void _initEngine() async {
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
  }

  void _addListeners() {
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

  _renderVideo(user, Size size) {
    String controlUid = user.uid + user.username;
    return Stack(
      children: [
        AspectRatio(
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
        ),
        if ('${user.uid}${user.username}' == widget.chanellID)
          Positioned(
            bottom: size.height / 100,
            right: size.width/45,
            child: Row(
              children: [
                InkWell(
                  onTap: _switchCamera,
                  child: SizedBox(
                    width: size.width / 6,
                    height: size.height / 20,
                    child: Image.asset(
                      'assets/icons/switch_camera.png',
                    ),
                  ),
                ),
                InkWell(
                  onTap: onToggleMute,
                  child: isMute
                      ? SizedBox(
                          width: size.width / 12,
                          height: size.height / 20,
                          child: Image.asset(
                            'assets/icons/volume.png',
                          ),
                        )
                      : SizedBox(
                          width: size.width / 12,
                          height: size.height / 20,
                          child: Image.asset(
                            'assets/icons/mute.png',
                          ),
                        ),
                )
              ],
            ),
          ),
      ],
    );
  }

  _leaveChannal() async {
    _engine.leaveChannel();
    String userNameUid =
        Provider.of<UserProvider>(context, listen: false).user.uid +
            Provider.of<UserProvider>(context, listen: false).user.username;
    if (userNameUid == widget.chanellID) {
      await FireStoreMethods().endLiveStream(widget.chanellID);
    } else {
      await FireStoreMethods().updateViewCount(widget.chanellID, false);
    }
    setState(() {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return WillPopScope(
      onWillPop: () async {
        await _leaveChannal();
        return Future.value(false);
      },
      child: Scaffold(
        body: Column(
          children: [
            _renderVideo(user, size),
            Expanded(
              child: ChatWidget(
                chanalId: widget.chanellID,
              ),
            )
          ],
        ),
      ),
    );
  }
}
