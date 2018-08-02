using System;
using System.Collections.Generic;
using System.Text;


namespace TestIRMark
{
    class Program
    {
        static void Main(string[] args)
        {
            string Document = System.IO.File.ReadAllText("c:\\test.xml");


            string Test = IRIS.Systems.InternetFiling.IRMark32.AddIRMark(ref Document, "http://www.govtalk.gov.uk/taxation/CT/2");

        }
    }
}
