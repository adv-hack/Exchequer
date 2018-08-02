using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using EnterpriseSecurity;
using CSH.Exchequer.Bespoke.Exceptions;

namespace CSH.Exchequer.Bespoke.Licencing
{
    /// <summary>
    /// Provides bespoke software licencing services
    /// </summary>
    public class Licensor
    {
        /// <summary>
        /// Friendly name for the different types of plug-in
        /// </summary>
        public enum PluginType
        {
            /// <summary>
            /// DLL
            /// </summary>
            DLL,
            /// <summary>
            /// COM
            /// </summary>
            COM,
            /// <summary>
            /// EXE
            /// </summary>
            EXE,
            /// <summary>
            /// TCM
            /// </summary>
            TCM
        }

        string _PlugInCode;
        string _SecurityCode;
        string _Description;
        string _VersionNo;
        PluginType _TypeOfPlugin;
        string _PluginPath;
        TSecurityType _SecurityType;

        /// <summary>
        /// Initializes a new instance of the <see cref="Licensor"/> class.
        /// </summary>
        /// <param name="PlugInCode">The plug in code.</param>
        /// <param name="SecurityCode">The security code.</param>
        /// <param name="Description">The description.</param>
        /// <param name="VersionNo">The version no.</param>
        /// <param name="SecurityType">Type of the security.</param>
        /// <param name="TypeOfPlugin">The type of plugin.</param>
        /// <param name="PluginPath">The plugin path.</param>
        public Licensor(string PlugInCode, string SecurityCode, string Description, string VersionNo, TSecurityType SecurityType, PluginType TypeOfPlugin, string PluginPath)
        {
            Initialise(PlugInCode, SecurityCode, Description, VersionNo, SecurityType, TypeOfPlugin, PluginPath);
        }

        /// <summary>
        /// Initialises the licensor.
        /// </summary>
        /// <param name="PlugInCode">The plug in code.</param>
        /// <param name="SecurityCode">The security code.</param>
        /// <param name="Description">The description.</param>
        /// <param name="VersionNo">The version no.</param>
        /// <param name="SecurityType">Type of the security.</param>
        /// <param name="TypeOfPlugin">The type of plugin.</param>
        /// <param name="PluginPath">The plugin path.</param>
        public void Initialise(string PlugInCode, string SecurityCode, string Description, string VersionNo, TSecurityType SecurityType, PluginType TypeOfPlugin, string PluginPath)
        {
            _PlugInCode = PlugInCode;
            _SecurityCode = SecurityCode;
            _Description = Description;
            _VersionNo = VersionNo;
            _TypeOfPlugin = TypeOfPlugin;
            _PluginPath = PluginPath;
            _SecurityType = SecurityType;
        }

        /// <summary>
        /// Shows the security expiry.
        /// </summary>
        /// <param name="SecurityResult">The security result.</param>
        public void ShowSecurityExpiry(TSystemSecurityStatus SecurityResult)
        {
            //Check Securityresult
            if (SecurityResult == EnterpriseSecurity.TSystemSecurityStatus.SysExpired)
            {
                throw new PluginLicenceExpiredException("Your evaluation period for the " + _Description + " has expired.\r\n\r\nIf you wish to reactivate this Plug-In please contact your Exchequer helpline number.");
            }
        }

        /// <summary>
        /// Determines whether the plug-in is released.
        /// </summary>
        /// <param name="Result">The result.</param>
        /// <param name="SecurityResult">The security result.</param>
        /// <returns>
        ///   <c>true</c> if the specified result is released; otherwise, <c>false</c>.
        /// </returns>
        public bool IsReleased(int Result, TSystemSecurityStatus SecurityResult)
        {
            return (Result == 0) && (SecurityResult == (EnterpriseSecurity.TSystemSecurityStatus.SysReleased) || (SecurityResult == EnterpriseSecurity.TSystemSecurityStatus.Sys30Day));
        }

        /// <summary>
        /// Checks the license.
        /// </summary>
        /// <param name="SecurityResult">The security result.</param>
        /// <returns></returns>
        public int CheckLicense(ref TSystemSecurityStatus SecurityResult)
        {
            // Initialise
            IThirdParty plugInSecurity = new ThirdParty();
            int returnCode = -1;

            try
            {
                //Set Security Object Properties
                plugInSecurity.tpSystemIdCode = _PlugInCode;
                plugInSecurity.tpSecurityCode = _SecurityCode;
                plugInSecurity.tpDescription = _Description + " " + _VersionNo;
                plugInSecurity.tpSecurityType = _SecurityType;
                plugInSecurity.tpMessage = "For Sales or Technical Help, contact your Exchequer reseller";
                try
                {
                    //Check Security
                    returnCode = plugInSecurity.ReadSecurity();
                    SecurityResult = plugInSecurity.tpSystemStatus;
                }
                catch (Exception)
                {
                    returnCode = -3;
                    SecurityResult = TSystemSecurityStatus.SysExpired;
                }
            }
            catch (Exception)
            {
                returnCode = -2;
            }
            finally
            {
                plugInSecurity = null;
            }

            //If IsWinForms Then
            if (returnCode > 0)
            {
                // Error Code returned from  oPlugInSecurity.ReadSecurity
                throw new BespokeSecurityException("IThirdParty.ReadSecurity returned an error code", returnCode);
            }
            else
            {
                // Check for Exception Errors
                string Message = "";
                switch (returnCode)
                {
                    case 0:
                        // ALL OK !
                        Message = "";
                        break;
                    case -1:
                        Message = "A Problem occurred on Initialisation";
                        break;
                    case -2:
                        Message = "A problem occurred setting the properties for IThirdParty";
                        break;
                    case -3:
                        Message = "A problem occurred when calling IThirdParty.ReadSecurity";
                        break;
                }

                if (string.IsNullOrEmpty(Message))
                {
                    // Show Expiry if bespoke has expired
                    ShowSecurityExpiry(SecurityResult);
                }
                else
                {
                    // Show Exception Error
                    throw new BespokeSecurityException(Message);
                }
            }

            return returnCode;
        }
    }
}