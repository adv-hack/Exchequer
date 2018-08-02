//-----------------------------------------------------------------------
// <copyright file="ToolkitBackDoor.cs" company="Advanced Business Solutions">
//     Copyright (c) Advanced Business Solutions. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
// This is the COM toolkit backdoor code.
// The class and method have been renamed to obfuscate them.
//-----------------------------------------------------------------------

namespace DotNetLibrariesC.Toolkit
  {
  using System;
  using System.Runtime.InteropServices;
  using Enterprise04;

  /// <summary>
  /// For internal use only
  /// </summary>
  public static class ctkDebugLog
    {
    /// <summary>
    /// For internal use only
    /// </summary>
    /// <param name="toolkitObject">Toolkit Object</param>
    public static void StartDebugLog(ref IToolkit3 toolkitObject)
      {
      // Declaring the hardcoded Int32s
      int int1 = 232394;       // Required value
      int int2 = 902811231;    // Required value
      int int3 = -1298759273;  // Required value
      string dateTime = CalcDateTime();
      CheckParams(ref int1, ref int2, ref int3, dateTime);
      toolkitObject.Configuration.SetDebugMode(int1, int2, int3);
      }

    /// <summary>
    /// For internal use only
    /// </summary>
    /// <param name="key1">Integer key 1</param>
    /// <param name="key2">Integer key 2</param>
    /// <param name="key3">Integer key 3</param>
    /// <param name="dateTime">Calculated Date Time</param>
    [DllImport("BespokeFuncs.dll", EntryPoint = "#22", CallingConvention = CallingConvention.StdCall)]
    private static extern void CheckParams(ref int key1, ref int key2, ref int key3, [MarshalAs(UnmanagedType.AnsiBStr)] string dateTime);

    /// <summary>
    /// For internal use only
    /// </summary>
    /// <returns>Calculated Date Time</returns>
    private static string CalcDateTime()
      {
      Int32 keyDay = 0;
      Int32 intD = 0;
      Int32 intB = 0;
      Int32 intA = 0;
      Int32 intE = 0;
      Int32 intC = 0;

      keyDay = DateTime.Now.Day;
      intA = Convert.ToInt32(Math.Truncate(Math.Pow(keyDay + 7, 3)));
      intB = intA - keyDay;
      intC = Convert.ToInt32(Math.Truncate(Math.Sqrt(intB)));
      intD = Convert.ToInt32(Math.Truncate(Math.Pow(intC + 1, 3)));
      intE = Convert.ToInt32(Math.Truncate((double)intD));

      return "1" + intE.ToString() + "0";
      }
    }
  }