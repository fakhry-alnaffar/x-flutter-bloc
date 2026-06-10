import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/size_ext.dart';
import '../../../domain/entity/user_profile.dart';
import '../../bloc/my_account_bloc.dart';
import '../../bloc/my_account_state.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MyAccountBloc, MyAccountState, UserProfile?>(
      selector: (state) => switch (state) {
        MyAccountLoaded(:final profile) => profile,
        _ => null,
      },
      builder: (context, profile) => _Card(
        title: 'Personal Information',
        child: profile != null
            ? _InfoContent(profile: profile)
            : const _InfoSkeleton(),
      ),
    );
  }
}

class _InfoContent extends StatelessWidget {
  const _InfoContent({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoRow(
          icon: Icons.person_outline_rounded,
          label: 'Full Name',
          value: profile.fullName,
          iconColor: const Color(0xFF6C63FF),
        ),
        _Divider(),
        _InfoRow(
          icon: Icons.email_outlined,
          label: 'Email',
          value: profile.email,
          iconColor: const Color(0xFF2196F3),
        ),
        _Divider(),
        _InfoRow(
          icon: Icons.phone_outlined,
          label: 'Phone',
          value: profile.phone ?? '—',
          iconColor: const Color(0xFF4CAF50),
        ),
        _Divider(),
        _InfoRow(
          icon: Icons.info_outline_rounded,
          label: 'Bio',
          value: profile.bio ?? '—',
          iconColor: const Color(0xFFFF9800),
          multiLine: true,
        ),
        _Divider(),
        _InfoRow(
          icon: Icons.calendar_today_outlined,
          label: 'Member Since',
          value: _formatDate(profile.memberSince),
          iconColor: const Color(0xFF9C27B0),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    this.multiLine = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final bool multiLine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment:
            multiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: 10.circular,
            ),
            child: Icon(icon, size: 19.r, color: iconColor),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                3.verticalSpace,
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSkeleton extends StatelessWidget {
  const _InfoSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (i) => Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: 10.circular,
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: 4.circular,
                      ),
                    ),
                    5.verticalSpace,
                    Container(
                      height: 14.h,
                      width: 140.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: 4.circular,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: 16.circular,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.06),
            blurRadius: 20.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF6B7280),
                letterSpacing: 0.5,
              ),
            ),
            8.verticalSpace,
            child,
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color(0xFFF3F4F6),
    );
  }
}
