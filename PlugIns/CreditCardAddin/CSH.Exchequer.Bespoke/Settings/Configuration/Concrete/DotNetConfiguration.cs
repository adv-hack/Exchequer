using System;
using System.Configuration;

namespace CSH.Exchequer.Bespoke.Settings
{
    /// <summary>
    /// Provides read/write access to .NET app.config files
    /// </summary>
    public class DotNetConfiguration : IConfiguration
    {
        private const string DEFAULT_SECTION = "appSettings";

        private Configuration Config { get; set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="DotNetConfiguration"/> class.
        /// </summary>
        public DotNetConfiguration()
        {
            this.Config = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
        }

        /// <summary>
        /// Gets or sets the setting value with the specified key.
        /// </summary>
        public string this[string key, string section = DEFAULT_SECTION]
        {
            get
            {
                string value = null;
                ConfigurationSection configurationSection = this.Config.GetSection(section);
                KeyValueConfigurationCollection settings = GetSettings(configurationSection);
                value = settings[key].Value;
                return value;
            }
            set
            {
                ConfigurationSection configurationSection = this.Config.GetSection(section);
                WriteSetting(configurationSection, key, value);
            }
        }

        /// <summary>
        /// Encrypts the config section.
        /// </summary>
        /// <param name="sectionKey">The section key.</param>
        public void EncryptConfigSection(string sectionKey)
        {
            ConfigurationSection section = this.Config.GetSection(sectionKey);
            if (section != null)
            {
                if (!section.SectionInformation.IsProtected)
                {
                    if (!section.ElementInformation.IsLocked)
                    {
                        section.SectionInformation.ProtectSection("DataProtectionConfigurationProvider");
                        section.SectionInformation.ForceSave = true;
                        this.Config.Save(ConfigurationSaveMode.Full);
                    }
                }
            }
        }

        /// <summary>
        /// Writes the setting.
        /// </summary>
        /// <param name="configurationSection">The configuration section.</param>
        /// <param name="key">The key.</param>
        /// <param name="value">The value.</param>
        private void WriteSetting(ConfigurationSection configurationSection, string key, string value)
        {
            KeyValueConfigurationCollection settings = GetSettings(configurationSection);

            if (settings[key] == null)
            {
                settings.Add(key, value);
            }
            else
            {
                settings[key].Value = value;
            }

            Config.Save(ConfigurationSaveMode.Full);
        }

        /// <summary>
        /// Gets the settings.
        /// </summary>
        /// <param name="configurationSection">The configuration section.</param>
        /// <returns></returns>
        private KeyValueConfigurationCollection GetSettings(ConfigurationSection configurationSection)
        {
            KeyValueConfigurationCollection result = null;
            if (configurationSection.GetType() == typeof(AppSettingsSection))
            {
                AppSettingsSection appSettingsSection = (AppSettingsSection)configurationSection;
                result = appSettingsSection.Settings;
            }
            else
            {
                throw new NotImplementedException();
            }

            return result;
        }
    }
}
