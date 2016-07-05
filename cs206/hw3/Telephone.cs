using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Program
{
    public class Telephone
    {
        public readonly string Number;
        public readonly string Name;
        public readonly string Group;

        public Telephone(string number, string name, string group)
        {
            Number = number; Name = name; Group = group;
        }

        public static explicit operator Telephone(string str)
        {
            string[] sp = str.Split(new char[] { ':' });
            if (sp.Length != 3)
                throw new Exception("Given input format is not correct.");
            return new Telephone(sp[0], sp[1], sp[2]);
        }

        public override string ToString()
        {
            return Name + " " + Group + " " + Number;
        }
    }
}
