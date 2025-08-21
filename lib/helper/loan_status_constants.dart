/// Loan Status Constants
///
/// This class contains all the status constants used throughout the EzLend application
/// for loan management, including application status, operational status, and blacklist status.
class LoanStatusConstants {
  // Private constructor to prevent instantiation
  LoanStatusConstants._();

  /// Application Status Constants
  /// These represent the approval status of loan applications
  static const int STATUS_PENDING_REVIEW = 0;
  static const int STATUS_UNDER_REVIEW = 1;
  static const int STATUS_REJECTED = 2;
  static const int STATUS_APPROVED = 3;
  static const int STATUS_PENDING_APPROVAL = 10;

  /// Operational Loan Status Constants
  /// These represent the current operational state of approved loans
  static const int STATUSLOAN_ACTIVE = 4;
  static const int STATUSLOAN_CLOSED = 5;
  static const int STATUSLOAN_OVERDUE_LEVEL_1 = 6;
  static const int STATUSLOAN_OVERDUE_LEVEL_2 = 7;
  static const int STATUSLOAN_OVERDUE_LEVEL_3 = 8;

  /// Blacklist Status Constants
  /// These represent user behavior status
  static const int BLACKLIST_NORMAL = 0;
  static const int BLACKLIST_BLACKLISTED = 9;

  /// Helper Methods for Status Checking

  /// Check if loan application is pending
  static bool isPendingApplication(int status, int statusloan) {
    return (status == STATUS_PENDING_REVIEW || status == STATUS_UNDER_REVIEW || status == STATUS_PENDING_APPROVAL) &&
        statusloan == STATUSLOAN_ACTIVE;
  }

  /// Check if loan is rejected
  static bool isRejected(int status) {
    return status == STATUS_REJECTED;
  }

  /// Check if loan is approved and active
  static bool isActiveAndApproved(int status, int statusloan, int blacklist) {
    return status == STATUS_APPROVED && statusloan == STATUSLOAN_ACTIVE && blacklist != BLACKLIST_BLACKLISTED;
  }

  /// Check if loan is overdue
  static bool isOverdue(int status, int statusloan, int blacklist) {
    return status == STATUS_APPROVED &&
        (statusloan == STATUSLOAN_OVERDUE_LEVEL_1 ||
            statusloan == STATUSLOAN_OVERDUE_LEVEL_2 ||
            statusloan == STATUSLOAN_OVERDUE_LEVEL_3 ||
            (statusloan == STATUSLOAN_ACTIVE && blacklist == BLACKLIST_BLACKLISTED));
  }

  /// Check if loan is closed/completed
  static bool isClosed(int statusloan) {
    return statusloan == STATUSLOAN_CLOSED;
  }

  /// Check if loan should be included in active balance calculation
  static bool isIncludedInActiveBalance(int status, int statusloan) {
    return status == STATUS_APPROVED &&
        (statusloan == STATUSLOAN_ACTIVE ||
            statusloan == STATUSLOAN_OVERDUE_LEVEL_1 ||
            statusloan == STATUSLOAN_OVERDUE_LEVEL_2 ||
            statusloan == STATUSLOAN_OVERDUE_LEVEL_3);
  }

  /// Get user-friendly status text key for localization
  static String getStatusTextKey(int status, int statusloan, int blacklist) {
    if (isOverdue(status, statusloan, blacklist)) {
      return 'overdue';
    } else if (isActiveAndApproved(status, statusloan, blacklist)) {
      return 'active';
    } else if (isClosed(statusloan)) {
      return 'closed';
    } else if (isRejected(status)) {
      return 'reject';
    } else if (status == STATUS_PENDING_APPROVAL) {
      return 'pendingApproval';
    } else if (isPendingApplication(status, statusloan)) {
      return 'pending';
    } else {
      return 'pending'; // Default fallback
    }
  }

  /// Get status priority for sorting (lower number = higher priority)
  /// Overdue loans should appear first, then active, then pending
  static int getStatusPriority(int status, int statusloan, int blacklist) {
    if (isOverdue(status, statusloan, blacklist)) {
      return 1; // Highest priority
    } else if (isActiveAndApproved(status, statusloan, blacklist)) {
      return 2;
    } else if (isPendingApplication(status, statusloan)) {
      return 3;
    } else if (isRejected(status)) {
      return 4;
    } else if (isClosed(statusloan)) {
      return 5; // Lowest priority
    } else {
      return 6; // Unknown status
    }
  }

  /// Check if user can apply for new loan
  /// User cannot apply if they have any active or overdue loans
  static bool canApplyForNewLoan(List<dynamic> loans) {
    for (var loan in loans) {
      int status = loan.status ?? 0;
      int statusloan = loan.statusloan ?? 0;
      int blacklist = loan.blacklist ?? 0;

      if (isActiveAndApproved(status, statusloan, blacklist) || isOverdue(status, statusloan, blacklist)) {
        return false;
      }
    }
    return true;
  }

  /// Debug helper to get readable status description
  static String getDebugStatusDescription(int status, int statusloan, int blacklist) {
    String statusDesc = _getStatusDescription(status);
    String statusloanDesc = _getStatusLoanDescription(statusloan);
    String blacklistDesc = blacklist == BLACKLIST_BLACKLISTED ? 'BLACKLISTED' : 'NORMAL';

    return 'Status: $statusDesc, StatusLoan: $statusloanDesc, Blacklist: $blacklistDesc';
  }

  static String _getStatusDescription(int status) {
    switch (status) {
      case STATUS_PENDING_REVIEW:
        return 'PENDING_REVIEW';
      case STATUS_UNDER_REVIEW:
        return 'UNDER_REVIEW';
      case STATUS_REJECTED:
        return 'REJECTED';
      case STATUS_APPROVED:
        return 'APPROVED';
      case STATUS_PENDING_APPROVAL:
        return 'PENDING_APPROVAL';
      default:
        return 'UNKNOWN($status)';
    }
  }

  static String _getStatusLoanDescription(int statusloan) {
    switch (statusloan) {
      case STATUSLOAN_ACTIVE:
        return 'ACTIVE';
      case STATUSLOAN_CLOSED:
        return 'CLOSED';
      case STATUSLOAN_OVERDUE_LEVEL_1:
        return 'OVERDUE_LEVEL_1';
      case STATUSLOAN_OVERDUE_LEVEL_2:
        return 'OVERDUE_LEVEL_2';
      case STATUSLOAN_OVERDUE_LEVEL_3:
        return 'OVERDUE_LEVEL_3';
      default:
        return 'UNKNOWN($statusloan)';
    }
  }
}
