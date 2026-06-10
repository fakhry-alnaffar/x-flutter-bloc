import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/size_ext.dart';
import '../../../domain/entity/user_profile.dart';
import '../../bloc/my_account_bloc.dart';
import '../../bloc/my_account_state.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MyAccountBloc, MyAccountState, UserProfile?>(
      selector: (state) => switch (state) {
        MyAccountLoaded(:final profile) => profile,
        _ => null,
      },
      builder: (context, profile) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C63FF), Color(0xFF9C27B0)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.only(
              top: 20.h,
              bottom: 32.h,
              left: 20.w,
              right: 20.w,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _Avatar(
                  initials: profile?.initials ?? '',
                  avatarUrl: profile?.avatarUrl,
                ),
                16.verticalSpace,
                if (profile != null) ...[
                  Text(
                    profile.fullName,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    profile.email,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ] else
                  _HeaderSkeleton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, this.avatarUrl});

  final String initials;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88.r,
      height: 88.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ClipOval(
        child: avatarUrl != null
            ? Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _InitialsAvatar(initials),
              )
            : _InitialsAvatar(initials),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar(this.initials);

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF5A52E0),
      alignment: Alignment.center,
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 20.h,
          width: 160.w,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: 8.circular,
          ),
        ),
        6.verticalSpace,
        Container(
          height: 14.h,
          width: 120.w,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: 6.circular,
          ),
        ),
      ],
    );
  }
}
