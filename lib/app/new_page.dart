import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'mobile_ads.dart';

class NewPage extends StatelessWidget {
  final String title;

  const NewPage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              title: Text(title),
              systemOverlayStyle: SystemUiOverlayStyle.light)
          .withBottomAdmobBanner(context),
      body: Container(
        color: Colors.green,
      ),
    );
  }
}

class AppBarBannerRecipe extends StatelessWidget
    implements PreferredSizeWidget {
  final AppBar appBar;
  final Size size;

  const AppBarBannerRecipe({
    Key? key,
    required this.appBar,
    required this.size,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      Size.fromHeight(appBar.preferredSize.height + height);

  double get height => max(size.height * .06, 50.0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        appBar,
        SizedBox(
          width: size.width,
          height: height,
          child: AdmobBanner(
            adUnitId: getBannerAdUnitId()!,
            adSize: AdmobBannerSize.ADAPTIVE_BANNER(
              width: size.width.toInt(),
            ),
          ),
        )
      ],
    );
  }
}

extension AppBarAdmobX on AppBar {
  PreferredSizeWidget withBottomAdmobBanner(BuildContext context) {
    return AppBarBannerRecipe(
      appBar: this,
      size: MediaQuery.of(context).size,
    );
  }
}

class TopBannerAdAppRecipe extends StatelessWidget {
  const TopBannerAdAppRecipe({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MediaQuery(
        data: MediaQueryData.fromView(WidgetsBinding.instance.window),
        child: Container(
          color: Colors.blueGrey,
          child: Column(children: [
            SafeArea(
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  final size = MediaQuery.of(context).size;
                  final height = max(size.height * .05, 50.0);
                  return SizedBox(
                    width: size.width,
                    height: height,
                    child: AdmobBanner(
                      adUnitId: getBannerAdUnitId()!,
                      adSize: AdmobBannerSize.ADAPTIVE_BANNER(
                        width: size.width.toInt(),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(child: child),
          ]),
        ),
      ),
    );
  }
}

class BottomBannerAdAppRecipe extends StatelessWidget {
  const BottomBannerAdAppRecipe({
    Key? key,
    required this.child,
  }) : super(key: key);

  final MaterialApp child;

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    return Directionality(
      textDirection: textDirection,
      child: MediaQuery(
        data: MediaQueryData.fromView(WidgetsBinding.instance.window),
        child: Container(
          color: Colors.blueGrey,
          child: Column(children: [
            Expanded(child: child),
            SafeArea(
              top: false,
              child: Builder(
                builder: (BuildContext context) {
                  final size = MediaQuery.of(context).size;
                  final height = max(size.height * .05, 50.0);
                  return SizedBox(
                    width: size.width,
                    height: height,
                    child: AdmobBanner(
                      adUnitId: getBannerAdUnitId()!,
                      adSize: AdmobBannerSize.ADAPTIVE_BANNER(
                        width: size.width.toInt(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

extension MaterialAppX on MaterialApp {
  Widget withBottomAdmobBanner(BuildContext context) {
    return BottomBannerAdAppRecipe(
      child: this,
    );
  }
}
