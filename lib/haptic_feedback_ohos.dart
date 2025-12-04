library haptic_feedback_ohos;

import 'dart:async';
import 'package:flutter/services.dart';

/// HarmonyOS 震动反馈类型
enum HapticType {
  /// 轻触反馈
  light,

  /// 中等反馈
  medium,

  /// 重触反馈
  heavy,

  /// 选择改变反馈
  selection,
}

/// HarmonyOS 震动反馈插件
class HapticFeedbackOhos {
  static const MethodChannel _channel =
      MethodChannel('haptic_feedback_ohos');

  /// 轻触反馈
  static Future<void> lightImpact() async {
    await _channel.invokeMethod('lightImpact');
  }

  /// 中等反馈
  static Future<void> mediumImpact() async {
    await _channel.invokeMethod('mediumImpact');
  }

  /// 重触反馈
  static Future<void> heavyImpact() async {
    await _channel.invokeMethod('heavyImpact');
  }

  /// 选择改变反馈
  static Future<void> selectionClick() async {
    await _channel.invokeMethod('selectionClick');
  }

  /// 震动指定时长（毫秒）
  static Future<void> vibrate({int duration = 50}) async {
    await _channel.invokeMethod('vibrate', {'duration': duration});
  }
}

/// 插件注册类（用于 Dart 端插件注册）
class HapticFeedbackOhosPlugin {
  static void registerWith() {
    // 无需实现，原生端处理
  }
}
