using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Program
{
    public class DTelBook
    {
        private DGroup head;
        private DGroup rear;

        public DTelBook()
        {
            head = new DGroup("HEAD", null, null);
            rear = new DGroup("REAR", null, null);
            head.Next = rear;
            rear.Prev = head;
        }

        public void AddTel(string obj)
        {
            Telephone tel = (Telephone)obj;
            DGroup insgroup = null, group = head.Next;
            while (group != rear)
            {
                if (group.ExistTel(tel.Number))
                    throw new Exception("Telephone number already exist.");
                if (group.Name == tel.Group)
                    insgroup = group;
                group = group.Next;
            }

            if (insgroup == null)
            {
                insgroup = new DGroup(tel.Group, head, head.Next);
                head.Next.Prev = insgroup;
                head.Next = insgroup;
            }
            insgroup.AddTel(tel);
        }

        public void RemoveTel(string tel)
        {
            DGroup group = head.Next;
            while (group != rear)
            {
                if (group.RemoveTel(tel))
                    return;
                group = group.Next;
            }
            throw new Exception("There's no number to be deleted.");
        }

        public string Find(string name)
        {
            string str = "";
            DGroup group = head.Next;
            while (group != rear)
            {
                str += group.FindTel(false, name);
                group = group.Next;
            }
            return str == "" ? "There's no member to show.\r\n" : str;
        }

        public string GetAll()
        {
            string str = "";
            DGroup group = head.Next;
            while (group != rear)
            {
                str += group.FindTel(true);
                group = group.Next;
            }
            return str == "" ? "There's no member to show.\r\n" : str;
        }

        public string GetGroup(string gname)
        {
            DGroup group = head.Next;
            while (group != rear)
            {
                if (group.Name.ToLower() == gname.ToLower())
                {
                    string str = group.FindTel(true);
                    return str == "" ? "There's no member to show.\r\n" : str;
                }
                group = group.Next;
            }
            return "There's no member to show.\r\n";
        }

        public void CreateGroup(string gname)
        {
            if (ExistGroup(gname))
                throw new Exception("Group [" + gname + "] is already exist.");

            DGroup group = new DGroup(gname, head, head.Next);
            head.Next.Prev = group;
            head.Next = group;
        }

        public bool ExistGroup(string gname)
        {
            DGroup group = head.Next;
            while (group != rear)
            {
                if (group.Name == gname)
                    return true;
                group = group.Next;
            }
            return false;
        }
    }
}
