using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Program
{
    public class IntStack
    {
        public int Count { get; private set; }
        private int[] data;

        public IntStack(int size = 40)
        {
            if (size < 1) throw new Exception("Invalid Stack Size");

            Count = 0;
            data = new int[size];
        }

        public void Push(int item)
        {
            if (Count == data.Length) throw new Exception("Stack Overflow");
            data[Count++] = item;
        }

        public int Pop()
        {
            if (Count == 0) throw new Exception("Stack Underflow");
            return data[--Count];
        }
    }
}
