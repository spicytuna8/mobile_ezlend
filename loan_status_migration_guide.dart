/*
=== MIGRATION GUIDE: USING LOAN STATUS CONSTANTS ===

This guide shows how to refactor existing code to use the new LoanStatusConstants
and extensions instead of scattered magic numbers throughout the codebase.

======================================================================
BENEFITS OF USING CONSTANTS:
======================================================================

✅ NO MORE MAGIC NUMBERS: All status values are centralized
✅ TYPE SAFETY: Compile-time checking of status values
✅ EASY MAINTENANCE: Change logic in one place
✅ BETTER READABILITY: Self-documenting code
✅ CONSISTENCY: Same logic used everywhere
✅ TESTING: Easier to unit test status logic

======================================================================
STEP 1: IMPORT THE CONSTANTS
======================================================================

// Add these imports to your files:
import 'package:loan_project/helper/loan_status_constants.dart';
import 'package:loan_project/helper/loan_status_extensions.dart';

======================================================================
STEP 2: REFACTOR STATUS CHECKING
======================================================================

// BEFORE (magic numbers):
if (loan.status == 3 && loan.statusloan == 4 && loan.blacklist != 9) {
  // loan is active
}

// AFTER (using constants):
if (loan.isActiveAndApproved) {
  // loan is active
}

// BEFORE (complex overdue checking):
bool isOverdue = loan.status == 3 &&
    (loan.statusloan == 7 ||
     loan.statusloan == 6 ||
     loan.statusloan == 8 ||
     (loan.statusloan == 4 && loan.blacklist == 9));

// AFTER (using extension):
bool isOverdue = loan.isOverdue;

======================================================================
STEP 3: REFACTOR LOAN FILTERING
======================================================================

// BEFORE (repeated logic):
List<DatumLoan> activeLoans = loans.where((loan) =>
    loan.status == 3 &&
    (loan.statusloan == 4 || loan.statusloan == 6 || 
     loan.statusloan == 7 || loan.statusloan == 8)
).toList();

// AFTER (using extension):
List<DatumLoan> activeLoans = loans.loansForBalanceCalculation;

// BEFORE (manual overdue filtering):
List<DatumLoan> overdueLoans = loans.where((loan) =>
    loan.status == 3 &&
    (loan.statusloan == 7 || loan.statusloan == 6 || 
     loan.statusloan == 8 || 
     (loan.statusloan == 4 && loan.blacklist == 9))
).toList();

// AFTER (using extension):
List<DatumLoan> overdueLoans = loans.overdueLoans;

======================================================================
STEP 4: REFACTOR STATUS TEXT LOGIC
======================================================================

// BEFORE (multiple if-else):
String getStatusText(DatumLoan loan) {
  if (loan.status == 3 && loan.statusloan == 7) {
    return Languages.of(context).overdue;
  } else if (loan.status == 3 && loan.statusloan == 4) {
    return Languages.of(context).active;
  } else if (loan.status == 0 || loan.status == 1) {
    return Languages.of(context).pending;
  }
  // ... more conditions
}

// AFTER (using extension + constants):
String getStatusText(DatumLoan loan) {
  String key = loan.statusTextKey;
  switch (key) {
    case 'overdue': return Languages.of(context).overdue;
    case 'active': return Languages.of(context).active;
    case 'pending': return Languages.of(context).pending;
    case 'reject': return Languages.of(context).reject;
    case 'closed': return Languages.of(context).closed;
    default: return Languages.of(context).pending;
  }
}

======================================================================
STEP 5: REFACTOR BUSINESS LOGIC
======================================================================

// BEFORE (complex eligibility checking):
bool canApplyForNewLoan(List<DatumLoan> loans) {
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

// AFTER (using extension):
bool canApplyForNewLoan(List<DatumLoan> loans) {
  return loans.canApplyForNewLoan;
}

======================================================================
STEP 6: REFACTOR UI CONDITIONAL LOGIC
======================================================================

// BEFORE (widget building with magic numbers):
Widget buildLoanStatusBadge(DatumLoan loan) {
  Color badgeColor;
  String badgeText;
  
  if (loan.status == 3 && 
      (loan.statusloan == 7 || loan.statusloan == 6 || 
       loan.statusloan == 8 || 
       (loan.statusloan == 4 && loan.blacklist == 9))) {
    badgeColor = Colors.red;
    badgeText = 'Overdue';
  } else if (loan.status == 3 && loan.statusloan == 4) {
    badgeColor = Colors.green;
    badgeText = 'Active';
  }
  // ... more conditions
}

// AFTER (using extensions):
Widget buildLoanStatusBadge(DatumLoan loan) {
  Color badgeColor;
  String badgeText;
  
  if (loan.isOverdue) {
    badgeColor = Colors.red;
    badgeText = 'Overdue';
  } else if (loan.isActiveAndApproved) {
    badgeColor = Colors.green;
    badgeText = 'Active';
  } else if (loan.isPendingApplication) {
    badgeColor = Colors.orange;
    badgeText = 'Pending';
  }
  // Much cleaner and readable!
}

======================================================================
STEP 7: FILES TO REFACTOR
======================================================================

High Priority Files (contains lots of status logic):
1. lib/screen/repayment/repayment_screen.dart
2. lib/screen/loan/my_loan_screen.dart
3. lib/screen/home_screen.dart
4. lib/widget/ui_history_loan_item.dart
5. lib/screen/repayment/loan_detail_screen.dart

Medium Priority Files:
6. lib/screen/loan/loan_screen.dart
7. lib/screen/loan/loan_apply_screen.dart
8. lib/widget/ui_active.dart

======================================================================
STEP 8: SEARCH AND REPLACE PATTERNS
======================================================================

Search for these patterns and replace:

1. "loan.status == 3" → Use appropriate extension method
2. "loan.statusloan == 4" → Use LoanStatusConstants.STATUSLOAN_ACTIVE
3. "loan.statusloan == 7" → Use LoanStatusConstants.STATUSLOAN_OVERDUE_LEVEL_2
4. "loan.blacklist == 9" → Use loan.isBlacklisted
5. Complex status combinations → Use extension methods

======================================================================
STEP 9: TESTING THE REFACTORING
======================================================================

After refactoring, test these scenarios:
✅ Active loans display correctly
✅ Overdue loans show red badge
✅ Pending loans show pending status
✅ Balance calculation works
✅ New loan application blocking works
✅ Loan sorting works correctly

======================================================================
EXAMPLE: COMPLETE REFACTORING
======================================================================

// BEFORE (repayment_screen.dart excerpt):
bool isLoanOverdue(DatumLoan loan) {
  return loan.status == 3 &&
      (loan.statusloan == 7 ||
          loan.statusloan == 6 ||
          loan.statusloan == 8 ||
          (loan.statusloan == 4 && loan.blacklist == 9));
}

List<DatumLoan> getActiveLoans() {
  return listLoan.where((loan) =>
      loan.status == 3 &&
      (loan.statusloan == 4 || loan.statusloan == 6 || 
       loan.statusloan == 7 || loan.statusloan == 8)
  ).toList();
}

double calculateTotalBalance() {
  double total = 0.0;
  for (DatumLoan loan in getActiveLoans()) {
    // calculation logic
  }
  return total;
}

// AFTER (refactored):
// Remove isLoanOverdue method - use loan.isOverdue directly

List<DatumLoan> getActiveLoans() {
  return listLoan.loansForBalanceCalculation;
}

double calculateTotalBalance() {
  double total = 0.0;
  for (DatumLoan loan in getActiveLoans()) {
    // same calculation logic
  }
  return total;
}

// Usage in UI:
Widget buildLoanItem(DatumLoan loan) {
  return Container(
    decoration: BoxDecoration(
      border: loan.isOverdue 
          ? Border.all(color: Colors.red) 
          : null,
    ),
    child: Column(
      children: [
        Text(loan.packageName ?? ''),
        if (loan.isOverdue) 
          Text('OVERDUE', style: TextStyle(color: Colors.red)),
        if (loan.isActiveAndApproved)
          Text('ACTIVE', style: TextStyle(color: Colors.green)),
      ],
    ),
  );
}

This refactoring makes the code much more maintainable and readable!
*/

void main() {
  print('📚 Loan Status Constants Migration Guide');
  print('See file content for complete refactoring instructions');
}
