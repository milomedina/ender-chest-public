using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Program
{
    public class SGroup
    {
        public readonly string Name;
        public SGroup Next { get; set; }
        private STelNode head;

        public SGroup(string name, SGroup next)
        {
            Name = name;
            Next = next;
            head = new STelNode(new Telephone("HEAD", "", ""), null);
        }

        public void AddTel(Telephone tel)
        {
            head.Next = new STelNode(tel, head.Next);
        }

        public bool RemoveTel(string number)
        {
            STelNode node = head;
            while (node.Next != null)
            {
                if (node.Next.Tel.Number == number)
                {
                    node.Next = node.Next.Next;
                    return true;
                }
                node = node.Next;
            }
            return false;
        }

        public bool ExistTel(string tel)
        {
            STelNode node = head.Next;
            while (node != null)
            {
                if (node.Tel.Number == tel)
                    return true;
                node = node.Next;
            }
            return false;
        }

        public string FindTel(bool all, string name = "")
        {
            string result = "";
            STelNode node = head.Next;
            while (node != null)
            {
                if (all || (node.Tel.Name.ToLower() == name.ToLower()))
                    result += node.Tel + "\r\n";
                node = node.Next;
            }
            return result;
        }

    }
}
