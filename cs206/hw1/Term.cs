using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Homework1
{
    public class Term
    {
        public int Coef { get; set; }
        public int Deg { get; set; }

        public Term(int coef, int deg)
        {
            Coef = coef; Deg = deg;
        }

        /* Operation Methods */
        public Term Differentiate()
        {
            if (Deg == 0) return new Term(0, 0);
            return new Term(Coef * Deg, Deg - 1);
        }

        public static Term operator +(Term t1, Term t2)
        {
            if (t1.Deg != t2.Deg) return new Term(0, 0);
            return new Term(t1.Coef + t2.Coef, t1.Deg);
        }

        public static Term operator *(Term t1, Term t2)
        {
            return new Term(t1.Coef * t2.Coef, t1.Deg + t2.Deg);
        }

        /* Helper Methods */
        public override string ToString()
        {
            string str = "";
            str += Coef >= 0 ? "+" : "-";
            str += (Math.Abs(Coef) != 1 || Deg == 0) ? Math.Abs(Coef) + "" : "";
            str += Deg != 0 ? (Deg!= 1? "x^" +Deg : "x") : "";
            return str;
        }
    }
}
