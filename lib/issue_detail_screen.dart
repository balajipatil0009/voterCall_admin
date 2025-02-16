import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/voter_issue.dart';
import '../models/voter_user.dart';
import '../models/team_member.dart';
import '../services/supabase_service.dart';
import 'voter_profile_screen.dart';
import 'team_member_profile_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class IssueDetailScreen extends StatefulWidget {
  final String issueId;

  const IssueDetailScreen({super.key, required this.issueId});

  @override
  State<IssueDetailScreen> createState() => _IssueDetailScreenState();
}

class _IssueDetailScreenState extends State<IssueDetailScreen> {
  late Future<VoterIssue> _issueFuture;
  Future<VoterUser?>? _voterUserFuture;
  Future<TeamMember?>? _teamMemberFuture;
  final _accentColor = const Color(0xFF0067C0);
  final _backgroundColor = const Color(0xFFF3F3F3);
  final _cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _issueFuture = SupabaseService.getVoterIssueDetails(widget.issueId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.black,
        toolbarHeight: 48,
      ),
      body: FutureBuilder<VoterIssue>(
        future: _issueFuture,
        builder: (context, issueSnapshot) {
          if (issueSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2.0, color: _accentColor),
            );
          } else if (issueSnapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 40, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Error loading issue\n${issueSnapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            );
          } else if (issueSnapshot.hasData) {
            final issue = issueSnapshot.data!;
            _voterUserFuture =
                SupabaseService.getVoterUserById(issue.createdBy);
            _teamMemberFuture = issue.solver?.isNotEmpty == true
                ? SupabaseService.getTeamMemberById(issue.solver!)
                : Future.value(null);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionCard(
                    children: [
                      _buildDetailRow('Title', issue.title,
                          isHeader: true, context: context),
                      _buildDivider(),
                      _buildDetailRow('Category', issue.category),
                      _buildDivider(),
                      _buildDetailRow('Description', issue.description),
                      _buildDivider(),
                      _buildDetailRow('Location', issue.location),
                      _buildDivider(),
                      _buildDetailRow('Desired Solution', issue.desireSolution),
                      _buildDivider(),
                      _buildDetailRow('Status', issue.status,
                          status: issue.status),
                      _buildDivider(),
                      _buildDetailRow(
                        'Created At',
                        DateFormat('MMM dd, yyyy - HH:mm')
                            .format(issue.createdAt),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (issue.attachedPhotos.isNotEmpty)
                    _buildAttachmentSection(
                      'Photos',
                      issue.attachedPhotos,
                      Icons.image,
                    ),
                  if (issue.attachedVideos.isNotEmpty)
                    _buildAttachmentSection(
                        'Videos', issue.attachedVideos, Icons.videocam),
                  if (issue.attachedDocs.isNotEmpty)
                    _buildAttachmentSection(
                        'Documents', issue.attachedDocs, Icons.description),
                  const SizedBox(height: 16),
                  _buildUserSection(
                    'Created By',
                    _voterUserFuture,
                    (user) => VoterProfileScreen(voterUserId: user.id),
                  ),
                  const SizedBox(height: 8),
                  _buildUserSection(
                    'Solver',
                    _teamMemberFuture,
                    (member) =>
                        TeamMemberProfileScreen(teamMemberId: member.id),
                    defaultText: 'Not Assigned',
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_late, size: 40, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Issue not found', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
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

  Widget _buildDetailRow(String label, String value,
      {bool isHeader = false, BuildContext? context, String? status}) {
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
            child: status != null
                ? _buildStatusIndicator(status)
                : Text(value,
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

  Widget _buildAttachmentSection(
      String title, List<String> urls, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('$title:',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
          ),
          Card(
            color: _cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Column(
              children:
                  urls.map((url) => _buildAttachmentItem(url, icon)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(String url, IconData icon) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () => _launchUrl(url),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 12),
              Expanded(
                child: Text(url,
                    style: TextStyle(
                        color: _accentColor,
                        decoration: TextDecoration.underline,
                        overflow: TextOverflow.ellipsis)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserSection<T>(
    String title,
    Future<T?>? futureUser,
    Widget Function(T) profileBuilder, {
    String defaultText = 'Unknown User',
  }) {
    return FutureBuilder<T?>(
      future: futureUser,
      builder: (context, snapshot) {
        final content = snapshot.hasData && snapshot.data != null
            ? _buildUserTile(snapshot.data!, profileBuilder)
            : Text('$title: $defaultText',
                style: TextStyle(color: Colors.grey.shade600));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$title:',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.grey.shade800)),
            const SizedBox(height: 4),
            Card(
              color: _cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: snapshot.connectionState == ConnectionState.waiting
                    ? _buildLoadingIndicator()
                    : content,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserTile<T>(T user, Widget Function(T) profileBuilder) {
    final name = user is VoterUser
        ? user.name
        : user is TeamMember
            ? user.name
            : 'Unknown';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => profileBuilder(user)),
        ),
        child: Row(
          children: [
            Icon(Icons.person_outline, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 12),
            Text(name,
                style: TextStyle(
                    color: _accentColor, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    final color = status == 'Open' ? const Color(0xFF107C10) : Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status == 'Open' ? Icons.circle_outlined : Icons.done_all,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(status,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _showSnackBar('Could not open URL');
      }
    } catch (e) {
      _showSnackBar('Error launching URL: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.grey.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
