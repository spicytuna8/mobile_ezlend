import 'package:loan_project/helper/loan_status_constants.dart';
import 'package:loan_project/model/response_get_loan.dart';

/// Extension methods for DatumLoan model to use the new status constants
/// This provides a clean interface for status checking without modifying the original model
extension DatumLoanStatusExtension on DatumLoan {
  /// Check if this loan is overdue
  bool get isOverdue {
    return LoanStatusConstants.isOverdue(status ?? 0, statusloan ?? 0, blacklist ?? 0);
  }

  /// Check if this loan is active and approved
  bool get isActiveAndApproved {
    return LoanStatusConstants.isActiveAndApproved(status ?? 0, statusloan ?? 0, blacklist ?? 0);
  }

  /// Check if this loan application is pending
  bool get isPendingApplication {
    return LoanStatusConstants.isPendingApplication(status ?? 0, statusloan ?? 0);
  }

  /// Check if this loan is rejected
  bool get isRejected {
    return LoanStatusConstants.isRejected(status ?? 0);
  }

  /// Check if this loan is closed/completed
  bool get isClosed {
    return LoanStatusConstants.isClosed(statusloan ?? 0);
  }

  /// Check if this loan should be included in active balance calculation
  bool get isIncludedInActiveBalance {
    return LoanStatusConstants.isIncludedInActiveBalance(status ?? 0, statusloan ?? 0);
  }

  /// Get the status text key for localization
  String get statusTextKey {
    return LoanStatusConstants.getStatusTextKey(status ?? 0, statusloan ?? 0, blacklist ?? 0);
  }

  /// Get the status priority for sorting (lower = higher priority)
  int get statusPriority {
    return LoanStatusConstants.getStatusPriority(status ?? 0, statusloan ?? 0, blacklist ?? 0);
  }

  /// Get debug-friendly status description
  String get debugStatusDescription {
    return LoanStatusConstants.getDebugStatusDescription(status ?? 0, statusloan ?? 0, blacklist ?? 0);
  }

  /// Check if this is a specific status value using constants
  bool hasStatus(int statusValue) {
    return status == statusValue;
  }

  /// Check if this is a specific statusloan value using constants
  bool hasStatusLoan(int statusloanValue) {
    return statusloan == statusloanValue;
  }

  /// Check if this loan is blacklisted
  bool get isBlacklisted {
    return blacklist == LoanStatusConstants.BLACKLIST_BLACKLISTED;
  }

  /// Check if this loan is in normal blacklist status
  bool get isNormalBlacklist {
    return blacklist == LoanStatusConstants.BLACKLIST_NORMAL;
  }
}

/// Extension methods for List<DatumLoan> to work with collections
extension DatumLoanListExtension on List<DatumLoan> {
  /// Filter loans that are overdue
  List<DatumLoan> get overdueLoans {
    return where((loan) => loan.isOverdue).toList();
  }

  /// Filter loans that are active and approved
  List<DatumLoan> get activeLoans {
    return where((loan) => loan.isActiveAndApproved).toList();
  }

  /// Filter loans that are pending
  List<DatumLoan> get pendingLoans {
    return where((loan) => loan.isPendingApplication).toList();
  }

  /// Filter loans that should be included in balance calculation
  List<DatumLoan> get loansForBalanceCalculation {
    return where((loan) => loan.isIncludedInActiveBalance).toList();
  }

  /// Sort loans by priority (overdue first, then active, etc.)
  List<DatumLoan> get sortedByPriority {
    final sorted = List<DatumLoan>.from(this);
    sorted.sort((a, b) => a.statusPriority.compareTo(b.statusPriority));
    return sorted;
  }

  /// Check if user can apply for new loan (no active/overdue loans)
  bool get canApplyForNewLoan {
    return !any((loan) => loan.isActiveAndApproved || loan.isOverdue);
  }

  /// Count loans by status
  int countLoansByStatus(int statusValue) {
    return where((loan) => loan.hasStatus(statusValue)).length;
  }

  /// Count loans by statusloan
  int countLoansByStatusLoan(int statusloanValue) {
    return where((loan) => loan.hasStatusLoan(statusloanValue)).length;
  }

  /// Get count of active loans
  int get activeLoansCount {
    return countLoansByStatusLoan(LoanStatusConstants.STATUSLOAN_ACTIVE);
  }

  /// Get count of overdue loans
  int get overdueLoansCount {
    return overdueLoans.length;
  }

  /// Check if any loan is overdue
  bool get hasOverdueLoan {
    return overdueLoans.isNotEmpty;
  }

  /// Check if any loan is active
  bool get hasActiveLoan {
    return activeLoans.isNotEmpty;
  }
}

/// Usage examples showing how to refactor existing code
class RefactoredStatusChecking {
  /// Example: Refactored from repayment_screen.dart
  static bool isLoanOverdue_Old(DatumLoan loan) {
    // OLD WAY - magic numbers scattered throughout code
    return loan.status == 3 &&
        (loan.statusloan == 7 ||
            loan.statusloan == 6 ||
            loan.statusloan == 8 ||
            (loan.statusloan == 4 && loan.blacklist == 9));
  }

  static bool isLoanOverdue_New(DatumLoan loan) {
    // NEW WAY - using extension method
    return loan.isOverdue;
  }

  /// Example: Refactored loan filtering
  static List<DatumLoan> getActiveLoans_Old(List<DatumLoan> loans) {
    // OLD WAY - repeated magic numbers
    return loans
        .where((loan) =>
            loan.status == 3 &&
            (loan.statusloan == 4 || loan.statusloan == 6 || loan.statusloan == 7 || loan.statusloan == 8))
        .toList();
  }

  static List<DatumLoan> getActiveLoans_New(List<DatumLoan> loans) {
    // NEW WAY - using extension method
    return loans.loansForBalanceCalculation;
  }

  /// Example: Check if user can apply for new loan
  static bool canApplyForNewLoan_Old(List<DatumLoan> loans) {
    // OLD WAY - complex nested conditions
    for (var loan in loans) {
      if ((loan.status == 3 && loan.statusloan == 4) ||
          (loan.status == 3 && loan.statusloan == 6) ||
          (loan.status == 3 && loan.statusloan == 7) ||
          (loan.status == 3 && loan.statusloan == 8) ||
          (loan.status == 3 && loan.statusloan == 4 && loan.blacklist == 9)) {
        return false;
      }
    }
    return true;
  }

  static bool canApplyForNewLoan_New(List<DatumLoan> loans) {
    // NEW WAY - using extension method
    return loans.canApplyForNewLoan;
  }
}
