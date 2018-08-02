using System;
using System.Xml;
using System.Security;
using System.Security.Cryptography;
using System.Security.Cryptography.Xml;
using System.IO;
using System.Text;
using System.Diagnostics;


namespace IRIS.Systems.InternetFiling
{
   /// <summary>
   /// Summary description for Class1.
   /// </summary>
   public class IRMark32
   {
      /// <summary>
      /// The main entry point for the application.
      /// </summary> 
      private static String base32Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";

      public static string AddIRMark(ref string DocumentXml, string ManifestNameSpace)
      {
         
         // write the Xml to a temporary file

         XmlDocument originalDoc = new XmlDocument();

         string irMark;
         try {
            // Load the Xml into a document
            originalDoc.LoadXml(DocumentXml);

         }
         catch (XmlException xex) {
             throw xex;
             // The following code is unreachable and causes a compiler warning
             // return String.Format("Unable to process {0}", xex.ToString());
         }
         catch (Exception ex) {
             throw ex;
             // The following code is unreachable and causes a compiler warning
             // return string.Format("An unhandled excpetion:\n\r {0}\n\r occurred", ex.ToString());
         }

         try
         {

             irMark = AddIRMark(ref originalDoc, ManifestNameSpace);
         }
            catch (Exception ex)
         {
             irMark = ex.Message;
            }


         DocumentXml = originalDoc.OuterXml;
         return irMark;

      }


      /// <summary>
      /// Takes a document
      /// </summary>
      /// <param name="args"></param>
      /// <returns></returns>
      public static string AddIRMark(ref XmlDocument originalDoc, string ManifestNameSpace)
      {

          try
          {

              if ((originalDoc == null) || (originalDoc.ChildNodes.Count == 0))
              {
                  return "";
              }

              // Load XML Return
              originalDoc.PreserveWhitespace = false;
              //              originalDoc.WriteTo(new XmlTextWriter("c:\\OriginalDoc.xml", Encoding.ASCII));

              // Step 1. Clone the original document and create a workspace object
              XmlDocument canonDoc = new XmlDocument();
              canonDoc.LoadXml(originalDoc.OuterXml);


              // We also pick up the name table from the original document
              XmlNamespaceManager nsMgr = new XmlNamespaceManager(canonDoc.NameTable);

              // Define namespaces within the document:
              nsMgr.AddNamespace("ir", ManifestNameSpace);                         // Define a namespace for the IRheader
              nsMgr.AddNamespace("gt", "http://www.govtalk.gov.uk/CM/envelope");   // Define a namespace for the GovTalk element


              XmlNode bodyNode = null;
              try
              {
                  // Step 2. Find the Body node and add the GovTalk namespace to it.
                  // Originally was using select single node but this has been replced
                  // with GetElementByTagName as SelectSingleNode has cannot be used
                  // through the COM interface.

                  //bodyNode = canonDoc.SelectSingleNode("//gt:Body", nsMgr);

                  XmlNodeList BodyNodeList = canonDoc.GetElementsByTagName("Body", "http://www.govtalk.gov.uk/CM/envelope");
                  bodyNode = BodyNodeList[0];

                  bodyNode.Attributes.Append(canonDoc.CreateAttribute("xmlns"));
                  bodyNode.Attributes["xmlns"].Value = "http://www.govtalk.gov.uk/CM/envelope";

              }
              catch (Exception ex)
              {
                  throw ex;
              }



              // Step 2. Find the IRmark and remove it
              // Originally was using select single node but this has been replced
              // with GetElementByTagName as SelectSingleNode has cannot be used
              // through the COM interface.

              //              XmlNode IRheader = canonDoc.SelectSingleNode("//ir:IRheader", nsMgr);
              //              XmlNode irMarkNode = IRheader.SelectSingleNode("//ir:IRmark", nsMgr);

              //if (irMarkNode != null)
              //    IRheader.RemoveChild(irMarkNode);


              XmlNodeList IRHeaderNodeList;
//              XmlNodeList irMarkNodeList;
              XmlNode IRheader;
              XmlNode irMarkNode;

              IRHeaderNodeList = canonDoc.GetElementsByTagName("IRheader", ManifestNameSpace);
              IRheader = IRHeaderNodeList[0];

              foreach (XmlNode SearchNode in IRheader.ChildNodes)
              {
                  if (SearchNode.Name == "IRmark")
                      SearchNode.ParentNode.RemoveChild(SearchNode);
//                      SearchNode.RemoveAll();
              }

              //Step 4. Generate IRmark
              canonDoc.PreserveWhitespace = true;


              // 4a. Extract <Body /> element into an XmlDocument
              XmlDocument workSpace = new XmlDocument();
              workSpace.LoadXml(bodyNode.OuterXml);



              // 4b. Canonicalise Document
              XmlDsigC14NWithCommentsTransform transform = new XmlDsigC14NWithCommentsTransform();
              transform.LoadInput(workSpace);


              // 4c. Create SHA1 digest
              Stream s = (Stream)transform.GetOutput(typeof(Stream));
              SHA1 sha1 = SHA1.Create();


              // 4d. Compute byte-array hash
              byte[] hash = sha1.ComputeHash(s);


              // Step 5. Replace the IRmark in the original document with the computed hash
              // Originally was using select single node but this has been replced
              // with GetElementByTagName as SelectSingleNode has cannot be used
              // through the COM interface.

              //              irMarkNode = originalDoc.SelectSingleNode("//ir:IRmark", nsMgr);
              XmlNodeList irMarkNodeList2;
              irMarkNodeList2 = originalDoc.GetElementsByTagName("IRmark", ManifestNameSpace);
              irMarkNode = irMarkNodeList2[0];
              if (irMarkNode == null)
              {
                  // Add the IRMark at the specified location
                  //                  XmlNode parentNode = originalDoc.SelectSingleNode("//ir:IRheader");
                  //                  XmlNode precedingNode = originalDoc.SelectSingleNode("//ir:Sender");
                  XmlNodeList parentNodeList;
                  XmlNodeList precedingNodeList;

                  parentNodeList = originalDoc.GetElementsByTagName("IRheader", ManifestNameSpace);
                  precedingNodeList = originalDoc.GetElementsByTagName("Sender", ManifestNameSpace);
                  XmlNode parentNode = parentNodeList[0];
                  XmlNode precedingNode = precedingNodeList[0];

                  irMarkNode = originalDoc.CreateElement("IRmark");
                  parentNode.InsertBefore(irMarkNode, precedingNode);
              }


              // 5a. Create the "Type" attribute if it does not exist
              bool found = false;
              foreach (XmlAttribute attr in irMarkNode.Attributes)
              {
                  if (attr.Name == "Type")
                  {
                      found = true;
                      break;
                  }
              }
              if (!found)
                  irMarkNode.Attributes.Prepend(originalDoc.CreateAttribute("Type"));


              // 5b. Assign the "Type" attribute the value of "generic"
              irMarkNode.Attributes["Type"].Value = "generic";


              // 5c. Convert the IRmark byte-array to a Base-64 string and set the  node with this value:
              irMarkNode.InnerText = Convert.ToBase64String(hash);


              // 6. Return the IRmark in Base32.
              return IRMark32.ToBase32String(hash);
          }
          catch // (Exception ex)
          {
              return "Failed the genration of the IR Mark";
          }

          // The following code is unreachable and causes a compiler warning
          // return "Failed the genration of the IR Mark";
      }

      static public String ToBase32String(byte[] bytes)
      {
         int i = 0, index = 0, digit = 0;
         int currByte, nextByte;
         StringBuilder base32 = new StringBuilder((bytes.Length + 7) * 8 / 5);

         while(i < bytes.Length) {
            currByte = (bytes[i] >= 0) ? bytes[i] : (bytes[i] + 256);

            if(index > 3) {
               if((i + 1) < bytes.Length) {
                  nextByte =
                     (bytes[i + 1] >= 0) ? bytes[i + 1] : (bytes[i + 1] + 256);
               }
               else {
                  nextByte = 0;
               }

               digit = currByte & (0xFF >> index);
               index = (index + 5) % 8;
               digit <<= index;
               digit |= nextByte >> (8 - index);
               i++;
            }
            else {
               digit = (currByte >> (8 - (index + 5))) & 0x1F;
               index = (index + 5) % 8;
               if(index == 0)
                  i++;
            }
            base32.Append(base32Chars[digit]);
         }

         return base32.ToString();
      }
   }
}