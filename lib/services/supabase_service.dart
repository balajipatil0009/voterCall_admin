import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart'
    show PostgrestException; // Import PostgrestException
import '../models/voter_issue.dart';
import '../models/voter_user.dart';
import '../models/team_member.dart';
import '../main.dart'; // Import supabase client

class SupabaseService {
  static Future<List<VoterIssue>> getVoterIssues() async {
    try {
      // Wrap the Supabase call in a try-catch block
      final response = await supabase
          .from('voter_issues')
          .select('*')
          .order('created_at', ascending: false);

      // If successful, response will be List<Map<String, dynamic>>
      final List<dynamic> data = response as List<dynamic>;
      return data.map((issue) => VoterIssue.fromJson(issue)).toList();
    } on PostgrestException catch (error) {
      // Catch PostgrestException specifically
      print(
          'Supabase PostgrestException fetching voter issues: ${error.message}');
      return []; // Return empty list or handle error appropriately
    } catch (e) {
      // Catch any other unexpected exceptions
      print('Unexpected Error fetching voter issues: $e');
      return []; // Return empty list or handle error
    }
  }

  static Future<VoterIssue> getVoterIssueDetails(String issueId) async {
    try {
      final response = await supabase
          .from('voter_issues')
          .select('*')
          .eq('id', issueId)
          .single();

      // If successful, response will be Map<String, dynamic>
      return VoterIssue.fromJson(response);
    } on PostgrestException catch (error) {
      print(
          'Supabase PostgrestException fetching issue details: ${error.message}');
      return VoterIssue(
        // Return a default VoterIssue object in case of error
        id: '',
        createdAt: DateTime.now(), // Placeholder values
        createdBy: '',
        title: 'Error Loading Issue',
        category: '',
        description: 'Failed to load issue details.',
        location: '',
        desireSolution: '',
        status: 'error',
      );
    } catch (e) {
      print('Unexpected Error fetching issue details: $e');
      return VoterIssue(
        // Return a default VoterIssue object in case of error
        id: '',
        createdAt: DateTime.now(), // Placeholder values
        createdBy: '',
        title: 'Error Loading Issue',
        category: '',
        description: 'Failed to load issue details.',
        location: '',
        desireSolution: '',
        status: 'error',
      );
    }
  }

  static Future<VoterUser?> getVoterUserById(String userId) async {
    print('getVoterUserById called with userId: $userId'); // Debug print

    try {
      final response = await supabase
          .from('voter_user')
          .select('*')
          .eq('id', userId)
          .single();

      print('getVoterUserById - Supabase Response: $response'); // Debug print

      return VoterUser.fromJson(response);
    } on PostgrestException catch (error) {
      print(
          'Supabase PostgrestException fetching voter user: ${error.message}');
      return null;
    } catch (e) {
      print('Unexpected Error fetching voter user: $e');
      return null;
    }
  }

  static Future<TeamMember?> getTeamMemberById(String teamMemberId) async {
    print(
        'getTeamMemberById called with teamMemberId: $teamMemberId'); // Debug print

    try {
      final response = await supabase
          .from('team_members')
          .select('*')
          .eq('id', teamMemberId)
          .single();
      print('getTeamMemberById - Supabase Response: $response'); // Debug print

      return TeamMember.fromJson(response);
    } on PostgrestException catch (error) {
      print(
          'Supabase PostgrestException fetching team member: ${error.message}');
      return null;
    } catch (e) {
      print('Unexpected Error fetching team member: $e');
      return null;
    }
  }
}
