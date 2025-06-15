import 'package:flutter/material.dart';

class BookingsTab extends StatefulWidget {
  const BookingsTab({super.key});

  @override
  State<BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends State<BookingsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _upcomingBookings = [
    {
      'provider': 'Dr. Afan khan',
      'profession': 'Dentist',
      'date': '15/06/2023',
      'time': '10:00 AM',
      'status': 'Confirmed',
    },
    {
      'provider': 'Aziz ullah',
      'profession': 'Electrician',
      'date': '18/06/2023',
      'time': '2:00 PM',
      'status': 'Pending',
    },
  ];

  final List<Map<String, dynamic>> _pastBookings = [
    {
      'provider': 'Atta ullah',
      'profession': 'House Cleaner',
      'date': '05/06/2023',
      'time': '9:00 AM',
      'status': 'Completed',
    },
    {
      'provider': 'Abdurrehman',
      'profession': 'Plumber',
      'date': '28/05/2023',
      'time': '11:30 AM',
      'status': 'Completed',
    },
    {
      'provider': 'zakir ullah',
      'profession': 'Carpenter',
      'date': '20/05/2023',
      'time': '3:00 PM',
      'status': 'Cancelled',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Upcoming Bookings Tab
          _upcomingBookings.isEmpty
              ? const Center(
            child: Text(
              'No upcoming bookings',
              style: TextStyle(fontSize: 16,
              color: Colors.black
              ),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _upcomingBookings.length,
            itemBuilder: (context, index) {
              final booking = _upcomingBookings[index];
              return _buildBookingCard(booking);
            },
          ),

          // Past Bookings Tab
          _pastBookings.isEmpty
              ? const Center(
            child: Text(
              'No past bookings',
              style: TextStyle(fontSize: 16),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _pastBookings.length,
            itemBuilder: (context, index) {
              final booking = _pastBookings[index];
              return _buildBookingCard(booking);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    Color statusColor;
    IconData statusIcon;

    switch (booking['status']) {
      case 'Confirmed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Pending':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      case 'Completed':
        statusColor = Colors.blue;
        statusIcon = Icons.task_alt;
        break;
      case 'Cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['provider'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black

                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking['profession'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        statusIcon,
                        size: 14,
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        booking['status'],
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        booking['date'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        booking['time'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (booking['status'] == 'Confirmed' || booking['status'] == 'Pending')
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFEEEEEE)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Implement reschedule functionality
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Reschedule'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement view details functionality
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('View Details'),
                    ),
                  ),
                ],
              ),
            ),
          if (booking['status'] == 'Completed')
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFEEEEEE)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Implement book again functionality
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Book Again'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Implement leave review functionality
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Leave Review'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

