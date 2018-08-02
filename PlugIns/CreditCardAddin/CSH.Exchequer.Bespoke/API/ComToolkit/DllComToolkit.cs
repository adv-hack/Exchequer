using System;
using CSH.Exchequer.Bespoke.API.ComToolkit.Builders;

namespace CSH.Exchequer.Bespoke.API.ComToolkit
{
    /// <summary>
    /// 
    /// </summary>
    public sealed class DllComToolkit : BaseComToolkit
    {
        private new Enterprise04.IToolkit instance;
        /// <summary>
        /// Gets the instance.
        /// </summary>
        public Enterprise04.IToolkit Instance
        {
            get
            {
                base.CheckToolkit();
                if (this.instance == null)
                {
                    this.instance = base.instance;
                }
                return this.instance;
            }
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="DllComToolkit"/> class.
        /// </summary>
        /// <param name="dataDirectory">The data directory.</param>
        public DllComToolkit(string dataDirectory)
            : this(dataDirectory, new DllComToolkitBuilder())
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="DllComToolkit"/> class.
        /// </summary>
        /// <param name="dataDirectory">The data directory.</param>
        /// <param name="builder">The builder.</param>
        public DllComToolkit(string dataDirectory, BaseComToolkitBuilder builder)
            : base(dataDirectory, builder)
        {
        }
    }
}
