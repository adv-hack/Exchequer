using System;
using System.IO;
using System.Management;
using System.Windows.Forms;
using System.Runtime.InteropServices;
using CSH.Exchequer.Bespoke.Exceptions;

namespace CSH.Exchequer.Bespoke.Network
{
    /// <summary>
    /// Network Drive Interface
    /// </summary>
    public class MappedDrive
    {
        private static class NativeMethods
        {
            [DllImport("user32.dll")]
            [return: MarshalAs(UnmanagedType.Bool)]
            public static extern bool SetForegroundWindow(IntPtr hWnd);
            [DllImport("user32.dll")]
            public static extern IntPtr GetForegroundWindow();
            [DllImport("mpr.dll")]
            public static extern int WNetAddConnection2A(ref NetResource pstNetRes, string psPassword, string psUsername, int piFlags);
            [DllImport("mpr.dll")]
            public static extern int WNetCancelConnection2A(string psName, int piFlags, int pfForce);
            [DllImport("mpr.dll")]
            public static extern int WNetConnectionDialog(int phWnd, int piType);
            [DllImport("mpr.dll")]
            public static extern int WNetDisconnectDialog(int phWnd, int piType);
            [DllImport("mpr.dll")]
            public static extern int WNetRestoreConnectionW(int phWnd, string psLocalDrive);
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct NetResource
        {
            public int Scope;
            public int Type;
            public int DisplayType;
            public int Usage;
            public string LocalName;
            public string RemoteName;
            public string Comment;
            public string Provider;
        }

        private enum DialogType
        {
            Connect = 1,
            Disconnect = 2
        }

        private const int RESOURCETYPE_DISK = 0x1;

        //Standard	
        private const int CONNECT_INTERACTIVE = 0x00000008;
        private const int CONNECT_PROMPT = 0x00000010;
        private const int CONNECT_UPDATE_PROFILE = 0x00000001;
        //IE4+
        private const int CONNECT_REDIRECT = 0x00000080;
        //NT5 only
        private const int CONNECT_COMMANDLINE = 0x00000800;
        private const int CONNECT_CMD_SAVECRED = 0x00001000;

        private const int ERROR_ALREADY_ASSIGNED = 85;

        /// <summary>
        /// Gets or sets a value indicating whether [throw if already connected].
        /// </summary>
        /// <value>
        /// 	<c>true</c> if [throw if already connected]; otherwise, <c>false</c>.
        /// </value>
        public bool ThrowIfAlreadyAssigned { get; set; }

        /// <summary>
        /// Option to save credentials are reconnection...
        /// </summary>
        public bool SaveCredentials { get; set; }
        /// <summary>
        /// Option to reconnect drive after log off / reboot ...
        /// </summary>
        public bool IsPersistent { get; set; }
        /// <summary>
        /// Option to force connection if drive is already mapped...
        /// or force disconnection if network path is not responding...
        /// </summary>
        public bool Force { get; set; }
        /// <summary>
        /// Option to prompt for user credintals when mapping a drive
        /// </summary>
        public bool PromptForCredentials { get; set; }

        private string localDrive = "s:";
        /// <summary>
        /// Drive to be used in mapping / unmapping...
        /// </summary>
        public string LocalDrive
        {
            get { return (this.localDrive); }
            set
            {
                if (value.Length >= 1)
                {
                    this.localDrive = value.Substring(0, 1) + ":";
                }
                else
                {
                    this.localDrive = "";
                }
            }
        }
        /// <summary>
        /// Share address to map drive to.
        /// </summary>
        public string ShareName { get; set; }

        /// <summary>
        /// Map network drive
        /// </summary>
        public void MapDrive()
        {
            MapDrive(null, null);
        }
        /// <summary>
        /// Map network drive (using supplied Password)
        /// </summary>
        public void MapDrive(string Password)
        {
            MapDrive(null, Password);
        }
        /// <summary>
        /// Map network drive (using supplied Username and Password)
        /// </summary>
        public void MapDrive(string userName, string password)
        {
            try
            {
                //create struct data
                NetResource netRes = new NetResource();
                netRes.Scope = 2;
                netRes.Type = RESOURCETYPE_DISK;
                netRes.DisplayType = 3;
                netRes.Usage = 1;
                netRes.RemoteName = this.ShareName;
                netRes.LocalName = this.localDrive;
                //prepare params
                int iFlags = 0;
                if (SaveCredentials)
                {
                    iFlags += CONNECT_CMD_SAVECRED;
                }

                if (IsPersistent)
                {
                    iFlags += CONNECT_UPDATE_PROFILE;
                }

                if (PromptForCredentials)
                {
                    iFlags += CONNECT_INTERACTIVE + CONNECT_PROMPT;
                }

                if (userName == "")
                {
                    userName = null;
                }

                if (password == "")
                {
                    password = null;
                }

                //if force, unmap ready for new connection
                if (Force)
                {
                    try
                    {
                        UnMapDrive();
                    }
                    catch
                    {
                    }
                }

                //call and return
                int i = NativeMethods.WNetAddConnection2A(ref netRes, password, userName, iFlags);

                var throwException = false;
                if ((i > 0) && (i != ERROR_ALREADY_ASSIGNED))
                {
                    throwException = true;
                }
                else if (i == ERROR_ALREADY_ASSIGNED && this.ThrowIfAlreadyAssigned)
                {
                    throwException = true;
                }

                if (throwException)
                {
                    throw new System.ComponentModel.Win32Exception(i);
                }
            }
            catch (SystemException ex)
            {
                throw new MappedDriveException("An error occurred while attempting to map a network drive.", ex);
            }
        }
        /// <summary>
        /// Unmap network drive
        /// </summary>
        public void UnMapDrive()
        {
            try
            {
                //call unmap and return
                int iFlags = 0;
                if (IsPersistent)
                {
                    iFlags += CONNECT_UPDATE_PROFILE;
                }

                int i = NativeMethods.WNetCancelConnection2A(this.localDrive, iFlags, Convert.ToInt32(this.Force));
                if (i != 0)
                {
                    i = NativeMethods.WNetCancelConnection2A(this.ShareName, iFlags, Convert.ToInt32(this.Force));  //disconnect if localname was null
                }

                if (i > 0)
                {
                    throw new System.ComponentModel.Win32Exception(i);
                }
            }
            catch (SystemException ex)
            {
                throw new MappedDriveException("An error occurred while attempting to unmap a network drive.", ex);
            }
        }
        /// <summary>
        /// Check / restore persistent network drive
        /// </summary>
        public void RestoreDrives()
        {
            try
            {
                //call restore and return
                int i = NativeMethods.WNetRestoreConnectionW(0, null);
                if (i > 0)
                {
                    throw new System.ComponentModel.Win32Exception(i);
                }
            }
            catch (SystemException ex)
            {
                throw new MappedDriveException("An error occurred while attempting to restore a connection to a network drive.", ex);
            }
        }
        /// <summary>
        /// Display windows dialog for mapping a network drive
        /// </summary>
        public void ShowConnectDialog(IWin32Window owner)
        {
            DisplayDialog(owner, DialogType.Connect);
        }
        /// <summary>
        /// Display windows dialog for disconnecting a network drive
        /// </summary>
        public void ShowDisconnectDialog(IWin32Window owner)
        {
            DisplayDialog(owner, DialogType.Disconnect);
        }

        // Display windows dialog
        private void DisplayDialog(IWin32Window owner, DialogType piDialog)
        {
            try
            {
                int i = -1;
                int iHandle = 0;
                //get parent handle
                if (owner != null)
                {
                    iHandle = owner.Handle.ToInt32();
                }
                //show dialog
                if (piDialog == DialogType.Connect)
                {
                    i = NativeMethods.WNetConnectionDialog(iHandle, RESOURCETYPE_DISK);
                }
                else if (piDialog == DialogType.Disconnect)
                {
                    i = NativeMethods.WNetDisconnectDialog(iHandle, RESOURCETYPE_DISK);
                }

                if (i > 0)
                {
                    throw new System.ComponentModel.Win32Exception(i);
                }

                //set focus on parent form
                if (NativeMethods.GetForegroundWindow() != owner.Handle)
                {
                    NativeMethods.SetForegroundWindow(owner.Handle);
                }
            }
            catch (SystemException ex)
            {
                throw new MappedDriveException("An error occurred whiled displaying the network drive dialog.", ex);
            }

        }

        /// <summary>Resolves the given path to a full UNC path, or full local drive path.</summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public string GetUNCPath(string path)
        {
            if (path.StartsWith(@"\\")) { return path; }

            string root = GetRootUNCPath(path);

            if (path.StartsWith(root))
            {
                return path; // Local drive, no resolving occurred
            }
            else
            {
                return path.Replace(GetDriveLetter(path), root);
            }
        }

        /// <summary>Resolves the given path to a root UNC path, or root local drive path.</summary>
        /// <param name="path"></param>
        /// <returns>\\server\share OR C:\</returns>
        public string GetRootUNCPath(string path)
        {
            ManagementObject mo = new ManagementObject();

            if (path.StartsWith(@"\\")) { return Directory.GetDirectoryRoot(path); }

            // Get just the drive letter for WMI call
            string driveletter = GetDriveLetter(path);

            mo.Path = new ManagementPath(string.Format("Win32_LogicalDisk='{0}'", driveletter));

            // Get the data we need
            uint DriveType = Convert.ToUInt32(mo["DriveType"]);
            string NetworkRoot = Convert.ToString(mo["ProviderName"]);
            mo = null;

            // Return the root UNC path if network drive, otherwise return the root path to the local drive
            if (DriveType == 4)
            {
                return NetworkRoot;
            }
            else
            {
                return driveletter + Path.DirectorySeparatorChar;
            }
        }

        /// <summary>Checks if the given path is on a network drive.</summary>
        /// <param name="path"></param>
        /// <returns></returns>
        public bool IsNetworkDrive(string path)
        {
            ManagementObject mo = new ManagementObject();

            if (path.StartsWith(@"\\"))
            {
                return true;
            }

            // Get just the drive letter for WMI call
            string driveletter = GetDriveLetter(path);

            mo.Path = new ManagementPath(string.Format("Win32_LogicalDisk='{0}'", driveletter));

            // Get the data we need
            uint DriveType = Convert.ToUInt32(mo["DriveType"]);
            mo = null;

            return DriveType == 4;
        }

        /// <summary>Given a path will extract just the drive letter with volume separator.</summary>
        /// <param name="path"></param>
        /// <returns>C:</returns>
        public string GetDriveLetter(string path)
        {
            if (path.StartsWith(@"\\"))
            {
                throw new MappedDriveException("A UNC path was passed to GetDriveLetter.");
            }

            return Directory.GetDirectoryRoot(path).Replace(Path.DirectorySeparatorChar.ToString(), "");
        }


        /// <summary>
        /// Gets the local path.
        /// </summary>
        /// <param name="uncPath">The unc path.</param>
        /// <param name="username">The username.</param>
        /// <param name="password">The password.</param>
        /// <returns></returns>
        public string GetLocalPath(string uncPath, string username = "", string password = "")
        {
            try
            {
                // remove the "\\" from the UNC path and split the path
                uncPath = uncPath.Replace(@"\\", "");
                string[] uncParts = uncPath.Split(new char[] { '\\' }, StringSplitOptions.RemoveEmptyEntries);

                if (uncParts.Length < 2)
                {
                    throw new MappedDriveException("Could not resolve the UNC path " + uncPath + ".");
                }

                // Get a connection to the server as found in the UNC path

                ManagementScope scope = null;
                if (String.IsNullOrWhiteSpace(username) && String.IsNullOrWhiteSpace(password))
                {
                    scope = new ManagementScope(@"\\" + uncParts[0] + @"\root\cimv2");
                }
                else
                {
                    ConnectionOptions options = new ConnectionOptions();
                    options.Username = username;
                    options.Password = password;
                    scope = new ManagementScope(@"\\" + uncParts[0] + @"\root\cimv2", options);
                }

                // Query the server for the share name
                SelectQuery query = new SelectQuery("Select * From Win32_Share Where Name = '" + uncParts[1] + "'");
                ManagementObjectSearcher searcher = new ManagementObjectSearcher(scope, query);

                // Get the path
                string path = string.Empty;
                foreach (ManagementObject obj in searcher.Get())
                {
                    path = obj["path"].ToString();
                }

                // Append any additional folders to the local path name
                if (uncParts.Length > 2)
                {
                    for (int i = 2; i < uncParts.Length; i++)
                        path = path.EndsWith(@"\") ? path + uncParts[i] : path + @"\" + uncParts[i];
                }

                return path;
            }
            catch (Exception ex)
            {
                throw new MappedDriveException("Error resolving UNC path " + uncPath + ".", ex);
            }
        }
    }
}