using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSH.Exchequer.Bespoke.Network.Email
{
    /// <summary>
    /// Represents an email message
    /// </summary>
    public class EmailMessage
    {
        /// <summary>
        /// From
        /// </summary>
        public string From = String.Empty;
        /// <summary>
        /// To
        /// </summary>
        public string To = String.Empty;
        /// <summary>
        /// Subject
        /// </summary>
        public string Subject = String.Empty;
        /// <summary>
        /// Body
        /// </summary>
        public string Body = String.Empty;
        /// <summary>
        /// BodyHTML
        /// </summary>
        public string BodyHTML = String.Empty;
        /// <summary>
        /// AttachmentPath
        /// </summary>
        public string AttachmentPath = String.Empty;
    }
}
