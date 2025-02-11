import 'package:flutter/material.dart';

class FavoriteMember extends StatelessWidget {
  final List<Map<String, String>> users;

  const FavoriteMember({Key? key, required this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteUsers =
        users.where((user) => user['isFavorite'] == 'true').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Members'),
        backgroundColor: const Color(0xFFFF6B6B),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
          ),
        ),
        child: favoriteUsers.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border,
                        size: 64, color: Colors.white.withOpacity(0.8)),
                    const SizedBox(height: 16),
                    Text(
                      'No favorite members yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favoriteUsers.length,
                itemBuilder: (context, index) {
                  final user = favoriteUsers[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFFF6B6B),
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
                      trailing: const Icon(
                        Icons.favorite,
                        color: Color(0xFFFF6B6B),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
