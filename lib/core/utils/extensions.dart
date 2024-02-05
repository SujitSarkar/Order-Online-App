extension ExtendedString on String?{
  bool get isLinkValidate {
    return this !=null && this!.length>=5;
  }
}