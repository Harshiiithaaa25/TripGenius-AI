
import 'package:flutter/material.dart';

void main() => runApp(const TripApp());

const purple = Color(0xFF6757F5);
const bg = Color(0xFFF5F6FF);

class TripApp extends StatelessWidget {
  const TripApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: bg,
          colorScheme: ColorScheme.fromSeed(seedColor: purple),
        ),
        home: const TripHome(),
      );
}

class TripHome extends StatefulWidget {
  const TripHome({super.key});

  @override
  State<TripHome> createState() => _TripHomeState();
}

class _TripHomeState extends State<TripHome> {
  final destination = TextEditingController();
  final days = TextEditingController(text: '3');
  final budget = TextEditingController(text: '5000');

  String interest = 'Nature';
  String style = 'Budget-friendly';
  List<Map<String, String>> plan = [];
  String place = '';

  final activities = {
    'Nature': [
      ['Explore scenic spots', 'Visit a beautiful garden',
        'Enjoy the sunset'],
      ['Discover a nearby lake', 'Explore nature trails',
        'Take memorable photos'],
      ['Visit a waterfall', 'Enjoy a picnic',
        'Relax in nature'],
    ],
    'History': [
      ['Visit a historic monument', 'Explore a museum',
        'Walk through heritage streets'],
      ['Discover an ancient temple', 'Learn local history',
        'Visit a historic market'],
      ['Explore a heritage site', 'Admire old architecture',
        'Enjoy a cultural evening'],
    ],
    'Food': [
      ['Try a local breakfast', 'Explore street food',
        'Taste regional dishes'],
      ['Visit a food market', 'Try local specialities',
        'Discover a dessert shop'],
      ['Enjoy a popular restaurant', 'Taste local snacks',
        'Go on an evening food walk'],
    ],
    'Adventure': [
      ['Explore an outdoor trail', 'Try an adventure activity',
        'Relax with scenic views'],
      ['Go trekking', 'Discover outdoor activities',
        'Watch the sunset'],
      ['Explore a scenic route', 'Try a new experience',
        'Enjoy an evening walk'],
    ],
  };

  void generate() {
    final d = int.tryParse(days.text);
    final b = int.tryParse(budget.text);

    if (destination.text.trim().isEmpty ||
        d == null || d < 1 || d > 7 ||
        b == null || b <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a destination, 1–7 days and a valid budget.'),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      place = destination.text.trim();
      plan = List.generate(d, (i) {
        final a = activities[interest]![i % 3];
        return {
          'day': 'Day ${i + 1}',
          'morning': a[0],
          'afternoon': a[1],
          'evening': a[2],
        };
      });
    });
  }

  void reset() {
    setState(() {
      destination.clear();
      days.text = '3';
      budget.text = '5000';
      interest = 'Nature';
      style = 'Budget-friendly';
      plan = [];
      place = '';
    });
  }

  @override
  void dispose() {
    destination.dispose();
    days.dispose();
    budget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg,
        title: const Row(children: [
          Icon(Icons.flight_takeoff, color: purple, size: 30),
          SizedBox(width: 9),
          Text('TripGenius ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text('AI', style: TextStyle(
              color: purple, fontWeight: FontWeight.bold)),
        ]),
        actions: [
          IconButton(onPressed: reset, icon: const Icon(Icons.refresh),
              tooltip: 'Plan a new trip'),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5865F2), Color(0xFF9B65EF)],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.explore, color: Colors.white, size: 36),
                    SizedBox(height: 12),
                    Text('Your next adventure\nstarts here!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 10),
                    Text(
                      'Discover places. Plan smarter. Travel happier.',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Plan Your Trip',
                  style: TextStyle(fontSize: 23,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text('Customize your next getaway',
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 18),

              field('Destination', destination, Icons.location_on,
                  'e.g. Goa, Ooty, Hyderabad'),
              const SizedBox(height: 13),
              Row(children: [
                Expanded(child: field('Days (1–7)', days,
                    Icons.calendar_month, '3', number: true)),
                const SizedBox(width: 12),
                Expanded(child: field('Budget (₹)', budget,
                    Icons.currency_rupee, '5000', number: true)),
              ]),
              const SizedBox(height: 15),

              const Text('Your interests',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: interest,
                isExpanded: true,
                decoration: inputDecoration(Icons.favorite),
                items: ['Nature', 'History', 'Food', 'Adventure']
                    .map((v) => DropdownMenuItem(
                        value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => interest = v!),
              ),
              const SizedBox(height: 15),

              const Text('Travel style',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: style,
                isExpanded: true,
                decoration: inputDecoration(Icons.luggage),
                items: ['Budget-friendly', 'Comfort', 'Luxury']
                    .map((v) => DropdownMenuItem(
                        value: v, child: Text(v))).toList(),
                onChanged: (v) => setState(() => style = v!),
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 54,
                child: FilledButton.icon(
                  onPressed: generate,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Generate My Itinerary',
                      style: TextStyle(fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  style: FilledButton.styleFrom(
                    backgroundColor: purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
              const SizedBox(height: 27),

              if (plan.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Column(children: [
                    Icon(Icons.map_outlined, size: 50, color: purple),
                    SizedBox(height: 10),
                    Text('Your adventure awaits!',
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    SizedBox(height: 7),
                    Text('Fill in your details to create a personalized '
                        'travel plan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54)),
                  ]),
                )
              else ...[
                Text('Your Trip to $place ✨',
                    style: const TextStyle(fontSize: 23,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  chip(Icons.calendar_month, '${plan.length} days'),
                  chip(Icons.currency_rupee, budget.text),
                  chip(Icons.favorite, interest),
                  chip(Icons.luggage, style),
                ]),
                const SizedBox(height: 17),
                ...plan.map((day) => dayCard(day)),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9E7FF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(children: [
                    Icon(Icons.lightbulb_outline, color: purple, size: 28),
                    SizedBox(width: 12),
                    Expanded(child: Text(
                      'Travel tip: Check weather, transport, opening hours '
                      'and entry fees before your trip.',
                    )),
                  ]),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    final text = StringBuffer('Trip to $place\n');
                    for (final day in plan) {
                      text.writeln('\n${day['day']}');
                      text.writeln('Morning: ${day['morning']}');
                      text.writeln('Afternoon: ${day['afternoon']}');
                      text.writeln('Evening: ${day['evening']}');
                    }
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Your itinerary'),
                        content: SingleChildScrollView(
                          child: SelectableText(text.toString()),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.share_outlined),
                  label: const Text('View Shareable Itinerary'),
                ),
              ],
              const SizedBox(height: 24),
              const Center(child: Text(
                '✈ Made for explorers • TripGenius AI',
                style: TextStyle(color: Colors.black45),
              )),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(IconData icon) => InputDecoration(
        prefixIcon: Icon(icon, color: purple),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE2E4F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFE2E4F0)),
        ),
      );

  Widget field(String label, TextEditingController c,
      IconData icon, String hint, {bool number = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        textCapitalization: TextCapitalization.words,
        decoration: inputDecoration(icon).copyWith(hintText: hint),
      ),
    ]);
  }

  Widget chip(IconData icon, String text) => Chip(
        avatar: Icon(icon, size: 17, color: purple),
        label: Text(text),
        backgroundColor: const Color(0xFFEAE8FF),
        side: BorderSide.none,
      );

  Widget dayCard(Map<String, String> day) {
    const icons = [
      Icons.wb_sunny_outlined,
      Icons.light_mode_outlined,
      Icons.nights_stay_outlined,
    ];
    const times = ['Morning', 'Afternoon', 'Evening'];
    const keys = ['morning', 'afternoon', 'evening'];

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE7E7F2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.event_note, color: purple),
              const SizedBox(width: 9),
              Text(day['day']!,
                  style: const TextStyle(fontSize: 19,
                      fontWeight: FontWeight.bold)),
            ]),
            const Divider(height: 25),
            for (int i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icons[i], color: purple, size: 24),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(times[i],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(day[keys[i]]!,
                            style: const TextStyle(height: 1.4)),
                      ],
                    )),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
