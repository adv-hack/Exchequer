using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.InteropServices;
using System.IO;
using System.Xml.Linq;
using System.ComponentModel;
using System.Security.Cryptography;
using System.Security;

namespace Data_Integrity_Checker
{
    public class ConnectionStringBuilder
    {
        public enum ALG_ID
        {
            CALG_MD5 = 0x00008003,
            CALG_RC4 = 0x00006801
        }

        //Constructor
        public ConnectionStringBuilder(string exchequerRootDirectory, string password)
        {
            if (exchequerRootDirectory.EndsWith("\\") == false)
                exchequerRootDirectory += "\\";

            exchSQLLoginXMLPath = exchequerRootDirectory;
            ePassword = password;
        }

        //Empty constructor
        public ConnectionStringBuilder() { }

        public string DecryptedString
        {
            get { return decryptedString; }
        }

        public string DecryptedPassword
        {
            get { return decryptedPassword; }
        }


        public string LastError { get { return lastError; } }

        [DllImport("advapi32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool CryptAcquireContext(out IntPtr phProv, string pszContainer, string pszProvider, uint dwProvType, uint dwFlags);

        [DllImport("advapi32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool CryptCreateHash(IntPtr hProv, ALG_ID Algid, IntPtr hKey, uint dwFlags, out IntPtr phHash);

        [DllImport("advapi32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool CryptDecrypt(IntPtr hKey, IntPtr hHash, [MarshalAs(UnmanagedType.Bool)]bool Final, uint dwFlags, byte[] pbData, ref int pdwDataLen);

        [DllImport("advapi32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool CryptDeriveKey(IntPtr hProv, ALG_ID Algid, IntPtr hBaseData, uint dwFlags, ref IntPtr phKey);

        [DllImport("advapi32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool CryptDestroyHash(IntPtr hHash);

        [DllImport("advapi32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool CryptDestroyKey(IntPtr hKey);

        [DllImport("advapi32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool CryptHashData(IntPtr hHash, byte[] pbData, int dwDataLen, uint dwFlags);

        [DllImport("advapi32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool CryptReleaseContext(IntPtr hProv, uint dwFlags);

       /*** public bool GetConnectionString(out string exceptionReturn)
        {
            exceptionReturn = null;
            IntPtr hCryptProv;
            IntPtr hKey = (IntPtr)0;
            IntPtr hHash;

            const string CRYPT_KEY_CONTAINER = "IRIS_EMULATOR_KEY_CONTAINER";

            this.lastError = "";
            string encryptedString = GetEncryptedConnectionString();
            if (encryptedString == "NoExchSQLLogin")
                return false;

            decodedBytes = Convert.FromBase64String(encryptedString);
            decodedBytesLength = decodedBytes.Length;
            ePasswordBytes = Encoding.UTF8.GetBytes(ePassword);

            // Get a handle to the default provider.
            if (!CryptAcquireContext(out hCryptProv, CRYPT_KEY_CONTAINER, null, PROV_RSA_FULL, 0))
            {
                int lastErrorInt = Marshal.GetLastWin32Error();
                uint lastErrorUint = Convert.ToUInt32(lastErrorInt);
                if (lastErrorUint == NTE_BAD_KEYSET)
                {
                    if (!CryptAcquireContext(out hCryptProv, CRYPT_KEY_CONTAINER, null, PROV_RSA_FULL, 8))
                        if (!CryptAcquireContext(out hCryptProv, null, null, PROV_RSA_FULL, CRYPT_NEWKEYSET))
                        {
                            exceptionReturn = "CryptAcquireContext failed";
                            return false;
                        }
                }
                else
                {
                    exceptionReturn = "CryptAcquireContext failed";
                    return false;
                }
            }

            // Decrypt the file with a session key derived from a password.

            // Create a hash object.
            if (!CryptCreateHash(hCryptProv, ALG_ID.CALG_MD5, IntPtr.Zero, 0, out hHash))
            {
                return false;
            }

            // Hash in the password data.
            if (!CryptHashData(hHash, ePasswordBytes, ePasswordBytes.Length, 0))
            {
                exceptionReturn = "CryptHashData failed";
                return false;
            }

            // Derive a session key from the hash object.
            if (!CryptDeriveKey(hCryptProv, ALG_ID.CALG_RC4, hHash, DW_FLAGS, ref hKey))
            {
                exceptionReturn = "CryptDeriveKey failed";
                return false;
            }

            // Destroy the hash object.
            if (!(CryptDestroyHash(hHash)))
            {
                exceptionReturn = "CryptDestroyHash failed";
                return false;
            }
            hHash = IntPtr.Zero;

            // The decryption key is now available, either having been imported
            // from a BLOB read in from the source file or having been created
            // using the password. This point in the program is not reached if
            // the decryption key is not available.

            // Decrypt data.
            if (!CryptDecrypt(hKey, IntPtr.Zero, true, 0, decodedBytes, ref decodedBytesLength))
            {
                exceptionReturn = "CryptDecrypt failed";
                return false;
            }

            foreach (byte x in decodedBytes)
            {
                decryptedString += Convert.ToChar(x).ToString();
            }

            // Destroy session key.
            if (hKey != IntPtr.Zero)
            {
                if (!(CryptDestroyKey(hKey)))
                {
                    exceptionReturn = "CryptDestroyKey failed";
                    return false;
                }
            }

            // Release provider handle.
            if (hCryptProv != IntPtr.Zero)
            {
                if (!(CryptReleaseContext(hCryptProv, 0)))
                {
                    exceptionReturn = "CryptReleaseContext failed";
                    return false;
                }
            }

            exceptionReturn = "";
            return true;
        } ***/

        //RB 20/02/2018 2018-R1 ABSEXCH-19790: Check SQL Posting Compatibility: Unhandled exception is occurred when running check for Single Daybook posting.
        private bool DecryptString(string aEncryptString, out string aDecryptString, out string exceptionReturn)
        {
            IntPtr hCryptProv;
            IntPtr hKey = (IntPtr)0;
            IntPtr hHash;
            aDecryptString = "";
            exceptionReturn = "";
            const string CRYPT_KEY_CONTAINER = "IRIS_EMULATOR_KEY_CONTAINER";

            decodedBytes = Convert.FromBase64String(aEncryptString);
            decodedBytesLength = decodedBytes.Length;
            ePasswordBytes = Encoding.UTF8.GetBytes(ePassword);

            // Get a handle to the default provider.
            bool bSuccess = CryptAcquireContext(out hCryptProv, CRYPT_KEY_CONTAINER, null, PROV_RSA_FULL, 0);

            if (!bSuccess)
                bSuccess = CryptAcquireContext(out hCryptProv, CRYPT_KEY_CONTAINER, null, PROV_RSA_FULL, CRYPT_MACHINE_KEYSET);

            int lastErrorInt = Marshal.GetLastWin32Error();
            exceptionReturn = Convert.ToString(lastErrorInt);

            // create a new context
            if (!bSuccess)
                bSuccess = CryptAcquireContext(out hCryptProv, CRYPT_KEY_CONTAINER, null, PROV_RSA_FULL, CRYPT_NEWKEYSET);

            lastErrorInt = Marshal.GetLastWin32Error();
            exceptionReturn = exceptionReturn + " - " + Convert.ToString(lastErrorInt);

            if (!bSuccess)
                bSuccess = CryptAcquireContext(out hCryptProv, CRYPT_KEY_CONTAINER, null, PROV_RSA_FULL, CRYPT_NEWKEYSET | CRYPT_MACHINE_KEYSET);

            lastErrorInt = Marshal.GetLastWin32Error();
            exceptionReturn = exceptionReturn + " - " + Convert.ToString(lastErrorInt);

            if (!bSuccess)
            {
                //exceptionReturn = "CryptAcquireContext failed";
                return false;
            }

            // Create a hash object.
            if (!CryptCreateHash(hCryptProv, ALG_ID.CALG_MD5, IntPtr.Zero, 0, out hHash))
            {
                return false;
            }

            // Hash in the password data.
            if (!CryptHashData(hHash, ePasswordBytes, ePasswordBytes.Length, 0))
            {
                exceptionReturn = "CryptHashData failed";
                return false;
            }

            // Derive a session key from the hash object.
            if (!CryptDeriveKey(hCryptProv, ALG_ID.CALG_RC4, hHash, DW_FLAGS, ref hKey))
            {
                exceptionReturn = "CryptDeriveKey failed";
                return false;
            }

            // Destroy the hash object.
            if (!(CryptDestroyHash(hHash)))
            {
                exceptionReturn = "CryptDestroyHash failed";
                return false;
            }
            hHash = IntPtr.Zero;

            // The decryption key is now available, either having been imported
            // from a BLOB read in from the source file or having been created
            // using the password. This point in the program is not reached if
            // the decryption key is not available.

            // Decrypt data.
            if (!CryptDecrypt(hKey, IntPtr.Zero, true, 0, decodedBytes, ref decodedBytesLength))
            {
                exceptionReturn = "CryptDecrypt failed";
                return false;
            }

            foreach (byte x in decodedBytes)
            {
                aDecryptString += Convert.ToChar(x).ToString();
            }

            // Destroy session key.
            if (hKey != IntPtr.Zero)
            {
                if (!(CryptDestroyKey(hKey)))
                {
                    exceptionReturn = "CryptDestroyKey failed";
                    return false;
                }
            }

            // Release provider handle.
            if (hCryptProv != IntPtr.Zero)
            {
                if (!(CryptReleaseContext(hCryptProv, 0)))
                {
                    exceptionReturn = "CryptReleaseContext failed";
                    return false;
                }
            }

            exceptionReturn = "";
            return true;
        }

        public bool GetNewConnectionString(out string exceptionReturn)
        {
            exceptionReturn = null;

            this.lastError = "";
            string lEncryptConnString, lEncryptConnPass,
                   lDecryptConnString, lDecryptConnPass;
            string encryptedString = GetEncryptedConnectionString(out lEncryptConnString, out lEncryptConnPass);

            if (encryptedString == "NoExchSQLLogin")
                return false;

            bool lSuccess = false;

            //RB 20/02/2018 2018-R1 ABSEXCH-19790: Check SQL Posting Compatibility: Unhandled exception is occurred when running check for Single Daybook posting.
            if (DecryptString(lEncryptConnString, out lDecryptConnString, out exceptionReturn))
            {
                decryptedString = lDecryptConnString;
                lSuccess = true;
            }

            if (lSuccess && lEncryptConnPass != "")
            {
                if (DecryptString(lEncryptConnPass, out lDecryptConnPass, out exceptionReturn))
                {
                    decryptedPassword = lDecryptConnPass;
                    lSuccess = true;
                }
                else
                    lSuccess = false;

            }
            return lSuccess;
        }

        private string GetEncryptedConnectionString(out string aConnString, out string aConnPass)
        {
            aConnString = "";
            aConnPass = "";
            try
            {
                const string exchSQLLoginXMLFileName = "ExchSQLLogin.XML"; /*This is the file
                                                                            which holds the
                                                                            encrypted string*/
                string exchSQLLoginXMLPathAndFileName
                    = this.exchSQLLoginXMLPath + exchSQLLoginXMLFileName; /*The file exists in
                                                                           the Exchequer root
                                                                           directory*/
                                                                          //     Find XML file
                if (File.Exists(exchSQLLoginXMLPathAndFileName) == false)
                {
                    return "NoExchSQLLogin";
                }

                //     Read XML file - get encrypted connection string*/
                XDocument xdoc = XDocument.Load(exchSQLLoginXMLPathAndFileName);
                var readValue = xdoc.Descendants("connection").Select(c => (string)c).First();
                var readValuePass = xdoc.Descendants("password").Select(c => (string)c).First();

                if (readValue.ToString().Trim() != "")
                    aConnString = readValue;
                if (readValuePass.ToString().Trim() != "")
                    aConnPass = readValuePass;
           
                return "";
            }
            catch (Exception ex)
            {
                this.lastError = "GetEncryptedConnectionString returned " + ex.Message;
                return "";
            }
        }

        public const uint CRYPT_EXPORTABLE = 1;

        public const uint CRYPT_MACHINE_KEYSET = 0x00000020;
        public const uint CRYPT_NEWKEYSET = 0x00000008;
        public const uint CRYPT_VERIFYCONTEXT = 0xF0000000;
        public const uint DW_FLAGS = 0x00800001;

        public const uint PROV_RSA_FULL = 1;

        private const string MS_DEF_PROV = "Microsoft Base Cryptographic Provider v1.0";
        private const uint NTE_BAD_KEYSET = 0x80090016;
        private byte[] decodedBytes;
        private int decodedBytesLength;
        private string decryptedString;
        private string decryptedPassword;
        private string ePassword;
        private byte[] ePasswordBytes;
        private string exchSQLLoginXMLPath;
        private string lastError;
    }
}