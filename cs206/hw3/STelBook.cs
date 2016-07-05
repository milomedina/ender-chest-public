using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Program
{
    public class STelBook
    {
        private SGroup head;

        public STelBook()
        {
            head = new SGroup("HEAD", null);
        }

        public void AddTel(string obj)
        {
            Telephone tel = (Telephone)obj;
            SGroup insgroup = null, group = head.Next;
            while (group != null)
            {
                if (group.ExistTel(tel.Number))
                    throw new Exception("Telephone number already exist.");
                if (group.Name == tel.Group)
                    insgroup = group;
                group = group.Next;
            }

            if (!ExistGroup(tel.Group))
            {
                insgroup = new SGroup(tel.Group, head.Next);
                head.Next = insgroup;
            }
            insgroup.AddTel(tel);
        }

        public void RemoveTel(string tel)
        {
            SGroup group = head.Next;
            while (group != null)
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
            SGroup group = head.Next;
            while (group != null)
            {
                str += group.FindTel(false, name);
                group = group.Next;
            }
            return str == "" ? "There's no member to show.\r\n" : str;
        }

        public string GetAll()
        {
            string str = "";
            SGroup group = head.Next;
            while (group != null)
            {
                str += group.FindTel(true);
                group = group.Next;
            }
            return str == "" ? "There's no member to show.\r\n" : str;
        }

        public string GetGroup(string gname)
        {
            SGroup group = head.Next;
            while (group != null)
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

            head.Next = new SGroup(gname, head.Next);
        }

        public bool ExistGroup(string gname)
        {
            SGroup group = head.Next;
            while (group != null)
            {
                if (group.Name == gname)
                    return true;
                group = group.Next;
            }
            return false;
        }
    }
}
