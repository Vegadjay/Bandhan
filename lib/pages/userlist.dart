import 'package:flutter/material.dart';
import 'package:metromony/pages/addmember.dart';
import 'addmember.dart';

class UsersListPage extends StatefulWidget {
  final Function(List) onFavoriteUpdate;

  const UsersListPage({Key? key, required this.onFavoriteUpdate})
      : super(key: key);

  @override
  State createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  List users = [
    {
      'name': 'John Doe',
      'email': 'john@example.com',
      'mobile': '1234567890',
      'address': '123 Main St, New York',
      'age': '30',
      'gender': 'Male',
      'profession': 'Software Engineer',
      'cast': 'Hindu',
      'country': 'USA',
      'maritalStatus': 'Single',
      'salaryRange': '₹50,000 - ₹80,000',
      'isFavorite': 'false',
    },
    {
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'mobile': '9876543210',
      'address': '456 Park Ave, London',
      'age': '28',
      'gender': 'Female',
      'profession': 'Data Scientist',
      'cast': 'Christian',
      'country': 'UK',
      'maritalStatus': 'Single',
      'salaryRange': '₹60,000 - ₹90,000',
      'isFavorite': 'false',
    }
  ];

  String searchQuery = '';
  List filteredUsers = [];
  bool showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    filteredUsers = List.from(users);
  }

  void _filterUsers(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (showOnlyFavorites) {
        _showFavoriteUsers();
      } else {
        if (query.isEmpty) {
          filteredUsers = List.from(users);
        } else {
          filteredUsers = users.where((user) {
            final name = user['name']?.toLowerCase() ?? '';
            final age = user['age']?.toLowerCase() ?? '';
            final profession = user['profession']?.toLowerCase() ?? '';
            final gender = user['gender']?.toLowerCase() ?? '';

            return name.contains(searchQuery) ||
                age.contains(searchQuery) ||
                profession.contains(searchQuery) ||
                gender.contains(searchQuery);
          }).toList();
        }
      }
    });
  }

  void _showFavoriteUsers() {
    setState(() {
      showOnlyFavorites = true;
      filteredUsers =
          users.where((user) => user['isFavorite'] == 'true').toList();
    });
  }

  void _showAllUsers() {
    setState(() {
      showOnlyFavorites = false;
      _filterUsers(searchQuery);
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      final userIndex = users.indexOf(filteredUsers[index]);
      users[userIndex]['isFavorite'] =
          (users[userIndex]['isFavorite'] == 'true' ? 'false' : 'true');
      if (showOnlyFavorites) {
        _showFavoriteUsers();
      } else {
        filteredUsers = List.from(users);
        _filterUsers(searchQuery);
      }
      widget.onFavoriteUpdate(users);
    });
  }

  void _addNewUser() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMemberPage(
          onAddMember: (userData) {
            userData['isFavorite'] = 'false';
            setState(() {
              users.add(userData);
              _filterUsers(searchQuery);
            });
          },
        ),
      ),
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _deleteUser(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Membership Finished'),
          content: Text(
              'Are you sure you want to delete ${filteredUsers[index]['name']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final userIndex = users.indexOf(filteredUsers[index]);
                  users.removeAt(userIndex);
                  _filterUsers(searchQuery);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User deleted successfully'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showUserDetails(int index) {
    final user = filteredUsers[index];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFF6B6B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      user['name'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      user['isFavorite'] == 'true'
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _toggleFavorite(index);
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      _editUser(index);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteUser(index);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailItem(
                        Icons.email_outlined, 'Email', user['email']!),
                    _buildDetailItem(
                        Icons.phone_outlined, 'Mobile', user['mobile']!),
                    _buildDetailItem(
                        Icons.home_outlined, 'Address', user['address']!),
                    _buildDetailItem(Icons.calendar_today_outlined, 'Age',
                        '${user['age']} years'),
                    _buildDetailItem(
                        Icons.person_outline, 'Gender', user['gender']!),
                    _buildDetailItem(
                        Icons.work_outline, 'Profession', user['profession']!),
                    _buildDetailItem(
                        Icons.people_outline, 'Cast', user['cast']!),
                    _buildDetailItem(
                        Icons.public_outlined, 'Country', user['country']!),
                    _buildDetailItem(Icons.favorite_outline, 'Marital Status',
                        user['maritalStatus']!),
                    _buildDetailItem(Icons.currency_rupee, 'Salary Range',
                        user['salaryRange']!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editUser(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMemberPage(
          onAddMember: (userData) {
            userData['isFavorite'] =
                filteredUsers[index]['isFavorite']!; // Preserve favorite status
            setState(() {
              final userIndex = users.indexOf(filteredUsers[index]);
              users[userIndex] = userData;
              _filterUsers(searchQuery);
            });
          },
          initialData: filteredUsers[index],
        ),
      ),
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
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
                  value,
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

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person_add, color: Color(0xFFFF6B6B)),
                title: const Text('Add Member'),
                onTap: () {
                  Navigator.pop(context);
                  _addNewUser();
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Color(0xFFFF6B6B)),
                title: const Text('Favorite Users'),
                onTap: () {
                  Navigator.pop(context);
                  _showFavoriteUsers();
                },
              ),
              if (showOnlyFavorites)
                ListTile(
                  leading: const Icon(Icons.people, color: Color(0xFFFF6B6B)),
                  title: const Text('Show All Users'),
                  onTap: () {
                    Navigator.pop(context);
                    _showAllUsers();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showOnlyFavorites ? 'Favorite Users' : 'Users List'),
        backgroundColor: const Color(0xFFFF6B6B),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMenu,
        backgroundColor: const Color(0xFFFF6B6B),
        child: const Icon(Icons.menu, color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: _filterUsers,
                decoration: InputDecoration(
                  hintText: 'Search by name, age, profession, or gender',
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFFFF6B6B)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            if (showOnlyFavorites)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: _showAllUsers,
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      label: const Text(
                        'Back to All Users',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
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
                      onTap: () => _showUserDetails(index),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              user['isFavorite'] == 'true'
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: const Color(0xFFFF6B6B),
                            ),
                            onPressed: () => _toggleFavorite(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Color(0xFFFF6B6B)),
                            onPressed: () => _editUser(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Color(0xFFFF6B6B)),
                            onPressed: () => _deleteUser(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
