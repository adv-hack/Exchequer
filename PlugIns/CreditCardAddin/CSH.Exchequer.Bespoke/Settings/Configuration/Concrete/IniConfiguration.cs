using System;
using System.IO;
using System.Linq;

namespace CSH.Exchequer.Bespoke.Settings
{
    /// <summary>
    /// Provides read/write access to '.ini' configuration files
    /// </summary>
    public class IniConfiguration : IConfiguration
    {
        private string _path;

        /// <summary>
        /// Initializes a new instance of the <see cref="IniConfiguration"/> class.
        /// </summary>
        /// <param name="path">The path.</param>
        public IniConfiguration(string path)
        {
            if (!File.Exists(path))
                throw new FileNotFoundException("Could not find file '" + path + "'.", path);

            this._path = path;
        }

        /// <summary>
        /// Gets or sets the setting value with the specified key.
        /// </summary>
        public string this[string key, string section = ""]
        {
            get
            {
                return ReadSetting(this._path, section, key);
            }
            set
            {
                WriteSetting(this._path, section, key, value);
            }
        }

        /// <summary>
        /// Reads the setting.
        /// </summary>
        /// <param name="path">The path.</param>
        /// <param name="section">The section.</param>
        /// <param name="key">The key.</param>
        /// <returns></returns>
        private string ReadSetting(string path, string section, string key)
        {
            string result = String.Empty;

            using (StreamReader sr = new StreamReader(path))
            {
                string line = null;
                string currentKey = null;
                string currentSection = null;

                while ((line = sr.ReadLine()) != null)
                {
                    if (line.Contains('['))
                    {
                        //load the current key into variable
                        currentSection = GetSection(line);
                        continue;
                    }

                    if (line.Contains('='))
                    {
                        currentKey = line.Substring(0, line.IndexOf("="));

                        if (String.IsNullOrWhiteSpace(currentSection))
                        {
                            if (!String.IsNullOrEmpty(currentKey))
                            {
                                if (String.CompareOrdinal(key, currentKey) == 0)
                                {
                                    //value found
                                    result = line.Substring(line.IndexOf("=") + 1);
                                    break;
                                }
                            }
                        }
                        else
                        {
                            if (!String.IsNullOrEmpty(currentKey))
                            {
                                if ((String.CompareOrdinal(key, currentKey) == 0)
                                && (String.CompareOrdinal(section, currentSection) == 0))
                                {
                                    //value found
                                    result = line.Substring(line.IndexOf("=") + 1);
                                    break;
                                }
                            }
                        }
                        continue;
                    }
                }
            }
            return result;
        }

        /// <summary>
        /// Writes the setting.
        /// </summary>
        /// <param name="path">The path.</param>
        /// <param name="section">The section.</param>
        /// <param name="key">The key.</param>
        /// <param name="value">The value.</param>
        private void WriteSetting(string path, string section, string key, string value)
        {
            string currentSection = null;
            string[] contents = File.ReadAllLines(path);

            for (int i = 0; i < contents.Length; i++)
            {
                string line = contents[i];

                if (line.Contains('['))
                {
                    currentSection = GetSection(line);
                    continue;
                }

                if (String.IsNullOrWhiteSpace(currentSection))
                {
                    if (line.Contains(key + "="))
                    {
                        line = line.Remove(line.IndexOf('=') + 1);
                        line = line.Insert(0, value);
                        contents[i] = line;
                    }
                }
                else
                {
                    if (String.CompareOrdinal(section, currentSection) == 0)
                    {
                        if (line.Contains(key + "="))
                        {
                            line = line.Remove(line.IndexOf('=') + 1);
                            line = line.Insert(line.IndexOf('=') + 1, value);
                            contents[i] = line;
                        }
                    }
                }
            }
            
            File.WriteAllLines(path, contents);
        }

        /// <summary>
        /// Gets the section.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        private string GetSection(string value)
        {
            string result = value;
            //load the current key into variable
            result = result.Replace("[", String.Empty);
            result = result.Replace("]", String.Empty);
            return result;
        }
    }
}
