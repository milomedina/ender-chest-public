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
                Console.Write("Enter reservation data(q to exit): ");
                string str = Console.ReadLine();
                if (str == "q" || str == "Q") return;
                try
                {
                    Console.WriteLine("Reservation Order: " + getReservation(str));
                }
                catch (Exception e)
                {
                    Console.WriteLine("Invalid Data. Detail Info: " + e.Message);
                }
                Console.WriteLine();
            }
        }

        static string getReservation(string str)
        {
            ReservationQueue q = new ReservationQueue(1000);
            string[] arr = str.Split(new char[] { ')' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (string s in arr)
            {
                string[] dt = s.Substring(1).Split(new char[] { ',' });
                if (dt.Length != 2) throw new Exception(s + ") is invalid");
                q.Enqueue(dt[0].Replace("\"", ""), int.Parse(dt[1]));
            }
            string list = "";
            while (q.Count > 0)
                list += q.Dequeue();
            return list;
        }
    }
}
