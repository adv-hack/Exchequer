
namespace CSH.Exchequer.Bespoke.Settings
{
    /// <summary>
    /// Provides a contract for all configuration reading/writing classes
    /// </summary>
    public interface IConfiguration
    {
        /// <summary>
        /// Gets or sets the setting value with the specified key.
        /// </summary>
        string this[string key, string section] { get; set; }
    }
}