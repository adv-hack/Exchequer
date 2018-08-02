using System.Diagnostics;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using System;
using System.Net;
using System.IO;
using System.Text.RegularExpressions;

namespace CSH.Exchequer.Bespoke.Network.Ftp
{
    /// <summary>
    /// A wrapper class for .NET 2.0 FTP
    /// </summary>
    /// <remarks>
    /// This class does not hold open an FTP connection but
    /// instead is stateless: for each FTP request it
    /// connects, performs the request and disconnects.
    /// </remarks>
    public class FtpClient
    {
        /// <summary>
        /// Blank constructor
        /// </summary>
        /// <remarks>Hostname, username and password must be set manually</remarks>
        public FtpClient()
        {
        }

        /// <summary>
        /// Constructor just taking the hostname
        /// </summary>
        /// <param name="Hostname">in either ftp://ftp.host.com or ftp.host.com form</param>
        /// <remarks></remarks>
        public FtpClient(string Hostname)
        {
            _hostname = Hostname;
            _proxy = FtpWebRequest.GetSystemWebProxy();
        }

        /// <summary>
        /// Constructor just taking the hostname
        /// </summary>
        /// <param name="Hostname">in either ftp://ftp.host.com or ftp.host.com form</param>
        /// <param name="Proxy">The proxy.</param>
        public FtpClient(string Hostname, IWebProxy Proxy)
        {
            _hostname = Hostname;
            _proxy = Proxy;
        }

        /// <summary>
        /// Constructor taking hostname, username and password
        /// </summary>
        /// <param name="Hostname">in either ftp://ftp.host.com or ftp.host.com form</param>
        /// <param name="Username">Leave blank to use 'anonymous' but set password to your email</param>
        /// <param name="Password"></param>
        /// <remarks></remarks>
        public FtpClient(string Hostname, string Username, string Password)
        {
            _hostname = Hostname;
            _username = Username;
            _password = Password;
            _proxy = FtpWebRequest.GetSystemWebProxy();
        }

        /// <summary>
        /// Constructor taking hostname, username, password &amp; proxy
        /// </summary>
        /// <param name="Hostname">in either ftp://ftp.host.com or ftp.host.com form</param>
        /// <param name="Username">Leave blank to use 'anonymous' but set password to your email</param>
        /// <param name="Password"></param>
        /// <param name="Proxy"></param>
        /// <remarks></remarks>
        public FtpClient(string Hostname, string Username, string Password, IWebProxy Proxy)
        {
            _hostname = Hostname;
            _username = Username;
            _password = Password;
            _proxy = Proxy;
        }

        /// <summary>
        /// Return a simple directory listing
        /// </summary>
        /// <param name="directory">Directory to list, e.g. /pub</param>
        /// <returns>A list of filenames and directories as a List(of String)</returns>
        /// <remarks>For a detailed directory listing, use ListDirectoryDetail</remarks>
        public List<string> ListDirectory(string directory)
        {
            //return a simple list of filenames in directory
            System.Net.FtpWebRequest ftp = GetRequest(GetDirectory(directory));
            ftp.Proxy = _proxy;
            //Set request to do simple list
            ftp.Method = System.Net.WebRequestMethods.Ftp.ListDirectory;

            string str = GetStringResponse(ftp);
            //replace CRLF to CR, remove last instance
            str = str.Replace("\r\n", "\r").TrimEnd('\r');
            //split the string into a list
            List<string> result = new List<string>();
            result.AddRange(str.Split('\r'));
            return result;
        }

        /// <summary>
        /// Return a detailed directory listing
        /// </summary>
        /// <param name="directory">Directory to list, e.g. /pub/etc</param>
        /// <returns>An FTPDirectory object</returns>
        public FtpDirectory ListDirectoryDetail(string directory)
        {
            System.Net.FtpWebRequest ftp = GetRequest(GetDirectory(directory));
            ftp.Proxy = _proxy;
            //Set request to do simple list
            ftp.Method = System.Net.WebRequestMethods.Ftp.ListDirectoryDetails;

            string str = GetStringResponse(ftp);
            //replace CRLF to CR, remove last instance
            str = str.Replace("\r\n", "\r").TrimEnd('\r');
            //split the string into a list
            return new FtpDirectory(str, _lastDirectory);
        }

        /// <summary>
        /// Copy a local file to the FTP server
        /// </summary>
        /// <param name="localFilename">Full path of the local file</param>
        /// <param name="targetFilename">Target filename, if required</param>
        /// <returns></returns>
        /// <remarks>If the target filename is blank, the source filename is used
        /// (assumes current directory). Otherwise use a filename to specify a name
        /// or a full path and filename if required.</remarks>
        public bool Upload(string localFilename, string targetFilename)
        {
            //1. check source
            if (!File.Exists(localFilename))
            {
                throw (new ApplicationException("File " + localFilename + " not found"));
            }
            //copy to FI
            FileInfo fi = new FileInfo(localFilename);
            return Upload(fi, targetFilename);
        }

        /// <summary>
        /// Upload a local file to the FTP server
        /// </summary>
        /// <param name="fi">Source file</param>
        /// <param name="targetFilename">Target filename (optional)</param>
        /// <returns></returns>
        public bool Upload(FileInfo fi, string targetFilename)
        {
            //copy the file specified to target file: target file can be full path or just filename (uses current dir)

            //1. check target
            string target;
            if (targetFilename.Trim() == "")
            {
                //Blank target: use source filename & current dir
                target = this.CurrentDirectory + fi.Name;
            }
            else if (targetFilename.Contains("/"))
            {
                //If contains / treat as a full path
                target = AdjustDir(targetFilename);
            }
            else
            {
                //otherwise treat as filename only, use current directory
                target = CurrentDirectory + targetFilename;
            }

            string URI = Hostname + target;
            //perform copy
            System.Net.FtpWebRequest ftp = GetRequest(URI);
            ftp.Proxy = _proxy;
            //Set request to upload a file in binary
            ftp.Method = System.Net.WebRequestMethods.Ftp.UploadFile;
            ftp.UseBinary = true;

            //Notify FTP of the expected size
            ftp.ContentLength = fi.Length;

            //create byte array to store: ensure at least 1 byte!
            const int BufferSize = 2048;
            byte[] content = new byte[BufferSize - 1 + 1];
            int dataRead;

            //open file for reading
            using (FileStream fs = fi.OpenRead())
            {
                try
                {
                    //open request to send
                    using (Stream rs = ftp.GetRequestStream())
                    {
                        do
                        {
                            dataRead = fs.Read(content, 0, BufferSize);
                            rs.Write(content, 0, dataRead);
                        } while (!(dataRead < BufferSize));
                        rs.Close();
                    }

                }
                catch (Exception)
                {

                }
                finally
                {
                    //ensure file closed
                    fs.Close();
                }

            }


            ftp = null;
            return true;

        }

        /// <summary>
        /// Copy a file from FTP server to local
        /// </summary>
        /// <param name="sourceFilename">Target filename, if required</param>
        /// <param name="localFilename">Full path of the local file</param>
        /// <param name="PermitOverwrite">if set to <c>true</c> [permit overwrite].</param>
        /// <returns></returns>
        /// <remarks>
        /// Target can be blank (use same filename), or just a filename
        /// (assumes current directory) or a full path and filename
        /// </remarks>
        public bool Download(string sourceFilename, string localFilename, bool PermitOverwrite)
        {
            //2. determine target file
            FileInfo fi = new FileInfo(localFilename);
            return this.Download(sourceFilename, fi, PermitOverwrite);
        }

        //Version taking an FtpFileInfo
        /// <summary>
        /// Downloads the specified file.
        /// </summary>
        /// <param name="file">The file.</param>
        /// <param name="localFilename">The local filename.</param>
        /// <param name="PermitOverwrite">if set to <c>true</c> [permit overwrite].</param>
        /// <returns></returns>
        public bool Download(FtpFileInfo file, string localFilename, bool PermitOverwrite)
        {
            return this.Download(file.FullName, localFilename, PermitOverwrite);
        }

        //Another version taking FtpFileInfo and FileInfo
        /// <summary>
        /// Downloads the specified file.
        /// </summary>
        /// <param name="file">The file.</param>
        /// <param name="localFI">The local FI.</param>
        /// <param name="PermitOverwrite">if set to <c>true</c> [permit overwrite].</param>
        /// <returns></returns>
        public bool Download(FtpFileInfo file, FileInfo localFI, bool PermitOverwrite)
        {
            return this.Download(file.FullName, localFI, PermitOverwrite);
        }

        //Version taking string/FileInfo
        /// <summary>
        /// Downloads the specified source filename.
        /// </summary>
        /// <param name="sourceFilename">The source filename.</param>
        /// <param name="targetFI">The target FI.</param>
        /// <param name="PermitOverwrite">if set to <c>true</c> [permit overwrite].</param>
        /// <returns></returns>
        public bool Download(string sourceFilename, FileInfo targetFI, bool PermitOverwrite)
        {
            //1. check target
            if (targetFI.Exists && !(PermitOverwrite))
            {
                throw (new ApplicationException("Target file already exists"));
            }

            //2. check source
            string target;
            if (sourceFilename.Trim() == "")
            {
                throw (new ApplicationException("File not specified"));
            }
            else if (sourceFilename.Contains("/"))
            {
                //treat as a full path
                target = AdjustDir(sourceFilename);
            }
            else
            {
                //treat as filename only, use current directory
                target = CurrentDirectory + sourceFilename;
            }

            string URI = Hostname + target;

            //3. perform copy
            System.Net.FtpWebRequest ftp = GetRequest(URI);
            ftp.Proxy = _proxy;
            //Set request to download a file in binary mode
            ftp.Method = System.Net.WebRequestMethods.Ftp.DownloadFile;
            ftp.UseBinary = true;

            //open request and get response stream
            using (FtpWebResponse response = (FtpWebResponse)ftp.GetResponse())
            {
                using (Stream responseStream = response.GetResponseStream())
                {
                    //loop to read & write to file
                    using (FileStream fs = targetFI.OpenWrite())
                    {
                        try
                        {
                            byte[] buffer = new byte[2048];
                            int read = 0;
                            do
                            {
                                read = responseStream.Read(buffer, 0, buffer.Length);
                                fs.Write(buffer, 0, read);
                            } while (!(read == 0));
                            responseStream.Close();
                            fs.Flush();
                            fs.Close();
                        }
                        catch (Exception)
                        {
                            //catch error and delete file only partially downloaded
                            fs.Close();
                            //delete target file as it's incomplete
                            targetFI.Delete();
                            throw;
                        }
                    }

                    responseStream.Close();
                }

                response.Close();
            }


            return true;
        }

        /// <summary>
        /// Delete remote file
        /// </summary>
        /// <param name="filename">filename or full path</param>
        /// <returns></returns>
        public bool Delete(string filename)
        {
            //Determine if file or full path
            string URI = this.Hostname + GetFullPath(filename);

            System.Net.FtpWebRequest ftp = GetRequest(URI);
            ftp.Proxy = _proxy;
            //Set request to delete
            ftp.Method = System.Net.WebRequestMethods.Ftp.DeleteFile;
            try
            {
                //get response but ignore it
                string str = GetStringResponse(ftp);
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// Determine if file exists on remote FTP site
        /// </summary>
        /// <param name="filename">Filename (for current dir) or full path</param>
        /// <returns></returns>
        /// <remarks>
        /// Note this only works for files
        /// </remarks>
        public bool FileExists(string filename)
        {
            //Try to obtain filesize: if we get error msg containing "550"
            //the file does not exist
            try
            {
                long size = GetFileSize(filename);
                return true;

            }
            catch (Exception ex)
            {
                //only handle expected not-found exception
                if (ex is System.Net.WebException)
                {
                    //file does not exist/no rights error = 550
                    if (ex.Message.Contains("550"))
                    {
                        //clear
                        return false;
                    }
                    else
                    {
                        throw;
                    }
                }
                else
                {
                    throw;
                }
            }
        }

        /// <summary>
        /// Determine size of remote file
        /// </summary>
        /// <param name="filename">The filename.</param>
        /// <returns></returns>
        /// <remarks>
        /// Throws an exception if file does not exist
        /// </remarks>
        public long GetFileSize(string filename)
        {
            string path;
            if (filename.Contains("/"))
            {
                path = AdjustDir(filename);
            }
            else
            {
                path = this.CurrentDirectory + filename;
            }
            string URI = this.Hostname + path;
            System.Net.FtpWebRequest ftp = GetRequest(URI);
            ftp.Proxy = _proxy;
            //Try to get info on file/dir?
            ftp.Method = System.Net.WebRequestMethods.Ftp.GetFileSize;
            string tmp = this.GetStringResponse(ftp);
            return GetSize(ftp);
        }

        /// <summary>
        /// FTPs the rename.
        /// </summary>
        /// <param name="sourceFilename">The source filename.</param>
        /// <param name="newName">The new name.</param>
        /// <returns></returns>
        public bool Rename(string sourceFilename, string newName)
        {
            //Does file exist?
            string source = GetFullPath(sourceFilename);
            if (!FileExists(source))
            {
                throw (new FileNotFoundException("File " + source + " not found"));
            }

            //build target name, ensure it does not exist
            string target = GetFullPath(newName);
            if (target == source)
            {
                throw (new ApplicationException("Source and target are the same"));
            }
            else if (FileExists(target))
            {
                throw (new ApplicationException("Target file " + target + " already exists"));
            }

            //perform rename
            string URI = this.Hostname + source;

            System.Net.FtpWebRequest ftp = GetRequest(URI);
            ftp.Proxy = _proxy;
            //Set request to delete
            ftp.Method = System.Net.WebRequestMethods.Ftp.Rename;
            ftp.RenameTo = target;
            try
            {
                //get response but ignore it
                string str = GetStringResponse(ftp);
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// FTPs the create directory.
        /// </summary>
        /// <param name="dirpath">The dirpath.</param>
        /// <returns></returns>
        public bool CreateDirectory(string dirpath)
        {
            //perform create
            string URI = this.Hostname + AdjustDir(dirpath);
            System.Net.FtpWebRequest ftp = GetRequest(URI);
            ftp.Proxy = _proxy;
            //Set request to MkDir
            ftp.Method = System.Net.WebRequestMethods.Ftp.MakeDirectory;
            try
            {
                //get response but ignore it
                string str = GetStringResponse(ftp);
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// FTPs the delete directory.
        /// </summary>
        /// <param name="dirpath">The dirpath.</param>
        /// <returns></returns>
        public bool DeleteDirectory(string dirpath)
        {
            //perform remove
            string URI = this.Hostname + AdjustDir(dirpath);
            System.Net.FtpWebRequest ftp = GetRequest(URI);
            ftp.Proxy = _proxy;
            //Set request to RmDir
            ftp.Method = System.Net.WebRequestMethods.Ftp.RemoveDirectory;
            try
            {
                //get response but ignore it
                string str = GetStringResponse(ftp);
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }

        //Get the basic FtpWebRequest object with the
        //common settings and security
        /// <summary>
        /// Gets the request.
        /// </summary>
        /// <param name="URI">The URI.</param>
        /// <returns></returns>
        private FtpWebRequest GetRequest(string URI)
        {
            //create request
            FtpWebRequest result = (FtpWebRequest)FtpWebRequest.Create(URI);
            result.Proxy = _proxy;
            //Set the login details
            result.Credentials = GetCredentials();
            //Do not keep alive (stateless mode)
            result.KeepAlive = false;
            return result;
        }


        /// <summary>
        /// Get the credentials from username/password
        /// </summary>
        /// <returns></returns>
        private System.Net.ICredentials GetCredentials()
        {
            return new System.Net.NetworkCredential(Username, Password);
        }

        /// <summary>
        /// returns a full path using CurrentDirectory for a relative file reference
        /// </summary>
        /// <param name="file">The file.</param>
        /// <returns></returns>
        private string GetFullPath(string file)
        {
            if (file.Contains("/"))
            {
                return AdjustDir(file);
            }
            else
            {
                return this.CurrentDirectory + file;
            }
        }

        /// <summary>
        /// Amend an FTP path so that it always starts with /
        /// </summary>
        /// <param name="path">Path to adjust</param>
        /// <returns></returns>
        private string AdjustDir(string path)
        {
            return ((path.StartsWith("/")) ? "" : "/").ToString() + path;
        }

        private string GetDirectory(string directory)
        {
            string URI;
            if (directory == "")
            {
                //build from current
                URI = Hostname + this.CurrentDirectory;
                _lastDirectory = this.CurrentDirectory;
            }
            else
            {
                if (!directory.StartsWith("/"))
                {
                    throw (new ApplicationException("Directory should start with /"));
                }
                URI = this.Hostname + directory;
                _lastDirectory = directory;
            }
            return URI;
        }

        //stores last retrieved/set directory
        private string _lastDirectory = "";

        /// <summary>
        /// Obtains a response stream as a string
        /// </summary>
        /// <param name="ftp">current FTP request</param>
        /// <returns>String containing response</returns>
        /// <remarks>FTP servers typically return strings with CR and
        /// not CRLF. Use respons.Replace(vbCR, vbCRLF) to convert
        /// to an MSDOS string</remarks>
        private string GetStringResponse(FtpWebRequest ftp)
        {
            //Get the result, streaming to a string
            string result = "";
            using (FtpWebResponse response = (FtpWebResponse)ftp.GetResponse())
            {
                long size = response.ContentLength;
                using (Stream datastream = response.GetResponseStream())
                {
                    using (StreamReader sr = new StreamReader(datastream))
                    {
                        result = sr.ReadToEnd();
                        sr.Close();
                    }

                    datastream.Close();
                }

                response.Close();
            }

            return result;
        }

        /// <summary>
        /// Gets the size of an FTP request
        /// </summary>
        /// <param name="ftp"></param>
        /// <returns></returns>
        /// <remarks></remarks>
        private long GetSize(FtpWebRequest ftp)
        {
            long size;
            using (FtpWebResponse response = (FtpWebResponse)ftp.GetResponse())
            {
                size = response.ContentLength;
                response.Close();
            }

            return size;
        }

        private IWebProxy _proxy;

        private string _hostname;
        /// <summary>
        /// Hostname
        /// </summary>
        /// <value></value>
        /// <remarks>Hostname can be in either the full URL format
        /// ftp://ftp.myhost.com or just ftp.myhost.com
        /// </remarks>
        public string Hostname
        {
            get
            {
                if (_hostname.StartsWith("ftp://"))
                {
                    return _hostname;
                }
                else
                {
                    return "ftp://" + _hostname;
                }
            }
            set
            {
                _hostname = value;
            }
        }
        private string _username;
        /// <summary>
        /// Username property
        /// </summary>
        /// <value></value>
        /// <remarks>Can be left blank, in which case 'anonymous' is returned</remarks>
        public string Username
        {
            get
            {
                return (_username == "" ? "anonymous" : _username);
            }
            set
            {
                _username = value;
            }
        }
        private string _password;
        /// <summary>
        /// Gets or sets the password.
        /// </summary>
        /// <value>
        /// The password.
        /// </value>
        public string Password
        {
            get
            {
                return _password;
            }
            set
            {
                _password = value;
            }
        }

        /// <summary>
        /// The CurrentDirectory value
        /// </summary>
        /// <remarks>Defaults to the root '/'</remarks>
        private string _currentDirectory = "/";
        /// <summary>
        /// Gets or sets the current directory.
        /// </summary>
        /// <value>
        /// The current directory.
        /// </value>
        public string CurrentDirectory
        {
            get
            {
                //return directory, ensure it ends with /
                return _currentDirectory + ((_currentDirectory.EndsWith("/")) ? "" : "/").ToString();
            }
            set
            {
                if (!value.StartsWith("/"))
                {
                    throw (new ApplicationException("Directory should start with /"));
                }
                _currentDirectory = value;
            }
        }
    }
}
