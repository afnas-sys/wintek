import 'package:flutter/material.dart';
import 'ticket_model.dart';
import 'ticket_tile.dart';

class MyTicketScreen extends StatefulWidget {
  const MyTicketScreen({super.key});

  @override
  State<MyTicketScreen> createState() => _MyTicketScreenState();
}

class _MyTicketScreenState extends State<MyTicketScreen> {
  late List<TicketModel> tickets;

  @override
  void initState() {
    super.initState();
    // Initialize with sample data - will be replaced with real API data later
    tickets = TicketModel.getSampleTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140A2D),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildTicketsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 24,
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'My Ticket',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(width: 42, height: 24),
        ],
      ),
    );
  }

  Widget _buildTicketsList() {
    if (tickets.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ...tickets.map(
              (ticket) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TicketTile(ticket: ticket),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.support_agent, color: Colors.white54, size: 64),
          SizedBox(height: 16),
          Text(
            'No tickets found',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You haven\'t created any support tickets yet.',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
