import 'package:loan_project/helper/status_helper.dart';
import 'package:loan_project/helper/status_loan_helper.dart';
import 'package:loan_project/model/response_get_loan.dart';

/// Extension for individual loan status checking
extension DatumLoanStatusExtension on DatumLoan {
  // Application Status Methods

  /// Check if loan application is pending review
  bool isPendingReview() {
    return StatusHelper.isPendingReview(status ?? 0);
  }

  /// Check if loan application is under review
  bool isUnderReview() {
    return StatusHelper.isUnderReview(status ?? 0);
  }

  /// Check if loan application is rejected
  bool isRejected() {
    return StatusHelper.isRejected(status ?? 0);
  }

  /// Check if loan application is approved
  bool isApproved() {
    return StatusHelper.isApproved(status ?? 0);
  }

  /// Check if loan application is pending approval
  bool isPendingApproval() {
    return StatusHelper.isPendingApproval(status ?? 0);
  }

  /// Check if loan application is in any pending state
  bool isPending() {
    return StatusHelper.isPending(status ?? 0);
  }

  /// Check if user is blacklisted
  bool isBlacklisted() {
    return StatusHelper.isBlacklisted(blacklist ?? 0);
  }

  // Loan Operational Status Methods

  /// Check if loan is active (currently being used)
  bool isActive() {
    return StatusLoanHelper.isActive(statusloan ?? 0);
  }

  /// Check if loan is paid off
  bool isPaidOff() {
    return StatusLoanHelper.isPaidOff(statusloan ?? 0);
  }

  /// Check if loan is overdue at any level
  bool isOverdue() {
    return StatusLoanHelper.isOverdue(statusloan ?? 0);
  }

  /// Check if loan is overdue level 1
  bool isOverdueLevel1() {
    return StatusLoanHelper.isOverdueLevel1(statusloan ?? 0);
  }

  /// Check if loan is overdue level 2
  bool isOverdueLevel2() {
    return StatusLoanHelper.isOverdueLevel2(statusloan ?? 0);
  }

  /// Check if loan is overdue level 3
  bool isOverdueLevel3() {
    return StatusLoanHelper.isOverdueLevel3(statusloan ?? 0);
  }

  /// Check if loan requires payment (active or overdue)
  bool requiresPayment() {
    return StatusLoanHelper.requiresPayment(statusloan ?? 0);
  }

  /// Check if loan is completed (paid off)
  bool isCompleted() {
    return StatusLoanHelper.isCompleted(statusloan ?? 0);
  }

  // Combined Status Methods

  /// Check if loan is active and approved (ready for use)
  bool isActiveAndApproved() {
    return isApproved() && isActive();
  }

  /// Check if loan is in a problematic state (overdue or blacklisted)
  bool isProblematic() {
    return isOverdue() || isBlacklisted();
  }

  /// Check if loan is eligible for new loan application
  bool canApplyForNewLoan() {
    return StatusHelper.canApplyForLoan(status ?? 0) && !isBlacklisted();
  }

  // UI Helper Methods

  /// Get user-friendly status text key for localization
  String getStatusTextKey() {
    return StatusHelper.getStatusTextKey(status ?? 0);
  }

  /// Get user-friendly loan status text key for localization
  String getLoanStatusTextKey() {
    return StatusLoanHelper.getStatusTextKey(statusloan ?? 0);
  }

  /// Get color indicator for loan status
  String getStatusColor() {
    return StatusLoanHelper.getStatusColor(statusloan ?? 0);
  }

  /// Get overdue level (0 = not overdue, 1-3 = overdue levels)
  int getOverdueLevel() {
    return StatusLoanHelper.getOverdueLevel(statusloan ?? 0);
  }

  /// Get urgency level for notifications
  int getUrgencyLevel() {
    return StatusLoanHelper.getUrgencyLevel(statusloan ?? 0);
  }

  /// Get status priority for sorting
  int getStatusPriority() {
    int statusPriority = StatusHelper.getStatusPriority(status ?? 0);
    int loanPriority = StatusLoanHelper.getStatusPriority(statusloan ?? 0);

    // Combine priorities - loan status takes precedence for active loans
    if (isApproved()) {
      return loanPriority;
    } else {
      return statusPriority;
    }
  }

  // Action Methods

  /// Check if loan allows early payment
  bool allowsEarlyPayment() {
    return StatusLoanHelper.allowsEarlyPayment(statusloan ?? 0);
  }

  /// Check if loan allows extension
  bool allowsExtension() {
    return StatusLoanHelper.allowsExtension(statusloan ?? 0);
  }

  /// Get recommended action for current status
  String getRecommendedAction() {
    if (!isApproved()) {
      return 'Wait for approval process';
    } else {
      return StatusLoanHelper.getRecommendedAction(statusloan ?? 0);
    }
  }

  // Debug Methods

  /// Debug helper to get complete status information
  String getDebugInfo() {
    String statusInfo = StatusHelper.getDebugStatusDescription(status ?? 0, blacklist ?? 0);
    String loanInfo = StatusLoanHelper.getDebugStatusDescription(statusloan ?? 0);
    return '$statusInfo, LoanStatus: $loanInfo';
  }
}

/// Extension for loan list operations
extension DatumLoanListExtension on List<DatumLoan> {
  /// Filter loans by application status
  List<DatumLoan> whereApproved() {
    return where((loan) => loan.isApproved()).toList();
  }

  List<DatumLoan> wherePending() {
    return where((loan) => loan.isPending()).toList();
  }

  List<DatumLoan> whereRejected() {
    return where((loan) => loan.isRejected()).toList();
  }

  /// Filter loans by operational status
  List<DatumLoan> whereActive() {
    return where((loan) => loan.isActive()).toList();
  }

  List<DatumLoan> whereOverdue() {
    return where((loan) => loan.isOverdue()).toList();
  }

  List<DatumLoan> wherePaidOff() {
    return where((loan) => loan.isPaidOff()).toList();
  }

  /// Filter loans that require payment
  List<DatumLoan> whereRequiresPayment() {
    return where((loan) => loan.requiresPayment()).toList();
  }

  /// Filter loans that are problematic
  List<DatumLoan> whereProblematic() {
    return where((loan) => loan.isProblematic()).toList();
  }

  /// Filter loans that are active and approved
  List<DatumLoan> whereActiveAndApproved() {
    return where((loan) => loan.isActiveAndApproved()).toList();
  }

  /// Count loans by status
  int countByStatus(int status) {
    return where((loan) => (loan.status ?? 0) == status).length;
  }

  int countByLoanStatus(int statusLoan) {
    return where((loan) => (loan.statusloan ?? 0) == statusLoan).length;
  }

  /// Count active loans
  int get activeCount => whereActive().length;

  /// Count overdue loans
  int get overdueCount => whereOverdue().length;

  /// Count problematic loans
  int get problematicCount => whereProblematic().length;

  /// Check if all loans are completed
  bool get allCompleted => every((loan) => loan.isCompleted());

  /// Check if any loans are overdue
  bool get hasOverdue => any((loan) => loan.isOverdue());

  /// Check if any loans are problematic
  bool get hasProblematic => any((loan) => loan.isProblematic());

  /// Sort loans by priority (most urgent first)
  List<DatumLoan> sortByPriority() {
    final sorted = [...this];
    sorted.sort((a, b) => a.getStatusPriority().compareTo(b.getStatusPriority()));
    return sorted;
  }

  /// Sort loans by urgency level (most urgent first)
  List<DatumLoan> sortByUrgency() {
    final sorted = [...this];
    sorted.sort((a, b) => b.getUrgencyLevel().compareTo(a.getUrgencyLevel()));
    return sorted;
  }

  /// Get total count by urgency level
  Map<int, int> countByUrgencyLevel() {
    final Map<int, int> counts = {};
    for (final loan in this) {
      final urgency = loan.getUrgencyLevel();
      counts[urgency] = (counts[urgency] ?? 0) + 1;
    }
    return counts;
  }
}
