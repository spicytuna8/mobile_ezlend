import 'package:loan_project/helper/loan_status_constants.dart';

/// Example of how to use LoanStatusConstants in existing code
/// This shows how to refactor the status checking logic using the new constants

class LoanStatusExample {
  /// Example: Refactored method from repayment_screen.dart
  static bool isLoanOverdueRefactored(dynamic loan) {
    int status = loan.status ?? 0;
    int statusloan = loan.statusloan ?? 0;
    int blacklist = loan.blacklist ?? 0;

    // OLD WAY (scattered magic numbers):
    // return loan.status == 3 &&
    //     (loan.statusloan == 7 ||
    //         loan.statusloan == 6 ||
    //         loan.statusloan == 8 ||
    //         (loan.statusloan == 4 && loan.blacklist == 9));

    // NEW WAY (using constants):
    return LoanStatusConstants.isOverdue(status, statusloan, blacklist);
  }

  /// Example: Refactored method for getting status text
  static String getLoanStatusTextRefactored(dynamic loan) {
    int status = loan.status ?? 0;
    int statusloan = loan.statusloan ?? 0;
    int blacklist = loan.blacklist ?? 0;

    // OLD WAY (multiple if-else with magic numbers):
    // if (isLoanOverdue(loan)) {
    //   return Languages.of(context).overdue;
    // } else if (loan.status == 3 && loan.statusloan == 4) {
    //   return Languages.of(context).active;
    // } else if ((loan.status == 0 || loan.status == 1 || loan.status == 10) && loan.statusloan == 4) {
    //   return Languages.of(context).pending;
    // }

    // NEW WAY (using constants):
    String statusKey = LoanStatusConstants.getStatusTextKey(status, statusloan, blacklist);

    // Then use statusKey with localization:
    // return Languages.of(context).getTranslation(statusKey);
    return statusKey; // Return key for this example
  }

  /// Example: Refactored balance calculation filter
  static List<dynamic> getActiveLoansForBalanceRefactored(List<dynamic> loans) {
    // OLD WAY (repeated logic):
    // return loans.where((loan) =>
    //     loan.status == 3 &&
    //     (loan.statusloan == 4 || loan.statusloan == 6 || loan.statusloan == 7 || loan.statusloan == 8)
    // ).toList();

    // NEW WAY (using constants):
    return loans.where((loan) {
      int status = loan.status ?? 0;
      int statusloan = loan.statusloan ?? 0;
      return LoanStatusConstants.isIncludedInActiveBalance(status, statusloan);
    }).toList();
  }

  /// Example: Check if user can apply for new loan
  static bool canUserApplyForNewLoanRefactored(List<dynamic> loans) {
    // OLD WAY (complex nested conditions):
    // for (var loan in loans) {
    //   if ((loan.status == 3 && loan.statusloan == 4) ||
    //       (loan.status == 3 && loan.statusloan == 6) ||
    //       (loan.status == 3 && loan.statusloan == 7) ||
    //       (loan.status == 3 && loan.statusloan == 8) ||
    //       (loan.status == 3 && loan.statusloan == 4 && loan.blacklist == 9)) {
    //     return false;
    //   }
    // }
    // return true;

    // NEW WAY (using constants):
    return LoanStatusConstants.canApplyForNewLoan(loans);
  }

  /// Example: Debug logging with readable status
  static void logLoanStatusRefactored(dynamic loan) {
    int status = loan.status ?? 0;
    int statusloan = loan.statusloan ?? 0;
    int blacklist = loan.blacklist ?? 0;

    // OLD WAY:
    // print('Loan ${loan.id}: status=$status, statusloan=$statusloan, blacklist=$blacklist');

    // NEW WAY (more readable):
    String description = LoanStatusConstants.getDebugStatusDescription(status, statusloan, blacklist);
    print('Loan ${loan.id}: $description');
  }

  /// Example: Sort loans by priority (overdue first, then active, etc.)
  static List<dynamic> sortLoansByPriorityRefactored(List<dynamic> loans) {
    return loans
      ..sort((a, b) {
        int priorityA = LoanStatusConstants.getStatusPriority(a.status ?? 0, a.statusloan ?? 0, a.blacklist ?? 0);
        int priorityB = LoanStatusConstants.getStatusPriority(b.status ?? 0, b.statusloan ?? 0, b.blacklist ?? 0);
        return priorityA.compareTo(priorityB);
      });
  }
}

/// Usage Examples:

void demonstrateConstantsUsage() {
  // Example loan data (simulated)
  int status = 3; // APPROVED
  int statusloan = 7; // OVERDUE_LEVEL_2
  int blacklist = 0; // NORMAL

  print('Sample Loan Data:');
  print('- status: $status');
  print('- statusloan: $statusloan');
  print('- blacklist: $blacklist');
  print('');

  // Check various conditions
  bool isOverdue = LoanStatusConstants.isOverdue(status, statusloan, blacklist);
  print('Is overdue: $isOverdue'); // true

  bool isActive = LoanStatusConstants.isActiveAndApproved(status, statusloan, blacklist);
  print('Is active: $isActive'); // false

  bool isPending = LoanStatusConstants.isPendingApplication(status, statusloan);
  print('Is pending: $isPending'); // false

  // Get status text key
  String statusTextKey = LoanStatusConstants.getStatusTextKey(status, statusloan, blacklist);
  print('Status text key: $statusTextKey'); // "overdue"

  // Get priority for sorting
  int priority = LoanStatusConstants.getStatusPriority(status, statusloan, blacklist);
  print('Status priority: $priority'); // 1 (highest priority)

  // Debug description
  String debugDesc = LoanStatusConstants.getDebugStatusDescription(status, statusloan, blacklist);
  print('Debug description: $debugDesc');

  print('');
  print('Constants values:');
  print('- STATUSLOAN_ACTIVE: ${LoanStatusConstants.STATUSLOAN_ACTIVE}');
  print('- STATUSLOAN_OVERDUE_LEVEL_2: ${LoanStatusConstants.STATUSLOAN_OVERDUE_LEVEL_2}');
  print('- STATUS_APPROVED: ${LoanStatusConstants.STATUS_APPROVED}');
  print('- BLACKLIST_NORMAL: ${LoanStatusConstants.BLACKLIST_NORMAL}');
}

void main() {
  print('🎯 Loan Status Constants Example Usage');
  print('=' * 50);
  demonstrateConstantsUsage();
}
