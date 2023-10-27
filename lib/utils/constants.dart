import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Constants{
  static String mainUrl = "https://api.themoviedb.org/3/";
  static String imgUrl = "https://image.tmdb.org/t/p/";
  static String token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZTM4YjJlNzNjYjIzZDM1YTA4OTNiZTQyZjcxODNjMCIsInN1YiI6IjY1MzRkZDE3NDJkODM3MDEwYmE4ZmVmZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.zoLVKtJ3djjwdVeFOkiL-ukJPaoczkkSZu-AVc-c4iU";
  String dbPath = 'persons.db';
 static bool deviceConnected = true;
  Future checkConnection() async {
    if (kDebugMode) {
      // Simple check to see if we have internet
      print("The statement 'this machine is connected to the Internet' is: ");
      print(await InternetConnectionChecker().hasConnection);
      // returns a bool

      // We can also get an enum value instead of a bool
      print(
          "Current status: ${await InternetConnectionChecker().connectionStatus}");
      // prints either InternetConnectionStatus.connected
      // or InternetConnectionStatus.disconnected
    }

    // actively listen for status updates
    // this will cause InternetConnectionChecker to check periodically
    // with the interval specified in InternetConnectionChecker().checkInterval
    // until listener.cancel() is called
    InternetConnectionChecker().onStatusChange.listen((status) async {
      switch (status) {
        case InternetConnectionStatus.connected:
          deviceConnected = await InternetConnectionChecker().hasConnection;
          if (kDebugMode) {
            print('Data connection is available.');
          }
          break;
        case InternetConnectionStatus.disconnected:
          deviceConnected = await InternetConnectionChecker().hasConnection;
          if (kDebugMode) {
            print('You are disconnected from the internet.');
          }
          break;
      }
    });

    // close listener after 30 seconds, so the program doesn't run forever
    // await Future.delayed(const Duration(seconds: 30));
    //await listener.cancel();
  }

}