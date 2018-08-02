using System;
using System.Runtime.InteropServices;
using CSH.Exchequer.Bespoke.API.ComToolkit.Builders;
using CSH.Exchequer.Bespoke.Exceptions;
using CSH.Exchequer.Bespoke.Licencing;

namespace CSH.Exchequer.Bespoke.API.ComToolkit
{
    /// <summary>
    /// 
    /// </summary>
    public class BaseComToolkit : IDisposable
    {
        private static class NativeMethods
        {
            [DllImport("BespokeFuncs.dll", EntryPoint = "#22", CallingConvention = CallingConvention.StdCall)]
            internal static extern void CheckParams(ref int I1,
                                                   ref int I2,
                                                   ref int I3,
                                                   [MarshalAs(UnmanagedType.AnsiBStr)]
                                                   string DateTime);
        }

        /// <summary>
        /// 
        /// </summary>
        protected dynamic instance;

        /// <summary>
        /// Gets the data directory.
        /// </summary>
        public string DataDirectory { get; private set; }

        /// <summary>
        /// Initializes a new instance of the <see cref="BaseComToolkit"/> class.
        /// </summary>
        /// <param name="dataDirectory">The data directory.</param>
        /// <param name="builder">The builder.</param>
        protected BaseComToolkit(string dataDirectory, BaseComToolkitBuilder builder)
        {
            this.DataDirectory = dataDirectory;
            builder.Build();
            builder.Configure(dataDirectory);
            this.instance = builder.Instance;
        }

        /// <summary>
        /// Checks the toolkit.
        /// </summary>
        protected void CheckToolkit()
        {
            if (this.instance == null)
            {
                throw new BespokeLibraryException("this.instance == null");
            }
        }

        /// <summary>
        /// Opens the specified bd.
        /// </summary>
        /// <param name="bd">if set to <c>true</c> [bd].</param>
        public void Open(bool bd = true)
        {
            this.CheckToolkit();
            if ((int)this.instance.Status != (int)ToolkitStatus.Open)
            {
                if (bd)
                {
                    this.SetBDMode();
                }

                this.Evoke(this.instance.OpenToolkit());
            }
        }

        /// <summary>
        /// Closes this instance.
        /// </summary>
        public void Close()
        {
            CheckToolkit();
            if ((int)instance.Status != (int)ToolkitStatus.Closed)
            {
                this.Evoke(instance.CloseToolkit());
            }
        }

        private void SetBDMode()
        {
            //Opens the Backdoor for the COM Toolkit

            //Declaring the hardcoded Int32s
            int I1 = 0;
            int I2 = 0;
            int I3 = 0;
            I1 = 232394;
            //Required value
            I2 = 902811231;
            //Required value
            I3 = -1298759273;
            //Required value
            string DateTime = StringUtilities.CalcDateTime();

            //Calling the imported method of the E32EXCH DLL
            NativeMethods.CheckParams(ref I1, ref I2, ref I3, DateTime);

            //Pass these values into the toolkit but
            //be warned that the SetDebugMode method 
            //is not visible via intellisense
            this.instance.Configuration.SetDebugMode(I1, I2, I3);
        }

        /// <summary>
        /// Evokes the specified return code.
        /// </summary>
        /// <param name="returnCode">The return code.</param>
        /// <returns></returns>
        public ReturnCode Evoke(int returnCode)
        {
            if ((returnCode != (int)ReturnCode.NoError)
             && (returnCode != (int)ReturnCode.KeyValueNotFound)
             && (returnCode != (int)ReturnCode.EndOfFile))
            {
                throw new ExchequerException(returnCode, this.instance);
            }
            else
            {
                return (ReturnCode)returnCode;
            }
        }

        #region "IDisposable Support"
        // To detect redundant calls
        private bool disposed;

        // IDisposable
        /// <summary>
        /// Releases unmanaged and - optionally - managed resources
        /// </summary>
        /// <param name="disposing"><c>true</c> to release both managed and unmanaged resources; <c>false</c> to release only unmanaged resources.</param>
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    //dispose managed state (managed objects).
                    this.DataDirectory = null;
                }

                //free unmanaged resources (unmanaged objects) and override Finalize() below.
                if ((this.instance != null))
                {
                    if ((int)instance.Status != (int)ToolkitStatus.Closed)
                    {
                        this.Close();
                    }

                    this.instance = null;
                    //int refCount = Marshal.ReleaseComObject(this.instance);
                    //while (refCount > 0)
                    //{
                    //    refCount = Marshal.ReleaseComObject(this.instance);
                    //}
                }
            }
            //set large fields to null (no large fields implemented)

            disposed = true;
        }

        //override Finalize() only if Dispose(ByVal disposing As Boolean) above has code to free unmanaged resources.
        /// <summary>
        /// Releases unmanaged resources and performs other cleanup operations before the
        /// <see cref="DllComToolkit"/> is reclaimed by garbage collection.
        /// </summary>
        ~BaseComToolkit()
        {
            // Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(false);
        }

        // This code added by Visual Basic to correctly implement the disposable pattern.
        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public void Dispose()
        {
            // Do not change this code.  Put cleanup code in Dispose(ByVal disposing As Boolean) above.
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        #endregion
    }
}
