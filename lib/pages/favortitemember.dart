import 'package:flutter/material.dart';

class FavoriteMember extends StatelessWidget {
  final List<Map<String, String>> users;

  const FavoriteMember({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Members'),
        backgroundColor: const Color(0xFF4ECDC4),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4ECDC4), Color(0xFF76E4E2)],
          ),
        ),
        child: users.isEmpty
            ? Center(
                child: Text(
                  'No favorite members yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF4ECDC4),
                        radius: 30,
                        child: Text(
                          user['name']?[0] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      title: Text(
                        user['name'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(user['profession'] ?? ''),
                          Text(user['email'] ?? ''),
                          Text(user['mobile'] ?? ''),
                          Text('${user['age']} years • ${user['gender']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
