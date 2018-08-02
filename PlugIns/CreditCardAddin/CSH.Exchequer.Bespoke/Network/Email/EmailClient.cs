using System;
using System.Diagnostics;
using System.Net;
using System.Net.Sockets;
using System.Net.Mail;
using System.Text;
using System.Threading;


namespace CSH.Exchequer.Bespoke.Network.Email
{
/// <summary>
    /// Represents an SMTP email client
    /// </summary>
    public class EmailClient
    {
        private string _strServer = "exchcas.isofin.co.uk";
        /// <summary>
        /// Gets or sets the server.
        /// </summary>
        /// <value>
        /// The server.
        /// </value>
        public string Server
        {
            get { return _strServer; }
            set { _strServer = value; }
        }

        private int _intPort = 25;
        /// <summary>
        /// Gets or sets the port.
        /// </summary>
        /// <value>
        /// The port.
        /// </value>
        public int Port
        {
            get { return _intPort; }
            set { _intPort = value; }
        }

        /// <summary>
        /// Sends the mail.
        /// </summary>
        /// <param name="mail">The mail.</param>
        /// <returns></returns>
        public bool SendMail(EmailMessage mail)
        {
            bool result = true;

            try
            {
                using (SmtpClient client = new SmtpClient(this.Server, this.Port))
                {
                    client.UseDefaultCredentials = true;

                    using (MailMessage message = new MailMessage())
                    {
                        message.To.Add(new MailAddress(mail.To));
                        message.From = new MailAddress(mail.From);
                        message.Subject = mail.Subject;

                        if (String.IsNullOrWhiteSpace(mail.BodyHTML))
                        {
                            message.Body = mail.Body;
                        }
                        else
                        {
                            message.IsBodyHtml = true;
                            message.Body = mail.BodyHTML;
                        }

                        if (!String.IsNullOrWhiteSpace(mail.AttachmentPath))
                            message.Attachments.Add(new Attachment(mail.AttachmentPath));

                        client.Send(message);
                    }
                }
            }
            catch (Exception ex)
            {
                Trace.WriteLine(ex.ToString());
                result = false;
            }

            return result;
        }
    }
}
