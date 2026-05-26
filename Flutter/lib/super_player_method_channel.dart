import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'super_player_platform_interface.dart';

/// An implementation of [SuperPlayerPlatform] that uses method channels.
class MethodChannelSuperPlayer extends SuperPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('super_player');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
