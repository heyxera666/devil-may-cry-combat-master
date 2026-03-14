import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'risk_service.dart';

class RiskNotificationsScreen extends StatefulWidget {
  final List<RiskAlert> alerts;

  const RiskNotificationsScreen({super.key, required this.alerts});

  @override
  State<RiskNotificationsScreen> createState() => _RiskNotificationsScreenState();
}

class _RiskNotificationsScreenState extends State<RiskNotificationsScreen> {
  bool _highVolatility = true;
  bool _sharpRateChange = true;
  bool _criticalThreshold = false;
  bool _dailySummary = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления о рисках'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B00), Color(0xFFFF8C00)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.white, size: 40),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Мониторинг рисков',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        'Уведомления при опасных изменениях курсов',
                        style: TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Настройки уведомлений', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildToggleTile(
            Icons.show_chart,
            'Высокая волатильность',
            'Уведомлять при колебаниях более 1.5%',
            _highVolatility,
            (val) => setState(() => _highVolatility = val),
          ),
          _buildToggleTile(
            Icons.trending_up,
            'Резкое изменение курса',
            'Уведомлять при изменении более 2% за час',
            _sharpRateChange,
            (val) => setState(() => _sharpRateChange = val),
          ),
          _buildToggleTile(
            Icons.crisis_alert,
            'Критический порог',
            'Уведомлять при достижении критических значений',
            _criticalThreshold,
            (val) => setState(() => _criticalThreshold = val),
          ),
          _buildToggleTile(
            Icons.summarize,
            'Ежедневная сводка',
            'Получать итоги торгов каждый день',
            _dailySummary,
            (val) => setState(() => _dailySummary = val),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text('Уведомления', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              if (widget.alerts.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.alerts.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (widget.alerts.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
                  SizedBox(height: 12),
                  Text(
                    'Всё в порядке',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Курсы Aiu Bank в норме относительно рынка',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...widget.alerts.map((alert) => _buildAlertCard(alert)),
        ],
      ),
    );
  }

  Widget _buildToggleTile(IconData icon, String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeThumbColor: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildAlertCard(RiskAlert alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: alert.isWarning ? Colors.orange.withValues(alpha: 0.4) : Colors.grey.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            alert.isWarning ? Icons.warning_amber_rounded : Icons.info_outline,
            color: alert.isWarning ? Colors.orange : Colors.grey,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(alert.description, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              ],
            ),
          ),
          Text(
            DateFormat('HH:mm').format(alert.time),
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
