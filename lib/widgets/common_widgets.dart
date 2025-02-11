import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const PageHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 80, color: Colors.red[400]),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            color: Colors.red[400],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class MemberListTile extends StatelessWidget {
  final int index;
  final IconData trailingIcon;
  final VoidCallback? onPressed;
  final bool isFavorite;

  const MemberListTile({
    required this.index,
    required this.trailingIcon,
    this.onPressed,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Color.fromARGB(255, 192, 21, 222),
        child: isFavorite
            ? Icon(Icons.star, color: Colors.white)
            : Text('${index + 1}', style: TextStyle(color: Colors.white)),
      ),
      title: Text('Member ${index + 1}'),
      subtitle: Text('member${index + 1}@example.com'),
      trailing: IconButton(
        icon: Icon(trailingIcon, color: Colors.red[300]),
        onPressed: onPressed,
      ),
    );
  }
}
