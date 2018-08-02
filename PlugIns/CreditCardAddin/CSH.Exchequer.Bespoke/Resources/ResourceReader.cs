using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace CSH.Exchequer.Bespoke.Resources
{
    /// <summary>
    /// Provides streaming of pre-defined embedded resources, like icons.
    /// </summary>
    public class ResourceReader
    {
        /// <summary>
        /// Reads the specified resource type.
        /// </summary>
        /// <param name="resourceType">Type of the resource.</param>
        /// <returns></returns>
        public Stream Read(ResourceName resourceType)
        {
            Stream result = null;
            switch (resourceType)
            {
                case ResourceName.IRISBallIcon:
                    result = GetType().Module.Assembly.GetManifestResourceStream("CSH.Exchequer.Bespoke.Icons.irisball.ico");
                    break;
                case ResourceName.IrisBall32x32Icon:
                    result = GetType().Module.Assembly.GetManifestResourceStream("CSH.Exchequer.Bespoke.Icons.IrisBall32x32.ico");
                    break;
                default:
                    throw new NotImplementedException();
            }

            return result;
        }
    }
}
