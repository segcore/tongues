import 'dart:io';

void main() async {
  // None of these stop on <C-d> (EOF). Strange.

  // stdin is a Stream<List<int>> ? Is a character a list of ints? a list of bytes?
  await stdin.pipe(stdout);

  // stdin.forEach((x) => {
  //   stdout.add(x)
  // });
}
