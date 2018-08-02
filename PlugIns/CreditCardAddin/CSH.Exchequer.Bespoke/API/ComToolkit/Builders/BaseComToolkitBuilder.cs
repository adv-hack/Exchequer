using System;
using System.IO;
using CSH.Exchequer.Bespoke.Exceptions;

namespace CSH.Exchequer.Bespoke.API.ComToolkit.Builders
{
    /// <summary>
    /// 
    /// </summary>
    public abstract class BaseComToolkitBuilder
    {
        /// <summary>
        /// Gets or sets the instance.
        /// </summary>
        /// <value>
        /// The instance.
        /// </value>
        public dynamic Instance { get; protected set; }

        /// <summary>
        /// Builds this instance.
        /// </summary>
        public abstract void Build();

        /// <summary>
        /// Configures the specified data directory.
        /// </summary>
        /// <param name="dataDirectory">The data directory.</param>
        public virtual void Configure(string dataDirectory)
        {
            if (this.Instance == null)
            {
                throw new BespokeLibraryException("this.instance == null. Ensure that Build is called before Configure");
            }

            if (!Directory.Exists(dataDirectory))
            {
                throw new DirectoryNotFoundException("Could not find a part of the path '" + dataDirectory + "'.");
            }

            this.Instance.Configuration.DataDirectory = dataDirectory;
            this.Instance.Configuration.OverwriteTransactionNumbers = true;
        }
    }
}
