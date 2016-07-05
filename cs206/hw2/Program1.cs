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
            while (true)
            {
                Console.Write("Enter arithmetic expression(q to exit): ");
                string str = Console.ReadLine();
                if (str == "q" || str == "Q") return;
                try
                {
                    Console.WriteLine(str + "=" + evaluate(str));
                }
                catch(Exception e)
                {
                    Console.WriteLine("Invalid Expression. Detail Info: " + e.Message);
                }
                Console.WriteLine();
            }
        }

        enum Operator { Add = 1, Minus, Multiply, Divide };

        static int evaluate(string str)
        {
            IntStack vs = new IntStack(1000), os = new IntStack(1000);
            int p = 0;
            str = str.Replace("(-", "(0-");
            while (p < str.Length)
            {
                if (str[p] == '(' || char.IsWhiteSpace(str[p]))
                    p++;
                else if (str[p] == ')')
                {
                    int b = vs.Pop(), a = vs.Pop();
                    switch ((Operator)os.Pop())
                    {
                        case Operator.Add:
                            vs.Push(a + b); break;
                        case Operator.Minus:
                            vs.Push(a - b); break;
                        case Operator.Multiply:
                            vs.Push(a * b); break;
                        case Operator.Divide:
                            vs.Push((int)(a / b)); break;
                    }
                    p++;
                }
                else if (str[p] == '+' || str[p] == '-' || str[p] == '*' || str[p] == '/')
                {
                    switch (str[p])
                    {
                        case '+':
                            os.Push((int)Operator.Add); break;
                        case '-':
                            os.Push((int)Operator.Minus); break;
                        case '*':
                            os.Push((int)Operator.Multiply); break;
                        case '/':
                            os.Push((int)Operator.Divide); break;
                    }
                    p++;
                }
                else if (char.IsDigit(str[p]))
                {
                    int sp = p;
                    while (p < str.Length && char.IsDigit(str[p]))
                        p++;

                    int num = int.Parse(str.Substring(sp, p - sp));
                    vs.Push(num);
                }
                else
                    throw new Exception("Invalid Character '" + str[p] + "'");
            }

            if (vs.Count != 1 || os.Count != 0) throw new Exception("Not Fully Parenthesized");
            return vs.Pop();
        }
    }
}
