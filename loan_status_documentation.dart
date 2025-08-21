/*
=== DOKUMENTASI LENGKAP STATUS VALUE DAN ARTINYA ===
EzLend Mobile App - Loan Status System

======================================================================
1. STATUS (Loan Application Status)
======================================================================

STATUS 0: PENDING REVIEW
- Arti: Permohonan pinjaman baru disubmit, menunggu review
- Display: "Pending" 
- Kombinasi: status=0 && statusloan=4
- Aksi: User menunggu approval dari admin

STATUS 1: UNDER REVIEW  
- Arti: Permohonan sedang dalam proses review
- Display: "Pending"
- Kombinasi: status=1 && statusloan=4
- Aksi: User menunggu keputusan

STATUS 2: REJECTED
- Arti: Permohonan pinjaman ditolak
- Display: "Reject" (warna merah)
- UI: Ada icon warning dan bisa tap untuk lihat alasan penolakan
- Field: rejectedCode berisi alasan penolakan

STATUS 3: APPROVED 
- Arti: Permohonan pinjaman disetujui
- Display: Bergantung pada statusloan
- Kombinasi: status=3 + berbagai statusloan

STATUS 10: PENDING APPROVAL
- Arti: Menunggu approval final
- Display: "Pending Approval"
- Kombinasi: status=10 && statusloan=4

======================================================================
2. STATUSLOAN (Loan Operational Status)
======================================================================

STATUSLOAN 4: ACTIVE
- Arti: Pinjaman aktif, perlu dibayar
- Kombinasi dengan status:
  * status=3 + statusloan=4 = "Active" (normal)
  * status=3 + statusloan=4 + blacklist=9 = "Overdue" 
  * status=0/1/10 + statusloan=4 = "Pending"

STATUSLOAN 5: CLOSED/COMPLETED
- Arti: Pinjaman sudah lunas/selesai
- Display: "Closed"
- Status: Loan sudah tidak aktif

STATUSLOAN 6: OVERDUE (Level 1)
- Arti: Pinjaman terlambat bayar (level ringan)
- Display: "Overdue" (warna merah)
- Kombinasi: status=3 + statusloan=6

STATUSLOAN 7: OVERDUE (Level 2)  
- Arti: Pinjaman terlambat bayar (level sedang)
- Display: "Overdue" (warna merah)
- Kombinasi: status=3 + statusloan=7

STATUSLOAN 8: OVERDUE (Level 3)
- Arti: Pinjaman terlambat bayar (level tinggi)
- Display: "Overdue" (warna merah)  
- Kombinasi: status=3 + statusloan=8

======================================================================
3. BLACKLIST STATUS
======================================================================

BLACKLIST 0: NORMAL
- Arti: User dalam kondisi normal, tidak ada masalah

BLACKLIST 9: BLACKLISTED/OVERDUE
- Arti: User masuk blacklist karena terlambat bayar
- Kombinasi: status=3 + statusloan=4 + blacklist=9 = "Overdue"
- Efek: Loan menjadi overdue meskipun statusloan=4

======================================================================
4. KOMBINASI STATUS LOGIC
======================================================================

OVERDUE CONDITIONS:
- status=3 + statusloan=6 (Overdue Level 1)
- status=3 + statusloan=7 (Overdue Level 2)  
- status=3 + statusloan=8 (Overdue Level 3)
- status=3 + statusloan=4 + blacklist=9 (Blacklisted)

ACTIVE CONDITIONS:
- status=3 + statusloan=4 + blacklist!=9

PENDING CONDITIONS:
- status=0 + statusloan=4 (New application)
- status=1 + statusloan=4 (Under review)
- status=10 + statusloan=4 (Pending approval)

REJECTED CONDITIONS:
- status=2 (Any statusloan)

COMPLETED CONDITIONS:
- status=3 + statusloan=5

======================================================================
5. UI DISPLAY MAPPING
======================================================================

Color Coding:
- GREEN: Active loans (normal payment)
- RED: Overdue loans (late payment)
- YELLOW/ORANGE: Pending loans (waiting approval)
- GRAY: Rejected/Closed loans

Text Display:
- "Active" → status=3 + statusloan=4 + blacklist!=9
- "Overdue" → Overdue conditions above
- "Pending" → Pending conditions above  
- "Pending Approval" → status=10
- "Reject" → status=2
- "Closed" → statusloan=5

======================================================================
6. BUSINESS RULES
======================================================================

LOAN ELIGIBILITY:
- User tidak bisa apply loan baru jika ada loan active/overdue
- Harus clear semua loan existing sebelum apply baru

BALANCE CALCULATION:
- Active loans (status=3 + statusloan=4,6,7,8) dihitung dalam total balance
- Menggunakan CheckLoan API untuk akurasi: loanamount - alreadypaid

PAYMENT LOGIC:
- Overdue loans prioritas bayar pertama
- Payment due date dihitung dari CheckDueDate API

MULTI-LOAN SUPPORT:
- User bisa memiliki multiple loans aktif bersamaan
- Setiap loan punya status independent
- Total balance = sum dari semua active loans

======================================================================
7. API ENDPOINTS TERKAIT
======================================================================

GET v1/member/loan/loan-package?statusloan=X
- Mengambil loans berdasarkan statusloan tertentu
- statusloan=4 → semua active/pending loans
- Tanpa parameter → semua loans

GET v1/member/loan/cek-loan?packageId=X
- CheckLoan untuk mendapatkan detail pembayaran
- Response: loanamount, alreadypaid, totalmustbepaid

GET v1/member/loan/cek-due-date?ic=X  
- Cek tanggal jatuh tempo pembayaran
- Response: duedate, status, statusloan

======================================================================
KESIMPULAN:
Status system menggunakan kombinasi 3 field:
1. status → Application approval status
2. statusloan → Operational loan status  
3. blacklist → User behavior status

Kombinasi ini menentukan display, behavior, dan business logic
di seluruh aplikasi EzLend.
*/

void main() {
  print("📋 Dokumentasi Status Value EzLend");
  print("Lihat isi file untuk detail lengkap semua status dan artinya");
}
