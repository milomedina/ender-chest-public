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
            Polynomial p;
			while(true)
			{
				Console.Write("Enter polynomial(q to exit): ");
				string str = Console.ReadLine();
				if (str == "q" || str == "Q") return;
                try
                {
                    p = Polynomial.Create(str).Simplify();
                    Console.WriteLine("p(x) = " + p.ToString());
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
