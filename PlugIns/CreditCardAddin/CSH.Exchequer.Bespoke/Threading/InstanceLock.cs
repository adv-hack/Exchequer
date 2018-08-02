using System.Threading;
using System;
using CSH.Exchequer.Bespoke.Versioning;
using CSH.Exchequer.Bespoke.Exceptions;

namespace CSH.Exchequer.Bespoke.Threading
{
    /// <summary>
    /// Prevents multiple instances of the same application from running.
    /// </summary>
    public class InstanceLock : IDisposable
    {
        private bool disposed = false;
        private bool isReleased = true;

        private Mutex _mutex;
        private bool Locked(string name)
        {
            bool result = false;
            _mutex = new Mutex(false, name);

            if (!_mutex.WaitOne(0, false))
            {
                result = true;
                _mutex = null;
                isReleased = false;
            }
            else
            {
                result = false;
            }

            return result;
        }

        /// <summary>
        /// Lockeds the specified name.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="throwIfLocked">if set to <c>true</c> [throw if locked].</param>
        /// <returns></returns>
        public bool Locked(string name, bool throwIfLocked = true)
        {
            bool result = this.Locked(name);
            if (result && throwIfLocked)
            {
                throw new MultiplePluginInstanceException(AssemblyAttributes.Product
                                                        + " "
                                                        + AssemblyAttributes.FileVersion
                                                        + "\r\n\r\n"
                                                        + "The running of multiple instances of this bespoke software on a single workstation is not permitted. \r\n\r\n"
                                                        + "Please contact your IRIS Exchequer helpline if you require more information on this issue.");
            }

            return result;
        }

        private void Unlock()
        {
            if ((_mutex != null) && (isReleased == false))
            {
                _mutex.ReleaseMutex();
                isReleased = true;
            }
        }

        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        private void Dispose(bool disposing)
        {
            if (!disposed)
            {
                if (disposing)
                {
                    // Free other state (managed objects).
                    Unlock();
                    if (_mutex != null)
                    {
                        _mutex.Dispose();
                        _mutex = null;
                    }
                }
                // Free your own state (unmanaged objects).
                // Set large fields to null.
                disposed = true;
            }
        }

        /// <summary>
        /// Releases unmanaged resources and performs other cleanup operations before the
        /// <see cref="InstanceLock"/> is reclaimed by garbage collection.
        /// </summary>
        ~InstanceLock()
        {
            Dispose(false);
        }
    }
}
