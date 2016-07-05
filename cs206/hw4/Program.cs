using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Program
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = 0;
            while (true) {
                Console.Write("Enter number of disks: ");
                string input = Console.ReadLine();
                if (input == "q" || input == "Q") break;

                if (int.TryParse(input, out n) && n > 0)
                    hanoi(n, 1, 3);
                else
                    Console.WriteLine("Input is not number or not positive");
                Console.WriteLine();
            }
        }

        private static void hanoi(int n, int start, int end)
        {
            if (n == 1)
                Console.WriteLine("Moving Disk[1] from " + start + " to " + end + "...");
            else
            {
                int middle = 6 - start - end;
                hanoi(n - 1, start, middle);
                Console.WriteLine("Moving Disk[" + n + "] from " + start + " to " + end + "...");
                hanoi(n - 1, middle, end);
            }
        }
    }
}
