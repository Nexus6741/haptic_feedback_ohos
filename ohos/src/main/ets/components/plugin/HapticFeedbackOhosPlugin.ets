import { FlutterPlugin, FlutterPluginBinding, MethodCall, MethodCallHandler, MethodChannel, MethodResult } from '@ohos/flutter_ohos';
import { vibrator } from '@kit.SensorServiceKit';

const TAG = 'HapticFeedbackOhosPlugin';
const CHANNEL_NAME = 'haptic_feedback_ohos';

class HapticFeedbackOhosPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;

  getUniqueClassName(): string {
    return TAG;
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), CHANNEL_NAME);
    this.channel.setMethodCallHandler(this);
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel !== null) {
      this.channel.setMethodCallHandler(null);
      this.channel = null;
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case 'lightImpact':
        this.doHaptic('light', result);
        break;
      case 'mediumImpact':
        this.doHaptic('medium', result);
        break;
      case 'heavyImpact':
        this.doHaptic('sharp', result);
        break;
      case 'selectionClick':
        this.doHaptic('light', result);
        break;
      case 'vibrate':
        const duration = call.argument('duration') as number ?? 50;
        this.doVibrate(duration, result);
        break;
      default:
        result.notImplemented();
    }
  }

  private doHaptic(effect: string, result: MethodResult): void {
    try {
      vibrator.startVibration({
        type: 'preset',
        effectId: effect,
        count: 1
      }, {
        usage: 'touch'
      }).then(() => {
        result.success(null);
      }).catch((err: Error) => {
        // 如果 preset 不支持，尝试使用 time 模式
        this.doVibrateByTime(effect, result);
      });
    } catch (e) {
      // 降级到 time 模式
      this.doVibrateByTime(effect, result);
    }
  }

  private doVibrateByTime(effect: string, result: MethodResult): void {
    let duration = 30;
    if (effect === 'medium') {
      duration = 50;
    } else if (effect === 'sharp' || effect === 'heavy') {
      duration = 80;
    }
    
    try {
      vibrator.startVibration({
        type: 'time',
        duration: duration
      }, {
        usage: 'touch'
      }).then(() => {
        result.success(null);
      }).catch((err: Error) => {
        console.error(TAG, `Vibration failed: ${err.message}`);
        result.success(null); // 静默失败，不影响用户体验
      });
    } catch (e) {
      console.error(TAG, `Vibration error: ${e}`);
      result.success(null);
    }
  }

  private doVibrate(duration: number, result: MethodResult): void {
    try {
      vibrator.startVibration({
        type: 'time',
        duration: duration
      }, {
        usage: 'touch'
      }).then(() => {
        result.success(null);
      }).catch((err: Error) => {
        console.error(TAG, `Vibration failed: ${err.message}`);
        result.success(null);
      });
    } catch (e) {
      console.error(TAG, `Vibration error: ${e}`);
      result.success(null);
    }
  }
}

export default HapticFeedbackOhosPlugin;
