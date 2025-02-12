import 'package:flutter/material.dart';

class MembershipPage extends StatelessWidget {
  const MembershipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const MembershipPlansPage(),
    );
  }
}

class MembershipPlan {
  final String title;
  final String price;
  final String duration;
  final List<String> features;
  final Color color;

  const MembershipPlan({
    required this.title,
    required this.price,
    required this.duration,
    required this.features,
    required this.color,
  });
}

class MembershipPlansPage extends StatelessWidget {
  const MembershipPlansPage({Key? key}) : super(key: key);

  static const List<MembershipPlan> plans = [
    MembershipPlan(
      title: "Basic Plan",
      price: "999.00",
      duration: "month",
      features: [
        "Access to limited profiles",
        "Basic search filters",
        "Email support",
      ],
      color: Colors.blue,
    ),
    MembershipPlan(
      title: "Standard Plan",
      price: "1999.00",
      duration: "month",
      features: [
        "Access to all profiles",
        "Advanced search filters",
        "Chat support",
        "Ad-free experience",
      ],
      color: Colors.green,
    ),
    MembershipPlan(
      title: "Premium Plan",
      price: "2999.00",
      duration: "month",
      features: [
        "Priority profile visibility",
        "Premium search filters",
        "24/7 Priority support",
        "Profile highlighting",
        "See who viewed your profile",
      ],
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Choose Your Membership",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4ECDC4),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Select the perfect plan for you",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  return _buildPlanCard(plans[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(MembershipPlan plan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: plan.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: plan.color,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: '₹${plan.price}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        TextSpan(
                          text: '/${plan.duration}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...plan.features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: plan.color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        feature,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle subscription
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: plan.color,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Subscribe Now",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
