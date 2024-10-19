using System;

public class main {
    public static void Main(String[] args) {
        System.IO.Stream stdin = Console.OpenStandardInput();
        System.IO.Stream stdout = Console.OpenStandardOutput();
        try {
            stdin.CopyTo(stdout);
        } catch(Exception e) {
            Console.Error.WriteLine("Failed to copy input to output: " + e.Message);
        }
    }
}
