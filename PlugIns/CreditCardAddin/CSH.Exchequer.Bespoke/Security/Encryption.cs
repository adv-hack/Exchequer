using System.IO;
using System.Text;
using System.Security.Cryptography;
using System;
using System.Configuration;

namespace CSH.Exchequer.Bespoke.Security
{
    /// <summary>
    /// Provides simple text and byte encryption and decryption services
    /// </summary>
    public class Encryption : IDisposable
    {
        //Implement IDisposable.
        private bool disposed = false;
        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        /// <summary>
        /// Releases unmanaged and - optionally - managed resources
        /// </summary>
        /// <param name="disposing"><c>true</c> to release both managed and unmanaged resources; <c>false</c> to release only unmanaged resources.</param>
        protected virtual void Dispose(bool disposing)
        {
            if (!disposed)
            {
                if (disposing)
                {
                    // Free other state (managed objects).
                    this.cipher.Dispose();
                }

                disposed = true;
            }
        }

        // finalization code.
        /// <summary>
        /// Releases unmanaged resources and performs other cleanup operations before the
        /// <see cref="Encryption"/> is reclaimed by garbage collection.
        /// </summary>
        ~Encryption()
        {
            // Simply call Dispose(false).
            Dispose(false);
        }

        private RijndaelManaged cipher = null;

        private readonly string defaultKey = "÷ úæÉüG¨õ³gB¥ý a ?Ô¡k¹8äI=«»hÏÔ\u008d";
        private readonly Encoding encoding;

        /// <summary>
        /// Initializes a new instance of the <see cref="Encryption"/> class.
        /// </summary>
        public Encryption()
        {
            this.encoding = Encoding.GetEncoding(1252);
            this.cipher = InitCipher(this.DefaultKey);
        }

        internal byte[] DefaultKey
        {
            get { return this.encoding.GetBytes(this.defaultKey); }
        }

        /// <summary>
        /// Gets or sets the key.
        /// </summary>
        /// <value>
        /// The key.
        /// </value>
        public byte[] key
        {
            get { return this.cipher.Key; }
            set { this.cipher.Key = value; }
        }

        /// <summary>
        /// Creates the cipher.
        /// </summary>
        /// <returns></returns>
        private RijndaelManaged CreateCipher()
        {
            //Create an instance of the cipher
            RijndaelManaged cipher = new RijndaelManaged();
            //Although the key size defaults to 256, it's better to be explicit
            cipher.KeySize = 256;
            //BlockSize defaults to 128 bits, so let's set this
            //to 256 for better security
            cipher.BlockSize = 256;
            //We set the padding mode to ISO10126
            cipher.Padding = PaddingMode.ISO10126;
            //Set the mode to Electronic Code Book
            //though less secure, it suits our purpose
            //as we won't need to store an initialisation vector
            cipher.Mode = CipherMode.ECB;
            return cipher;
        }

        /// <summary>
        /// Inits the cipher.
        /// </summary>
        /// <returns></returns>
        private RijndaelManaged InitCipher()
        {
            RijndaelManaged cipher = CreateCipher();
            //GenerateKey method utilises the RNGCryptoServiceProvider
            //class to generate random bytes of necessary length
            cipher.GenerateKey();
            return cipher;
        }

        /// <summary>
        /// Inits the cipher.
        /// </summary>
        /// <param name="key">The key.</param>
        /// <returns></returns>
        private RijndaelManaged InitCipher(byte[] key)
        {
            RijndaelManaged cipher = CreateCipher();
            cipher.Key = key;
            return cipher;
        }

        /// <summary>
        /// Encrypts the message.
        /// </summary>
        /// <param name="plainText">The plain text.</param>
        /// <returns></returns>
        public string EncryptMessage(string plainText)
        {
            byte[] plainBytes = this.encoding.GetBytes(plainText);
            return this.encoding.GetString(this.EncryptMessage(plainBytes));
        }

        /// <summary>
        /// Decrypts the message.
        /// </summary>
        /// <param name="cipherText">The cipher text.</param>
        /// <returns></returns>
        public string DecryptMessage(string cipherText)
        {
            byte[] cipherBytes = this.encoding.GetBytes(cipherText);
            return this.encoding.GetString(this.DecryptMessage(cipherBytes));
        }

        /// <summary>
        /// Encrypts the message.
        /// </summary>
        /// <param name="plainText">The plain text.</param>
        /// <returns></returns>
        public byte[] EncryptMessage(byte[] plainText)
        {
            using (ICryptoTransform transform = this.cipher.CreateEncryptor())
            {
                byte[] cipherText = transform.TransformFinalBlock(plainText, 0, plainText.Length);
                return cipherText;
            }
        }

        /// <summary>
        /// Decrypts the message.
        /// </summary>
        /// <param name="cipherText">The cipher text.</param>
        /// <returns></returns>
        public byte[] DecryptMessage(byte[] cipherText)
        {
            using (ICryptoTransform transform = this.cipher.CreateDecryptor())
            {
                byte[] plainText = transform.TransformFinalBlock(cipherText, 0, cipherText.Length);
                return plainText;
            }
        }

        /// <summary>
        /// Encrypts the message using stream.
        /// </summary>
        /// <param name="plainText">The plain text.</param>
        /// <returns></returns>
        public byte[] EncryptMessageUsingStream(byte[] plainText)
        {
            using (ICryptoTransform transform = this.cipher.CreateEncryptor())
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    CryptoStream cs = new CryptoStream(ms, transform, CryptoStreamMode.Write);
                    cs.Write(plainText, 0, plainText.Length);
                    cs.FlushFinalBlock();
                    byte[] cipherText = ms.ToArray();
                    return cipherText;
                }
            }
        }

        /// <summary>
        /// Decrypts the message using stream.
        /// </summary>
        /// <param name="cipherText">The cipher text.</param>
        /// <returns></returns>
        public byte[] DecryptMessageUsingStream(byte[] cipherText)
        {
            using (ICryptoTransform transform = this.cipher.CreateDecryptor())
            {
                using (MemoryStream ms = new MemoryStream(cipherText))
                {
                    CryptoStream cs = new CryptoStream(ms, transform, CryptoStreamMode.Read);
                    byte[] plainTextBuffer = new byte[cipherText.Length + 1];
                    int plainTextLength = cs.Read(plainTextBuffer, 0, cipherText.Length);
                    byte[] plainText = new byte[plainTextLength + 1];
                    Array.Copy(plainTextBuffer, 0, plainText, 0, plainTextLength);
                    return plainText;
                }
            }
        }


    }
}
