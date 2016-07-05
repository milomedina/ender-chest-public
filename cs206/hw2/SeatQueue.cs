using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Program
{
    public class SeatQueue
    {
        public int Count { get; private set; }
        private int front = 0;
        private int rear = -1;
        private string[] data;

        public SeatQueue(int size = 40)
        {
            if (size < 1) throw new Exception("Invalid Queue Size");

            Count = 0;
            data = new string[size];
        }

        public void Enqueue(string item)
        {
            if (Count == data.Length) throw new Exception("Queue Overflow");
            rear = (rear + 1) % data.Length; Count++;
            data[rear] = item;
        }

        public string Dequeue()
        {
            if (Count == 0) throw new Exception("Queue Underflow");
            string item = data[front];
            front = (front + 1) % data.Length; Count--;
            return item;
        }
    }
}
