import 'package:flutter/foundation.dart';

class PerformanceMonitor {
  static final Map<String, Stopwatch> _timers = {};
  static final List<PerformanceMetric> _metrics = [];

  static void startTimer(String name) {
    if (!kDebugMode) return;
    
    _timers[name] = Stopwatch()..start();
  }

  static void stopTimer(String name, {String? description}) {
    if (!kDebugMode) return;
    
    final timer = _timers[name];
    if (timer != null) {
      timer.stop();
      final metric = PerformanceMetric(
        name: name,
        duration: timer.elapsedMilliseconds,
        description: description,
        timestamp: DateTime.now(),
      );
      _metrics.add(metric);
      
      // Log slow operations
      if (timer.elapsedMilliseconds > 100) {
        debugPrint('⚠️ Slow operation: $name took ${timer.elapsedMilliseconds}ms');
      }
      
      _timers.remove(name);
    }
  }

  static void logMetric(String name, int value, {String? unit}) {
    if (!kDebugMode) return;
    
    final metric = PerformanceMetric(
      name: name,
      duration: value,
      description: unit,
      timestamp: DateTime.now(),
    );
    _metrics.add(metric);
  }

  static List<PerformanceMetric> getMetrics() {
    return List.unmodifiable(_metrics);
  }

  static void clearMetrics() {
    _metrics.clear();
  }

  static void printSummary() {
    if (!kDebugMode) return;
    
    debugPrint('📊 Performance Summary:');
    final groupedMetrics = <String, List<PerformanceMetric>>{};
    
    for (final metric in _metrics) {
      groupedMetrics.putIfAbsent(metric.name, () => []).add(metric);
    }
    
    for (final entry in groupedMetrics.entries) {
      final metrics = entry.value;
      final avgDuration = metrics.map((m) => m.duration).reduce((a, b) => a + b) / metrics.length;
      final maxDuration = metrics.map((m) => m.duration).reduce((a, b) => a > b ? a : b);
      
      debugPrint('  ${entry.key}: avg ${avgDuration.toStringAsFixed(1)}ms, max ${maxDuration}ms (${metrics.length} calls)');
    }
  }
}

class PerformanceMetric {
  final String name;
  final int duration;
  final String? description;
  final DateTime timestamp;

  const PerformanceMetric({
    required this.name,
    required this.duration,
    this.description,
    required this.timestamp,
  });
}

// Extension for easy performance monitoring
extension PerformanceExtension<T> on Future<T> Function() {
  Future<T> withPerformanceMonitoring(String name, {String? description}) async {
    PerformanceMonitor.startTimer(name);
    try {
      final result = await this();
      return result;
    } finally {
      PerformanceMonitor.stopTimer(name, description: description);
    }
  }
}