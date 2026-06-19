import 'package:delivery_app/features/admin/view/all_person.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ navigation/navigation.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class Person extends StatelessWidget {
  const Person({super.key});

  Widget _buildDashboardCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Color> gradientColors,
    required int? count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: count != null
                    ? Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AdminCubit()..getUsersCounts(context: context),
      child: BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AdminCubit.get(context);
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFF2F2F7),
              body: Column(
                children: [
                  CustomAppbar(),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 1.0,
                        children: [
                          _buildDashboardCard(
                            context: context,
                            title: 'الآدمن',
                            icon: Icons.admin_panel_settings_outlined,
                            count: cubit.adminsCount,
                            gradientColors: [
                              const Color(0xFF1A2A6C),
                              const Color(0xFF2753A7),
                            ],
                            onTap: () {
                              navigateTo(context, const AllPerson(role: 'Admin'));
                            },
                          ),
                          _buildDashboardCard(
                            context: context,
                            title: 'المستخدمون',
                            icon: Icons.people_alt_outlined,
                            count: cubit.usersCount,
                            gradientColors: [
                              const Color(0xFF0083B0),
                              const Color(0xFF00B4DB),
                            ],
                            onTap: () {
                              navigateTo(context, const AllPerson(role: 'Only'));
                            },
                          ),
                          _buildDashboardCard(
                            context: context,
                            title: 'الدليفري',
                            icon: Icons.motorcycle_outlined,
                            count: cubit.deliveryCount,
                            gradientColors: [
                              const Color(0xFFD38312),
                              const Color(0xFFA83279),
                            ],
                            onTap: () {
                              navigateTo(context, const AllPerson(role: 'Delivery'));
                            },
                          ),
                          _buildDashboardCard(
                            context: context,
                            title: 'التجار',
                            icon: Icons.storefront_outlined,
                            count: cubit.vendorsCount,
                            gradientColors: [
                              const Color(0xFF11998E),
                              const Color(0xFF38EF7D),
                            ],
                            onTap: () {
                              navigateTo(context, const AllPerson(role: 'vendor'));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
