import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MinimalCalendarPage extends StatefulWidget {
  const MinimalCalendarPage({Key? key}) : super(key: key);

  @override
  State<MinimalCalendarPage> createState() => _MinimalCalendarPageState();
}

class _MinimalCalendarPageState extends State<MinimalCalendarPage> {
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysBefore = firstDay.weekday % 7;
    final firstToShow = firstDay.subtract(Duration(days: daysBefore));

    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysAfter = 6 - (lastDay.weekday % 7);
    final lastToShow = lastDay.add(Duration(days: daysAfter));

    return List.generate(
      lastToShow.difference(firstToShow).inDays + 1,
      (index) => firstToShow.add(Duration(days: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth(currentMonth);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F9),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Gradient başlık alanı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7E57C2), Color(0xFFF06292)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Takvim',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.more_vert, color: Colors.transparent),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    DateFormat(
                      'MMMM yyyy',
                      'tr_TR',
                    ).format(currentMonth).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Cam efektiyle çevrili takvim kutusu
            Expanded(
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔹 Ay geçiş butonları
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left_rounded,
                              size: 26,
                              color: Color(0xFF7E57C2),
                            ),
                            onPressed: () {
                              setState(() {
                                currentMonth = DateTime(
                                  currentMonth.year,
                                  currentMonth.month - 1,
                                );
                              });
                            },
                          ),
                          Text(
                            DateFormat(
                              'MMMM yyyy',
                              'tr_TR',
                            ).format(currentMonth).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A148C),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_right_rounded,
                              size: 26,
                              color: Color(0xFF7E57C2),
                            ),
                            onPressed: () {
                              setState(() {
                                currentMonth = DateTime(
                                  currentMonth.year,
                                  currentMonth.month + 1,
                                );
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // 🔹 Gün başlıkları
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['P', 'S', 'Ç', 'P', 'C', 'C', 'P']
                            .map(
                              (e) => Expanded(
                                child: Center(
                                  child: Text(
                                    e,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),

                      const SizedBox(height: 10),

                      // 🔹 Günler ızgarası
                      Flexible(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: days.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                              ),
                          itemBuilder: (context, index) {
                            final day = days[index];
                            final isSelected =
                                day.day == selectedDate.day &&
                                day.month == selectedDate.month &&
                                day.year == selectedDate.year;
                            final isThisMonth = day.month == currentMonth.month;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDate = day;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: isSelected
                                      ? const LinearGradient(
                                          colors: [
                                            Color(0xFF7E57C2),
                                            Color(0xFFF06292),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                  border: !isSelected
                                      ? Border.all(
                                          color: Colors.black12,
                                          width: 1.2,
                                        )
                                      : null,
                                  color: isSelected
                                      ? null
                                      : Colors.white.withOpacity(0.9),
                                ),
                                child: Center(
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(
                                      color: isThisMonth
                                          ? (isSelected
                                                ? Colors.white
                                                : Colors.black87)
                                          : Colors.black26,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 Seçilen tarih bilgisi
                      Text(
                        DateFormat(
                          'd MMMM y, EEEE',
                          'tr_TR',
                        ).format(selectedDate),
                        style: const TextStyle(
                          color: Color(0xFF7E57C2),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 Done butonu
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, selectedDate);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7E57C2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            "Tarihi Onayla",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
