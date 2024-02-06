extension ExtendedString on String?{
  bool get isLinkValidate {
    return this !=null && this!.length>=5;
  }
}

extension ExtendedBool on bool?{
  bool get isEnabled {
    return this != null && this == true;
  }
}