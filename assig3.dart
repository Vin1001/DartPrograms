void main() {
  List<Employee> emp = [
    Employee("ABC", 5000),
    Employee("CBD", 6000),
    Employee("Arthur", 7000),
    Employee("Benedict", 12000),
    Employee("Clive", 10000),
    Employee("Adler", 10000)
  ];

  // Query 1: select all the employees with salary>9000
  List<Employee> Q1 = emp.where((e) => e.salary! > 9000).toList();
  Q1.forEach((element) {
    element.Details();
  });

  //Query 2: Show the total expenditure on salaries
  dynamic total = emp.fold(
      0, (dynamic previousValue, element) => previousValue += element.salary!);

  print("Total Expenditure: \$${total}");

  //Query 3: Filter all the employees whose names start with "A"

  emp.removeWhere((element) => element.name!.substring(0, 1) == "A");
  emp.forEach((element) {
    element.Details();
  });
}

class Employee {
  String? name;
  int? salary;

  Employee(this.name, this.salary);

  void Details() {
    print("""Name: ${name}
Salary: \$${salary}\n""");
  }
}
