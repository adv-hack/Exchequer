using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSH.Exchequer.Bespoke.API
{
    /// <summary>
    /// Friendly names for common Btrieve return codes
    /// </summary>
    public enum ReturnCode
    {
        /// <summary>
        /// NoError
        /// </summary>
        NoError = 0,
        /// <summary>
        /// KeyValueNotFound
        /// </summary>
        KeyValueNotFound = 4,
        /// <summary>
        /// EndOfFile
        /// </summary>
        EndOfFile = 9
    }
}
