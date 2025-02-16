import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/voter_user.dart';
import '../services/supabase_service.dart';

class VoterProfileScreen extends StatefulWidget {
  final String voterUserId;

  const VoterProfileScreen({super.key, required this.voterUserId});

  @override
  State<VoterProfileScreen> createState() => _VoterProfileScreenState();
}

class _VoterProfileScreenState extends State<VoterProfileScreen> {
  late Future<VoterUser?> _voterUserFuture;
  final _accentColor = const Color(0xFF0067C0);
  final _backgroundColor = const Color(0xFFF3F3F3);
  final _cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _voterUserFuture = SupabaseService.getVoterUserById(widget.voterUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voter Profile',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.black,
        toolbarHeight: 48,
      ),
      body: FutureBuilder<VoterUser?>(
        future: _voterUserFuture,
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
            final voterUser = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildProfileCard(
                    children: [
                      _buildDetailRow('Name', voterUser.name, isHeader: true),
                      if (voterUser.profile != null) ...[
                        _buildDivider(),
                        _buildDetailRow('Profile', voterUser.profile!),
                      ],
                      if (voterUser.number != null) ...[
                        _buildDivider(),
                        _buildDetailRow('Contact Number', voterUser.number!),
                      ],
                      _buildDivider(),
                      _buildDetailRow(
                        'Member Since',
                        DateFormat('MMM dd, yyyy').format(voterUser.createdAt),
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
                  Text('Voter not found',
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
