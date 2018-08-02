using System;
using System.Collections.Specialized;
using System.Configuration;
using System.Reflection;
using System.Text.RegularExpressions;
using CSH.Exchequer.Bespoke.Extensions.Primitives;

namespace CSH.Exchequer.Bespoke.Versioning
{
    /// <summary>
    /// Provides read access to assembly information
    /// </summary>
    public static class AssemblyAttributes
    {
        private static string _strAppBase;
        private static string _strConfigPath;
        private static string _strSecurityZone;
        private static string _strRuntimeVersion;

        private static System.Collections.Specialized.NameValueCollection _objAssemblyAttribs = null;

        static AssemblyAttributes()
        {
            // to keep this class from being creatable as an instance.
            _objAssemblyAttribs = GetAssemblyAttribs();
        }

        /// <summary>
        /// Gets a value indicating whether [debug mode].
        /// </summary>
        /// <value>
        ///   <c>true</c> if [debug mode]; otherwise, <c>false</c>.
        /// </value>
        public static bool DebugMode
        {
            get
            {
                return System.Diagnostics.Debugger.IsAttached;
            }
        }

        /// <summary>
        /// Gets the build date.
        /// </summary>
        public static string BuildDate
        {
            get
            {
                return _objAssemblyAttribs["BuildDate"];
            }
        }

        /// <summary>
        /// Gets the product.
        /// </summary>
        public static string Product
        {
            get
            {
                return _objAssemblyAttribs["Product"];
            }
        }

        /// <summary>
        /// Gets the company.
        /// </summary>
        public static string Company
        {
            get
            {
                return _objAssemblyAttribs["Company"];
            }
        }

        /// <summary>
        /// Gets the copyright.
        /// </summary>
        public static string Copyright
        {
            get
            {
                return _objAssemblyAttribs["Copyright"];
            }
        }

        /// <summary>
        /// Gets the description.
        /// </summary>
        public static string Description
        {
            get
            {
                return _objAssemblyAttribs["Description"];
            }
        }

        /// <summary>
        /// Gets the title.
        /// </summary>
        public static string Title
        {
            get
            {
                return _objAssemblyAttribs["Title"];
            }
        }

        /// <summary>
        /// Gets the name of the file.
        /// </summary>
        /// <value>
        /// The name of the file.
        /// </value>
        public static string FileName
        {
            get { return Regex.Match(Path, "[^/]*.(exe|dll)", RegexOptions.IgnoreCase).ToString(); }
        }

        /// <summary>
        /// Gets the path.
        /// </summary>
        public static string Path
        {
            get
            {
                return _objAssemblyAttribs["CodeBase"];
            }
        }

        /// <summary>
        /// Gets the full name.
        /// </summary>
        public static string FullName
        {
            get
            {
                return _objAssemblyAttribs["FullName"];
            }
        }

        /// <summary>
        /// Gets the runtime version.
        /// </summary>
        public static string RuntimeVersion
        {
            get
            {
                if (_strRuntimeVersion == null)
                {
                    //-- returns 1.0.3705.288; we don't want that much detail
                    _strRuntimeVersion = Regex.Match(System.Environment.Version.ToString(), "\\d+.\\d+.\\d+").ToString();
                }
                return _strRuntimeVersion;
            }
        }

        /// <summary>
        /// Gets the file version.
        /// </summary>
        public static string FileVersion
        {
            get
            {
                return _objAssemblyAttribs["Version"];
            }
        }

        /// <summary>
        /// Gets the informational version.
        /// </summary>
        public static string InformationalVersion
        {
            get
            {
                return _objAssemblyAttribs["InformationalVersion"];
            }
        }

        /// <summary>
        /// Gets the config path.
        /// </summary>
        public static string ConfigPath
        {
            get
            {
                if (_strConfigPath == null)
                {
                    _strConfigPath = Convert.ToString(System.AppDomain.CurrentDomain.GetData("APP_CONFIG_FILE"));
                }
                return _strConfigPath;
            }
        }

        /// <summary>
        /// Gets the app base.
        /// </summary>
        public static string AppBase
        {
            get
            {
                if (_strAppBase == null)
                {
                    _strAppBase = Convert.ToString(System.AppDomain.CurrentDomain.GetData("APPBASE"));
                }
                return _strAppBase;
            }
        }

        /// <summary>
        /// Gets the security zone.
        /// </summary>
        public static string SecurityZone
        {
            get
            {
                if (_strSecurityZone == null)
                {
                    _strSecurityZone = System.Security.Policy.Zone.CreateFromUrl(AppBase).SecurityZone.ToString();
                }
                return _strSecurityZone;
            }
        }

        /// <summary>
        /// Gets the version.
        /// </summary>
        public static Version Version
        {
            get { return GetEntryAssembly().GetName().Version; }
        }

        private static Assembly GetEntryAssembly()
        {
            if (System.Reflection.Assembly.GetEntryAssembly() == null)
            {
                return System.Reflection.Assembly.GetCallingAssembly();
            }
            else
            {
                return System.Reflection.Assembly.GetEntryAssembly();
            }
        }

        //--
        //-- returns string name / string value pair of all attribs
        //-- for specified assembly
        //--
        //-- note that Assembly* values are pulled from AssemblyInfo file in project folder
        //--
        //-- Product         = AssemblyProduct string
        //-- Copyright       = AssemblyCopyright string
        //-- Company         = AssemblyCompany string
        //-- Description     = AssemblyDescription string
        //-- Title           = AssemblyTitle string
        //--
        private static NameValueCollection GetAssemblyAttribs()
        {
            object[] objAttributes = null;
            object objAttribute = null;
            string strAttribName = null;
            string strAttribValue = null;
            System.Collections.Specialized.NameValueCollection objNameValueCollection = new System.Collections.Specialized.NameValueCollection();
            System.Reflection.Assembly objAssembly = GetEntryAssembly();

            objAttributes = objAssembly.GetCustomAttributes(false);
            foreach (object objAttribute_loopVariable in objAttributes)
            {
                objAttribute = objAttribute_loopVariable;
                strAttribName = objAttribute.GetType().ToString();
                strAttribValue = "";
                switch (strAttribName)
                {
                    case "System.Reflection.AssemblyInformationalVersionAttribute":
                        strAttribName = "InformationalVersion";
                        strAttribValue = ((AssemblyInformationalVersionAttribute)objAttribute).InformationalVersion.ToString();
                        break;
                    case "System.Reflection.AssemblyTrademarkAttribute":
                        strAttribName = "Trademark";
                        strAttribValue = ((AssemblyTrademarkAttribute)objAttribute).Trademark.ToString();
                        break;
                    case "System.Reflection.AssemblyProductAttribute":
                        strAttribName = "Product";
                        strAttribValue = ((AssemblyProductAttribute)objAttribute).Product.ToString();
                        break;
                    case "System.Reflection.AssemblyCopyrightAttribute":
                        strAttribName = "Copyright";
                        strAttribValue = ((AssemblyCopyrightAttribute)objAttribute).Copyright.ToString();
                        break;
                    case "System.Reflection.AssemblyCompanyAttribute":
                        strAttribName = "Company";
                        strAttribValue = ((AssemblyCompanyAttribute)objAttribute).Company.ToString();
                        break;
                    case "System.Reflection.AssemblyTitleAttribute":
                        strAttribName = "Title";
                        strAttribValue = ((AssemblyTitleAttribute)objAttribute).Title.ToString();
                        break;
                    case "System.Reflection.AssemblyDescriptionAttribute":
                        strAttribName = "Description";
                        strAttribValue = ((AssemblyDescriptionAttribute)objAttribute).Description.ToString();
                        break;
                    default:
                        break;
                }
                if (!string.IsNullOrEmpty(strAttribValue))
                {
                    if (string.IsNullOrEmpty(objNameValueCollection[strAttribName]))
                    {
                        objNameValueCollection.Add(strAttribName, strAttribValue);
                    }
                }
            }

            //-- add some extra values that are not in the AssemblyInfo, but nice to have
            objNameValueCollection.Add("CodeBase", objAssembly.CodeBase.Replace("file:///", ""));
            objNameValueCollection.Add("BuildDate", AssemblyBuildDate(objAssembly).ToString());
            objNameValueCollection.Add("Version", objAssembly.GetName().Version.ToString());
            objNameValueCollection.Add("FullName", objAssembly.FullName);

            //-- we must have certain assembly keys to proceed.
            if (objNameValueCollection["Product"] == null)
            {
                objNameValueCollection["Product"] = "";
            }
            if (objNameValueCollection["Company"] == null)
            {
                objNameValueCollection["Company"] = "";
            }

            return objNameValueCollection;
        }

        //--
        //-- exception-safe file attrib retrieval; we don't care if this fails
        //--
        private static DateTime AssemblyFileTime(System.Reflection.Assembly objAssembly)
        {
            try
            {
                return System.IO.File.GetLastWriteTime(objAssembly.Location);
            }
            catch (Exception)
            {
                return DateTime.MaxValue;
            }
        }

        //--
        //-- returns build datetime of assembly
        //-- assumes default assembly value in AssemblyInfo:
        //-- <Assembly: AssemblyVersion("1.0.*")>
        //--
        //-- filesystem create time is used, if revision and build were overridden by user
        //--
        private static DateTime AssemblyBuildDate(System.Reflection.Assembly objAssembly, bool blnForceFileDate = false)
        {
            System.Version objVersion = objAssembly.GetName().Version;
            DateTime dtBuild = default(DateTime);

            if (blnForceFileDate)
            {
                dtBuild = AssemblyFileTime(objAssembly);
            }
            else
            {
                //dtBuild = ((DateTime)"01/01/2000").AddDays(objVersion.Build).AddSeconds(objVersion.Revision * 2);
                dtBuild = Convert.ToDateTime("01/01/2000").AddDays((double)objVersion.Build).AddSeconds((double)(objVersion.Revision * 2));
                if (TimeZone.IsDaylightSavingTime(dtBuild, TimeZone.CurrentTimeZone.GetDaylightChanges(dtBuild.Year)))
                {
                    dtBuild = dtBuild.AddHours(1);
                }
                if (dtBuild > DateTime.Now | objVersion.Build < 730 | objVersion.Revision == 0)
                {
                    dtBuild = AssemblyFileTime(objAssembly);
                }
            }

            return dtBuild;
        }
    }
}
