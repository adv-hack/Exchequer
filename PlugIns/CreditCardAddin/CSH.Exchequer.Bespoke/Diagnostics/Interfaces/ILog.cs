using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace CSH.Exchequer.Bespoke.Diagnostics
{
    /// <summary>
    /// Provides a contract for all current and future logging components
    /// </summary>
    public interface ILog : IDisposable
    {
        /// <summary>
        /// Gets or sets a value indicating whether the logging component should automatically flush its buffer.
        /// </summary>
        /// <value>
        ///   <c>true</c> if [auto flush]; otherwise, <c>false</c>.
        /// </value>
        bool AutoFlush { get; set; }

        /// <summary>
        /// Gets or sets the level of tracing.
        /// </summary>
        /// <value>
        /// The level.
        /// </value>
        SourceLevels Level { get ; set ;}

        /// <summary>
        /// Gets the listeners.
        /// </summary>
        TraceListenerCollection Listeners { get ; }

        /// <summary>
        /// Traces the information.
        /// </summary>
        /// <param name="message">The message.</param>
        void TraceInformation(string message);

        /// <summary>
        /// Traces the information.
        /// </summary>
        /// <param name="format">The format.</param>
        /// <param name="args">The args.</param>
        void TraceInformation(string format, params object[] args);

        /// <summary>
        /// Traces the event.
        /// </summary>
        /// <param name="eventType">Type of the event.</param>
        /// <param name="id">The id.</param>
        void TraceEvent(TraceEventType eventType, int id);

        /// <summary>
        /// Traces the event.
        /// </summary>
        /// <param name="eventType">Type of the event.</param>
        /// <param name="id">The id.</param>
        /// <param name="message">The message.</param>
        void TraceEvent(TraceEventType eventType, int id, string message);

        /// <summary>
        /// Traces the event.
        /// </summary>
        /// <param name="eventType">Type of the event.</param>
        /// <param name="id">The id.</param>
        /// <param name="format">The format.</param>
        /// <param name="args">The args.</param>
        void TraceEvent(TraceEventType eventType, int id, string format, params object[] args);

        //void TraceData(TraceEventType eventType, int id, object data);

        /// <summary>
        /// Traces the data.
        /// </summary>
        /// <param name="eventType">Type of the event.</param>
        /// <param name="id">The id.</param>
        /// <param name="data">The data.</param>
        void TraceData(TraceEventType eventType, int id, params object[] data);

        /// <summary>
        /// Flushes the buffer.
        /// </summary>
        void Flush();

        /// <summary>
        /// Closes the logging component.
        /// </summary>
        void Close();

    }
}
