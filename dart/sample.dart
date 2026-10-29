import 'dart:math';
import 'dart:io';

void main(List<String> args) {
  print("Hello, world!");
  print("Your arguments are $args");

  var name = "hello";
  var list = ['Aaa', 'bbb', 5];

  for (int i = 0; i < 10; i++) {
    print(i);
  }
  const input = 5;
  print("fibonnaci of $input is ${fibonnaci(5)}");
  print("fibonnaci2 of $input is ${fibonnaci2(5)}");

  // These all implicitly get null, despite no return values existing
  var x, y, z = mynoreturn();
  print("$x, $y, $z");
}

int fibonnaci(int n) {
  if (n <= 1) return 1;
  return n * fibonnaci(n - 1);
}

// who knows what type are return values I have? not me!
fibonnaci2(n) {
  // Now with runtime checks, instead of compile time checks
  if (n <= 1) return 1;
  // n + "a"; // runtime exception
  return n * fibonnaci(n - 1);
}

// Named `max` default null
int fibonnaci3(int n, {int? max}) {
  if (n <= 1) return 1;
  if (max != null && n >= max) n = max;
  return n * fibonnaci(n - 1);
}

// Optional positional parameters
int fibonnaci4(int n, [int? max]) {
  if (n <= 1) return 1;
  if (max != null && n >= max) n = max;
  return n * fibonnaci(n - 1);
}

mynoreturn() {}

enum Kind { Bad, Good }

enum Thing {
  GoodThing(kind: Kind.Good, value: 42),
  BadThing(kind: Kind.Bad, value: 12);

  // {} makes them named parameters. `required` means they cannot be defaulted (and removes the default `null` assignment and type)
  const Thing({required this.kind, required this.value});

  final Kind kind;
  final int value;
}
