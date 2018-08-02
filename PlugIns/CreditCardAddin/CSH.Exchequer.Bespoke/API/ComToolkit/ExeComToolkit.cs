using System;
using CSH.Exchequer.Bespoke.API.ComToolkit.Builders;

namespace CSH.Exchequer.Bespoke.API.ComToolkit
{
    /// <summary>
    /// 
    /// </summary>
    public sealed class ExeComToolkit : BaseComToolkit
    {
        /// <summary>
        /// Gets the count.
        /// </summary>
        public static int Count { get; private set; }

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
        /// Initializes a new instance of the <see cref="ExeComToolkit"/> class.
        /// </summary>
        /// <param name="dataDirectory">The data directory.</param>
        public ExeComToolkit(string dataDirectory)
            : this(dataDirectory, new ExeComToolkitBuilder())
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ExeComToolkit"/> class.
        /// </summary>
        /// <param name="dataDirectory">The data directory.</param>
        /// <param name="builder">The builder.</param>
        public ExeComToolkit(string dataDirectory, BaseComToolkitBuilder builder)
            : base(dataDirectory, builder)
        {
            ++Count;
        }

        /// <summary>
        /// Releases unmanaged and - optionally - managed resources
        /// </summary>
        /// <param name="disposing"><c>true</c> to release both managed and unmanaged resources; <c>false</c> to release only unmanaged resources.</param>
        protected override void Dispose(bool disposing)
        {
            --Count;
            base.Dispose(disposing);
        }
    }
}
