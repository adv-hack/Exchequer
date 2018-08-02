using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using NewExportBox;

namespace IRIS.DotNet.ExportPlugins
{
	[ComVisible(true)]
	[Guid("C23D6AD2-D309-46a0-9442-64E7CDCF168B")]
	public class MyICEPlugin : IExportBoxEvents
	{
		private List<string> _XmlList = new List<string>();

		#region IExportBoxEvents Members

		public void DoExport(uint pCompany, short pMsgType, DateTime pFrom, DateTime pTo, out uint pResult)
		{
			// Just execute some arbitrary code, to test the function call.
			// Not too worried about the params, for this test anyway.

			if (_XmlList.Count != 0)
				_XmlList.Clear();

			for (int i = 0; i < 10; i++)
			{
				_XmlList.Add("String Number: " + i.ToString());
			}

			pResult = 0; // Don't know what this value is used for; no documentation currently.
		}

		public int XmlCount
		{
			get { return _XmlList.Count; }
		}

		public string get_XmlList(int Index)
		{
			return _XmlList[Index];
		}

		#endregion
	}
}
