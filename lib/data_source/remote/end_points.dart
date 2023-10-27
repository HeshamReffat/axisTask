class EndPoints {
  static String peopleList = 'person/popular';

  static String personImages(String id) => 'person/$id/images';
  static String personDetails(String id) => 'person/$id';
}