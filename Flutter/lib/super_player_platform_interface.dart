import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'super_player_method_channel.dart';

abstract class SuperPlayerPlatform extends PlatformInterface {
  /// Constructs a SuperPlayerPlatform.
  SuperPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static SuperPlayerPlatform _instance = MethodChannelSuperPlayer();

  /// The default instance of [SuperPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelSuperPlayer].
  static SuperPlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SuperPlayerPlatform] when
  /// they register themselves.
  static set instance(SuperPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
