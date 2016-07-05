using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Program
{
    public class DGroup
    {
        public readonly string Name;
        public DGroup Prev { get; set; }
        public DGroup Next { get; set; }
        private DTelNode head;
        private DTelNode rear;

        public DGroup(string name, DGroup prev, DGroup next)
        {
            Name = name;
            Prev = prev;
            Next = next;
            head = new DTelNode(new Telephone("HEAD", "", ""), null, null);
            rear = new DTelNode(new Telephone("REAR", "", ""), null, null);
            head.Next = rear;
            rear.Prev = head;
        }

        public void AddTel(Telephone tel)
        {
            DTelNode node = new DTelNode(tel, head, head.Next);
            head.Next.Prev = node;
            head.Next = node;
        }

        public bool RemoveTel(string number)
        {
            DTelNode node = head.Next;
            while (node != rear)
            {
                if (node.Tel.Number == number)
                {
                    node.Prev.Next = node.Next;
                    node.Next.Prev = node.Prev;
                    return true;
                }
                node = node.Next;
            }
            return false;
        }

        public bool ExistTel(string tel)
        {
            DTelNode node = head.Next;
            while (node != rear)
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
            DTelNode node = head.Next;
            while (node != rear)
            {
                if (all || (node.Tel.Name.ToLower() == name.ToLower()))
                    result += node.Tel + "\r\n";
                node = node.Next;
            }
            return result;
        }

    }
}
