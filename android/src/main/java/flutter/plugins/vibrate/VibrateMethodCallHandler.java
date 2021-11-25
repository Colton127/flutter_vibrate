package flutter.plugins.vibrate;

import android.os.Build;
import android.os.Vibrator;
import android.os.VibrationEffect;
import android.view.HapticFeedbackConstants;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class VibrateMethodCallHandler implements MethodChannel.MethodCallHandler {
    private final Vibrator vibrator;
    private final boolean hasVibrator;
    private final boolean legacyVibrator;
    long[] timings = { 12, 12, };
    int[] amplitudes = {0, 255,};
    boolean isVibrating = false;

    VibrateMethodCallHandler(Vibrator vibrator) {
        assert (vibrator != null);
        this.vibrator = vibrator;
        this.hasVibrator = vibrator.hasVibrator();
        this.legacyVibrator = Build.VERSION.SDK_INT < 26;
    }

    @SuppressWarnings("deprecation")
    private void vibrate(int duration, int amplitude) {
        if (hasVibrator) {
            if (legacyVibrator) {
                vibrator.vibrate(duration);
            } else {
           vibrator.vibrate(VibrationEffect.createOneShot(duration, amplitude));
            }
        }
    }

    @SuppressWarnings("deprecation")
    private void loopVibrate(int duration, int amplitude) {
        long[] loopTimings = { duration, duration, };
        long[] legacyLoopTimings = {0, duration, duration, };
        int[] loopAmplitudes = {0, amplitude,};
isVibrating = true;
if (hasVibrator) {
    if (legacyVibrator) {
        vibrator.vibrate(legacyLoopTimings, 0);
    } else {
        vibrator.vibrate(VibrationEffect.createWaveform(loopTimings, loopAmplitudes, 0));
    }


}
        
    
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case "canVibrate":
                result.success(hasVibrator);
                break;
            case "vibrate":
                final int duration = call.argument("duration");
                final int amplitude = call.argument("amplitude");
                vibrate(duration, amplitude);
                result.success(null);
                break;
                case "cancel":
                vibrator.cancel();
                result.success(null);
                break;
              case "loop":
              final int gduration = call.argument("duration");
              final int gamplitude = call.argument("amplitude");
              loopVibrate(gduration, gamplitude);
              result.success(null);
              break;
            default:
                result.notImplemented();
                break;
        }

    }
}
