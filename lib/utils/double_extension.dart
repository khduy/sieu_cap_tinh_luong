extension RoundToQuarter on double {
  double roundToQuarter() {
    return (this * 4).round() / 4;
  }
}
