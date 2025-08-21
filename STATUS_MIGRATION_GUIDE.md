# Migration Guide: StatusHelper Classes

This guide helps you migrate from the single `LoanStatusConstants` class to the new separated `StatusHelper` and `StatusLoanHelper` classes.

## Migration Overview

### OLD STRUCTURE (Single Class):
```
lib/helper/loan_status_constants.dart
├── LoanStatusConstants
    ├── STATUS_* constants (application status)
    ├── STATUSLOAN_* constants (operational status)  
    ├── BLACKLIST_* constants
    └── Mixed helper methods
```

### NEW STRUCTURE (Separated Classes):
```
lib/helper/status_helper.dart
├── StatusHelper
    ├── Application status constants (PENDING_REVIEW, APPROVED, etc.)
    ├── Blacklist constants
    └── Application-related helper methods

lib/helper/status_loan_helper.dart
├── StatusLoanHelper
    ├── Operational status constants (ACTIVE, OVERDUE_LEVEL_1, etc.)
    └── Loan operation helper methods

lib/helper/loan_status_extensions_new.dart
├── DatumLoanStatusExtension (individual loan methods)
└── DatumLoanListExtension (list operations)
```

## Step-by-Step Migration

### 1. Update Imports

**OLD:**
```dart
import 'package:loan_project/helper/loan_status_constants.dart';
```

**NEW:**
```dart
import 'package:loan_project/helper/status_helper.dart';
import 'package:loan_project/helper/status_loan_helper.dart';
// Optional: for extension methods
import 'package:loan_project/helper/loan_status_extensions_new.dart';
```

### 2. Update Constant References

| OLD Constants | NEW Constants |
|---------------|---------------|
| `LoanStatusConstants.STATUS_PENDING_REVIEW` | `StatusHelper.PENDING_REVIEW` |
| `LoanStatusConstants.STATUS_APPROVED` | `StatusHelper.APPROVED` |
| `LoanStatusConstants.STATUSLOAN_ACTIVE` | `StatusLoanHelper.ACTIVE` |
| `LoanStatusConstants.STATUSLOAN_OVERDUE_LEVEL_1` | `StatusLoanHelper.OVERDUE_LEVEL_1` |
| `LoanStatusConstants.BLACKLIST_NORMAL` | `StatusHelper.BLACKLIST_NORMAL` |

### 3. Update Method Calls

**Application Status Methods:**
```dart
// OLD
LoanStatusConstants.isApproved(status)
// NEW  
StatusHelper.isApproved(status)

// OLD
LoanStatusConstants.isBlacklisted(blacklist)
// NEW
StatusHelper.isBlacklisted(blacklist)
```

**Operational Status Methods:**
```dart
// OLD
LoanStatusConstants.isActive(statusloan)
// NEW
StatusLoanHelper.isActive(statusloan)

// OLD
LoanStatusConstants.isOverdue(statusloan)
// NEW
StatusLoanHelper.isOverdue(statusloan)
```

### 4. Use Extension Methods (Recommended)

**OLD:**
```dart
if (StatusHelper.isApproved(loan.status) && StatusLoanHelper.isActive(loan.statusloan)) {
  // Do something
}
```

**NEW:**
```dart
if (loan.isActiveAndApproved()) {
  // Do something
}
```

## Migration Examples

### Example 1: Status Checking

**OLD CODE:**
```dart
import 'package:loan_project/helper/loan_status_constants.dart';

bool checkLoanStatus(DatumLoan loan) {
  if (LoanStatusConstants.isApproved(loan.status ?? 0) && 
      LoanStatusConstants.isActive(loan.statusloan ?? 0) &&
      !LoanStatusConstants.isBlacklisted(loan.blacklist ?? 0)) {
    return true;
  }
  return false;
}
```

**NEW CODE:**
```dart
import 'package:loan_project/helper/loan_status_extensions_new.dart';

bool checkLoanStatus(DatumLoan loan) {
  return loan.isActiveAndApproved();
}
```

### Example 2: List Operations

**OLD CODE:**
```dart
List<DatumLoan> getOverdueLoans(List<DatumLoan> loans) {
  return loans.where((loan) {
    return LoanStatusConstants.isOverdue(loan.statusloan ?? 0);
  }).toList();
}
```

**NEW CODE:**
```dart
List<DatumLoan> getOverdueLoans(List<DatumLoan> loans) {
  return loans.whereOverdue();
}
```

## Benefits of New Structure

1. **Better Separation of Concerns** - Application vs operational status logic
2. **Cleaner Code** - Extension methods provide intuitive API
3. **Better Performance** - Direct method calls, no multiple parameters
4. **Enhanced Functionality** - More granular control and helper methods
5. **Future-Proof** - Easier to extend and maintain

## Files to Update

Typically these files need updates:
- `lib/screen/repayment/*.dart`
- `lib/bloc/*bloc.dart` 
- `lib/widget/*` (where loan status is displayed)
- `test/*` (unit tests)

## Testing Migration

1. Search and replace all imports
2. Update constant references 
3. Test critical loan status flows
4. Verify UI displays correctly
5. Run unit tests
6. Check extension method usage
