using System;
using System.Collections.Generic;

namespace CSH.Exchequer.Bespoke.Network.Ftp
{
    /// <summary>
    /// Stores a list of files and directories from an FTP result
    /// </summary>
    /// <remarks></remarks>
    public class FtpDirectory : List<FtpFileInfo>
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="FtpDirectory"/> class.
        /// </summary>
        public FtpDirectory()
        {
            //creates a blank directory listing
        }

        /// <summary>
        /// Constructor: create list from a (detailed) directory string
        /// </summary>
        /// <param name="dir">directory listing string</param>
        /// <param name="path"></param>
        /// <remarks></remarks>
        public FtpDirectory(string dir, string path)
        {
            foreach (string line in dir.Replace("\n", "").Split(System.Convert.ToChar('\r')))
            {
                //parse
                if (line != "")
                {
                    this.Add(new FtpFileInfo(line, path));
                }
            }
        }

        /// <summary>
        /// Filter out only files from directory listing
        /// </summary>
        /// <param name="ext">optional file extension filter</param>
        /// <returns>FTPdirectory listing</returns>
        public FtpDirectory GetFiles(string ext = "")
        {
            return this.GetFileOrDir(FtpFileInfo.DirectoryEntryTypes.File, ext);
        }

        /// <summary>
        /// Returns a list of only subdirectories
        /// </summary>
        /// <returns>FTPDirectory list</returns>
        /// <remarks></remarks>
        public FtpDirectory GetDirectories()
        {
            return this.GetFileOrDir(FtpFileInfo.DirectoryEntryTypes.Directory, "");
        }

        //internal: share use function for GetDirectories/Files
        private FtpDirectory GetFileOrDir(FtpFileInfo.DirectoryEntryTypes type, string ext)
        {
            FtpDirectory result = new FtpDirectory();
            foreach (FtpFileInfo fi in this)
            {
                if (fi.FileType == type)
                {
                    if (ext == "")
                    {
                        result.Add(fi);
                    }
                    else if (ext == fi.Extension)
                    {
                        result.Add(fi);
                    }
                }
            }
            return result;
        }

        /// <summary>
        /// Files the exists.
        /// </summary>
        /// <param name="filename">The filename.</param>
        /// <returns></returns>
        public bool FileExists(string filename)
        {
            foreach (FtpFileInfo ftpfile in this)
            {
                if (ftpfile.Filename == filename)
                {
                    return true;
                }
            }
            return false;
        }

        private const char slash = '/';

        /// <summary>
        /// Gets the parent directory.
        /// </summary>
        /// <param name="dir">The dir.</param>
        /// <returns></returns>
        public static string GetParentDirectory(string dir)
        {
            string tmp = dir.TrimEnd(slash);
            int i = tmp.LastIndexOf(slash);
            if (i > 0)
            {
                return tmp.Substring(0, i - 1);
            }
            else
            {
                throw (new ApplicationException("No parent for root"));
            }
        }
    }
}

