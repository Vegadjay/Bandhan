import 'package:flutter/material.dart';
import '../db/data_access.dart';

class FavoriteMember extends StatefulWidget {
  const FavoriteMember({Key? key}) : super(key: key);

  @override
  _FavoriteMemberState createState() => _FavoriteMemberState();
}

class _FavoriteMemberState extends State<FavoriteMember> {
  final MyDatabase db = MyDatabase();
  List<Map<String, dynamic>> favoriteUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFavoriteUsers();
    searchController.addListener(_filterUsers);
  }

  Future<void> _loadFavoriteUsers() async {
    final users = await db.getUsers();
    setState(() {
      favoriteUsers = users.where((user) => user['isfavorite'] == 1).toList();
      filteredUsers = List.from(favoriteUsers); // Copy for search filtering
    });
  }

  void _filterUsers() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = favoriteUsers
          .where((user) =>
      user['name']?.toLowerCase().contains(query) ?? false)
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Members'),
        backgroundColor: const Color(0xFF4ECDC4),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Color(0xFF4ECDC4),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search members...",
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF4ECDC4)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          // Member List
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF4ECDC4), Color(0xFF76E4E2)],
                ),
              ),
              child: filteredUsers.isEmpty
                  ? const Center(
                child: Text(
                  'No favorite members found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MemberDetailScreen(user: user),
                        ),
                      );
                    },
                    child: Card(
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
                            user['name']?.isNotEmpty == true
                                ? user['name'][0]
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        title: Text(
                          user['name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(user['profession'] ?? 'No profession'),
                            Text(user['email'] ?? 'No email'),
                            Text(user['mobile'] ?? 'No mobile'),
                            Text(
                                '${user['age'] ?? 'N/A'} years • ${user['gender'] ?? 'N/A'}'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MemberDetailScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const MemberDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user['name'] ?? 'Member Details'),
        backgroundColor: const Color(0xFF4ECDC4),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem(Icons.email_outlined, 'Email', user['email']),
            _buildDetailItem(Icons.phone_outlined, 'Mobile', user['mobile']),
            _buildDetailItem(Icons.home_outlined, 'Address', user['address']),
            _buildDetailItem(Icons.calendar_today_outlined, 'Age',
                '${user['age']} years'),
            _buildDetailItem(
                Icons.person_outline, 'Gender', user['gender']),
            _buildDetailItem(
                Icons.work_outline, 'Profession', user['profession']),
            _buildDetailItem(Icons.people_outline, 'Cast', user['cast']),
            _buildDetailItem(
                Icons.public_outlined, 'Country', user['country']),
            _buildDetailItem(Icons.favorite_outline, 'Marital Status',
                user['marital_status']),
            _buildDetailItem(
                Icons.currency_rupee, 'Salary Range', user['salary_range']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B6B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFFF6B6B)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
