/// Loan Operational Status Helper
///
/// This class handles operational loan status constants and helper methods
/// for managing loan lifecycle states in the EzLend application.
// ignore_for_file: constant_identifier_names

class StatusLoanHelper {
  // Private constructor to prevent instantiation
  StatusLoanHelper._();

  /// Operational Loan Status Constants
  /// These represent the operational state of active loans
  static const int ACTIVE = 4;
  static const int PAID_OFF = 5;
  static const int OVERDUE_LEVEL_1 = 6;
  static const int OVERDUE_LEVEL_2 = 7;
  static const int OVERDUE_LEVEL_3 = 8;

  /// Check if loan is active (currently being used)
  static bool isActive(int statusLoan) {
    return statusLoan == ACTIVE;
  }

  /// Check if loan is paid off
  static bool isPaidOff(int statusLoan) {
    return statusLoan == PAID_OFF;
  }

  /// Check if loan is overdue at any level
  static bool isOverdue(int statusLoan) {
    return statusLoan >= OVERDUE_LEVEL_1 && statusLoan <= OVERDUE_LEVEL_3;
  }

  /// Check if loan is overdue level 1 (early overdue)
  static bool isOverdueLevel1(int statusLoan) {
    return statusLoan == OVERDUE_LEVEL_1;
  }

  /// Check if loan is overdue level 2 (moderate overdue)
  static bool isOverdueLevel2(int statusLoan) {
    return statusLoan == OVERDUE_LEVEL_2;
  }

  /// Check if loan is overdue level 3 (severe overdue)
  static bool isOverdueLevel3(int statusLoan) {
    return statusLoan == OVERDUE_LEVEL_3;
  }

  /// Check if loan requires payment (active or overdue)
  static bool requiresPayment(int statusLoan) {
    return isActive(statusLoan) || isOverdue(statusLoan);
  }

  /// Check if loan is completed (paid off)
  static bool isCompleted(int statusLoan) {
    return isPaidOff(statusLoan);
  }

  /// Get overdue level (0 = not overdue, 1-3 = overdue levels)
  static int getOverdueLevel(int statusLoan) {
    if (isOverdueLevel1(statusLoan)) return 1;
    if (isOverdueLevel2(statusLoan)) return 2;
    if (isOverdueLevel3(statusLoan)) return 3;
    return 0; // Not overdue
  }

  /// Get status priority for sorting (lower number = higher priority)
  static int getStatusPriority(int statusLoan) {
    if (isOverdueLevel3(statusLoan)) {
      return 1; // Highest priority - severe overdue
    } else if (isOverdueLevel2(statusLoan)) {
      return 2; // High priority - moderate overdue
    } else if (isOverdueLevel1(statusLoan)) {
      return 3; // Medium priority - early overdue
    } else if (isActive(statusLoan)) {
      return 4; // Normal priority - active loan
    } else if (isPaidOff(statusLoan)) {
      return 5; // Low priority - completed
    } else {
      return 6; // Unknown status
    }
  }

  /// Get user-friendly status text key for localization
  static String getStatusTextKey(int statusLoan) {
    if (isActive(statusLoan)) {
      return 'active';
    } else if (isPaidOff(statusLoan)) {
      return 'paidOff';
    } else if (isOverdueLevel1(statusLoan)) {
      return 'overdueLevel1';
    } else if (isOverdueLevel2(statusLoan)) {
      return 'overdueLevel2';
    } else if (isOverdueLevel3(statusLoan)) {
      return 'overdueLevel3';
    } else {
      return 'unknown';
    }
  }

  /// Get color indicator for status (for UI)
  static String getStatusColor(int statusLoan) {
    if (isActive(statusLoan)) {
      return 'green'; // Normal active loan
    } else if (isPaidOff(statusLoan)) {
      return 'blue'; // Completed loan
    } else if (isOverdueLevel1(statusLoan)) {
      return 'yellow'; // Early warning
    } else if (isOverdueLevel2(statusLoan)) {
      return 'orange'; // Warning
    } else if (isOverdueLevel3(statusLoan)) {
      return 'red'; // Critical
    } else {
      return 'gray'; // Unknown
    }
  }

  /// Check if loan allows early payment
  static bool allowsEarlyPayment(int statusLoan) {
    return isActive(statusLoan) || isOverdue(statusLoan);
  }

  /// Check if loan allows extension
  static bool allowsExtension(int statusLoan) {
    return isOverdueLevel1(statusLoan) || isOverdueLevel2(statusLoan);
  }

  /// Get urgency level for notifications (1-5, higher = more urgent)
  static int getUrgencyLevel(int statusLoan) {
    if (isOverdueLevel3(statusLoan)) {
      return 5; // Critical - immediate action required
    } else if (isOverdueLevel2(statusLoan)) {
      return 4; // High - urgent action required
    } else if (isOverdueLevel1(statusLoan)) {
      return 3; // Medium - action needed soon
    } else if (isActive(statusLoan)) {
      return 2; // Low - normal monitoring
    } else if (isPaidOff(statusLoan)) {
      return 1; // Minimal - completed
    } else {
      return 0; // Unknown
    }
  }

  /// Debug helper to get readable status description
  static String getDebugStatusDescription(int statusLoan) {
    return _getStatusDescription(statusLoan);
  }

  /// Get readable status description
  static String _getStatusDescription(int statusLoan) {
    switch (statusLoan) {
      case ACTIVE:
        return 'ACTIVE';
      case PAID_OFF:
        return 'PAID_OFF';
      case OVERDUE_LEVEL_1:
        return 'OVERDUE_LEVEL_1';
      case OVERDUE_LEVEL_2:
        return 'OVERDUE_LEVEL_2';
      case OVERDUE_LEVEL_3:
        return 'OVERDUE_LEVEL_3';
      default:
        return 'UNKNOWN($statusLoan)';
    }
  }

  /// Get all valid statusLoan values
  static List<int> getAllValidStatuses() {
    return [
      ACTIVE,
      PAID_OFF,
      OVERDUE_LEVEL_1,
      OVERDUE_LEVEL_2,
      OVERDUE_LEVEL_3,
    ];
  }

  /// Validate if statusLoan value is valid
  static bool isValidStatus(int statusLoan) {
    return getAllValidStatuses().contains(statusLoan);
  }

  /// Get recommended action for status
  static String getRecommendedAction(int statusLoan) {
    if (isOverdueLevel3(statusLoan)) {
      return 'Contact customer immediately - critical overdue';
    } else if (isOverdueLevel2(statusLoan)) {
      return 'Send urgent payment reminder';
    } else if (isOverdueLevel1(statusLoan)) {
      return 'Send payment reminder';
    } else if (isActive(statusLoan)) {
      return 'Monitor payment schedule';
    } else if (isPaidOff(statusLoan)) {
      return 'Loan completed successfully';
    } else {
      return 'Review status - unknown state';
    }
  }
}
