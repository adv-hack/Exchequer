using System;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Xml;
using System.Xml.Linq;

namespace Advanced.Encryption
  {
  public class TextLock
    {
    private const string kStr = "!siri@eimw"; // This has been reversed to prevent casual hacking

    private byte[] byteBuffer;
    private byte[] eStrBytes;
    private string decryptedString;
    private string encryptedString;
    private int decodedBytesLength;
    private string exchequerPath;
    private string cfgVersion;

    //Constructor
    /// <summary>
    /// Constructor
    /// </summary>
    /// <param name="exchequerRootDirectory">The root working directory</param>
    /// <param name="password">The password used to decrypt the data</param>
    public TextLock(string exchequerRootDirectory)
      {
      if (exchequerRootDirectory.EndsWith("\\") == false)
        {
        exchequerRootDirectory += "\\";
        }

      exchequerPath = exchequerRootDirectory;
      cfgVersion = string.Empty;
      }

    /// <summary>
    /// The decoded and decrypted string
    /// </summary>
    public string DecryptedString
      {
      get { return decryptedString; }
      }

    /// <summary>
    /// The encrypted and encoded string
    /// </summary>
    public string EncryptedString
      {
      get { return encryptedString; }
      }

    public string ConfigVersion
      {
      get { return cfgVersion; }
      }

    private string lastError;

    public string LastError { get { return lastError; } }

    //From http://social.msdn.microsoft.com/Forums/vstudio/en-US/55269997-4ba6-4973-a002-c0d50e5a4f12/how-to-use-cmanaged-code-rewrite-cryptography-api-unmanaged-code?forum=csharpgeneral
    // found in https://www.google.co.uk/search?q=c%23+CryptAcquireContext+CryptCreateHash+CryptHashData+CryptDeriveKey&oq=c%23+CryptAcquireContext+CryptCreateHash+CryptHashData+CryptDeriveKey&aqs=chrome..69i57j69i58.61412j0j7&sourceid=chrome&espv=210&es_sm=93&ie=UTF-8
    public const uint PROV_RSA_FULL = 1;

    public const uint CRYPT_VERIFYCONTEXT = 0xF0000000;
    public const uint CRYPT_NEWKEYSET = 0x00000008;

    //Added by Bob Barker
    public const uint CRYPT_EXPORTABLE = 1;

    public const uint DW_FLAGS = 0x00800001;

    public enum ALG_ID
      {
      CALG_MD5 = 0x00008003,
      CALG_RC4 = 0x00006801
      }

    // Interop because there's no native .NET library
    [DllImport("advapi32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool CryptAcquireContext(out IntPtr phProv, string pszContainer, string pszProvider, uint dwProvType, uint dwFlags);

    [DllImport("advapi32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool CryptCreateHash(IntPtr hProv, ALG_ID Algid, IntPtr hKey, uint dwFlags, out  IntPtr phHash);

    [DllImport("advapi32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool CryptHashData(IntPtr hHash, byte[] pbData, int dwDataLen, uint dwFlags);

    [DllImport("advapi32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool CryptDeriveKey(IntPtr hProv, ALG_ID Algid, IntPtr hBaseData, uint dwFlags, ref IntPtr phKey);

    [DllImport("advapi32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool CryptDestroyHash(IntPtr hHash);

    [DllImport("advapi32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool CryptDecrypt(IntPtr hKey, IntPtr hHash, [MarshalAs(UnmanagedType.Bool)]bool Final, uint dwFlags, byte[] pbData, ref int pdwDataLen);

    [DllImport("advapi32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool CryptEncrypt(IntPtr hKey, IntPtr hHash, [MarshalAs(UnmanagedType.Bool)]bool Final, uint dwFlags, byte[] pbData, ref int pdwDataLen, uint dwBufLen);

    [DllImport("advapi32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool CryptDestroyKey(IntPtr hKey);

    [DllImport("advapi32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool CryptReleaseContext(IntPtr hProv, uint dwFlags);

    private const string MS_DEF_PROV = "Microsoft Base Cryptographic Provider v1.0";
    private const uint NTE_BAD_KEYSET = 0x80090016;

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Decodes (BASE64) and decrypts an encrypted string (old version)
    /// </summary>
    /// <param name="eStr"></param>
    /// <param name="encryptedString"></param>
    /// <returns></returns>
    public bool DecryptString(string eStr, string encryptedString)
      {
      IntPtr hCryptProv;
      IntPtr hKey = (IntPtr)0;
      IntPtr hHash;

      const string CRYPT_KEY_CONTAINER = "IRIS_EMULATOR_KEY_CONTAINER";

      this.lastError = "";
      // Base64 decode the encrypted string into a byte buffer
      byteBuffer = Convert.FromBase64String(encryptedString);
      decodedBytesLength = byteBuffer.Length;

      // If no password, use the default one
      if (eStr == "")
        {
        eStr = string.Concat(Enumerable.Reverse(kStr));
        }

      // Convert the password into a UTF byte buffer
      eStrBytes = Encoding.UTF8.GetBytes(eStr);

      // Get a handle to the default cryptology provider
      if (!CryptAcquireContext(out hCryptProv, CRYPT_KEY_CONTAINER, null, PROV_RSA_FULL, 0))
        {
        int lastErrorInt = Marshal.GetLastWin32Error();
        uint lastErrorUint = Convert.ToUInt32(lastErrorInt);
        if (lastErrorUint == NTE_BAD_KEYSET)
          {
          // Could not open Key Container, so try to create one
          this.lastError = "CryptAcquireContext failed - Could not open key container";
          if (!CryptAcquireContext(out hCryptProv, CRYPT_KEY_CONTAINER, null, PROV_RSA_FULL, 8))
            {
            if (!CryptAcquireContext(out hCryptProv, null, null, PROV_RSA_FULL, CRYPT_NEWKEYSET))
              {
              // Couldn't create a Key Container
              this.lastError = "CryptAcquireContext failed - could not create key container";
              return false;
              }
            else
              {
              this.lastError = string.Empty;
              }
            }
          }
        else
          {
          this.lastError = "CryptAcquireContext failed";
          return false;
          }
        }

      // Decrypt the file with a session key derived from a password.

      // Create a hash object.
      if (!CryptCreateHash(hCryptProv, ALG_ID.CALG_MD5, IntPtr.Zero, 0, out hHash))
        {
        this.lastError = "CryptCreateHash failed";
        return false;
        }

      // Hash in the password data.
      if (!CryptHashData(hHash, eStrBytes, eStrBytes.Length, 0))
        {
        this.lastError = "CryptHashData failed";
        return false;
        }

      // Derive a session key from the hash object.
      if (!CryptDeriveKey(hCryptProv, ALG_ID.CALG_RC4, hHash, DW_FLAGS, ref hKey))
        {
        this.lastError = "CryptDeriveKey failed";
        return false;
        }

      // Destroy the hash object.
      if (!(CryptDestroyHash(hHash)))
        {
        this.lastError = "CryptDestroyHash failed";
        return false;
        }
      hHash = IntPtr.Zero;

      // The decryption key is now available, either having been imported
      // from a BLOB read in from the source file or having been created
      // using the password. This point in the program is not reached if
      // the decryption key is not available.

      // Decrypt data.
      if (!CryptDecrypt(hKey, IntPtr.Zero, true, 0, byteBuffer, ref decodedBytesLength))
        {
        this.lastError = "CryptDecrypt failed";
        return false;
        }

      foreach (byte x in byteBuffer)
        {
        decryptedString += Convert.ToChar(x).ToString();
        }

      // Destroy session key.
      if (hKey != IntPtr.Zero)
        {
        if (!(CryptDestroyKey(hKey)))
          {
          this.lastError = "CryptDestroyKey failed";
          return false;
          }
        }

      // Release provider handle.
      if (hCryptProv != IntPtr.Zero)
        {
        if (!(CryptReleaseContext(hCryptProv, 0)))
          {
          this.lastError = "CryptReleaseContext failed";
          return false;
          }
        }

      this.lastError = "";
      return true;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Encrypts and BASE64 encodes a string
    /// </summary>
    /// <param name="filename"></param>
    /// <param name="enclosingTag"></param>
    /// <param name="eStr">The password (leave blank for default)</param>
    /// <returns></returns>
    public bool EncryptString(string plaintext, string eStr)
      {
      IntPtr hCryptProv;
      IntPtr hKey = (IntPtr)0;
      IntPtr hHash;
      UInt32 bufferLength;
      int textLength;

      textLength = plaintext.Length;
      bufferLength = Convert.ToUInt32(textLength + 128);  // Encrypted text can be 1 block bigger than the input text

      const string CRYPT_KEY_CONTAINER = "CC_ADDIN_KEY_CONTAINER";

      this.lastError = "";

      // If no password, use the default one
      if (eStr == "")
        {
        eStr = string.Concat(Enumerable.Reverse(kStr));
        }

      // Convert the password into a UTF byte buffer
      eStrBytes = Encoding.UTF8.GetBytes(eStr);

      // Get a handle to the default cryptology provider
      if (!CryptAcquireContext(out hCryptProv, CRYPT_KEY_CONTAINER, null, PROV_RSA_FULL, 0))
        {
        // Failed, so get the last error code
        int lastErrorInt = Marshal.GetLastWin32Error();
        uint lastErrorUint = Convert.ToUInt32(lastErrorInt);
        if (lastErrorUint == NTE_BAD_KEYSET)
          {
          this.lastError = "CryptAcquireContext failed to open key container";
          // Couldn't open key container - possibly doesn't exist, so try to create one
          if (!CryptAcquireContext(out hCryptProv, CRYPT_KEY_CONTAINER, null, PROV_RSA_FULL, 8))
            {
            if (!CryptAcquireContext(out hCryptProv, null, null, PROV_RSA_FULL, CRYPT_NEWKEYSET))
              {
              // Failed to create one
              this.lastError = "CryptAcquireContext failed to create key container";
              return false;
              }
            else
              {
              // Created one, so clear the error and continue
              this.lastError = "";
              }
            }
          }
        else
          {
          this.lastError = "CryptAcquireContext failed : Code " + lastErrorUint.ToString();
          return false;
          }
        }

      // Create a hash object.
      if (!CryptCreateHash(hCryptProv, ALG_ID.CALG_MD5, IntPtr.Zero, 0, out hHash))
        {
        this.lastError = "CryptCreateHash failed";
        return false;
        }

      // Hash in the password data.
      if (!CryptHashData(hHash, eStrBytes, eStrBytes.Length, 0))
        {
        this.lastError = "CryptHashData failed";
        return false;
        }

      // Derive a session key from the hash object.
      if (!CryptDeriveKey(hCryptProv, ALG_ID.CALG_RC4, hHash, DW_FLAGS, ref hKey))
        {
        this.lastError = "CryptDeriveKey failed";
        return false;
        }

      // Destroy the hash object.
      if (!(CryptDestroyHash(hHash)))
        {
        this.lastError = "CryptDestroyHash failed";
        return false;
        }
      hHash = IntPtr.Zero;

      byteBuffer = new byte[bufferLength];

      Encoding e = Encoding.GetEncoding("Windows-1252");
      //      Encoding e = Encoding.GetEncoding("UTF-8");
      byteBuffer = e.GetBytes(plaintext);
      if (byteBuffer.Length == 0)
        {
        this.lastError = "e.GetBytes returned empty buffer from " + plaintext;
        return false;
        }

      // Copy the plaintext to the byte buffer
      //      for (int index = 0; index < textLength; index++)
      //        {
      //        byteBuffer[index] = Convert.ToByte(plaintext[index]);
      //        }

      // Encrypt data.
      // Parameters:
      // - Handle to the encryption key
      // - Handle to the hash object. Null if not used
      // - Flag indicating true if last section in a series being encrypted.
      // - Flags for future use only
      // - Buffer containing the plaintext data
      // - Pointer to a DWORD containing the length of the plaintext
      // - Size of the input buffer
      if (!CryptEncrypt(hKey, IntPtr.Zero, true, 0, byteBuffer, ref textLength, bufferLength))
        {
        this.lastError = "CryptEncrypt failed. TextLength=" +textLength.ToString() + ", bufferLength="+bufferLength.ToString();
        return false;
        }

      // Base64 Encode the encrypted buffer
      encryptedString = Convert.ToBase64String(byteBuffer, 0, textLength);
      if (encryptedString.Length == 0)
        {
        this.lastError = "ToBase64String returned zero-length string";
        return false;
        }

      // Destroy the session key.
      if (hKey != IntPtr.Zero)
        {
        if (!(CryptDestroyKey(hKey)))
          {
          this.lastError = "CryptDestroyKey failed";
          return false;
          }
        }

      // Release the provider handle.
      if (hCryptProv != IntPtr.Zero)
        {
        if (!(CryptReleaseContext(hCryptProv, 0)))
          {
          this.lastError = "CryptReleaseContext failed";
          return false;
          }
        }

      this.lastError = "";

      return true;
      } // end Decryptfile

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Reads the encrypted data from the specified file
    /// </summary>
    /// <param name="filename"></param>
    /// <returns></returns>
    public string GetEncryptedStringFromFile(string filename, string enclosingTag)
      {
      string Result = "";

      try
        {
        string encryptedString = "";

        // Find XML file
        if (!File.Exists(exchequerPath +  filename))
          {
          Result = "";
          }
        else
          {
          // Read XML file - get encrypted connection string*/
          XDocument xdoc = XDocument.Load(exchequerPath + filename);

          XmlDocument xmlDoc = new XmlDocument();
          xmlDoc.LoadXml(xdoc.FirstNode.ToString());
          XmlNode node = xmlDoc.ChildNodes[0];
          node = node.ChildNodes[0];

          cfgVersion = string.Empty;
          if (node.Attributes["Version"] != null)
            {
            cfgVersion = node.Attributes["Version"].Value.ToString();
            }

          var readValue = xdoc.Descendants(enclosingTag).Select(c => (string)c).First();
          // Convert from var to string
          encryptedString = readValue;
          Result = encryptedString;
          node = null;
          xdoc = null;
          xmlDoc = null;
          }
        }
      catch (Exception ex)
        {
        this.lastError = "GetEncryptedStringFromFile returned " + ex.Message;
        Result = "";
        }
      return Result;
      }
    }
  }
