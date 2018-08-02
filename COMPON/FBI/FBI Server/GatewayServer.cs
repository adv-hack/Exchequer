using System;
using System.Xml;
using System.Net;
using System.IO;
using System.Collections;

namespace IRIS.Systems.InternetFiling
{
	/// <summary>
	/// Summary description for GovGateway.
	/// </summary>
	public class GatewayServer
	{
        /// <summary>
        /// Subit the prepared document to the gateway specified in gtwDoc.Url
        /// </summary>
        /// <param name="gtwDoc">The full assembled gateway document object</param>
        /// <returns>Tne response message provided by the gateway, this will usually be
        /// the initial submission ackowledgement</returns>
		static public XmlDocument Submit(GatewayDocument gtwDoc)
		{
			return PostToGateway(gtwDoc.GatewayDoc, gtwDoc.Url);
		}	
		
        /// <summary>
        /// Sends a delete request to the gateway specified in gtwDoc.Url, the gtwDoc must have a valid
        /// correlation identifier (i.e. it must be in the gateway somwhere.
        /// </summary>
        /// <param name="gtwDoc">The full assembled gateway document object</param>
        /// <returns>The reposnse receoived from the gateway, this will usually be the 
        /// deleteion ackowledgement</returns>
		static public XmlDocument Delete(GatewayDocument gtwDoc)
		{
			return PollingMessage("request", "delete", gtwDoc);
		}

        /// <summary>
        /// Allows an additional poll to be madce by the application, however if the polling 
        /// </summary>
        /// <param name="gtwDoc"></param>
        /// <returns></returns>
		static public XmlDocument Poll(GatewayDocument gtwDoc)
		{
			return PollingMessage("poll", "submit", gtwDoc);
		}

      static public XmlDocument RequestList(GatewayDocument gtwDoc)
      {
         return PollingMessage("request", "list", gtwDoc);
      }

      static private XmlDocument PostToGateway(string strMessage, string strUrl)
		{
			#region Set up the WebRequest object
         if (strUrl == "") return new XmlDocument();

         WebRequest wr = (WebRequest)WebRequest.Create(strUrl);
			wr.Timeout = 90000;
			wr.Method = "POST";

            #region Set up the proxy. We will use IE's settings

            // ABSEXCH-14471.  PKR. 29/07/2013.
            // Components rebuilt in VS2008.  The following call is obsolete in .NET 2.0 and above.
            // Replaced with recommended alternative.
//            wr.Proxy = WebProxy.GetDefaultProxy();
            wr.Proxy = WebRequest.GetSystemWebProxy();

            wr.Proxy.Credentials = CredentialCache.DefaultCredentials;
            #endregion
			#endregion
			
			#region Submit Document
			WebResponse wrsp = null;
			try
			{
				Stream reqStream = wr.GetRequestStream();
				StreamWriter reqWriter = new StreamWriter(reqStream);
				reqWriter.WriteLine(strMessage);
				reqWriter.Close();
			}
			catch
			{
				return null;
			}
			#endregion

         try {
            #region Receive Response
            wrsp = (HttpWebResponse)wr.GetResponse();
            Stream strm = wrsp.GetResponseStream();
            StreamReader sr = new StreamReader(strm);
            string strResponse = sr.ReadToEnd();

            sr.Close();
            strm.Close();


			#endregion
		
			#region Put the response in an XmlDocument object
			XmlDocument docResponse = new XmlDocument();
			docResponse.LoadXml(strResponse);

         return docResponse;
			#endregion
         }
         catch {
            return null;
         }

		}
	
		static private XmlDocument PollingMessage(string strQualifier, string strFunction, GatewayDocument gtwDoc)
        {
			// Polling messages like Poll or Delete are pretty basic, so we build them on the fly
			// and use the same template for both

			XmlDocument messageDoc = new XmlDocument();
			XmlDeclaration xmldecl = messageDoc.CreateXmlDeclaration("1.0", null, null);

			XmlNode root = messageDoc.CreateElement("GovTalkMessage");
			messageDoc.AppendChild(root);
			messageDoc.InsertBefore(xmldecl, root);

			XmlNode currentNode = root;
			((XmlElement) currentNode).SetAttribute("xmlns", "http://www.govtalk.gov.uk/CM/envelope");

			currentNode = messageDoc.CreateElement("EnvelopeVersion");
			currentNode.InnerText = "2.0";
			root.AppendChild(currentNode);

         XmlNode headerNode;
			XmlNode parentNode;
			
			headerNode = messageDoc.CreateElement("Header");
			parentNode = root.AppendChild(headerNode);

			currentNode = messageDoc.CreateElement("MessageDetails");
			parentNode = parentNode.AppendChild(currentNode);

			currentNode = messageDoc.CreateElement("Class");
			currentNode.InnerText = gtwDoc.DocumentType;
			parentNode.AppendChild(currentNode);

			currentNode = messageDoc.CreateElement("Qualifier");
			currentNode.InnerText = strQualifier;
			parentNode.AppendChild(currentNode);
	
			currentNode = messageDoc.CreateElement("Function");
			currentNode.InnerText = strFunction;
			parentNode.AppendChild(currentNode);

			currentNode = messageDoc.CreateElement("CorrelationID");
			currentNode.InnerText = gtwDoc.CorrelationID;
			parentNode.AppendChild(currentNode);

			currentNode = messageDoc.CreateElement("Transformation");
			currentNode.InnerText = "XML";
			parentNode.AppendChild(currentNode);

			if (gtwDoc.UsesTestGateway) 
			{
				currentNode = messageDoc.CreateElement("GatewayTest");
				currentNode.InnerText = "1";
				parentNode.AppendChild(currentNode);
			}

         currentNode = messageDoc.CreateElement("SenderDetails");
         parentNode = headerNode.AppendChild(currentNode);

	
			currentNode = messageDoc.CreateElement("GovTalkDetails");
			root = root.AppendChild(currentNode);

			currentNode = messageDoc.CreateElement("Keys");
			root.AppendChild(currentNode);

			root = root.ParentNode;

			currentNode = messageDoc.CreateElement("Body");
			root.AppendChild(currentNode);

         // JAY - Debug method for testing generated polling message
         //StreamWriter writer = new StreamWriter(
         //   string.Format("{0}\\{1}",
         //                  Environment.GetFolderPath(Environment.SpecialFolder.Desktop),
         //                  "out.xml"));
         //writer.Write(messageDoc.OuterXml);
         //writer.Close();

            return PostToGateway(messageDoc.OuterXml, gtwDoc.Url);
		}

		private GatewayServer() { }
	}
}
