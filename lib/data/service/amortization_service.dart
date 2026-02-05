import '../../domain/model/amortization_table_model.dart';

class AmortizationResult {
  final List<AmortizationTableModel> table;
  final double totalInterest;
  final double totalPaid;
  final int months;

  AmortizationResult({
    required this.table,
    required this.totalInterest,
    required this.totalPaid,
    required this.months,
  });
}

class AmortizationService {
  static AmortizationResult calculate({
    required double principal,
    required double annualRate,
    required double emi,
    required int maxMonths,
    double? monthlyPrepayment,
  }) {
    final List<AmortizationTableModel> table = [];
    final monthlyRate = annualRate / 12 / 100;

    double balance = principal;
    double totalInterest = 0;
    double totalPaid = 0;

    for (int month = 1; month <= maxMonths && balance > 0; month++) {
      final interest = balance * monthlyRate;
      double principalFromEmi = emi - interest;

      if (principalFromEmi > balance) {
        principalFromEmi = balance;
      }

      balance -= principalFromEmi;

      double extra = monthlyPrepayment ?? 0;
      if (extra > balance) extra = balance;
      balance -= extra;

      final actualEmi = interest + principalFromEmi;

      totalInterest += interest;
      totalPaid += actualEmi + extra;

      table.add(
        AmortizationTableModel(
          period: month.toDouble(),
          emi: actualEmi,
          interest: interest,
          principleAmount: principalFromEmi + extra,
          balance: balance,
        ),
      );
    }

    return AmortizationResult(
      table: table,
      totalInterest: totalInterest,
      totalPaid: totalPaid,
      months: table.length,
    );
  }
}
