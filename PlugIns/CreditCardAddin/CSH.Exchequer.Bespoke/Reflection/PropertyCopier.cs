using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;

namespace CSH.Exchequer.Bespoke.Reflection
{
    /// <summary>
    /// Used to copy properties from one instance of a class to another using System.Reflection
    /// </summary>
    public static class PropertyCopier
    {
        /// <summary>
        /// Sets the properties.
        /// </summary>
        /// <param name="fromFields">From fields.</param>
        /// <param name="toFields">To fields.</param>
        /// <param name="fromRecord">From record.</param>
        /// <param name="toRecord">To record.</param>
        public static void SetProperties(IEnumerable<PropertyInfo> fromFields, IEnumerable<PropertyInfo> toFields, object fromRecord, object toRecord)
        {
            if (fromFields == null)
            {
                return;
            }
            if (toFields == null)
            {
                return;
            }

            foreach (var fromField in fromFields)
            {
                var fromField1 = fromField;
                var matchedToFields = toFields.Where(toField => fromField1.Name == toField.Name);
                if (!matchedToFields.Any())
                {
                    continue;
                }
                matchedToFields.First().SetValue(toRecord, fromField.GetValue(fromRecord, null), null);
            }
        }

        /// <summary>
        /// Sets the properties.
        /// </summary>
        /// <param name="fromFields">From fields.</param>
        /// <param name="fromRecord">From record.</param>
        /// <param name="toRecord">To record.</param>
        public static void SetProperties(IEnumerable<PropertyInfo> fromFields, object fromRecord, object toRecord)
        {
            if (fromFields == null)
            {
                return;
            }

            foreach (var fromField in fromFields)
            {
                fromField.SetValue(toRecord, fromField.GetValue(fromRecord, null), null);
            }
        }

        /// <summary>
        /// Gets the settable properties of the given class
        /// </summary>
        /// <param name="type">The type.</param>
        /// <returns></returns>
        public static List<PropertyInfo> GetSettableProperties(Type type)
        {
            var fromFields = type.GetProperties(BindingFlags.Public | BindingFlags.Instance);
            var list = new List<PropertyInfo>(fromFields.Length);
            list.AddRange(fromFields.Where(info => info.CanWrite));
            return list;
        }
    }
}
