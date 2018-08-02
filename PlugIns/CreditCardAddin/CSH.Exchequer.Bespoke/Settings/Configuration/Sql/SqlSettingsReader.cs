using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Runtime.InteropServices;
using System.Runtime.CompilerServices;
using System.Xml;
using System.Xml.Linq;
using CSH.Exchequer.Bespoke.Exceptions;

namespace CSH.Exchequer.Bespoke.Settings.Sql
{
    //[Obsolete("Use app.config instead.")]
    /// <summary>
    /// Reads SQL connection string information from the standard SQL bespoke XML configuration file
    /// </summary>
    public class SqlSettingsReader
    {
        private XDocument _ExchBespokeXML = null;

        /// <summary>
        /// Initializes a new instance of the <see cref="SqlSettingsReader"/> class.
        /// </summary>
        /// <param name="path">The path.</param>
        public SqlSettingsReader(string path)
        {
            if (File.Exists(path))
            {
                _ExchBespokeXML = XDocument.Load(path);
            }
            else
            {
                throw new FileNotFoundException("Could not find file '" + path + "'.", path);
            }
        }

        /// <summary>
        /// Gets the bespoke database name from XML file.
        /// </summary>
        /// <param name="PlugInCode">The plug in code.</param>
        /// <returns></returns>
        public string GetBespokeDatabaseNameFromXML(string PlugInCode)
        {
            //Check if XML file Exists
            if (_ExchBespokeXML == null)
                return "";

            //initialise
            bool CorrectBespokeFound = false;
            string DatabaseName = "";

            //read through XML
            foreach (var element in _ExchBespokeXML.Descendants().Elements())
            {
                if (element.Name.ToString().ToUpper() == "PLUGINS")
                {
                    foreach (var element2 in element.Elements())
                    {
                        if (element2.Name.ToString().ToUpper() == "PLUGIN")
                        {
                            foreach (var element3 in element2.Elements())
                            {
                                if (CorrectBespokeFound)
                                {
                                    if (element3.Name.ToString().ToUpper() == "SQLDATABASE")
                                    {
                                        foreach (var element4 in element3.Elements())
                                        {
                                            if (element4.Name.ToString().ToUpper() == "NAME")
                                            {
                                                // found Database name
                                                DatabaseName = element4.Value;
                                            }
                                        }
                                    }
                                }

                                if (element3.Name.ToString().ToUpper() == "CODE")
                                {
                                    // Check bespoke code

                                    if (element3.Value.ToUpper() == PlugInCode.ToUpper())
                                    {
                                        // found section for this plugin
                                        CorrectBespokeFound = true;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            return DatabaseName;
        }


        /// <summary>
        /// Gets the MSSQL server name for a pervasive edition of exchequer.
        /// </summary>
        /// <returns></returns>
        public string GetMSSQLServerNameForPervasiveExchequer()
        {

            //Check if XML file Exists
            if (_ExchBespokeXML == null)
                return "";

            //initialise
            string ServerName = "";

            //read through XML
            foreach (var element in _ExchBespokeXML.Descendants().Elements())
            {
                if (element.Name.ToString().ToUpper() == "PERVASIVE")
                {
                    foreach (var element2 in element.Elements())
                    {
                        if (element2.Name.ToString().ToUpper() == "SERVERNAME")
                        {
                            // Found MS_SQL Server name for Pervasive Exchequer
                            ServerName = element2.Value;
                        }
                    }
                }
            }

            return ServerName;
        }

        /// <summary>
        /// Gets the connection string.
        /// </summary>
        /// <param name="PlugInCode">The plug in code.</param>
        /// <param name="ServerName">Name of the server.</param>
        /// <param name="BespokeSQLUserName">Name of the bespoke SQL user.</param>
        /// <param name="SQLRWPassword">The SQL read/write password.</param>
        /// <returns></returns>
        public string GetConnectionString(string PlugInCode, string ServerName, string BespokeSQLUserName, string SQLRWPassword)
        {
            //Build connection string
            string BespokeDatabaseName = GetBespokeDatabaseNameFromXML(PlugInCode);
            return "Data Source=" + ServerName + ";" + "Initial Catalog=" + BespokeDatabaseName + ";" + "User Id=" + BespokeSQLUserName + ";" + "Password=" + SQLRWPassword + ";";
        }
    }
}
