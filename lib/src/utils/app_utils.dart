import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version} (${packageInfo.buildNumber})';
  }

  static Future<void> openExternalLink(String url, {LaunchMode? mode}) async {
    try {
      LaunchMode? modeLaunch;

      if (mode != null) {
        modeLaunch = mode;
      } else {
        modeLaunch =
            Platform.isIOS
                ? LaunchMode.inAppWebView
                : LaunchMode.externalNonBrowserApplication;
      }
      await launchUrl(Uri.parse(url), mode: modeLaunch);
    } catch (e) {
      return;
    }
  }

  static openEmail() async => launchUrl(
    Uri(
      scheme: 'mailto',
      path: 'contatorua404@gmail.com',
      query: _encodeQueryParameters(<String, String>{
        'subject': 'Eai Rua404! Topa participar de um evento?',
      }),
    ),
  );

  static String? _encodeQueryParameters(Map<String, String> params) => params
      .entries
      .map(
        (MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}}',
      )
      .join('&');
}
