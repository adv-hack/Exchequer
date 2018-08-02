using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Text;
using System.Xml;

namespace HMRCFilingService
  {
  public static class PrettyPrinter
    {
    //---------------------------------------------------------------------------------------------
    public static String PrettyPrintXML(String XML)
      {
      String Result = string.Empty;

      MemoryStream mStream = null;
      XmlTextWriter writer = null;
      XmlDocument document = null;

      try
        {
        mStream = new MemoryStream();
        writer = new XmlTextWriter(mStream, Encoding.Unicode);
        document = new XmlDocument();

        try
          {
          // Load the XmlDocument with the XML.
          document.LoadXml(XML);

          writer.Formatting = Formatting.Indented;

          // Write the XML into a formatting XmlTextWriter
          document.WriteContentTo(writer);
          writer.Flush();
          mStream.Flush();

          // Have to rewind the MemoryStream in order to read its contents.
          mStream.Position = 0;

          // Read MemoryStream contents into a StreamReader.
          StreamReader sReader = new StreamReader(mStream);

          // Extract the text from the StreamReader.
          String FormattedXML = sReader.ReadToEnd();

          Result = FormattedXML;
          }
        catch (XmlException)
          {
          Result = "Invalid XML";
          }
        }
      finally
        {
        mStream.Close();
        }

      return Result;
      }

    }
  }