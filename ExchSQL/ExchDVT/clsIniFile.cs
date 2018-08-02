using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Collections;
using System.Collections.Specialized;

namespace Data_Integrity_Checker
{
    public class clsIniFile
    {
        // Ensure the release of resources
        ~clsIniFile()
        {
            UpdateFile();
        }

        // Delete some Section Next key
        public void DeleteKey(string Section, string Ident)
        {
            WritePrivateProfileString(Section, Ident, null, FileName);
        }

        //// Read the specified Section All Value Into the list ，
        //public void ReadSectionValues(string Section, NameValueCollection Values,char splitString)
        //{　 string sectionValue;
        //　　string[] sectionValueSplit;
        //　　StringCollection KeyList = new StringCollection();
        //　　ReadSection(Section, KeyList);
        //　　Values.Clear();
        //　　foreach (string key in KeyList)
        //　　{
        //　　　　sectionValue=ReadString(Section, key, "");
        //　　　　sectionValueSplit=sectionValue.Split(splitString);
        //　　　　Values.Add(key, sectionValueSplit[0].ToString(),sectionValueSplit[1].ToString());
        //　　}
        //}
        // Clear a certain Section
        public void EraseSection(string Section)
        {
            if (!WritePrivateProfileString(Section, null, null, FileName))
            {
                throw (new ApplicationException(" Cannot clear Ini File in Section"));
            }
        }

        // Class constructor ， transmit INI file name
        public void IniFiles(string AFileName)
        {
            //  To determine whether the file exists
            FileInfo fileInfo = new FileInfo(AFileName);
            //Todo: To make clear the usage of enumeration.
            if ((!fileInfo.Exists))
            { //|| (FileAttributes.Directory in fileInfo.Attributes))
                // file does not exist ， create file
                System.IO.StreamWriter sw = new System.IO.StreamWriter(AFileName, false, System.Text.Encoding.Default);
                try
                {
                    sw.Write(" ");
                    sw.Close();
                }
                catch
                {
                    throw (new ApplicationException("Ini file does not exist "));
                }
            }
            // Must be the full path ， Can not be the relative path
            FileName = fileInfo.FullName;
        }

        // Read Boolean
        public bool ReadBool(string Section, string Ident, bool Default)
        {
            try
            {
                return Convert.ToBoolean(ReadString(Section, Ident, Convert.ToString(Default)));
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return Default;
            }
        }

        // Read integer
        public int ReadInteger(string Section, string Ident, int Default)
        {
            string intStr = ReadString(Section, Ident, Convert.ToString(Default));
            try
            {
                return Convert.ToInt32(intStr);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return Default;
            }
        }

        // from Ini File in ， Would specify Section All in the name Ident Add to the list
        public void ReadSection(string Section, StringCollection Idents)
        {
            Byte[] Buffer = new Byte[16384];
            //Idents.Clear();
            int bufLen = GetPrivateProfileString(Section, null, null, Buffer, Buffer.GetUpperBound(0),
                FileName);
            // Yes Section Make analysis
            GetStringsFromBuffer(Buffer, bufLen, Idents);
        }

        // from Ini File in ， Read all Sections Name
        public void ReadSections(StringCollection SectionList)
        {
            //Note: Must be used Bytes To realize ，StringBuilder Can only be taken to the first Section
            byte[] Buffer = new byte[65535];
            int bufLen = 0;
            bufLen = GetPrivateProfileString(null, null, null, Buffer,
                Buffer.GetUpperBound(0), FileName);
            GetStringsFromBuffer(Buffer, bufLen, SectionList);
        }

        // Read the specified Section All Value Into the list
        public void ReadSectionValues(string Section, NameValueCollection Values)
        {
            StringCollection KeyList = new StringCollection();
            ReadSection(Section, KeyList);
            Values.Clear();
            foreach (string key in KeyList)
            {
                Values.Add(key, ReadString(Section, key, ""));
            }
        }

        // read INI File specify
        public string ReadString(string Section, string Ident, string Default)
        {
            Byte[] Buffer = new Byte[65535];
            int bufLen = GetPrivateProfileString(Section, Ident, Default, Buffer, Buffer.GetUpperBound(0), FileName);
            // Must set 0（ System default code page ） Coding mode ， Otherwise unable to support Chinese
            string s = Encoding.GetEncoding(0).GetString(Buffer);
            s = s.Substring(0, bufLen);
            return s.Trim();
        }

        // Note: about Win9X， It needs to be realized. UpdateFile Method writes data in a buffer to a file
        // stay Win NT, 2000 and XP upper ， Are written directly to the file ， No buffer ， therefore ， Need not be realized UpdateFile
        // Execute the right Ini After the modification of the document ， This method should be called to update the buffer 。
        public void UpdateFile()
        {
            WritePrivateProfileString(null, null, null, FileName);
        }

        // Check a Section A key is there
        public bool ValueExists(string Section, string Ident)
        {
            StringCollection Idents = new StringCollection();
            ReadSection(Section, Idents);
            return Idents.IndexOf(Ident) > -1;
        }

        // write Bool
        public void WriteBool(string Section, string Ident, bool Value)
        {
            WriteString(Section, Ident, Convert.ToString(Value));
        }

        // Write integer
        public void WriteInteger(string Section, string Ident, int Value)
        {
            WriteString(Section, Ident, Value.ToString());
        }

        // write INI file
        public void WriteString(string Section, string Ident, string Value)
        {
            if (!WritePrivateProfileString(Section, Ident, Value, FileName))
            {
                throw (new ApplicationException(" write Ini File error "));
            }
        }

        [DllImport("kernel32")]
        private static extern int GetPrivateProfileString(string section, string key, string def, byte[] retVal, int size, string filePath);

        // Read and write in a statement INI File API function
        [DllImport("kernel32")]
        private static extern bool WritePrivateProfileString(string section, string key, string val, string filePath);

        private void GetStringsFromBuffer(Byte[] Buffer, int bufLen, StringCollection Strings)
        {
            Strings.Clear();
            if (bufLen != 0)
            {
                int start = 0;
                for (int i = 0; i < bufLen; i++)
                {
                    if ((Buffer[i] == 0) && ((i - start) > 0))
                    {
                        String s = Encoding.GetEncoding(0).GetString(Buffer, start, i - start);
                        Strings.Add(s);
                        start = i + 1;
                    }
                }
            }
        }

        public string FileName; //INI file name
    }
}