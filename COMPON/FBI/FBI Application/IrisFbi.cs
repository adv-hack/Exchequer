using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace IRIS.Systems.InternetFiling
{
    class Program
    {
        static void Main(string[] args)
        {
            FBIServer currentServer = null;

            TextWriterTraceListener myWriter = new
                TextWriterTraceListener(Console.Out);

            Trace.Listeners.Add(myWriter);

            try
            {
                currentServer = new FBIServer();
                if (args.Length > 0)
                   currentServer.Port = int.Parse(args[0]);
                currentServer.OpenChannel();
                IRISGlobalVariables.CurrentServer = currentServer;
            }
            catch (System.Net.Sockets.SocketException ex)
            {
                Trace.WriteLine("Could not build FBI_Server object: exception was thrown.");
                Trace.WriteLine("The exception was:");
                Trace.WriteLine(ex.Message);
                return;
            }

            Console.WriteLine("Press any key to exit");
            Console.ReadLine();

            currentServer.CloseChannel();
        }
    }
}
