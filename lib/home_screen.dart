import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/voter_issue.dart';
import '../services/supabase_service.dart';
import 'issue_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<VoterIssue>> _issuesFuture;
  final _accentColor = const Color(0xFF0067C0); // Windows Azure color
  final _backgroundColor = const Color(0xFFF3F3F3);
  final _cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _issuesFuture = SupabaseService.getVoterIssues();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: _accentColor,
          background: _backgroundColor,
        ),
        fontFamily: 'Segoe UI',
        cardTheme: CardTheme(
          color: _cardColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Voter Issues',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          elevation: 0,
          toolbarHeight: 48,
          backgroundColor: _backgroundColor,
          foregroundColor: Colors.black,
        ),
        body: FutureBuilder<List<VoterIssue>>(
          future: _issuesFuture,
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
                    const Icon(Icons.error_outline,
                        size: 40, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('Failed to load issues\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final issues = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.separated(
                  itemCount: issues.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final issue = issues[index];
                    return _buildIssueCard(issue);
                  },
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.assignment_outlined,
                        size: 40, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text('No issues found',
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFamily: 'Segoe UI')),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildIssueCard(VoterIssue issue) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IssueDetailScreen(issueId: issue.id),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildStatusIndicator(issue.status),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(issue.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                  const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                DateFormat('MMM dd, yyyy - HH:mm').format(issue.createdAt),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
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
        children: [
          Icon(
            status == 'Open' ? Icons.circle_outlined : Icons.done_all,
            size: 12,
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
}
