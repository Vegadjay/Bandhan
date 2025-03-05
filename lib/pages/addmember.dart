import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../db/data_access.dart';
import 'package:intl/intl.dart';

class AddMemberPage extends StatefulWidget {
  final int? memberId;

  const AddMemberPage({super.key, this.memberId});

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final _formKey = GlobalKey<FormState>();
  final MyDatabase db = MyDatabase();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController castController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  String selectedGender = 'Male';
  String selectedMaritalStatus = 'Single';
  String selectedSalaryRange = 'Below ₹10,000';
  DateTime? selectedDate;
  int? calculatedAge;

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
    if (widget.memberId != null) {
      _loadMemberData(widget.memberId!);
    }
  }

  Future<void> _loadMemberData(int id) async {
    final member = await db.getUserById(id);
    if (member != null) {
      setState(() {
        nameController.text = member['name'] ?? '';
        emailController.text = member['email'] ?? '';
        mobileController.text = member['mobile'] ?? '';
        addressController.text = member['address'] ?? '';
        dateOfBirthController.text = member['dob'] ?? '';
        professionController.text = member['profession'] ?? '';
        castController.text = member['cast'] ?? '';
        countryController.text = member['country'] ?? '';
        selectedGender = member['gender'] ?? 'Male';
        selectedMaritalStatus = member['marital_status'] ?? 'Single';
        selectedSalaryRange = member['salary_range'] ?? 'Below ₹10,000';

        if (member['dob'] != null) {
          try {
            selectedDate = DateFormat('dd/MM/yyyy').parse(member['dob']);
            _calculateAge();
          } catch (e) {}
        }
      });
    }
  }

  void _calculateAge() {
    if (selectedDate != null) {
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - selectedDate!.year;
      if (currentDate.month < selectedDate!.month ||
          (currentDate.month == selectedDate!.month &&
              currentDate.day < selectedDate!.day)) {
        age--;
      }
      setState(() {
        calculatedAge = age;
      });
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

  String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of Birth is required';
    }
    if (selectedDate == null) {
      return 'Please select a valid date';
    }
    if (calculatedAge! < 18 || calculatedAge! > 100) {
      return 'Age must be between 18 and 100 years';
    }
    return null;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
      selectedDate ?? DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime.now().subtract(const Duration(days: 36500)),
      lastDate: DateTime.now().subtract(const Duration(days: 6570)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF4ECDC4),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateOfBirthController.text = DateFormat('dd/MM/yyyy').format(picked);
        _calculateAge();
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
    VoidCallback? onTap,
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
          suffixIcon: onTap != null
              ? Icon(Icons.calendar_today, color: Color(0xFF4ECDC4))
              : null,
        ),
        validator: validator,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        readOnly: readOnly,
        onTap: onTap,
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final memberData = {
        'name': nameController.text,
        'email': emailController.text,
        'mobile': mobileController.text,
        'address': addressController.text,
        'dob': dateOfBirthController.text,
        'age': calculatedAge,
        'gender': selectedGender,
        'profession': professionController.text,
        'cast': castController.text,
        'country': countryController.text,
        'marital_status': selectedMaritalStatus,
        'salary_range': selectedSalaryRange,
      };

      if (widget.memberId == null) {
        await db.insertUser(memberData);
      } else {
        await db.updateUser(widget.memberId!, memberData);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memberId == null ? 'Add New Member' : 'Edit Member'),
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
                          controller: nameController,
                          label: 'Full Name',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Name is required'
                              : null,
                        ),
                        _buildTextField(
                          controller: emailController,
                          label: 'Email',
                          validator: validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _buildTextField(
                          controller: mobileController,
                          label: 'Mobile Number',
                          validator: validateMobile,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                        _buildTextField(
                          controller: addressController,
                          label: 'Address',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Address is required'
                              : null,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextField(
                              controller: dateOfBirthController,
                              label: 'Date of Birth',
                              validator: validateDateOfBirth,
                              readOnly: true,
                              onTap: _selectDate,
                            ),
                            if (calculatedAge != null)
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 16, bottom: 16),
                                child: Text(
                                  'Age: $calculatedAge years',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
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
                          controller: professionController,
                          label: 'Profession',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Profession is required'
                              : null,
                        ),
                        _buildTextField(
                          controller: castController,
                          label: 'Cast',
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Cast is required'
                              : null,
                        ),
                        _buildTextField(
                          controller: countryController,
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
                              widget.memberId == null
                                  ? 'Add Member'
                                  : 'Update Member',
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
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    dateOfBirthController.dispose();
    professionController.dispose();
    castController.dispose();
    countryController.dispose();
    super.dispose();
  }
}