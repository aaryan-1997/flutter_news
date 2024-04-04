import 'package:flutter/material.dart';

import '../utils/appcolors.dart';
import '../utils/onboarding_util/topics.dart';
import '../../core/widgets/apptext.dart';
import '../../core/widgets/capsule_widget.dart';
import '../../core/widgets/subwidgets/home_section_country.dart';
import '../../core/widgets/subwidgets/home_section_geo.dart';
import '../../core/widgets/subwidgets/home_section_tab.dart';
import 'profilescreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedItemIndex = 0;
  String tabName = "World";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          leading: const Text(""),
          backgroundColor: AppColors.primaryColor,
          title: const AppText(
            text: "H I G H L I G H T S",
            fontSize: 18.0,
            color: AppColors.blackColor,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()),
                  );
                },
                icon: const Icon(
                  Icons.account_circle_outlined,
                  color: AppColors.blackColor,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.98,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: topicList.length,
                  itemBuilder: (context, index) {
                    return CapsuleWidget(
                      name: topicList[index].value,
                      border: AppColors.primaryColor,
                      background: _selectedItemIndex == index
                          ? AppColors.primaryColor.withOpacity(0.8)
                          : Colors.white,
                      currentIndex: index,
                      onTapCallback: (String isTapped) {
                        setState(() {
                          tabName = isTapped;
                        });
                      },
                      onTapIndex: (int index) {
                        setState(() {
                          if (_selectedItemIndex == index) {
                            _selectedItemIndex = -1; // Deselect if tapped again
                          } else {
                            _selectedItemIndex = index;
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              HomeSectionTab(topic: tabName),
              const HomeSectionCountry(),
              const HomeSectionGeo(),
            ],
          ),
        ),
      ),
    );
  }
}
