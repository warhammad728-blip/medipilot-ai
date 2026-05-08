import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/doctor.dart';
import '../providers/chat_provider.dart';
import '../widgets/doctor_card.dart';

class AppointmentScreen extends ConsumerStatefulWidget {
  const AppointmentScreen({super.key});

  @override
  ConsumerState<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends ConsumerState<AppointmentScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final _filters = ['All', 'Cardiology', 'Endocrinology', 'General'];

  List<Doctor> _filteredDoctors(List<Doctor> doctors) {
    var filtered = doctors;
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((d) => d.specialty.toLowerCase().contains(_selectedFilter.toLowerCase()))
          .toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((d) =>
              d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              d.specialty.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return filtered;
  }

  void _showBookingSheet(Doctor doctor) {
    String? selectedSlot;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Book Appointment', style: AppTextStyles.heading2),
                  const SizedBox(height: 4),
                  Text(
                    '${doctor.name} · ${doctor.specialty}',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.teal),
                  ),
                  const SizedBox(height: 16),
                  Text('Select a time slot', style: AppTextStyles.bodyBold),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: doctor.availableSlots.map((slot) {
                      final isSelected = selectedSlot == slot;
                      return ChoiceChip(
                        label: Text(slot),
                        selected: isSelected,
                        selectedColor: AppColors.tealLight,
                        labelStyle: AppTextStyles.bodySmall.copyWith(
                          color: isSelected ? AppColors.tealDark : AppColors.textPrimary,
                        ),
                        onSelected: (val) {
                          setSheetState(() => selectedSlot = val ? slot : null);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text('Patient Name', style: AppTextStyles.bodyBold),
                  const SizedBox(height: 6),
                  TextFormField(
                    initialValue: 'Ali Hassan',
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedSlot != null
                          ? () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '✅ Appointment booked with ${doctor.name} at $selectedSlot',
                                  ),
                                  backgroundColor: AppColors.green,
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navyDark,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.border,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Confirm Booking',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctors = ref.watch(doctorsProvider);
    final filtered = _filteredDoctors(doctors);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Book Appointment', style: AppTextStyles.headingWhite.copyWith(fontSize: 18)),
            Text(
              'AI recommended for you',
              style: AppTextStyles.caption.copyWith(color: Colors.white54),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search doctors...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          // Filter chips
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    selectedColor: AppColors.tealLight,
                    checkmarkColor: AppColors.tealDark,
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? AppColors.tealDark : AppColors.textPrimary,
                    ),
                    onSelected: (_) => setState(() => _selectedFilter = filter),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // AI Recommended header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, size: 16, color: AppColors.teal),
                const SizedBox(width: 6),
                Text('AI Recommended', style: AppTextStyles.heading3),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.tealLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${filtered.length} doctors',
                    style: AppTextStyles.agentTag.copyWith(color: AppColors.teal),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Doctor list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                return DoctorCard(
                  doctor: filtered[index],
                  onBook: () => _showBookingSheet(filtered[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
