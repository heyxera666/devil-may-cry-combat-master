import 'package:flutter/material.dart';

class RateManagementScreen extends StatefulWidget {
  final List<Map<String, String>> currentRates;

  const RateManagementScreen({super.key, required this.currentRates});

  @override
  State<RateManagementScreen> createState() => _RateManagementScreenState();
}

class _RateManagementScreenState extends State<RateManagementScreen> {
  late List<Map<String, TextEditingController>> controllers;

  @override
  void initState() {
    super.initState();
    controllers = widget.currentRates.map((rate) {
      return {
        'flag': TextEditingController(text: rate['flag']),
        'buy': TextEditingController(text: rate['buy']),
        'sell': TextEditingController(text: rate['sell']),
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Управление курсами'),
        actions: [
          TextButton(
            onPressed: () {
              final updatedRates = controllers.map((controller) {
                return {
                  'flag': controller['flag']!.text,
                  'buy': controller['buy']!.text,
                  'sell': controller['sell']!.text,
                };
              }).toList();
              Navigator.pop(context, updatedRates);
            },
            child: const Text('Сохранить', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controllers.length,
        itemBuilder: (context, index) {
          final controller = controllers[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      controller['flag']!.text,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _getCurrencyName(controller['flag']!.text),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller['buy'],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Покупка',
                          suffixText: '₸',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: controller['sell'],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Продажа',
                          suffixText: '₸',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getCurrencyName(String flag) {
    const names = {
      '🇺🇸': 'USD',
      '🇪🇺': 'EUR',
      '🇷🇺': 'RUB',
    };
    return names[flag] ?? '';
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller['flag']?.dispose();
      controller['buy']?.dispose();
      controller['sell']?.dispose();
    }
    super.dispose();
  }
}
