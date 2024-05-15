import 'dart:developer';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';

import 'new_page.dart';

class GoogleMobileAd extends StatefulWidget {
  const GoogleMobileAd({super.key});

  @override
  State<GoogleMobileAd> createState() => _GoogleMobileAdState();
}

class _GoogleMobileAdState extends State<GoogleMobileAd> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize? bannerSize;
  late AdmobInterstitial interstitialAd;
  //late AdmobReward rewardAd;

  @override
  void initState() {
    super.initState();

    // You should execute `Admob.requestTrackingAuthorization()` here before showing any ad.

    bannerSize = AdmobBannerSize.BANNER;

    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId()!,
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    // rewardAd = AdmobReward(
    //   adUnitId: getRewardBasedVideoAdUnitId()!,
    //   listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
    //     if (event == AdmobAdEvent.closed) rewardAd.load();
    //     handleEvent(event, args, 'Reward');
    //   },
    // );

    interstitialAd.load();
    //rewardAd.load();
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic>? args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        //showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        //showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        //showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        //showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext!,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                return true;
              },
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args!['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
            );
          },
        );
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: const Text('AdmobFlutter'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (BuildContext context) {
                    return const NewPage(title: 'Full Screen Dialog');
                  },
                ),
              );
            },
            child: const Text(
              'FullscreenDialog',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ), // .withBottomAdmobBanner(context),
      bottomNavigationBar: Builder(
        builder: (BuildContext context) {
          return Container(
            color: Colors.blueGrey,
            child: SafeArea(
              child: SizedBox(
                height: 60,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final isLoaded = await interstitialAd.isLoaded;
                          if (isLoaded ?? false) {
                            interstitialAd.show();
                          } else {
                            showSnackBar('Interstitial ad is still loading...');
                          }
                        },
                        child: const Text(
                          'Show Interstitial',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          // if (await rewardAd.isLoaded) {
                          //   rewardAd.show();
                          // } else {
                          //   showSnackBar('Reward ad is still loading...');
                          // }
                        },
                        child: const Text(
                          'Show Reward',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PopupMenuButton(
                        initialValue: bannerSize,
                        offset: const Offset(0, 20),
                        onSelected: (AdmobBannerSize newSize) {
                          setState(() {
                            bannerSize = newSize;
                          });
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<AdmobBannerSize>>[
                          const PopupMenuItem(
                            value: AdmobBannerSize.BANNER,
                            child: Text('BANNER'),
                          ),
                          const PopupMenuItem(
                            value: AdmobBannerSize.LARGE_BANNER,
                            child: Text('LARGE_BANNER'),
                          ),
                          const PopupMenuItem(
                            value: AdmobBannerSize.MEDIUM_RECTANGLE,
                            child: Text('MEDIUM_RECTANGLE'),
                          ),
                          const PopupMenuItem(
                            value: AdmobBannerSize.FULL_BANNER,
                            child: Text('FULL_BANNER'),
                          ),
                          const PopupMenuItem(
                            value: AdmobBannerSize.LEADERBOARD,
                            child: Text('LEADERBOARD'),
                          ),
                          PopupMenuItem(
                            value: AdmobBannerSize.SMART_BANNER(context),
                            child: const Text('SMART_BANNER'),
                          ),
                          PopupMenuItem(
                            value: AdmobBannerSize.ADAPTIVE_BANNER(
                              width: MediaQuery.of(context).size.width.toInt() -
                                  40, // considering EdgeInsets.all(20.0)
                            ),
                            child: const Text('ADAPTIVE_BANNER'),
                          ),
                        ],
                        child: const Center(
                          child: Text(
                            'Banner size',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return const NewPage(
                                title: 'Push Page',
                              );
                            }),
                          );
                        },
                        child: const Text(
                          'Push Page',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: 1000,
                itemBuilder: (BuildContext context, int index) {
                  if (index != 0 && index % 6 == 0) {
                    log("$index");
                    return Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: AdmobBanner(
                            adUnitId: getBannerAdUnitId()!,
                            adSize: bannerSize!,
                            listener: (AdmobAdEvent event,
                                Map<String, dynamic>? args) {
                              handleEvent(event, args, 'Banner');
                            },
                            onBannerCreated:
                                (AdmobBannerController controller) {
                              // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
                              // Normally you don't need to worry about disposing this yourself, it's handled.
                              // If you need direct access to dispose, this is your guy!
                              // controller.dispose();
                            },
                          ),
                        ),
                        Container(
                          height: 100.0,
                          margin: const EdgeInsets.only(bottom: 20.0),
                          color: Colors.cyan,
                        ),
                      ],
                    );
                  }
                  return Container(
                    height: 100.0,
                    margin: const EdgeInsets.only(bottom: 20.0),
                    color: Colors.cyan,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    //rewardAd.dispose();
    super.dispose();
  }
}

String? getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111';
  }
  return null;
}

String? getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-1700309772001520/7073281365';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-1700309772001520/7073281365';
  }
  return null;
}

String? getRewardBasedVideoAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-1700309772001520/7073281365';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-1700309772001520/7073281365';
  }
  return null;
}
