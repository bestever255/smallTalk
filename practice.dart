main() {
  String karem = 'my age is 21';
  karem = karem.replaceAll(RegExp(r'\d+'), // r = raw , \d => search for any digit above 1
      'twenty one');  // Replace any digit with this
  print(karem);
}
