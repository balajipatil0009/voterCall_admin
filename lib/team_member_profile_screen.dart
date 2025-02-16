import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/team_member.dart';
import '../services/supabase_service.dart';

class TeamMemberProfileScreen extends StatefulWidget {
  final String teamMemberId;

  const TeamMemberProfileScreen({super.key, required this.teamMemberId});

  @override
  State<TeamMemberProfileScreen> createState() =>
      _TeamMemberProfileScreenState();
}

class _TeamMemberProfileScreenState extends State<TeamMemberProfileScreen> {
  late Future<TeamMember?> _teamMemberFuture;
  final _accentColor = const Color(0xFF0067C0);
  final _backgroundColor = const Color(0xFFF3F3F3);
  final _cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _teamMemberFuture = SupabaseService.getTeamMemberById(widget.teamMemberId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Member Profile',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.black,
        toolbarHeight: 48,
      ),
      body: FutureBuilder<TeamMember?>(
        future: _teamMemberFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: _accentColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 40, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Error loading profile\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            final teamMember = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileCard(
                    children: [
                      _buildDetailRow('Name', teamMember.name, isHeader: true),
                      if (teamMember.city != null) ...[
                        _buildDivider(),
                        _buildDetailRow('City', teamMember.city!),
                      ],
                      if (teamMember.phoneNumber != null) ...[
                        _buildDivider(),
                        _buildDetailRow(
                            'Phone Number', teamMember.phoneNumber!),
                      ],
                      _buildDivider(),
                      _buildDetailRow(
                        'Member Since',
                        DateFormat('MMM dd, yyyy').format(teamMember.createdAt),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_off, size: 40, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Member not found',
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileCard({required List<Widget> children}) {
    return Card(
      color: _cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text('$label:',
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(value,
                style: isHeader
                    ? TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800)
                    : TextStyle(color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 24, color: Colors.grey.shade200);
  }
}
