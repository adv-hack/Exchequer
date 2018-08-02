namespace IRIS.ExchequerSQL.ClrExtensions
{
    using System;
    using System.Text;

    public static class FieldConverter
    {
        /// <summary>
        /// Convert string to byte_array
        /// </summary>
        /// <param name="value">String to convert to byte array</param>        
        public static byte[] ConvertStringToBytes(string value)
        {
            // allocate byte array based on half of string length
            int byteCount = (value.Length) / 2;
            byte[] bytes = new byte[byteCount];

            // loop through the string - 2 bytes at a time converting it to decimal equivalent and store in byte array
            // x variable used to hold byte array element position
            for (int x = 0; x < byteCount; ++x)
            {
                bytes[x] = Convert.ToByte(value.Substring(x * 2, 2), 16);
            }

            // return the finished byte array of decimal values
            return bytes;
        }

        /// <summary>
        /// Convert byte array to string
        /// </summary>
        /// <param name="value">Byte array to convert to string</param>
        public static string ConvertBytesToString(byte[] value)
        {
            StringBuilder sb = new StringBuilder(value.Length * 2);
            foreach (byte b in value)
            {
                sb.Append(b.ToString("X02"));
            }
            return sb.ToString();
        }
    }
}
