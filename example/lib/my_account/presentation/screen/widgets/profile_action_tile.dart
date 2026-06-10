import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/size_ext.dart';

class ActionsCard extends StatelessWidget {
  const ActionsCard({
    super.key,
    required this.onEditProfile,
    required this.onChangePassword,
  });

  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;

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
      child: Column(
        children: [
          ProfileActionTile(
            icon: Icons.edit_outlined,
            iconColor: const Color(0xFF6C63FF),
            label: 'Edit Profile',
            onTap: onEditProfile,
            isFirst: true,
          ),
          Divider(height: 1, thickness: 1, color: const Color(0xFFF3F4F6),
              indent: 56.w),
          ProfileActionTile(
            icon: Icons.lock_outline_rounded,
            iconColor: const Color(0xFF4CAF50),
            label: 'Change Password',
            onTap: onChangePassword,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class ProfileActionTile extends StatelessWidget {
  const ProfileActionTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
    this.labelColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? Radius.circular(16.r) : Radius.zero,
          bottom: isLast ? Radius.circular(16.r) : Radius.zero,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
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
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: labelColor ?? const Color(0xFF1A1A2E),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.r,
                color: const Color(0xFFD1D5DB),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(Icons.logout_rounded, size: 20.r),
        label: Text(
          'Sign Out',
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFEF4444),
          side: const BorderSide(color: Color(0xFFEF4444)),
          shape: RoundedRectangleBorder(borderRadius: 14.circular),
        ),
      ),
    );
  }
}
