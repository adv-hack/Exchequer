using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

// PKR. 09/04/2015.
// New functions added to overcome ABSEXCH-16104, but implemented as a utility unit
//  for general use. 

namespace PaymentGatewayAddin
  {
  /// <summary>
  /// A set of functions for handling XML, HTML and other web-related data
  /// </summary>
  public static class XMLFuncs
    {
    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Replace troublesome characters with their web encoded equivalents
    /// </summary>
    /// <param name="plainText"></param>
    /// <returns></returns>
    public static string WebEncode(string plainText)
      {
      StringBuilder result = new StringBuilder("");

      if (!string.IsNullOrEmpty(plainText))
        {
        for (int index = 0; index < plainText.Length; index++)
          {
          switch (plainText[index])
            {
            case '<':
              result.Append("&lt;");
              break;
            case '>':
              result.Append("&gt;");
              break;
            case '"':
              result.Append("&quot;");
              break;
            case '&':
              result.Append("&amp;");
              break;
            case '\'':
              result.Append("&apos;");
              break;
            default:
              result.Append(plainText[index]);
              break;
            }
          }
        }
      return result.ToString();
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Replace web encoded characters with their proper character representation
    /// </summary>
    /// <param name="webText"></param>
    /// <returns></returns>
    public static string WebDecode(string webText)
      {
      string result = webText;

      result = result.Replace("&lt;", "<");
      result = result.Replace("&gt;", ">");
      result = result.Replace("&quot;", "\"");
      result = result.Replace("&amp;", "&");
      result = result.Replace("&apos;", "'");

      return result;
      }
    }
  }
