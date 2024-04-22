// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mesibo_flutter_sdk/mesibo.dart';
import 'package:restart_app/restart_app.dart';

void main() async {
  runApp(const FirstMesiboApp());
}

class FirstMesiboApp extends StatelessWidget {
  const FirstMesiboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mesibo Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("First Mesibo App"),
        ),
        body: const HomeWidget(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    implements
        MesiboConnectionListener,
        MesiboMessageListener,
        MesiboSyncListener {
  Mesibo mesibo = Mesibo();
  String mesiboStatus = 'Mesibo status: Not Connected.';
  bool isMesiboInit = false;
  bool isProfilesInit = false;
  MesiboProfile? selfProfile;

  initProfilesUser() async {
    selfProfile = await mesibo.getSelfProfile() as MesiboProfile;
    // remoteProfile = await mesibo.getUserProfile('2');

    isProfilesInit = true;
    getGroupDetails();

    setState(() {});
  }

  getGroupDetails() async {
    // 3032044 - tushar test 1 - april
    // 3040939 - abrar test 4 - abrar test 4
    List<int> addresses = [3032044, 3040939];

    for (int i = 0; i < addresses.length; i++) {
      try {
        final profile = await mesibo.getGroupProfile(addresses[i]);

        print("gorup name: ${profile.name}");
      } catch (e, s) {
        print("error: $e, stachtrace $s");
        continue;
      }
    }
  }

  @override
  void Mesibo_onConnectionStatus(int status) {
    String statusText = status.toString();
    if (status == Mesibo.MESIBO_STATUS_ONLINE) {
      statusText = "Online";

      initProfilesUser();
    } else if (status == Mesibo.MESIBO_STATUS_CONNECTING) {
      statusText = "Connecting";
    } else if (status == Mesibo.MESIBO_STATUS_CONNECTFAILURE) {
      statusText = "Connect Failed";
    } else if (status == Mesibo.MESIBO_STATUS_NONETWORK) {
      statusText = "No Network";
    } else if (status == Mesibo.MESIBO_STATUS_AUTHFAIL) {
      statusText = "The token is invalid.";
    }
    mesiboStatus = 'Mesibo status: $statusText';
    setState(() {});
  }

  initMesiboUser() async {
    await mesibo.stop();

    await mesibo.setAccessToken(
        '759b6a38bf5b8867f823ea2a6d96e0a4e0c129d8a31fba3f38eaa4af797za4175518091');
    mesibo.setListener(this);
    await mesibo.setDatabase('6462503.db');
    await mesibo.restoreDatabase('6462503.db', 9999);
    await mesibo.start();
    isMesiboInit = true;

    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mesibo.stop();

    mesiboStatus = 'Mesibo status: Not Connected.';
    isMesiboInit = false;
    isProfilesInit = false;
    selfProfile = null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  initMesiboUser();
                },
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await Restart.restartApp();
                },
                child: const Text('logout'),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              mesiboStatus,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          isMesiboInit && isProfilesInit
              ? Text("successfully logged in")
              : CircularProgressIndicator()
        ],
      ),
    );
  }

  @override
  void Mesibo_onMessageStatus(MesiboMessage message) {
    // TODO: implement Mesibo_onMessageStatus
  }

  @override
  void Mesibo_onMessageUpdate(MesiboMessage message) {
    // TODO: implement Mesibo_onMessageUpdate
  }

  @override
  void Mesibo_onSync(MesiboReadSession rs, int count) {
    // TODO: implement Mesibo_onSync
  }

  @override
  void Mesibo_onMessage(MesiboMessage message) {
    // TODO: implement Mesibo_onMessage
  }
}
