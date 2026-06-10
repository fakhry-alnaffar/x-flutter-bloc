import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/entity/update_profile_params.dart';
import '../../../domain/entity/user_profile.dart';
import '../../bloc/my_account_bloc.dart';
import '../../bloc/my_account_event.dart';
import 'sheet_components.dart';

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _bioCtrl;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.profile.firstName);
    _lastNameCtrl = TextEditingController(text: widget.profile.lastName);
    _phoneCtrl = TextEditingController(text: widget.profile.phone ?? '');
    _bioCtrl = TextEditingController(text: widget.profile.bio ?? '');
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<MyAccountBloc>().add(
          UpdateProfile(
            UpdateProfileParams(
              firstName: _firstNameCtrl.text.trim(),
              lastName: _lastNameCtrl.text.trim(),
              phone: _phoneCtrl.text.trim().isEmpty
                  ? null
                  : _phoneCtrl.text.trim(),
              bio: _bioCtrl.text.trim().isEmpty ? null : _bioCtrl.text.trim(),
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
                  const SheetTitle(title: 'Edit Profile'),
                  20.verticalSpace,
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SheetField(
                                controller: _firstNameCtrl,
                                label: 'First Name',
                                validator: (v) => (v?.trim().isEmpty ?? true)
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: SheetField(
                                controller: _lastNameCtrl,
                                label: 'Last Name',
                                validator: (v) => (v?.trim().isEmpty ?? true)
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        14.verticalSpace,
                        SheetField(
                          controller: _phoneCtrl,
                          label: 'Phone (optional)',
                          keyboardType: TextInputType.phone,
                        ),
                        14.verticalSpace,
                        SheetField(
                          controller: _bioCtrl,
                          label: 'Bio (optional)',
                          maxLines: 3,
                        ),
                        20.verticalSpace,
                        SheetSubmitButton(
                          onPressed: _submit,
                          label: 'Save Changes',
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
