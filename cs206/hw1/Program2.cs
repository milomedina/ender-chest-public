using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Homework1
{
    class Program
    {
        static void Main(string[] args)
        {
            Polynomial p1, p2;
			while(true)
			{
				Console.Write("Choose Operation (Add = 1, Multi = 2, Diff = 3, Exit = q): ");
				string str = Console.ReadLine();
                switch (str)
                {
                    case "q":
                    case "Q":
                        return;
                    case "1":
                        p1 = inputPoly();
                        p2 = inputPoly();
                        Console.WriteLine("p1(x) = " + p1.ToString());
                        Console.WriteLine("p2(x) = " + p2.ToString());
                        Console.WriteLine("p1(x) + p2(x) = " + p1.Add(p2).ToString()); break;
                    case "2":
                        p1 = inputPoly();
                        p2 = inputPoly();
                        Console.WriteLine("p1(x) = " + p1.ToString());
                        Console.WriteLine("p2(x) = " + p2.ToString());
                        Console.WriteLine("p1(x) * p2(x) = " + p1.Multiply(p2).ToString()); break;
                    case "3":
                        p1 = inputPoly();
                        Console.WriteLine("p(x) = " + p1.ToString());
                        Console.WriteLine("p'(x) = " + p1.Differentiate().ToString()); break;
                    default:
                        Console.WriteLine("Invalid Operation"); break;
                }
				Console.WriteLine();
			}
        }

        private static Polynomial inputPoly()
        {
            while (true)
            {
                Console.Write("Enter polynomial: ");
                string str = Console.ReadLine();
                try
                {
                    return Polynomial.Create(str).Simplify();
                }
                catch
                {
                    Console.WriteLine("Invalid Polynomial");
                }
                Console.WriteLine();
            }
        }
    }
}
