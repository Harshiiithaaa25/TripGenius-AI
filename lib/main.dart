
import 'package:flutter/material.dart';

void main() => runApp(const TripApp());

const purple = Color(0xFF6757F5);
const background = Color(0xFFF5F6FF);

class TripApp extends StatelessWidget {
  const TripApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: purple),
        scaffoldBackgroundColor: background,
      ),
      home: const TripHome(),
    );
  }
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
  List<Map<String, String>> itinerary = [];
  String place = '';

  final activities = {
    'Nature': [
      ['Explore scenic spots', 'Visit a beautiful garden', 'Watch the sunset'],
      ['Discover a nearby lake', 'Explore nature trails', 'Take photos'],
      ['Visit a waterfall', 'Enjoy a picnic', 'Relax in nature'],
    ],
    'History': [
      ['Visit a historic monument', 'Explore a museum', 'Walk heritage streets'],
      ['Discover an ancient temple', 'Learn local history', 'Visit a market'],
      ['Explore a heritage site', 'Admire architecture', 'Enjoy local culture'],
    ],
    'Food': [
      ['Try a local breakfast', 'Explore street food', 'Taste regional dishes'],
      ['Visit a food market', 'Try local specialities', 'Discover a dessert shop'],
      ['Enjoy a popular restaurant', 'Taste local snacks', 'Take a food walk'],
    ],
    'Adventure': [
      ['Explore an outdoor trail', 'Try an adventure activity', 'Enjoy the views'],
      ['Go trekking', 'Discover outdoor activities', 'Watch the sunset'],
      ['Explore a scenic route', 'Try something new', 'Enjoy an evening walk'],
    ],
  };

  void generateTrip() {
    final d = int.tryParse(days.text.trim());
    final b = int.tryParse(budget.text.trim());

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
      itinerary = List.generate(d, (i) {
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

  void resetTrip() {
    setState(() {
      destination.clear();
      days.text = '3';
      budget.text = '5000';
      interest = 'Nature';
      style = 'Budget-friendly';
      itinerary = [];
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
        backgroundColor: background,
        title: const Row(
          children: [
            Icon(Icons.flight_takeoff, color: purple, size: 30),
            SizedBox(width: 8),
            Text('TripGenius ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('AI', style: TextStyle(
                color: purple, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: resetTrip,
            tooltip: 'Plan another trip',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF536DFE), Color(0xFF9B65EF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.explore, color: Colors.white, size: 40),
                    SizedBox(height: 14),
                    Text(
                      'Your next adventure\nstarts here!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Discover places. Plan smarter. Travel happier.',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text('Plan Your Trip',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text('Customize your next getaway',
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 18),

              buildField('Destination', destination,
                  Icons.location_on, 'e.g. Goa, Ooty, Hyderabad'),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: buildField('Days (1–7)', days,
                        Icons.calendar_month, '3', number: true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildField('Budget (₹)', budget,
                        Icons.currency_rupee, '5000', number: true),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              const Text('What interests you?',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: interest,
                isExpanded: true,
                decoration: decoration(Icons.favorite),
                items: const ['Nature', 'History', 'Food', 'Adventure']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => interest = v);
                },
              ),
              const SizedBox(height: 16),

              const Text('Travel style',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: style,
                isExpanded: true,
                decoration: decoration(Icons.luggage),
                items: const ['Budget-friendly', 'Comfort', 'Luxury']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => style = v);
                },
              ),
              const SizedBox(height: 22),

              SizedBox(
                height: 54,
                child: FilledButton.icon(
                  onPressed: generateTrip,
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
              const SizedBox(height: 26),

              if (itinerary.isEmpty)
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.map_outlined, color: purple, size: 50),
                      SizedBox(height: 12),
                      Text('Your adventure awaits!',
                          style: TextStyle(fontSize: 19,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 7),
                      Text(
                        'Enter your trip details above to create a '
                        'personalized day-by-day plan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, height: 1.5),
                      ),
                    ],
                  ),
                )
              else ...[
                Text('Your Trip to $place ✨',
                    style: const TextStyle(fontSize: 24,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    buildChip(Icons.calendar_month, '${itinerary.length} days'),
                    buildChip(Icons.currency_rupee, budget.text),
                    buildChip(Icons.favorite, interest),
                    buildChip(Icons.luggage, style),
                  ],
                ),
                const SizedBox(height: 18),
                ...itinerary.map(buildDayCard),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAE8FF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: purple, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Travel tip: Check weather, transport, opening '
                          'hours and entry fees before travelling.',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    final text = StringBuffer('Trip to $place\n');
                    for (final day in itinerary) {
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
              const Center(
                child: Text('✈ Made for explorers • TripGenius AI',
                    style: TextStyle(color: Colors.black45)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration decoration(IconData icon) {
    return InputDecoration(
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
  }

  Widget buildField(String label, TextEditingController controller,
      IconData icon, String hint, {bool number = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          textCapitalization: TextCapitalization.words,
          decoration: decoration(icon).copyWith(hintText: hint),
        ),
      ],
    );
  }

  Widget buildChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 17, color: purple),
      label: Text(text),
      backgroundColor: const Color(0xFFEAE8FF),
      side: BorderSide.none,
    );
  }

  Widget buildDayCard(Map<String, String> day) {
    const icons = [
      Icons.wb_sunny_outlined,
      Icons.light_mode_outlined,
      Icons.nights_stay_outlined,
    ];
    const labels = ['Morning', 'Afternoon', 'Evening'];
    const keys = ['morning', 'afternoon', 'evening'];

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE6E6F2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.event_note, color: purple),
                const SizedBox(width: 10),
                Text(day['day']!,
                    style: const TextStyle(fontSize: 19,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 25),
            for (int i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 17),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icons[i], color: purple, size: 23),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(labels[i],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(day[keys[i]]!,
                              style: const TextStyle(height: 1.4)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
