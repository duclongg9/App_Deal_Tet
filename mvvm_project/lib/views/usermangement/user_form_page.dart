import 'package:flutter/material.dart';
import 'package:mvvm_project/domain/entities/user_profile.dart';
import 'package:mvvm_project/views/usermangement/user_management_header.dart';

class UserFormPage extends StatefulWidget {
  final UserProfile? initialValue;

  const UserFormPage({super.key, this.initialValue});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _addressCtrl;
  DateTime? _birthDate;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialValue?.fullName ?? '');
    _addressCtrl = TextEditingController(text: widget.initialValue?.address ?? '');
    _birthDate = widget.initialValue?.birthDate;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FF),
      body: SafeArea(
        child: Column(
          children: [
            UserManagementHeader(
              title: 'Thêm / Sửa người dùng',
              subtitle: 'Nhập thông tin và bấm Lưu',
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(18),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _Field(controller: _nameCtrl, hint: 'Họ và tên'),
                      const SizedBox(height: 14),
                      _DateField(
                        value: _birthDate,
                        onTap: _pickDate,
                        formatter: _formatDate,
                      ),
                      const SizedBox(height: 14),
                      _Field(controller: _addressCtrl, hint: 'Địa chỉ', maxLines: 3),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Hủy'),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _submit,
                              child: const Text('Lưu'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final initialDate = _birthDate ?? DateTime(1995, 1, 1);
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (selected != null) {
      setState(() => _birthDate = selected);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngày sinh.')),
      );
      return;
    }

    final user = UserProfile(
      id: widget.initialValue?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      fullName: _nameCtrl.text.trim(),
      birthDate: _birthDate!,
      address: _addressCtrl.text.trim(),
    );

    Navigator.pop(context, user);
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _Field({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) {
        if ((value ?? '').trim().isEmpty) {
          return 'Không được để trống';
        }
        return null;
      },
      decoration: InputDecoration(hintText: hint),
    );
  }
}

class _DateField extends StatelessWidget {
  final DateTime? value;
  final VoidCallback onTap;
  final String Function(DateTime date) formatter;

  const _DateField({
    required this.value,
    required this.onTap,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: const InputDecoration(
          hintText: 'Ngày sinh',
          suffixIcon: Icon(Icons.calendar_month),
        ),
        child: Text(value == null ? 'Ngày sinh' : formatter(value!)),
      ),
    );
  }
}
