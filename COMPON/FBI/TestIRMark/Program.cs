using System;
using System.Collections.Generic;
using System.Text;


namespace TestIRMark
{
    class Program
    {
        static void Main(string[] args)
        {
            string Document1 = System.IO.File.ReadAllText("c:\\test.xml");


            string Test = IRIS.Systems.InternetFiling.IRMark32.AddIRMark(ref Document1, "http://www.govtalk.gov.uk/taxation/CISrequest");

            IRIS.Systems.InternetFiling.Posting Post = new IRIS.Systems.InternetFiling.Posting();

            string Document2 = System.IO.File.ReadAllText("c:\\test.xml");

            string Test2 = Post.AddIRMark(ref Document2, 5);



        }
    }
}
