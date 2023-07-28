//import 'dart:io';

void main() {
  List<Laptop> Lappys = [
    Laptop(1101, "Dell", "8GB"),
    Laptop(1102, "hp", "6GB"),
    Laptop(1103, "Alienware", "16GB")
  ];

  Lappys.forEach((laptop) {
    laptop.printDetails();
  });
}

class Laptop {
  int? id;
  String? name;
  String? RAM;

  Laptop(this.id, this.name, this.RAM);

  void printDetails() {
    print("""Laptop ID: $id
Laptop name: $name
RAM: $RAM \n""");
  }
}
