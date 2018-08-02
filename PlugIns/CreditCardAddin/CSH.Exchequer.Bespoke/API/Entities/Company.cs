using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using CSH.Exchequer.Bespoke.Extensions.IO;
using CSH.Exchequer.Bespoke.Extensions.Primitives;
using Enterprise04;

namespace CSH.Exchequer.Bespoke.API.Entities
{
    /// <summary>
    /// Represents an Exchequer company
    /// </summary>
    public class Company
    {
        private string _Code;
        private string _Path;
        private string _Description;

        /// <summary>
        /// Gets the code.
        /// </summary>
        public string Code
        {
            get { return _Code; }
        }

        /// <summary>
        /// Gets the path.
        /// </summary>
        public string Path
        {
            get { return _Path; }
        }

        /// <summary>
        /// Gets the description.
        /// </summary>
        public string Description
        {
            get { return _Description; }
        }

        /// <summary>
        /// Gets the screen description.
        /// </summary>
        public string ScreenDescription
        {
            get { return _Code + " - " + _Description; }
        }

        /// <summary>
        /// Prevents a default instance of the <see cref="Company"/> class from being created.
        /// </summary>
        private Company()
        {
            // To stop this from being called
            throw new NotImplementedException();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Company"/> class.
        /// </summary>
        /// <param name="Code">The code.</param>
        /// <param name="Path">The path.</param>
        /// <param name="Description">The description.</param>
        /// <param name="toolkit">The toolkit.</param>
        public Company(string Code, string Path, string Description, ref IToolkit toolkit)
        {
            _Code = Code.Trim();
            _Path = Path.Trim();
            _Description = Description.Trim();
        }

        /// <summary>
        /// Gets the company list.
        /// </summary>
        /// <param name="toolkit">The toolkit.</param>
        /// <param name="sort">if set to <c>true</c> [sort].</param>
        /// <returns></returns>
        public static List<Company> GetCompanyList(IToolkit toolkit, bool sort = false)
        {
            List<Company> results = new List<Company>();

            //Fill List
            for (int i = 1; i <= toolkit.Company.cmCount; i++)
            {
                results.Add(new Company(toolkit.Company.cmCompany[i].coCode.NullToString(),
                                            toolkit.Company.cmCompany[i].coPath.NullToString(),
                                            toolkit.Company.cmCompany[i].coName.NullToString(),
                                            ref toolkit));
            }

            //Sort List by company code ?
            if (sort)
            {
                IEnumerable<Company> sortedList = results.OrderBy(x => x.Code);
                results = new List<Company>(sortedList);
            }

            return results;
        }

        /// <summary>
        /// Gets the company code by data directory.
        /// </summary>
        /// <param name="toolkit">The toolkit.</param>
        /// <param name="dataDirectory">The data directory.</param>
        /// <returns></returns>
        public static string GetCompanyCodeByDataDirectory(IToolkit toolkit, string dataDirectory)
        {
            string result = null;
            DirectoryInfo dataDirectoryInfo = new DirectoryInfo(dataDirectory);
            for (int i = 1; i <= toolkit.Company.cmCount; i++)
            {
                int compareResult = 0;
                compareResult = string.Compare(toolkit.Company.cmCompany[i].coPath.Trim(),
                                               dataDirectoryInfo.GetShortName(),
                                               StringComparison.InvariantCultureIgnoreCase);

                if ((compareResult == 0))
                {
                    result = toolkit.Company.cmCompany[i].coCode.Trim();
                    break;
                }
            }

            return result;
        }

        /// <summary>
        /// Determines whether [is company code valid] [the specified company code].
        /// </summary>
        /// <param name="companyCode">The company code.</param>
        /// <returns>
        ///   <c>true</c> if [is company code valid] [the specified company code]; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsCompanyCodeValid(string companyCode)
        {
            bool result = true;
            if (string.IsNullOrWhiteSpace(companyCode))
            {
                result = false;
            }
            else if (companyCode.Length > 6)
            {
                result = false;
            }
            return result;
        }

    }
}
