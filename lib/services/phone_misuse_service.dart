import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
//import 'package:screen_state/screen_state.dart';

class PhoneMisuseService {
  /// SENSOR STREAMS
  StreamSubscription? _accelSub;
  StreamSubscription? _gyroSub;
  StreamSubscription? _screenSub;

  /// MISUSE SCORE
  int misuseScore = 0;

  /// START MONITORING
  void start() {
    _monitorAccelerometer();
    _monitorGyroscope();
    _monitorScreen();
  }

  /// STOP MONITORING
  void stop() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    _screenSub?.cancel();
  }

  // 📳 ACCELEROMETER LOGIC (Shaking / movement)
  void _monitorAccelerometer() {
    _accelSub = accelerometerEvents.listen((event) {
      double magnitude = sqrt(
        event.x * event.x +
        event.y * event.y +
        event.z * event.z,
      );

      // Threshold (phone moving a lot)
      if (magnitude > 18) {
        misuseScore += 2;
        _log("Accelerometer misuse detected");
      }
    });
  }

  // 🔄 GYROSCOPE LOGIC (Rotation / flipping phone)
  void _monitorGyroscope() {
    _gyroSub = gyroscopeEvents.listen((event) {
      double rotation =
          event.x.abs() + event.y.abs() + event.z.abs();

      if (rotation > 6) {
        misuseScore += 1;
        _log("Gyroscope misuse detected");
      }
    });
  }

  // 📴 SCREEN STATE LOGIC
  void _monitorScreen() {
    Screen screen = Screen();
    ScreenStateEvent? lastEvent;
    DateTime? screenOnTime;

    _screenSub = screen.screenStateStream!.listen((event) {
      if (event == ScreenStateEvent.SCREEN_ON) {
        screenOnTime = DateTime.now();
      }

      if (event == ScreenStateEvent.SCREEN_OFF &&
          screenOnTime != null) {
        final duration =
            DateTime.now().difference(screenOnTime!);

        if (duration.inSeconds > 30) {
          misuseScore += 3;
          _log("Screen misuse detected (${duration.inSeconds}s)");
        }
      }

      lastEvent = event;
    });
  }

  void _log(String msg) {
    print("📵 MISUSE: $msg | Score: $misuseScore");
  }
}
