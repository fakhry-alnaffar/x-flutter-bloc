import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// flutter_screenutil already provides num.verticalSpace and num.horizontalSpace
// via SizeExtension. This file adds EdgeInsets and BorderRadius helpers only.

extension EdgeInsetsX on num {
  EdgeInsets get padAll => EdgeInsets.all(toDouble().r);
  EdgeInsets get padH => EdgeInsets.symmetric(horizontal: toDouble().w);
  EdgeInsets get padV => EdgeInsets.symmetric(vertical: toDouble().h);
  EdgeInsets get padLeft => EdgeInsets.only(left: toDouble().w);
  EdgeInsets get padRight => EdgeInsets.only(right: toDouble().w);
  EdgeInsets get padTop => EdgeInsets.only(top: toDouble().h);
  EdgeInsets get padBottom => EdgeInsets.only(bottom: toDouble().h);
}

extension BorderRadiusX on num {
  BorderRadius get circular => BorderRadius.circular(toDouble().r);
}
