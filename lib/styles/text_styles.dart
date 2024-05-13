import 'package:flutter/material.dart';
import './sizes.dart';

// const fontfamily = "SVN-Gotham";

class BaseTextStyle extends TextStyle {
  const BaseTextStyle(
      {super.fontSize, super.color = const Color(0xff000000), super.fontWeight})
      : super();
}

class NormalTextStyle extends BaseTextStyle {
  const NormalTextStyle({
    double fontSize = Sizes.textNormal,
    super.color,
  }) : super(fontWeight: FontWeight.normal, fontSize: fontSize);
}

class BoldTextStyle extends BaseTextStyle {
  const BoldTextStyle({super.fontSize, super.color})
      : super(fontWeight: FontWeight.w700);
}

class MediumTextStyle extends BaseTextStyle {
  const MediumTextStyle({super.fontSize = Sizes.textNormal, super.color})
      : super(fontWeight: FontWeight.w600);
}

class TinyNormalTextStyle extends NormalTextStyle {
  const TinyNormalTextStyle({super.color}) : super(fontSize: Sizes.textTiny);
}

class SmallestNormalTextStyle extends NormalTextStyle {
  const SmallestNormalTextStyle({super.color})
      : super(fontSize: Sizes.textSmallest);
}

class SmallerNormalTextStyle extends NormalTextStyle {
  const SmallerNormalTextStyle({super.color})
      : super(fontSize: Sizes.textSmaller);
}

class SmallNormalTextStyle extends NormalTextStyle {
  const SmallNormalTextStyle({super.color}) : super(fontSize: Sizes.textSmall);
}

class TinyMediumTextStyle extends MediumTextStyle {
  const TinyMediumTextStyle({super.color}) : super(fontSize: Sizes.textTiny);
}

class SmallestMediumTextStyle extends MediumTextStyle {
  const SmallestMediumTextStyle({super.color})
      : super(fontSize: Sizes.textSmallest);
}

class SmallerMediumTextStyle extends MediumTextStyle {
  const SmallerMediumTextStyle({super.color})
      : super(fontSize: Sizes.textSmaller);
}

class SmallMediumTextStyle extends MediumTextStyle {
  const SmallMediumTextStyle({super.color}) : super(fontSize: Sizes.textSmall);
}

class TitleSmallNormalTextStyle extends NormalTextStyle {
  const TitleSmallNormalTextStyle({super.color})
      : super(fontSize: Sizes.textTitleSmall);
}

class TitleNormalTextStyle extends NormalTextStyle {
  const TitleNormalTextStyle({super.color}) : super(fontSize: Sizes.textTitle);
}

class TitleLargeNormalTextStyle extends NormalTextStyle {
  const TitleLargeNormalTextStyle({super.color})
      : super(fontSize: Sizes.textTitleLarge);
}

class TitleSmallBoldTextStyle extends BoldTextStyle {
  const TitleSmallBoldTextStyle({super.color})
      : super(fontSize: Sizes.textTitleSmall);
}

class TitleSmallMediumTextStyle extends MediumTextStyle {
  const TitleSmallMediumTextStyle({super.color})
      : super(fontSize: Sizes.textTitleSmall);
}

class TitleBoldTextStyle extends BoldTextStyle {
  const TitleBoldTextStyle({super.color}) : super(fontSize: Sizes.textTitle);
}

class TitleLargeBoldTextStyle extends BoldTextStyle {
  const TitleLargeBoldTextStyle({super.color})
      : super(fontSize: Sizes.textTitleLarge);
}

class SmallBoldTextStyle extends BoldTextStyle {
  const SmallBoldTextStyle({super.color}) : super(fontSize: Sizes.textSmall);
}

class NormalBoldTextStyle extends BoldTextStyle {
  const NormalBoldTextStyle({double fontSize = Sizes.textNormal, super.color})
      : super(fontSize: fontSize);
}
