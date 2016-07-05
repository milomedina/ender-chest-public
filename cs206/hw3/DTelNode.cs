using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Program
{
    public class DTelNode
    {
        public Telephone Tel { get; set; }
        public DTelNode Prev { get; set; }
        public DTelNode Next { get; set; }

        public DTelNode(Telephone tel, DTelNode prev, DTelNode next)
        {
            Tel = tel; Prev = prev; Next = next;
        }
    }
}
