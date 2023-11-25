class DailySalesReportEntry {
  final String? date;
  final double? dailyTotal;
  final double? dailyCost;
  final double? dailyProfit;
  final double? profitPercentage;

  DailySalesReportEntry({
    this.date,
    this.dailyTotal,
    this.dailyCost,
    this.dailyProfit,
    this.profitPercentage,
  });

  factory DailySalesReportEntry.fromJson(Map<String, dynamic> json) {
    return DailySalesReportEntry(
      date: json['date'],
      dailyTotal: json['dailyTotal'],
      dailyCost: json['dailyCost'],
      dailyProfit: json['dailyProfit'],
      profitPercentage: json['profitPercentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'dailyTotal': dailyTotal,
      'dailyCost': dailyCost,
      'dailyProfit': dailyProfit,
      'profitPercentage': profitPercentage,
    };
  }

  DailySalesReportEntry copyWith({
    String? date,
    double? dailyTotal,
    double? dailyCost,
    double? dailyProfit,
    double? profitPercentage,
  }) {
    return DailySalesReportEntry(
      date: date ?? this.date,
      dailyTotal: dailyTotal ?? this.dailyTotal,
      dailyCost: dailyCost ?? this.dailyCost,
      dailyProfit: dailyProfit ?? this.dailyProfit,
      profitPercentage: profitPercentage ?? this.profitPercentage,
    );
  }
}

class MenuItemSalesReport {
  String? salesDay;
  double? quantitySold;
  double? totalAmount;
  double? totalCost;
  double? totalProfit;
  double? profitPercentage;

  MenuItemSalesReport(
      {this.salesDay,
      this.quantitySold,
      this.totalAmount,
      this.totalCost,
      this.totalProfit,
      this.profitPercentage
      });


  factory MenuItemSalesReport.fromJson(Map<String, dynamic> json) {
    return MenuItemSalesReport(
      salesDay: json['salesDay'],
      quantitySold: json['quantitySold'],
      totalAmount: json['totalAmount'],
      totalCost: json['totalCost'],
      totalProfit: json['totalProfit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salesDay': salesDay,
      'quantitySold': quantitySold,
      'totalAmount': totalAmount,
      'totalCost': totalCost,
      'totalProfit': totalProfit,
    };
  }

  MenuItemSalesReport copyWith({
    String? salesDay,
    double? quantitySold,
    double? totalAmount,
    double? totalCost,
    double? totalProfit,
  }) {
    return MenuItemSalesReport(
      salesDay: salesDay ?? this.salesDay,
      quantitySold: quantitySold ?? this.quantitySold,
      totalAmount: totalAmount ?? this.totalAmount,
      totalCost: totalCost ?? this.totalCost,
      totalProfit: totalProfit ?? this.totalProfit,
    );
  }

  @override
  String toString() {
    return 'MenuItemSalesReport{salsDay: $salesDay, quantitySold: $quantitySold, totalAmount: $totalAmount, totalCost: $totalCost, totalProfit: $totalProfit}';
  }
}
