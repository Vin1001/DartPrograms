void main() {
  var student1 = Student(
      rollno: 090,
      name: "Vinayak",
      branch: "AI-DS",
      marks: {"DSA": 89, "OOPS": 78, "CN": 74});

  student1.showMarks();
  student1.showPercentage();
  student1.showMarksheet();
}

class Student {
  int? rollno;
  String? name;
  String? branch;
  Map<String, double>? marks;

  Student({this.rollno, this.name, this.branch, this.marks});

  double _getMarks() {
    double sum = 0;
    for (double m in this.marks!.values.toList()) {
      sum = sum + m;
    }
    //print("Total Marks: ${sum}/${(this.marks!.values.toList().length) * 100}");
    return sum;
  }

  double _getPercentage() {
    double total = this._getMarks();

    return (total / ((this.marks!.values.toList().length) * 100)) * 100;
  }

  void showMarks() {
    print(
        "Total Marks: ${this._getMarks()}/${(this.marks!.values.toList().length) * 100}");
  }

  void showPercentage() {
    print("Percentage: ${this._getPercentage()}%");
  }

  void showMarksheet() {
    print("""\nName: ${this.name}
Rollno: ${this.rollno}
Branch: ${this.branch}\n""");
    this.marks!.forEach((key, value) {
      print("${key}: ${value}/100\n");
    });
  }
}
