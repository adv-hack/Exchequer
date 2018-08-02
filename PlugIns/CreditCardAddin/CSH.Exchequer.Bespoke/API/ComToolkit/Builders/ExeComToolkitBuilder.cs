using System;

namespace CSH.Exchequer.Bespoke.API.ComToolkit.Builders
{
    /// <summary>
    /// 
    /// </summary>
    public class ExeComToolkitBuilder : BaseComToolkitBuilder
    {
        /// <summary>
        /// Builds this instance.
        /// </summary>
        public override void Build()
        {
            Enterprise04.IToolkit toolkit = new Enterprise04.Toolkit();
            this.Instance = toolkit;
        }
    }
}
