using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Homework1
{
    public class Polynomial
    {
        private List<Term> terms = new List<Term>();

        public Polynomial(List<Term> terms)
        {
            this.terms = terms;
        }

        public static Polynomial Create(string str)
        {
            List<Term> terms = new List<Term>();
            string[] sp = str.Split(new char[] { ' ' });
            if (sp.Length % 2 != 0) throw new ArgumentOutOfRangeException();
            for (int i = 0; i < sp.Length; i += 2)
                terms.Add(new Term(int.Parse(sp[i]), int.Parse(sp[i + 1])));
            return new Polynomial(terms);
        }

        /* Operation Methods */
        public Polynomial Add(Polynomial p)
        {
            return this + p;
        }

        public Polynomial Multiply(Polynomial p)
        {
            return this * p;
        }

        public Polynomial Differentiate()
        {
            List<Term> newTerms = new List<Term>();
            foreach (Term t in terms)
                newTerms.Add(t.Differentiate());
            return new Polynomial(newTerms).Simplify(); 
        }

        public static Polynomial operator +(Polynomial p1, Polynomial p2)
        {
            return new Polynomial(p1.GetTerms().Concat(p2.GetTerms()).ToList()).Simplify();
        }

        public static Polynomial operator *(Polynomial p1, Polynomial p2)
        {
            List<Term> newTerms = new List<Term>();
            List<Term> p1Terms = p1.GetTerms(), p2Terms = p2.GetTerms();
            foreach (Term p1t in p1Terms)
                foreach (Term p2t in p2Terms)
                    newTerms.Add(p1t * p2t);
            return new Polynomial(newTerms).Simplify();
        }

        /* Helper Methods */
        public Polynomial Simplify()
        {
            if (terms.Count == 0) return this;
            List<Term> tmpTerms = terms.OrderByDescending(term => term.Deg).ToList();
            List<Term> newTerms = new List<Term>();
            Term tmp = null;
            foreach (Term t in tmpTerms)
            {
                if (tmp == null)
                    tmp = t;
                else if (tmp.Deg == t.Deg)
                    tmp += t;
                else
                {
                    newTerms.Add(tmp);
                    tmp = t;
                }
            }
            newTerms.Add(tmp);
            newTerms.RemoveAll(term => term.Coef == 0);
            return new Polynomial(newTerms);
        }

        public List<Term> GetTerms()
        {
            return terms;
        }

        public override string ToString()
        {
            if (terms.Count == 0) return "0";
            string str = "";
            foreach (Term t in terms)
                str += t.ToString();
            return str[0] == '+' ? str.Substring(1) : str;
        }
    }
}
