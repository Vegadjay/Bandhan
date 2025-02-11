// add_member_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddMemberPage extends StatefulWidget {
  final Function(Map<String, String>) onAddMember;
  final Map<String, String>? initialData;

  const AddMemberPage({
    super.key,
    required this.onAddMember,
    this.initialData,
  });

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();
  final _professionController = TextEditingController();
  final _castController = TextEditingController();
  final _countryController = TextEditingController();

  String selectedGender = 'Male';
  String selectedMaritalStatus = 'Single';
  String selectedSalaryRange = 'Below ₹10,000';

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> maritalStatus = [
    'Single',
    'Married',
    'Divorced',
    'Widowed'
  ];
  final List<String> salaryRanges = [
    'Below ₹10,000',
    '₹10,000 - ₹30,000',
    '₹30,000 - ₹50,000',
    '₹50,000 - ₹80,000',
    'Above ₹80,000'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _nameController.text = widget.initialData!['name'] ?? '';
      _emailController.text = widget.initialData!['email'] ?? '';
      _mobileController.text = widget.initialData!['mobile'] ?? '';
      _addressController.text = widget.initialData!['address'] ?? '';
      _ageController.text = widget.initialData!['age'] ?? '';
      _professionController.text = widget.initialData!['profession'] ?? '';
      _castController.text = widget.initialData!['cast'] ?? '';
      _countryController.text = widget.initialData!['country'] ?? '';
      selectedGender = widget.initialData!['gender'] ?? 'Male';
      selectedMaritalStatus = widget.initialData!['maritalStatus'] ?? 'Single';
      selectedSalaryRange =
          widget.initialData!['salaryRange'] ?? 'Below ₹10,000';
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null || age < 18 || age > 100) {
      return 'Enter a valid age between 18 and 100';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final memberData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'mobile': _mobileController.text,
        'address': _addressController.text,
        'age': _ageController.text,
        'gender': selectedGender,
        'profession': _professionController.text,
        'cast': _castController.text,
        'country': _countryController.text,
        'maritalStatus': selectedMaritalStatus,
        'salaryRange': selectedSalaryRange,
      };

      widget.onAddMember(memberData);
      Navigator.pop(context, true);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.initialData == null ? 'Add New Member' : 'Edit Member'),
        backgroundColor: const Color(0xFF4ECDC4),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4ECDC4), Color(0xFF7FDFD9)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Name is required'
                              : null,
                        ),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          validator: validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _buildTextField(
                          controller: _mobileController,
                          label: 'Mobile Number',
                          validator: validateMobile,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                        _buildTextField(
                          controller: _addressController,
                          label: 'Address',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Address is required'
                              : null,
                        ),
                        _buildTextField(
                          controller: _ageController,
                          label: 'Age',
                          validator: validateAge,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                        ),
                        _buildDropdownField(
                          label: 'Gender',
                          value: selectedGender,
                          items: genderOptions,
                          onChanged: (newValue) {
                            setState(() {
                              selectedGender = newValue!;
                            });
                          },
                        ),
                        _buildTextField(
                          controller: _professionController,
                          label: 'Profession',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Profession is required'
                              : null,
                        ),
                        _buildTextField(
                          controller: _castController,
                          label: 'Cast',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Cast is required'
                              : null,
                        ),
                        _buildTextField(
                          controller: _countryController,
                          label: 'Country',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Country is required'
                              : null,
                        ),
                        _buildDropdownField(
                          label: 'Marital Status',
                          value: selectedMaritalStatus,
                          items: maritalStatus,
                          onChanged: (newValue) {
                            setState(() {
                              selectedMaritalStatus = newValue!;
                            });
                          },
                        ),
                        _buildDropdownField(
                          label: 'Salary Range',
                          value: selectedSalaryRange,
                          items: salaryRanges,
                          onChanged: (newValue) {
                            setState(() {
                              selectedSalaryRange = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF4ECDC4),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              widget.initialData == null
                                  ? 'Add Member'
                                  : 'Save Changes',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    _professionController.dispose();
    _castController.dispose();
    _countryController.dispose();
    super.dispose();
  }
}
