import 'sensor_service.dart';

class TeachingModeController {
  bool teachingMode = false;
  final SensorService sensorService = SensorService();

  void enableTeachingMode(Function onMisuseDetected) {
    teachingMode = true;

    sensorService.startMonitoring((score) {
      if (score >= 10) {
        onMisuseDetected();
      }
    });
  }

  void disableTeachingMode() {
    teachingMode = false;
    sensorService.stopMonitoring();
  }
}
