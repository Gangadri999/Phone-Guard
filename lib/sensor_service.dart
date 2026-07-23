import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  StreamSubscription? _accelSub;
  StreamSubscription? _gyroSub;

  double movementScore = 0;

  void startMonitoring(Function(double score) onUpdate) {
    _accelSub = accelerometerEvents.listen((event) {
      double magnitude =
          event.x.abs() + event.y.abs() + event.z.abs();

      if (magnitude > 20) {
        movementScore += 1;
      }

      onUpdate(movementScore);
    });

    _gyroSub = gyroscopeEvents.listen((event) {
      double rotation =
          event.x.abs() + event.y.abs() + event.z.abs();

      if (rotation > 5) {
        movementScore += 0.5;
      }

      onUpdate(movementScore);
    });
  }

  void stopMonitoring() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    movementScore = 0;
  }
}
