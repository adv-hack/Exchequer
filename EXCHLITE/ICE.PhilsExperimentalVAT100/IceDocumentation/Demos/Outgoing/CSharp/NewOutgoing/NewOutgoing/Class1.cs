using System;
using System.Collections.Generic;
using System.Text;
using NewOutgoing;
using System.Web;
using System.Net.Mail;
using System.Runtime.InteropServices;

namespace NewOutgoing
{
    [ComVisible(true)]
    [Guid("DFB99E8A-A124-4DA9-B56A-CD698DAD073B")]
    public class Class1: IDSROutgoingSystem
    {
        #region IDSROutgoingSystem Members

        public uint SendMsg(string pFrom, string pTo, string pSubject, string pBody, string pFiles)
        {

            MailMessage mail = new MailMessage();
            SmtpClient SmtpMail = new SmtpClient();

            mail.To.Add(new MailAddress(pTo));

            if (pFiles.Length > 0)
                mail.Attachments.Add(new Attachment(pFiles));

            mail.Subject = pSubject;
            mail.Body = pBody;

            mail.From = new MailAddress(pFrom);

            SmtpMail.Host = "192.168.0.1";
            SmtpMail.Port = 25;
            SmtpMail.Send(mail);

            return 0;
        }

        #endregion
    }
}
