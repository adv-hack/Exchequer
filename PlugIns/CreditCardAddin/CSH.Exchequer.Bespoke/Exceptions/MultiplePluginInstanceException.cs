using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSH.Exchequer.Bespoke.Exceptions
{
    /// <summary>
    /// Represents an error generated while mapping network drives
    /// </summary>
    [Serializable]
    public class MultiplePluginInstanceException : Exception
    {
        private MultiplePluginInstanceException() { } //Hide default constructor

        /// <summary>
        /// Initializes a new instance of the <see cref="MultiplePluginInstanceException"/> class.
        /// </summary>
        /// <param name="message">The message.</param>
        internal MultiplePluginInstanceException(string message)
            : base(message)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MultiplePluginInstanceException"/> class.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="innerException">The inner exception.</param>
        internal MultiplePluginInstanceException(string message, Exception innerException)
            : base(message, innerException)
        {
        }

        /// <summary>
        /// When overridden in a derived class, sets the <see cref="T:System.Runtime.Serialization.SerializationInfo"/> with information about the exception.
        /// </summary>
        /// <param name="info">The <see cref="T:System.Runtime.Serialization.SerializationInfo"/> that holds the serialized object data about the exception being thrown.</param>
        /// <param name="context">The <see cref="T:System.Runtime.Serialization.StreamingContext"/> that contains contextual information about the source or destination.</param>
        /// <exception cref="T:System.ArgumentNullException">The <paramref name="info"/> parameter is a null reference (Nothing in Visual Basic). </exception>
        ///   
        /// <PermissionSet>
        ///   <IPermission class="System.Security.Permissions.FileIOPermission, mscorlib, Version=2.0.3600.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" version="1" Read="*AllFiles*" PathDiscovery="*AllFiles*"/>
        ///   <IPermission class="System.Security.Permissions.SecurityPermission, mscorlib, Version=2.0.3600.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" version="1" Flags="SerializationFormatter"/>
        ///   </PermissionSet>
        public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context)
        {
            base.GetObjectData(info, context);
        }
    }
}
