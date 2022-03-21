class Assets {
  Assets._();

  static const kAppIcon = 'assets/images/logo.png';
  static const kImgNotAvailable = 'assets/images/img_not_available.jpeg';

  static String getMimi(String mimi) => 'assets/images/mimes/$mimi.gif';
}

final mimes = List.generate(9, (index) => 'mimi$index');
