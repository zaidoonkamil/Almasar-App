
import 'package:delivery_app/core/%20navigation/navigation.dart';
import 'package:delivery_app/features/auth/view/login.dart';
import 'package:flutter/material.dart';

import '../../core/network/local/cache_helper.dart';
import '../../core/styles/themes.dart';
import '../user/navigation_bar_user.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<OnboardingData> onboardingPages = [
    OnboardingData(
      image: 'assets/images/Take Away-pana.png',
      title: " نوصل طلباتك بسرعة فائقة",
      description: "نضمن لك سرعة استثنائية في توصيل الطلبات من خلال شبكة توصيل متطورة وفريق محترف",
    ),
    OnboardingData(
      image: 'assets/images/Mobile-rafiki.png',
      title: "تابع طلبك لحظة بلحظة",
      description: "نوفر لك ميزة التتبع المباشر، حيث يمكنك معرفة موقع طلبك في أي وقت حتى لحظة وصوله إليك",

    ),
    OnboardingData(
      image: 'assets/images/Mailbox-rafiki.png',
      title: 'قم بتحليل نتائجك وتتبعها',
      description: "نحن هنا دائمًا لمساعدتك! فريق الدعم لدينا متاح 24/7 لحل أي استفسار لضمان تجربة توصيل سلسة ومرضية",
    ),
  ];

  void nextPage() {
    if (currentIndex < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      CacheHelper.saveData(key: 'onBoarding',value: true );
      navigateAndFinish(context, BottomNavBarUser());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 24,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      CacheHelper.saveData(key: 'onBoarding',value: true );
                      navigateAndFinish(context, BottomNavBarUser());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Text(
                        'تخطي',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1E1E1E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingPages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final data = onboardingPages[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Expanded(
                        flex: 6,
                        child: Image.asset(data.image),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        data.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E1E1E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 90),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingPages.length,
                          (index) => buildDot(index == currentIndex),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: nextPage,
                    backgroundColor: primaryColor,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24,),
          ],
        ),
      ),
    );
  }


  Widget buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: isActive ? 34 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? primaryColor : Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}
