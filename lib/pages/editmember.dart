import 'package:flutter/material.dart';
import '../db/data_access.dart';

class EditMemberPage extends StatefulWidget {
  final int memberId;

  const EditMemberPage({
    super.key,
    required this.memberId,
  });

  @override
  State<EditMemberPage> createState() => _EditMemberPageState();
}

class _EditMemberPageState extends State<EditMemberPage> {
  final _formKey = GlobalKey<FormState>();
  final MyDatabase db = MyDatabase();
  late Map<String, dynamic> _editedData;

  @override
  void initState() {
    super.initState();
    _loadMemberData();
  }

  Future<void> _loadMemberData() async {
    final member = await db.getUserById(widget.memberId);
    if (member != null) {
      setState(() {
        _editedData = Map<String, dynamic>.from(member);
      });
    }
  }

  Widget _buildTextField(String label, String field, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: _editedData[field],
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFFFF6B6B)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            _editedData[field] = value;
          });
        },
      ),
    );
  }

  Widget _buildDropdownField(
      String label, String field, IconData icon, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _editedData[field],
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFFFF6B6B)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $label';
          }
          return null;
        },
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _editedData[field] = value;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
        backgroundColor: const Color(0xFFFF6B6B),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFFFF0F0)],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildTextField('Name', 'name', Icons.person_outline),
              _buildTextField('Email', 'email', Icons.email_outlined),
              _buildTextField('Mobile', 'mobile', Icons.phone_outlined),
              _buildTextField('Address', 'address', Icons.home_outlined),
              _buildTextField('Age', 'age', Icons.calendar_today_outlined),
              _buildDropdownField(
                'Gender',
                'gender',
                Icons.person_outline,
                ['Male', 'Female', 'Other'],
              ),
              _buildTextField('Profession', 'profession', Icons.work_outline),
              _buildTextField('Cast', 'cast', Icons.people_outline),
              _buildTextField('Country', 'country', Icons.public_outlined),
              _buildDropdownField(
                'Marital Status',
                'marital_status',
                Icons.favorite_outline,
                ['Single', 'Married', 'Divorced', 'Widowed'],
              ),
              _buildTextField(
                  'Salary Range', 'salary_range', Icons.currency_rupee),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await db.updateUser(widget.memberId, _editedData);
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFFF6B6B),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 8),
                    Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}