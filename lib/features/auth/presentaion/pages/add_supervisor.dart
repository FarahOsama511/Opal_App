import 'package:flutter/material.dart';

class AddSupervisor extends StatefulWidget {
  const AddSupervisor({super.key});

  @override
  State<AddSupervisor> createState() => _AddSupervisorState();
}

class _AddSupervisorState extends State<AddSupervisor> {
  String? selectedLine;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: size.height * 0.05),

                  // اللوجو
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE71A45),
                      ),
                      child: Image.asset(
                        'assets/logo.png',
                        width: size.width * 0.22,
                      ),
                    ),
                  ),

            const SizedBox(height: 20),

            _buildTextField(hint: 'الاسم'),

            const SizedBox(height: 12),

            _buildTextField(hint: 'رقم الهاتف'),

            const SizedBox(height: 12),

// ✅ Dropdown بنفس تنسيق الحقول
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedLine,
                    hint: const Text('الخط'),
                    items: const [
                      DropdownMenuItem(value: '1', child: Text('خط رقم 1')),
                      DropdownMenuItem(value: '2', child: Text('خط رقم 2')),
                      DropdownMenuItem(value: '3', child: Text('خط رقم 3')),
                      DropdownMenuItem(value: '4', child: Text('خط رقم 4')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedLine = value;
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
              ),
            ),



            const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE71A45),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                      },
                      child: const Text(
                        'اضافه مشرف',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                ] )

        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14),
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

