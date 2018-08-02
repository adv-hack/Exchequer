using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication1
{
    using IRIS.ExchequerSQL.ClrExtensions;

    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                byte[] b1=SQLCLRFunctions.GetHiCodeComputedValue (2010, "", "", false);
                Console.WriteLine(FieldConverter.ConvertBytesToString(b1));                
            }
            finally
            {
                Console.WriteLine("Press any key to close");
                Console.ReadKey();
            }
        }
    }
}
