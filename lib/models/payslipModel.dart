// class Product {
//   final String? id;
//   //Dấu chấm hỏi ? có thể chứa một giá trị kiểu String hoặc null => Đây là cách khai báo một biến có thể không có giá trị (nullable).
//   final String? name;
//   final String? price;
//   final String? desc;
//   final String? pimagePath;
// // hàm tạo (constructor)
//   Product({
//     this.id,
//     this.name,
//     this.price,
//     this.desc,
//     this.pimagePath,
//   });
// // phương thức factory
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       name: json['name'],
//       price: json['price'],
//       desc: json['desc'],
//       pimagePath: json['pimagePath'],
//     );
//   }
// }
class Payslip {
  final String? id;
  final String? basicSalary;
  final String? actualWork;
  final String? timeKPI;
  final String? jobKPI;
  final String? kraIncome;
  final String? overtime;
  final String? bonus;
  final String? otherPenalties;
  final String? incomeReceived;

  Payslip({
    this.id,
    this.basicSalary,
    this.actualWork,
    this.timeKPI,
    this.jobKPI,
    this.kraIncome,
    this.overtime,
    this.bonus,
    this.otherPenalties,
    this.incomeReceived,
  });

  factory Payslip.fromJson(Map<String, dynamic> json) {
    return Payslip(
      id: json['_id'],
      basicSalary: json['basicSalary'],
      actualWork: json['actualWork'],
      timeKPI: json['timeKPI'],
      jobKPI: json['jobKPI'],
      kraIncome: json['kraIncome'],
      overtime: json['overtime'],
      bonus: json['bonus'],
      otherPenalties: json['otherPenalties'],
      incomeReceived: json['incomeReceived'],
    );
  }
}
