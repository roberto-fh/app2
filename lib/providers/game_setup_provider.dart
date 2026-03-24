import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_setup_provider.g.dart';

@Riverpod(keepAlive: true)
class GameSetup extends _$GameSetup {
  static const int defaultDuration = 30;
  static const int minDuration = 15;
  static const int maxDuration = 120;

  @override
  int build() => defaultDuration;

  void setDuration(int seconds) {
    state = seconds.clamp(minDuration, maxDuration);
  }
}
