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
            STelBook telbook = new STelBook();
            while (true)
            {
                Console.Write("TelBook: ");
                string input = Console.ReadLine().ToLower();
                string[] command = input.Split(new char[] { ' ' });
                try
                {
                    switch (command[0])
                    {
                        case "add":
                            Console.Write("> ");
                            telbook.AddTel(Console.ReadLine());
                            Console.WriteLine("Telephone number has been successfully added.");
                            break;
                        case "remove":
                            Console.Write("> ");
                            telbook.RemoveTel(Console.ReadLine());
                            Console.WriteLine("Telephone number has been removed.");
                            break;
                        case "creategroup":
                            Console.Write("> ");
                            string str = Console.ReadLine();
                            telbook.CreateGroup(str);
                            Console.WriteLine("Group [" + str + "] has been successfully created.");
                            break;
                        case "showall":
                            Console.Write(telbook.GetAll());
                            break;
                        case "showgroup":
                            if (command.Length < 2)
                                throw new Exception("Command [showgroup] need one argument.");
                            Console.Write(telbook.GetGroup(command[1]));
                            break;
                        case "f":
                            if (command.Length < 2)
                                throw new Exception("Command [f] need one argument.");
                            Console.Write(telbook.Find(command[1]));
                            break;
                        case "q":
                        case "exit":
                            return;
                        default:
                            Console.WriteLine("Command is not allowed.");
                            break;
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }
                Console.WriteLine();
            }
        }
    }
}
