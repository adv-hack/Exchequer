using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace IRIS.Systems.InternetFiling
{
   
   /// <summary>
   /// A global, static instance of an FBIServer object
   /// </summary>
   public static class IRISGlobalVariables
	{
        private static FBIServer currentServer;

        public static FBIServer CurrentServer
        {
            get { return currentServer; }
            set { currentServer = value; }
        }
	
	}
}

