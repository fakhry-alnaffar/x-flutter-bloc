import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:x_flutter_bloc/x_flutter_bloc.dart';
import 'package:x_flutter_core_models/x_flutter_core_models.dart';

import '../../../core/extensions/size_ext.dart';
import '../bloc/my_account_bloc.dart';
import '../bloc/my_account_event.dart';
import '../bloc/my_account_sr.dart';
import '../bloc/my_account_state.dart';
import 'widgets/change_password_sheet.dart';
import 'widgets/edit_profile_sheet.dart';
import 'widgets/info_card.dart';
import 'widgets/profile_action_tile.dart';
import 'widgets/profile_header.dart';

class MyAccountScreen
    extends BaseStatelessScreen<MyAccountState, MyAccountBloc, MyAccountSR> {
  const MyAccountScreen({super.key});

  @override
  MyAccountBloc createBloc(BuildContext context) =>
      GetIt.I<MyAccountBloc>()..add(const LoadProfile());

  @override
  void onSR(BuildContext context, MyAccountSR sr) {
    switch (sr) {
      case ProfileUpdated():
        if (Navigator.canPop(context)) Navigator.pop(context);
        _showSnackBar(context, Icons.check_circle_outline_rounded,
            'Profile updated successfully', const Color(0xFF10B981));
      case PasswordChanged():
        if (Navigator.canPop(context)) Navigator.pop(context);
        _showSnackBar(context, Icons.lock_outline_rounded,
            'Password changed successfully', const Color(0xFF10B981));
      case LoggedOut():
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }
  }

  @override
  void onFailure(BuildContext context, Failure failure) {
    _showSnackBar(
      context,
      Icons.error_outline_rounded,
      switch (failure) {
        ApiResponseFailure(:final message) when message.isNotEmpty => message,
        ConnectionFailure() => 'No internet connection',
        ApiUnauthorizedFailure() => 'Incorrect password',
        _ => 'Something went wrong. Please try again.',
      },
      const Color(0xFFEF4444),
    );
  }

  @override
  Widget buildScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          const _AppBar(),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverList.list(
              children: [
                20.verticalSpace,
                const InfoCard(),
                12.verticalSpace,
                ActionsCard(
                  onEditProfile: () => _openEditProfileSheet(context),
                  onChangePassword: () => _openChangePasswordSheet(context),
                ),
                12.verticalSpace,
                LogoutButton(onTap: () => _confirmLogout(context)),
                32.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  void _openEditProfileSheet(BuildContext context) {
    final bloc = blocOf(context);
    if (bloc.state is! MyAccountLoaded) return;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => BlocProvider.value(
        value: bloc,
        child: EditProfileSheet(profile: (bloc.state as MyAccountLoaded).profile),
      ),
    );
  }

  void _openChangePasswordSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => BlocProvider.value(
        value: blocOf(context),
        child: const ChangePasswordSheet(),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: 16.circular),
        title: Text('Sign Out',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: Navigator.of(dialogCtx).pop,
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              blocOf(context).add(const Logout());
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, IconData icon, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: 12.circular),
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20.r),
            12.horizontalSpace,
            Text(msg),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240.h,
      pinned: true,
      backgroundColor: const Color(0xFF6C63FF),
      flexibleSpace: FlexibleSpaceBar(
        background: const ProfileHeader(),
        title: BlocSelector<MyAccountBloc, MyAccountState, String>(
          selector: (state) => state is MyAccountLoaded ? state.profile.fullName : 'Account',
          builder: (context, name) => Text(name, style: TextStyle(fontSize: 16.sp)),
        ),
      ),
    );
  }
}
