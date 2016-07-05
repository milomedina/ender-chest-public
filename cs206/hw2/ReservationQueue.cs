using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Program
{
    public class ReservationQueue
    {
        public int Count
        {
            get
            {
                return queue.Sum(item => item.Count);
            }
        }

        private SeatQueue[] queue = new SeatQueue[3];

        public ReservationQueue(int size = 40)
        {
            if (size < 1) throw new Exception("Invalid Queue Size");
            for (int i = 0; i < 3; i++)
                queue[i] = new SeatQueue(size);
        }

        public void Enqueue(string item, int order)
        {
            if (order < 1 || order > 3) throw new Exception("Invalid Seat Type");
            queue[order - 1].Enqueue(item);
        }

        public string Dequeue()
        {
            for (int i = 0; i < 3; i++)
                if (queue[i].Count != 0)
                    return "(\"" + queue[i].Dequeue() + "\"," + (i + 1) + ")";
            throw new Exception("Queue Underflow");
        }
    }
}
