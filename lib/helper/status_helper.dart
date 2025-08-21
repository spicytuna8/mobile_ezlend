/// Application Status Helper
///
/// This class handles loan application status constants and helper methods
/// for status-related operations in the EzLend application.
// ignore_for_file: constant_identifier_names

class StatusHelper {
  // Private constructor to prevent instantiation
  StatusHelper._();

  /// Application Status Constants
  /// These represent the approval status of loan applications
  static const int PENDING_REVIEW = 0;
  static const int UNDER_REVIEW = 1;
  static const int REJECTED = 2;
  static const int APPROVED = 3;
  static const int PENDING_APPROVAL = 10;

  /// Blacklist Status Constants
  /// These represent user behavior status
  static const int BLACKLIST_NORMAL = 0;
  static const int BLACKLIST_BLACKLISTED = 9;

  /// Check if loan application is pending review
  static bool isPendingReview(int status) {
    return status == PENDING_REVIEW;
  }

  /// Check if loan application is under review
  static bool isUnderReview(int status) {
    return status == UNDER_REVIEW;
  }

  /// Check if loan application is rejected
  static bool isRejected(int status) {
    return status == REJECTED;
  }

  /// Check if loan application is approved
  static bool isApproved(int status) {
    return status == APPROVED;
  }

  /// Check if loan application is pending approval
  static bool isPendingApproval(int status) {
    return status == PENDING_APPROVAL;
  }

  /// Check if loan application is in any pending state
  static bool isPending(int status) {
    return isPendingReview(status) || isUnderReview(status) || isPendingApproval(status);
  }

  /// Check if user is blacklisted
  static bool isBlacklisted(int blacklist) {
    return blacklist == BLACKLIST_BLACKLISTED;
  }

  /// Check if user has normal blacklist status
  static bool isNormalBlacklist(int blacklist) {
    return blacklist == BLACKLIST_NORMAL;
  }

  /// Get user-friendly status text key for localization
  static String getStatusTextKey(int status) {
    if (isRejected(status)) {
      return 'reject';
    } else if (isPendingApproval(status)) {
      return 'pendingApproval';
    } else if (isPending(status)) {
      return 'pending';
    } else if (isApproved(status)) {
      return 'approved';
    } else {
      return 'unknown';
    }
  }

  /// Get status priority for sorting (lower number = higher priority)
  static int getStatusPriority(int status) {
    if (isRejected(status)) {
      return 4;
    } else if (isPending(status)) {
      return 3;
    } else if (isApproved(status)) {
      return 1; // Approved has highest priority for further processing
    } else {
      return 5; // Unknown status
    }
  }

  /// Debug helper to get readable status description
  static String getDebugStatusDescription(int status, int blacklist) {
    String statusDesc = _getStatusDescription(status);
    String blacklistDesc = isBlacklisted(blacklist) ? 'BLACKLISTED' : 'NORMAL';

    return 'Status: $statusDesc, Blacklist: $blacklistDesc';
  }

  /// Get readable status description
  static String _getStatusDescription(int status) {
    switch (status) {
      case PENDING_REVIEW:
        return 'PENDING_REVIEW';
      case UNDER_REVIEW:
        return 'UNDER_REVIEW';
      case REJECTED:
        return 'REJECTED';
      case APPROVED:
        return 'APPROVED';
      case PENDING_APPROVAL:
        return 'PENDING_APPROVAL';
      default:
        return 'UNKNOWN($status)';
    }
  }

  /// Check if status allows loan application
  static bool canApplyForLoan(int status) {
    // User can apply if no previous loan or previous loan was rejected
    return isRejected(status) || status == 0; // 0 for new users
  }

  /// Get all valid status values
  static List<int> getAllValidStatuses() {
    return [
      PENDING_REVIEW,
      UNDER_REVIEW,
      REJECTED,
      APPROVED,
      PENDING_APPROVAL,
    ];
  }

  /// Validate if status value is valid
  static bool isValidStatus(int status) {
    return getAllValidStatuses().contains(status);
  }
}
