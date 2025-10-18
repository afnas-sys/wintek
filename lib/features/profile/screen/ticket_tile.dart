import 'package:flutter/material.dart';
import 'ticket_model.dart';

class TicketTile extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback? onTap;

  const TicketTile({super.key, required this.ticket, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF271358),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIconContainer(),
            const SizedBox(width: 16),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white.withOpacity(0.10),
      ),
      child: _buildIcon(),
    );
  }

  Widget _buildIcon() {
    switch (ticket.type) {
      case TicketType.wallet:
      case TicketType.payment:
        return _buildWalletIcon();
      case TicketType.game:
        return _buildGameIcon();
      case TicketType.account:
      case TicketType.technical:
      case TicketType.other:
        return _buildSupportIcon();
    }
  }

  Widget _buildWalletIcon() {
    return SizedBox(
      width: 16,
      height: 16,
      child: CustomPaint(painter: WalletIconPainter()),
    );
  }

  Widget _buildGameIcon() {
    return SizedBox(
      width: 16,
      height: 16,
      child: CustomPaint(painter: GameIconPainter()),
    );
  }

  Widget _buildSupportIcon() {
    return const Icon(Icons.support_agent, color: Colors.white, size: 16);
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 10),
        _buildDescription(),
        const SizedBox(height: 10),
        _buildTimestamp(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            ticket.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final color = _getStatusColor();
    return Text(
      ticket.statusText,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        height: 1.33,
      ),
    );
  }

  Color _getStatusColor() {
    switch (ticket.status) {
      case TicketStatus.pending:
        return const Color(0xFFF98500);
      case TicketStatus.inProgress:
        return const Color(0xFF6041FF);
      case TicketStatus.resolved:
        return const Color(0xFF00C851);
      case TicketStatus.closed:
        return const Color(0xFF757575);
    }
  }

  Widget _buildDescription() {
    return Text(
      ticket.description,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        height: 1.33,
      ),
    );
  }

  Widget _buildTimestamp() {
    return Text(
      ticket.formattedCreatedDate,
      style: const TextStyle(
        color: Color.fromRGBO(255, 255, 255, 0.5),
        fontSize: 12,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        height: 1.33,
      ),
    );
  }
}

// Custom painter for wallet icon (matching the design SVG)
class WalletIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Main wallet body
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.3,
        size.width * 0.8,
        size.height * 0.6,
      ),
      Radius.circular(size.width * 0.08),
    );
    canvas.drawRRect(rect, paint);

    // Wallet flap
    final flapRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.2,
        size.height * 0.1,
        size.width * 0.6,
        size.height * 0.3,
      ),
      Radius.circular(size.width * 0.06),
    );
    canvas.drawRRect(flapRect, paint);

    // Card slot indicator
    final cardSlot = Rect.fromLTWH(
      size.width * 0.3,
      size.height * 0.45,
      size.width * 0.4,
      size.height * 0.1,
    );
    paint.color = const Color(0xFF271358);
    canvas.drawRRect(
      RRect.fromRectAndRadius(cardSlot, Radius.circular(size.width * 0.02)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for game icon (matching the design SVG)
class GameIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Game controller body
    final controllerBody = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.1,
        size.height * 0.25,
        size.width * 0.8,
        size.height * 0.6,
      ),
      Radius.circular(size.width * 0.15),
    );
    canvas.drawRRect(controllerBody, paint);

    // Left analog area
    final leftAnalog = Offset(size.width * 0.25, size.height * 0.6);
    canvas.drawCircle(leftAnalog, size.width * 0.08, paint);

    // Right buttons area
    final rightButton1 = Offset(size.width * 0.7, size.height * 0.45);
    final rightButton2 = Offset(size.width * 0.8, size.height * 0.55);
    canvas.drawCircle(rightButton1, size.width * 0.04, paint);
    canvas.drawCircle(rightButton2, size.width * 0.04, paint);

    // D-pad
    final dpadCenter = Offset(size.width * 0.3, size.height * 0.45);
    final dpadSize = size.width * 0.03;

    // Horizontal line of d-pad
    canvas.drawRect(
      Rect.fromCenter(
        center: dpadCenter,
        width: dpadSize * 3,
        height: dpadSize,
      ),
      paint,
    );

    // Vertical line of d-pad
    canvas.drawRect(
      Rect.fromCenter(
        center: dpadCenter,
        width: dpadSize,
        height: dpadSize * 3,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
