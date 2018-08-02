using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Enterprise04;
using CSH.Exchequer.Bespoke.Mathematics;

namespace CSH.Exchequer.Bespoke.API.Entities
{
    /// <summary>
    /// Represents an Exchequer VAT code
    /// </summary>
    public class VatCode
    {
        private string _Code;
        private decimal _Rate;

        private string _Description;
        /// <summary>
        /// Gets the code.
        /// </summary>
        public string Code
        {
            get { return _Code; }
        }

        /// <summary>
        /// Gets the rate.
        /// </summary>
        public decimal Rate
        {
            get { return _Rate; }
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
            get { return _Code + " - " + _Description + "  (" + _Rate.ToString() + " %)"; }
        }

        /// <summary>
        /// Prevents a default instance of the <see cref="VatCode"/> class from being created.
        /// </summary>
        private VatCode()
        {
            // To stop this from being called
            throw new NotImplementedException();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="VatCode"/> class.
        /// </summary>
        /// <param name="Code">The code.</param>
        /// <param name="Rate">The rate.</param>
        /// <param name="Description">The description.</param>
        public VatCode(string Code, decimal Rate, string Description)
        {
            _Code = Code.Trim();
            _Rate = Calc.Round(Rate * 100, Calc.RoundMode.RoundUpOrDown, 2, MidpointRounding.ToEven);
            _Description = Description.Trim();
        }

        /// <summary>
        /// Gets the vat code list.
        /// </summary>
        /// <param name="toolkit">The toolkit.</param>
        /// <param name="sort">if set to <c>true</c> [sort].</param>
        /// <returns></returns>
        public static List<VatCode> GetVatCodeList(IToolkit toolkit, bool sort = false)
        {
            string[] VATCodesToInclude = {
                "S",
                "E",
                "Z",
                "1",
                "2",
                "3",
                "4",
                "5",
                "6",
                "7",
                "8",
                "9",
                "T",
                "X",
                "B",
                "C",
                "F",
                "G",
                "R",
                "W",
                "Y"
            };

            List<VatCode> VATCodeList = new List<VatCode>();
            int iVATCode = 0;

            //Fill List
            for (iVATCode = 0; iVATCode <= VATCodesToInclude.Length - 1; iVATCode++) {
                VATCodeList.Add(
                    new VatCode(toolkit.SystemSetup.ssVATRates[VATCodesToInclude[iVATCode]].svCode, 
                    Convert.ToDecimal(toolkit.SystemSetup.ssVATRates[VATCodesToInclude[iVATCode]].svRate), 
                    toolkit.SystemSetup.ssVATRates[VATCodesToInclude[iVATCode]].svDesc));
            }

            //NF: 22/02/2011 Added Acquisitions / Despatches to the VAT Code list
            VATCodeList.Add(new VatCode("A", Convert.ToDecimal(toolkit.SystemSetup.ssVATRates["3"].svRate), "Acquisitions"));
            VATCodeList.Add(new VatCode("D", Convert.ToDecimal(toolkit.SystemSetup.ssVATRates["4"].svRate), "Despatches"));

            //Sort List by VATCode ?
            if (sort) {
                IEnumerable<VatCode> SortedVATCodeList = VATCodeList.OrderBy(x => x.Code);
                return new List<VatCode>(SortedVATCodeList);
            } else {
                return VATCodeList;
            }
        }
    }
}
