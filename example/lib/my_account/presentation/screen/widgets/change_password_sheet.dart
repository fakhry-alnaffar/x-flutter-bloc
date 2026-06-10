import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/entity/change_password_params.dart';
import '../../bloc/my_account_bloc.dart';
import '../../bloc/my_account_event.dart';
import 'sheet_components.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<MyAccountBloc>().add(
          ChangePassword(
            ChangePasswordParams(
              currentPassword: _currentCtrl.text,
              newPassword: _newCtrl.text,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SheetHandle(),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SheetTitle(title: 'Change Password'),
                  6.verticalSpace,
                  Text(
                    'Demo: current password is  Pass@1234',
                    style: TextStyle(
                        fontSize: 11.sp, color: const Color(0xFF9CA3AF)),
                  ),
                  20.verticalSpace,
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _PasswordField(
                          controller: _currentCtrl,
                          label: 'Current Password',
                          show: _showCurrent,
                          onToggle: () =>
                              setState(() => _showCurrent = !_showCurrent),
                          validator: (v) =>
                              (v?.isEmpty ?? true) ? 'Required' : null,
                        ),
                        14.verticalSpace,
                        _PasswordField(
                          controller: _newCtrl,
                          label: 'New Password',
                          show: _showNew,
                          onToggle: () =>
                              setState(() => _showNew = !_showNew),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (v.length < 8) return 'At least 8 characters';
                            return null;
                          },
                        ),
                        14.verticalSpace,
                        _PasswordField(
                          controller: _confirmCtrl,
                          label: 'Confirm New Password',
                          show: _showConfirm,
                          onToggle: () =>
                              setState(() => _showConfirm = !_showConfirm),
                          validator: (v) => v != _newCtrl.text
                              ? 'Passwords do not match'
                              : null,
                        ),
                        20.verticalSpace,
                        SheetSubmitButton(
                          onPressed: _submit,
                          label: 'Update Password',
                        ),
                      ],
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
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.label,
    required this.show,
    required this.onToggle,
    required this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool show;
  final VoidCallback onToggle;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return SheetField(
      controller: controller,
      label: label,
      obscureText: !show,
      validator: validator,
      suffixIcon: IconButton(
        onPressed: onToggle,
        icon: Icon(
          show ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 20.r,
          color: const Color(0xFF9CA3AF),
        ),
      ),
    );
  }
}
