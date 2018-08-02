using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Diagnostics;
using CSH.Exchequer.Bespoke.Exceptions;
using CSH.Exchequer.Bespoke.Versioning;

namespace CSH.Exchequer.Bespoke.Diagnostics
{
    /// <summary>
    /// Provides logging services to the bespoke application
    /// </summary>
    public class Log : ILog
    {
        private static int instanceCount = 0;
        private const string SWITCH_NAME = "BespokeSwitch";
        private readonly string sourceName;
        private TraceSource traceSource;

        /// <summary>
        /// Gets or sets a value indicating whether the logging component should automatically flush its buffer.
        /// </summary>
        /// <value>
        ///   <c>true</c> if [auto flush]; otherwise, <c>false</c>.
        /// </value>
        public bool AutoFlush { get; set; }

        /// <summary>
        /// Gets or sets the tracing level.
        /// </summary>
        /// <value>
        /// The level.
        /// </value>
        public SourceLevels Level
        {
            get { return this.traceSource.Switch.Level; }
            set { this.traceSource.Switch.Level = value; }
        }

        /// <summary>
        /// Gets the listeners.
        /// </summary>
        public TraceListenerCollection Listeners
        {
            get { return this.traceSource.Listeners; }
        }

        /// <summary>
        /// Prevents a default instance of the <see cref="Log"/> class from being created.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="level">The level.</param>
        private Log(string name, SourceLevels level)
        {
            this.sourceName = name;
            if ((instanceCount + 1) > 1)
            {
                throw new BespokeLibraryException("Log instance count is > 1, only one log instance is permitted");
            }

            ++instanceCount;
            this.traceSource = new TraceSource(sourceName, level);
            this.Level = level;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Log"/> class.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="traceListener">The trace listener.</param>
        /// <param name="level">The level.</param>
        public Log(string name, TraceListener traceListener, SourceLevels level)
            : this(name, level)
        {
            if (traceListener == null)
                throw new ArgumentNullException("traceListener");

            this.traceSource.Listeners.Add(traceListener);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Log"/> class.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <param name="traceListeners">The trace listeners.</param>
        /// <param name="level">The level.</param>
        public Log(string name, TraceListenerCollection traceListeners, SourceLevels level)
            : this(name, level)
        {
            if (traceListeners == null)
                throw new ArgumentNullException("traceListeners");

            for (int i = 0; i < traceListeners.Count; i++)
            {
                this.traceSource.Listeners.Add(traceListeners[i]);
            }
        }
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
                    Close();
                    for (int i = 0; i < traceSource.Listeners.Count; i++)
                    {
                        traceSource.Listeners[i].Dispose();
                    }
                    --instanceCount;
                }
                // Free your own state (unmanaged objects).
                // Set large fields to null.
                this.disposed = true;
            }
        }

        // Use C# destructor syntax for finalization code.
        /// <summary>
        /// Releases unmanaged resources and performs other cleanup operations before the
        /// <see cref="Log"/> is reclaimed by garbage collection.
        /// </summary>
        ~Log()
        {
            // Simply call Dispose(false).
            Dispose(false);
        }

        /// <summary>
        /// Traces the information.
        /// </summary>
        /// <param name="message">The message.</param>
        public void TraceInformation(string message)
        {
            this.traceSource.TraceInformation(message);
            if (this.AutoFlush)
                Flush();
        }

        /// <summary>
        /// Traces the information.
        /// </summary>
        /// <param name="format">The format.</param>
        /// <param name="args">The args.</param>
        public void TraceInformation(string format, params object[] args)
        {
            this.traceSource.TraceInformation(format, args);
            if (this.AutoFlush)
                Flush();
        }

        /// <summary>
        /// Traces the event.
        /// </summary>
        /// <param name="eventType">Type of the event.</param>
        /// <param name="id">The id.</param>
        public void TraceEvent(TraceEventType eventType, int id)
        {
            this.traceSource.TraceEvent(eventType, id);
            if (this.AutoFlush)
                Flush();
        }

        /// <summary>
        /// Traces the event.
        /// </summary>
        /// <param name="eventType">Type of the event.</param>
        /// <param name="id">The id.</param>
        /// <param name="message">The message.</param>
        public void TraceEvent(TraceEventType eventType, int id, string message)
        {
            this.traceSource.TraceEvent(eventType, id, message);
            if (this.AutoFlush)
                Flush();
        }

        /// <summary>
        /// Traces the event.
        /// </summary>
        /// <param name="eventType">Type of the event.</param>
        /// <param name="id">The id.</param>
        /// <param name="format">The format.</param>
        /// <param name="args">The args.</param>
        public void TraceEvent(TraceEventType eventType, int id, string format, params object[] args)
        {
            this.traceSource.TraceEvent(eventType, id, format, args);
            if (this.AutoFlush)
                Flush();
        }

        /// <summary>
        /// Traces the data.
        /// </summary>
        /// <param name="eventType">Type of the event.</param>
        /// <param name="id">The id.</param>
        /// <param name="data">The data.</param>
        public void TraceData(TraceEventType eventType, int id, params object[] data)
        {
            this.traceSource.TraceData(eventType, id, data);
            if (this.AutoFlush)
                Flush();
        }

        /// <summary>
        /// Flushes the buffer.
        /// </summary>
        public void Flush()
        {
            this.traceSource.Flush();
        }

        /// <summary>
        /// Closes the logging component.
        /// </summary>
        public void Close()
        {
            this.traceSource.Close();
        }
    }
}
