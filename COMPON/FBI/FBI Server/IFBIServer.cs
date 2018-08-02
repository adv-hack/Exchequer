using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;

namespace IRIS.Systems.InternetFiling
{
    /// <summary>
    /// Seems to be an accessor method on to the global
    /// variables defined elswhere.
    /// </summary>
    public class IFBIServer : MarshalByRefObject
    {
        public int Submit(GatewayDocument fbiParams)
        {
            return IRISGlobalVariables.CurrentServer.Submit(fbiParams);
        }
        
        public int Query(int num)
        {
            return IRISGlobalVariables.CurrentServer.Query(num);
        }
    }
}

