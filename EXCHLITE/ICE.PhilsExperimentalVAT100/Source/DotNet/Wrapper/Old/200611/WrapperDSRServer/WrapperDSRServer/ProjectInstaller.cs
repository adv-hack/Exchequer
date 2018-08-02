using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration.Install;

namespace WrapperDSRServer
{
    [RunInstaller(true)]
    public partial class ProjectInstaller : Installer
    {
        public ProjectInstaller()
        {
            InitializeComponent();
        }

        public string GetContextParameter(string key)
        {
            string sValue = "";
            try
            {
                sValue = this.Context.Parameters[key].ToString();
            }
            catch
            {
                sValue = "";
            }
            return sValue;
        }

        private void serviceProcessInstaller1_BeforeInstall(object sender, InstallEventArgs e)
        {
            // User name and password
            string username = GetContextParameter("user");
            string password = GetContextParameter("password");

            if (((username != null) || (username != string.Empty)) && 
                ((password != null) || (username != string.Empty)))
            {
                // set the user name and password
                
                serviceProcessInstaller1.Account = System.ServiceProcess.ServiceAccount.User;
                serviceProcessInstaller1.Username = username;
                serviceProcessInstaller1.Password = password;
            }
            else
                serviceProcessInstaller1.Account = System.ServiceProcess.ServiceAccount.LocalSystem;
            
        }
    }
}