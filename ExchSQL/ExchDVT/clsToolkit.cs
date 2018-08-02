using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Enterprise01;

namespace Data_Integrity_Checker
{
    internal class clsToolkit
    {
        public static void EncodeOpCode(int OpCode, out Int32 Long1, out Int32 Long2, out Int32 Long3)
        {
            byte[] ByteArray1 = new byte[4];

            byte[] ByteArray2 = new byte[4];
            byte[] ByteArray3 = new byte[4];

            Random random = new Random();

            if (OpCode <= 220)
            {
                // LongArray1
                ByteArray1[0] = Convert.ToByte(Convert.ToInt16(random.Next(0, 254)));
                ByteArray1[1] = Convert.ToByte(Convert.ToInt16(random.Next(0, 199)));
                ByteArray1[2] = Convert.ToByte(Convert.ToInt16(random.Next(0, 254)));
                ByteArray1[3] = Convert.ToByte(Convert.ToInt16(random.Next(0, 29)) + OpCode);

                //LongArray2
                ByteArray2[0] = Convert.ToByte(Convert.ToInt16(ByteArray1[1]) + CalcDateVal(DateTime.Now));
                ByteArray2[1] = Convert.ToByte(Convert.ToInt16(ByteArray1[0] | ByteArray1[2]));
                ByteArray2[2] = Convert.ToByte(Convert.ToInt16(ByteArray1[1] & ByteArray1[3]));
                ByteArray2[3] = Convert.ToByte(Convert.ToInt16(ByteArray1[3]) - Convert.ToInt16(OpCode));

                //LongArray3
                int LANot1 = Convert.ToInt16(~(ByteArray1[2] & ByteArray1[3]));

                ByteArray3[0] = (byte)LANot1;

                byte TmpByte = Convert.ToByte(Convert.ToInt16(ByteArray1[3]) - Convert.ToInt16(ByteArray2[3]));

                int LANot2 = (sbyte)~TmpByte;

                ByteArray3[1] = (byte)LANot2;
                ByteArray3[2] = Convert.ToByte(Convert.ToInt16(ByteArray1[0] & ByteArray1[2]));
                ByteArray3[3] = Convert.ToByte(Convert.ToInt16(ByteArray3[0] & ByteArray3[1] & ByteArray3[2]));
            }

            Long1 = BitConverter.ToInt32(ByteArray1, 0);
            Long2 = BitConverter.ToInt32(ByteArray2, 0);
            Long3 = BitConverter.ToInt32(ByteArray3, 0);
        }

        private static int CalcDateVal(DateTime TheDate)
        {
            string DateStr = TheDate.ToString("dd/MM/yyyy");

            string d1 = DateStr.Substring(0, 1);

            int CalcDateVal = Convert.ToInt32(DateStr.Substring(0, 1)) +
                              Convert.ToInt32(DateStr.Substring(1, 1)) +
                              Convert.ToInt32(DateStr.Substring(3, 1)) +
                              Convert.ToInt32(DateStr.Substring(4, 1)) +
                              Convert.ToInt32(DateStr.Substring(6, 1)) +
                              Convert.ToInt32(DateStr.Substring(7, 1)) +
                              Convert.ToInt32(DateStr.Substring(8, 1)) +
                              Convert.ToInt32(DateStr.Substring(9, 1));
            return CalcDateVal;
        }
    }
}