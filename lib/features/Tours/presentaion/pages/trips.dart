import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/get_tour_bloc/tour_cubit.dart';
import '../bloc/get_tour_bloc/tour_state.dart';
import 'edit_trip_time.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreen();
}

class _TripsScreen extends State<TripsScreen> {
  int? expandedCardIndex;
  String? selectedLine;
  @override
  initState() {
    super.initState();
    BlocProvider.of<TourCubit>(context).getAllTours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE71A45),
      body: SafeArea(
        child: Column(
          children: [
            // Header

            // White container with trips list
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFE71A45),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: const EdgeInsets.all(16),
                                child: EditTripBox(
                                  onClose: () => Navigator.pop(context),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                          tooltip: 'تعديل',
                        ),

                        const Text(
                          "مواعيد الرحلات",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          final isExpanded = index == expandedCardIndex;
                          return _buildBusCard(index, isExpanded);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusCard(int index, bool isExpanded) {
    return GestureDetector(
      onTap: () {
        setState(() {
          expandedCardIndex = expandedCardIndex == index ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -5,
              left: -5,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset('assets/logo.png', width: 60),
              ),
            ),
            BlocBuilder<TourCubit, TourState>(
              builder: (context, state) {
                print("STATE => ${state.runtimeType}");

                if (state is TourLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TourLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _RowInfo(
                        label: 'الخط',
                        value: state.tours[index].line.name!,
                      ),
                      _RowInfo(
                        label: 'اسم المشرف',
                        value: state.tours[index].driverName,
                      ),
                      const _RowInfo(
                        label: 'ميعاد الذهاب',
                        value: '7:00 صباحاً',
                      ),
                      const _RowInfo(label: 'تاريخ اليوم', value: '22/6/2025'),
                      if (isExpanded) ...[
                        const Divider(height: 20),
                        const Text(
                          'اختر ميعاد العودة:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          items: const [
                            DropdownMenuItem(
                              value: '1',
                              child: Text('1:00 مساءً'),
                            ),
                            DropdownMenuItem(
                              value: '2',
                              child: Text('2:00 مساءً'),
                            ),
                            DropdownMenuItem(
                              value: '3',
                              child: Text('3:00 مساءً'),
                            ),
                          ],
                          onChanged: (val) {},
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    expandedCardIndex = null;
                                  });
                                },
                                child: const Text('إلغاء'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/confirm');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFE71A45),
                                ),
                                child: const Text('التالي'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  );
                } else if (state is TourError) {
                  return Center(child: Text("${state.message}"));
                } else {
                  return const Center(
                    child: Text('حدث خطأ أثناء تحميل البيانات'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RowInfo extends StatelessWidget {
  final String label;
  final String value;

  const _RowInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}
