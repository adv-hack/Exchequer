using System.Collections.Generic;

namespace PaymentGatewayAddin
  {
  internal class ISO4217Currency
    {
    public string CountryName;
    public string CurrencyName;
    public string CurrencyCode;
    public int NumericCode;
    public int MinorUnit;

    /// <summary>
    /// Constructor
    /// </summary>
    public ISO4217Currency(string aCountryName, string aCurrencyName, string aISOCode, int aNumCode, int aMinorUnit)
      {
      CountryName = aCountryName;
      CurrencyName = aCurrencyName;
      CurrencyCode = aISOCode;
      NumericCode = aNumCode;
      // This is a strange value.  It's the power of 10 that represents the minor unit of currency relative to the major unit.
      // For example, GBP has value 2.  10^2 = 100.  There are 100 pennies to the pound.
      MinorUnit = aMinorUnit;
      }
    }

  internal class ISO4217CurrencyList
    {
    public string publishedDate = "2014-08-15";
    public List<ISO4217Currency> Currencies;

    /// <summary>
    /// Constructor
    /// </summary>
    public ISO4217CurrencyList()
      {
      // Create the currency list and populate it
      Currencies = new List<ISO4217Currency>()
        {
        // Some of these have been omitted by commenting out because they are very unlikely to be used
        //  by an Exchequer customer.  However, they remain in case they need to be reinstated in future.
        // Note that some countries use multiple currencies which are not listed here, but these codes are
        //  the official ISO standard ones, so any others are not included.
        new ISO4217Currency("United Kingdom", "Pound Sterling", "GBP", 826, 2),
        new ISO4217Currency("European Union", "Euro", "EUR", 978, 2),
        new ISO4217Currency("United States", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Afghanistan", "Afghani", "AFN", 971, 2),
        new ISO4217Currency("Ãland Islands", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Albania", "Lek", "ALL", 008, 2),
        new ISO4217Currency("Algeria", "Algerian Dinar", "DZD", 012, 2),
        new ISO4217Currency("American Samoa", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Andorra", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Angola", "Kwanza", "AOA", 973, 2),
        new ISO4217Currency("Anguilla", "East Caribbean Dollar", "XCD", 951, 2),
//        new ISO4217Currency("Antarctica", "No universal currency", "", 0, 0),
        new ISO4217Currency("Antigua and Barbuda", "East Caribbean Dollar", "XCD", 951, 2),
        new ISO4217Currency("Argentina", "Argentine Peso", "ARS", 032, 2),
        new ISO4217Currency("Armenia", "Armenian Dram", "AMD", 051, 2),
        new ISO4217Currency("Aruba", "Aruban Florin", "AWG", 533, 2),
        new ISO4217Currency("Australia", "Australian Dollar", "AUD", 036, 2),
        new ISO4217Currency("Austria", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Azerbaijan", "Azerbaijanian Manat", "AZN", 944, 2),
        new ISO4217Currency("Bahamas", "Bahamian Dollar", "BSD", 044, 2),
        new ISO4217Currency("Bahrain", "Bahraini Dinar", "BHD", 048, 3),
        new ISO4217Currency("Bangladesh", "Taka", "BDT", 050, 2),
        new ISO4217Currency("Barbados", "Barbados Dollar", "BBD", 052, 2),
        new ISO4217Currency("Belarus", "Belarussian Ruble", "BYR", 974, 0),
        new ISO4217Currency("Belgium", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Belize", "Belize Dollar", "BZD", 084, 2),
        new ISO4217Currency("Benin", "CFA Franc", "XOF", 952, 2),
        new ISO4217Currency("Bermuda", "Bermudian Dollar", "BMD", 060, 2),
        new ISO4217Currency("Bhutan", "Ngultrum", "BTN", 064, 2),
        new ISO4217Currency("Bhutan", "Indian Rupee", "INR", 356, 2),
        new ISO4217Currency("Bolivia, Plurinational State of", "Boliviano", "BOB", 068, 2),
//        new ISO4217Currency("Bolivia, Plurinational State of", "Mvdol", "BOV", 984, 2),
        new ISO4217Currency("Bonaire Sint Eustatius and Saba", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Bosnia and Herzegovina", "Convertible Mark", "BAM", 977, 2),
        new ISO4217Currency("Botswana", "Pula", "BWP", 072, 2),
        new ISO4217Currency("Bouvet Island", "Norwegian Krone", "NOK", 578, 2),
        new ISO4217Currency("Brazil", "Brazilian Real", "BRL", 986, 2),
        new ISO4217Currency("British Indian Ocean Territory", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Brunei Darussalam", "Brunei Dollar", "BND", 096, 2),
        new ISO4217Currency("Bulgaria", "Bulgarian Lev", "BGN", 975, 2),
        new ISO4217Currency("Burkina Faso", "CFA Franc", "XOF", 952, 0),
        new ISO4217Currency("Burundi", "Burundi Franc", "BIF", 108, 0),
        new ISO4217Currency("Cambodia", "Riel", "KHR", 116, 2),
        new ISO4217Currency("Cameroon", "CFA Franc", "XAF", 950, 2),
        new ISO4217Currency("Canada", "Canadian Dollar", "CAD", 124, 2),
        new ISO4217Currency("Cabo Verde", "Cabo Verde Escudo", "CVE", 132, 2),
        new ISO4217Currency("Cayman Islands", "Cayman Islands Dollar", "KYD", 136, 2),
        new ISO4217Currency("Central African Republic", "CFA Franc", "XAF", 950, 0),
        new ISO4217Currency("Chad", "CFA Franc", "XAF", 950, 0),
//        new ISO4217Currency("Chile", "Unidad de Fomento", "CLF", 990, 4),
        new ISO4217Currency("Chile", "Chilean Peso", "CLP", 152, 0),
        new ISO4217Currency("China", "Yuan Renminbi", "CNY", 156, 2),
        new ISO4217Currency("Christmas Island", "Australian Dollar", "AUD", 036, 2),
        new ISO4217Currency("Cocos (Keeling) Islands", "Australian Dollar", "AUD", 036, 2),
        new ISO4217Currency("Colombia", "Colombian Peso", "COP", 170, 2),
//        new ISO4217Currency("Colombia", "Unidad de Valor Real", "COU", 970, 2),
        new ISO4217Currency("Comoros", "Comoro Franc", "KMF", 174, 0),
        new ISO4217Currency("Congo", "CFA Franc", "XAF", 950, 0),
//        new ISO4217Currency("Congo Democratic Republic of the", "Congolese Franc", "CDF", 976, 2),
        new ISO4217Currency("Cook Islands", "New Zealand Dollar", "NZD", 554, 2),
        new ISO4217Currency("Costa Rica", "Costa Rican Colon", "CRC", 188, 2),
        new ISO4217Currency("Cote D'Ivoire", "CFA Franc", "XOF", 952, 0),
        new ISO4217Currency("Croatia", "Croatian Kuna", "HRK", 191, 2),
//        new ISO4217Currency("Cuba", "Peso Convertible", "CUC", 931, 2),
        new ISO4217Currency("Cuba", "Cuban Peso", "CUP", 192, 2),
        new ISO4217Currency("Curacao", "Netherlands Antillean Guilder", "ANG", 532, 2),
        new ISO4217Currency("Cyprus", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Czech Republic", "Czech Koruna", "CZK", 203, 2),
        new ISO4217Currency("Denmark", "Danish Krone", "DKK", 208, 2),
        new ISO4217Currency("Djibouti", "Djibouti Franc", "DJF", 262, 0),
        new ISO4217Currency("Dominica", "East Caribbean Dollar", "XCD", 951, 2),
        new ISO4217Currency("Dominican Republic", "Dominican Peso", "DOP", 214, 2),
        new ISO4217Currency("Ecuador", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Egypt", "Egyptian Pound", "EGP", 818, 2),
//        new ISO4217Currency("El Salvador", "El Salvador Colon", "SVC", 222, 2),
        new ISO4217Currency("El Salvador", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Equatorial Guinea", "CFA Franc", "XAF", 950, 0),
        new ISO4217Currency("Eritrea", "Nakfa", "ERN", 232, 2),
        new ISO4217Currency("Estonia", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Ethiopia", "Ethiopian Birr", "ETB", 230, 2),
        new ISO4217Currency("Falkland Islands (Malvinas)", "Falkland Islands Pound", "FKP", 238, 2),
        new ISO4217Currency("Faroe Islands", "Danish Krone", "DKK", 208, 2),
        new ISO4217Currency("Fiji", "Fiji Dollar", "FJD", 242, 2),
        new ISO4217Currency("Finland", "Euro", "EUR", 978, 2),
        new ISO4217Currency("France", "Euro", "EUR", 978, 2),
        new ISO4217Currency("French Guiana", "Euro", "EUR", 978, 2),
        new ISO4217Currency("French Polynesia", "CFP Franc", "XPF", 953, 0),
        new ISO4217Currency("French Southern Territories", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Gabon", "CFA Franc", "XAF", 950, 0),
        new ISO4217Currency("Gambia", "Dalasi", "GMD", 270, 2),
        new ISO4217Currency("Georgia", "Lari", "GEL", 981, 2),
        new ISO4217Currency("Germany", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Ghana", "Ghana Cedi", "GHS", 936, 2),
        new ISO4217Currency("Gibraltar", "Gibraltar Pound", "GIP", 292, 2),
        new ISO4217Currency("Greece", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Greenland", "Danish Krone", "DKK", 208, 2),
        new ISO4217Currency("Grenada", "East Caribbean Dollar", "XCD", 951, 2),
        new ISO4217Currency("Guadeloupe", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Guam", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Guatemala", "Quetzal", "GTQ", 320, 2),
        new ISO4217Currency("Guernsey", "Pound Sterling", "GBP", 826, 2),
        new ISO4217Currency("Guinea", "Guinea Franc", "GNF", 324, 0),
        new ISO4217Currency("Guinea-Bissau", "CFA Franc", "XOF", 952, 0),
        new ISO4217Currency("Guyana", "Guyana Dollar", "GYD", 328, 2),
        new ISO4217Currency("Haiti", "Gourde", "HTG", 332, 2),
//        new ISO4217Currency("Haiti", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Heard Island and Mcdonald Islands", "Australian Dollar", "AUD", 036, 2),
        new ISO4217Currency("Holy See (Vatican City State)", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Honduras", "Lempira", "HNL", 340, 2),
        new ISO4217Currency("Hong Kong", "Hong Kong Dollar", "HKD", 344, 2),
        new ISO4217Currency("Hungary", "Forint", "HUF", 348, 2),
        new ISO4217Currency("Iceland", "Iceland Krona", "ISK", 352, 0),
        new ISO4217Currency("India", "Indian Rupee", "INR", 356, 2),
        new ISO4217Currency("Indonesia", "Rupiah", "IDR", 360, 2),
//        new ISO4217Currency("International Monetary Fund (IMF)", "SDR (Special Drawing Right)", "XDR", 960, -1),
        new ISO4217Currency("Iran Islamic Republic of", "Iranian Rial", "IRR", 364, 2),
        new ISO4217Currency("Iraq", "Iraqi Dinar", "IQD", 368, 3),
        new ISO4217Currency("Ireland", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Isle of Man", "Pound Sterling", "GBP", 826, 2),
        new ISO4217Currency("Israel", "New Israeli Sheqel", "ILS", 376, 2),
        new ISO4217Currency("Italy", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Jamaica", "Jamaican Dollar", "JMD", 388, 2),
        new ISO4217Currency("Japan", "Yen", "JPY", 392, 0),
        new ISO4217Currency("Jersey", "Pound Sterling", "GBP", 826, 2),
        new ISO4217Currency("Jordan", "Jordanian Dinar", "JOD", 400, 3),
        new ISO4217Currency("Kazakhstan", "Tenge", "KZT", 398, 2),
        new ISO4217Currency("Kenya", "Kenyan Shilling", "KES", 404, 2),
        new ISO4217Currency("Kiribati", "Australian Dollar", "AUD", 036, 2),
        new ISO4217Currency("Korea Democratic People's Republic of", "North Korean Won", "KPW", 408, 2),
        new ISO4217Currency("Korea Republic of", "Won", "KRW", 410, 0),
        new ISO4217Currency("Kuwait", "Kuwaiti Dinar", "KWD", 414, 3),
        new ISO4217Currency("Kyrgyzstan", "Som", "KGS", 417, 2),
        new ISO4217Currency("Lao, People's Democratic Republic", "Kip", "LAK", 418, 2),
        new ISO4217Currency("Latvia", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Lebanon", "Lebanese Pound", "LBP", 422, 2),
        new ISO4217Currency("Lesotho", "Loti", "LSL", 426, 2),
        new ISO4217Currency("Lesotho", "Rand", "ZAR", 710, 2),
        new ISO4217Currency("Liberia", "Liberian Dollar", "LRD", 430, 2),
        new ISO4217Currency("Libya", "Libyan Dinar", "LYD", 434, 3),
        new ISO4217Currency("Liechtenstein", "Swiss Franc", "CHF", 756, 2),
        new ISO4217Currency("Lithuania", "Lithuanian Litas", "LTL", 440, 2),
        new ISO4217Currency("Luxembourg", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Macao", "Pataca", "MOP", 446, 2),
        new ISO4217Currency("Macedonia, The Former Yugoslav Republic of", "Denar", "MKD", 807, 2),
        new ISO4217Currency("Madagascar", "Malagasy Ariary", "MGA", 969, 2),
        new ISO4217Currency("Malawi", "Kwacha", "MWK", 454, 2),
        new ISO4217Currency("Malaysia", "Malaysian Ringgit", "MYR", 458, 2),
        new ISO4217Currency("Maldives", "Rufiyaa", "MVR", 462, 2),
        new ISO4217Currency("Mali", "CFA Franc", "XOF", 952, 0),
        new ISO4217Currency("Malta", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Marshall Islands", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Martinique", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Mauritania", "Ouguiya", "MRO", 478, 2),
        new ISO4217Currency("Mauritius", "Mauritius Rupee", "MUR", 480, 2),
        new ISO4217Currency("Mayotte", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Member Countries of the African Development Bank Group", "ADB Unit of Account", "XUA", 965, -1),
        new ISO4217Currency("Mexico", "Mexican Peso", "MXN", 484, 2),
//        new ISO4217Currency("Mexico", "Mexican Unidad de Inversion (UDI)", "MXV", 979, 2),
        new ISO4217Currency("Micronesia, Federated States of", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Moldova, Republic of", "Moldovan Leu", "MDL", 498, 2),
        new ISO4217Currency("Monaco", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Mongolia", "Tugrik", "MNT", 496, 2),
        new ISO4217Currency("Montenegro", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Montserrat", "East Caribbean Dollar", "XCD", 951, 2),
        new ISO4217Currency("Morocco", "Moroccan Dirham", "MAD", 504, 2),
        new ISO4217Currency("Mozambique", "Mozambique Metical", "MZN", 943, 2),
        new ISO4217Currency("Myanmar", "Kyat", "MMK", 104, 2),
        new ISO4217Currency("Namibia", "Namibia Dollar", "NAD", 516, 2),
        new ISO4217Currency("Namibia", "Rand", "ZAR", 710, 2),
        new ISO4217Currency("Nauru", "Australian Dollar", "AUD", 036, 2),
        new ISO4217Currency("Nepal", "Nepalese Rupee", "NPR", 524, 2),
        new ISO4217Currency("Netherlands", "Euro", "EUR", 978, 2),
        new ISO4217Currency("New Caledonia", "CFP Franc", "XPF", 953, 0),
        new ISO4217Currency("New Zealand", "New Zealand Dollar", "NZD", 554, 2),
        new ISO4217Currency("Nicaragua", "Cordoba Oro", "NIO", 558, 2),
        new ISO4217Currency("Niger", "CFA Franc", "XOF", 952, 0),
        new ISO4217Currency("Nigeria", "Naira", "NGN", 566, 2),
        new ISO4217Currency("Niue", "New Zealand Dollar", "NZD", 554, 2),
        new ISO4217Currency("Norfolk Island", "Australian Dollar", "AUD", 036, 2),
        new ISO4217Currency("Northern Mariana Islands", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Norway", "Norwegian Krone", "NOK", 578, 2),
        new ISO4217Currency("Oman", "Rial Omani", "OMR", 512, 3),
        new ISO4217Currency("Pakistan", "Pakistan Rupee", "PKR", 586, 2),
        new ISO4217Currency("Palau", "US Dollar", "USD", 840, 2),
//        new ISO4217Currency("Palestine, State of", "No universal currency", "", 0, 0),
        new ISO4217Currency("Panama", "Balboa", "PAB", 590, 2),
        new ISO4217Currency("Panama", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Papua New Guinea", "Kina", "PGK", 598, 2),
        new ISO4217Currency("Paraguay", "Guarani", "PYG", 600, 0),
        new ISO4217Currency("Peru", "Nuevo Sol", "PEN", 604, 2),
        new ISO4217Currency("Philippines", "Philippine Peso", "PHP", 608, 2),
        new ISO4217Currency("Pitcairn", "New Zealand Dollar", "NZD", 554, 2),
        new ISO4217Currency("Poland", "Zloty", "PLN", 985, 2),
        new ISO4217Currency("Portugal", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Puerto Rico", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Qatar", "Qatari Rial", "QAR", 634, 2),
        new ISO4217Currency("Reunion", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Romania", "New Romanian Leu", "RON", 946, 2),
        new ISO4217Currency("Russian Federation", "Russian Ruble", "RUB", 643, 2),
        new ISO4217Currency("Rwanda", "Rwanda Franc", "RWF", 646, 0),
        new ISO4217Currency("Saint Barthlemy", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Saint Helena Ascension and Tristan Da Cunha", "Saint Helena Pound", "SHP", 654, 2),
        new ISO4217Currency("Saint Kitts and Nevis", "East Caribbean Dollar", "XCD", 951, 2),
        new ISO4217Currency("Saint Lucia", "East Caribbean Dollar", "XCD", 951, 2),
        new ISO4217Currency("Saint Martin (French Part)", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Saint Pierre and Miquelon", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Saint Vincent and the Grenadines", "East Caribbean Dollar", "XCD", 951, 2),
        new ISO4217Currency("Samoa", "Tala", "WST", 882, 2),
        new ISO4217Currency("San Marino", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Sao Tome and Principe", "Dobra", "STD", 678, 2),
        new ISO4217Currency("Saudi Arabia", "Saudi Riyal", "SAR", 682, 2),
        new ISO4217Currency("Senegal", "CFA Franc", "XOF", 952, 0),
        new ISO4217Currency("Serbia", "Serbian Dinar", "RSD", 941, 2),
        new ISO4217Currency("Seychelles", "Seychelles Rupee", "SCR", 690, 2),
        new ISO4217Currency("Sierra Leone", "Leone", "SLL", 694, 2),
        new ISO4217Currency("Singapore", "Singapore Dollar", "SGD", 702, 2),
        new ISO4217Currency("Sint Maarten (Dutch Part)", "Netherlands Antillean Guilder", "ANG", 532, 2),
//        new ISO4217Currency("Sistema Unitario De Compensacion Regional De Pagos (Sucre)", "Sucre", "XSU", 994, -1),
        new ISO4217Currency("Slovakia", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Slovenia", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Solomon Islands", "Solomon Islands Dollar", "SBD", 090, 2),
        new ISO4217Currency("Somalia", "Somali Shilling", "SOS", 706, 2),
        new ISO4217Currency("South Africa", "Rand", "ZAR", 710, 2),
//        new ISO4217Currency("South Georgia and the South Sandwich Islands", "No universal currency", "", 0, 0),
        new ISO4217Currency("South Sudan", "South Sudanese Pound", "SSP", 728, 2),
        new ISO4217Currency("Spain", "Euro", "EUR", 978, 2),
        new ISO4217Currency("Sri Lanka", "Sri Lanka Rupee", "LKR", 144, 2),
        new ISO4217Currency("Sudan", "Sudanese Pound", "SDG", 938, 2),
        new ISO4217Currency("Suriname", "Surinam Dollar", "SRD", 968, 2),
        new ISO4217Currency("Svalbard and Jan Mayen", "Norwegian Krone", "NOK", 578, 2),
        new ISO4217Currency("Swaziland", "Lilangeni", "SZL", 748, 2),
        new ISO4217Currency("Sweden", "Swedish Krona", "SEK", 752, 2),
        new ISO4217Currency("Switzerland", "WIR Euro", "CHE", 947, 2),
        new ISO4217Currency("Switzerland", "Swiss Franc", "CHF", 756, 2),
        new ISO4217Currency("Switzerland", "WIR Franc", "CHW", 948, 2),
        new ISO4217Currency("Syrian Arab Republic", "Syrian Pound", "SYP", 760, 2),
        new ISO4217Currency("Taiwan Province of China", "New Taiwan Dollar", "TWD", 901, 2),
        new ISO4217Currency("Tajikistan", "Somoni", "TJS", 972, 2),
        new ISO4217Currency("Tanzania United Republic of", "Tanzanian Shilling", "TZS", 834, 2),
        new ISO4217Currency("Thailand", "Baht", "THB", 764, 2),
        new ISO4217Currency("Timor-Leste", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Togo", "CFA Franc", "XOF", 952, 0),
        new ISO4217Currency("Tokelau", "New Zealand Dollar", "NZD", 554, 2),
        new ISO4217Currency("Tonga", "Pa'anga", "TOP", 776, 2),
        new ISO4217Currency("Trinidad and Tobago", "Trinidad and Tobago Dollar", "TTD", 780, 2),
        new ISO4217Currency("Tunisia", "Tunisian Dinar", "TND", 788, 3),
        new ISO4217Currency("Turkey", "Turkish Lira", "TRY", 949, 2),
        new ISO4217Currency("Turkmenistan", "Turkmenistan New Manat", "TMT", 934, 2),
        new ISO4217Currency("Turks and Caicos Islands", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Tuvalu", "Australian Dollar", "AUD", 036, 2),
        new ISO4217Currency("Uganda", "Uganda Shilling", "UGX", 800, 0),
        new ISO4217Currency("Ukraine", "Hryvnia", "UAH", 980, 2),
        new ISO4217Currency("United Arab Emirates", "UAE Dirham", "AED", 784, 2),
//        new ISO4217Currency("United States", "US Dollar (Next day)", "USN", 997),
        new ISO4217Currency("United States Minor Outlying Islands", "US Dollar", "USD", 840, 2),
//        new ISO4217Currency("Uruguay", "Uruguay Peso en Unidades Indexadas (URUIURUI)", "UYI", 940, 0),
        new ISO4217Currency("Uruguay", "Peso Uruguayo", "UYU", 858, 2),
        new ISO4217Currency("Uzbekistan", "Uzbekistan Sum", "UZS", 860, 2),
        new ISO4217Currency("Vanuatu", "Vatu", "VUV", 548, 0),
        new ISO4217Currency("Venezuela Bolivarian Republic of", "Bolivar", "VEF", 937, 2),
        new ISO4217Currency("Viet Nam", "Dong", "VND", 704, 0),
        new ISO4217Currency("Virgin Islands, (British)", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Virgin Islands, (U.S.)", "US Dollar", "USD", 840, 2),
        new ISO4217Currency("Wallis and Futuna", "CFP Franc", "XPF", 953, 0),
        new ISO4217Currency("Western Sahara", "Moroccan Dirham", "MAD", 504, 2),
        new ISO4217Currency("Yemen", "Yemeni Rial", "YER", 886, 2),
        new ISO4217Currency("Zambia", "Zambian Kwacha", "ZMW", 967, 2),
        new ISO4217Currency("Zimbabwe", "Zimbabwe Dollar", "ZWL", 932, 2)
//        new ISO4217Currency("Zz01_Bond Markets Unit European_Eurco", "Bond Markets Unit European Composite Unit (EURCO)", "XBA", 955, -1),
//        new ISO4217Currency("Zz02_Bond Markets Unit European_Emu-6", "Bond Markets Unit European Monetary Unit (E.M.U.-6)", "XBB", 956, -1),
//        new ISO4217Currency("Zz03_Bond Markets Unit European_Eua-9", "Bond Markets Unit European Unit of Account 9 (E.U.A.-9)", "XBC", 957, -1),
//        new ISO4217Currency("Zz04_Bond Markets Unit European_Eua-17", "Bond Markets Unit European Unit of Account 17 (E.U.A.-17)", "XBD", 958, -1),
//        new ISO4217Currency("Zz06_Testing_Code", "Codes specifically reserved for testing purposes", "XTS", 963, -1),
//        new ISO4217Currency("Zz07_No_Currency", "The codes assigned for transactions where no currency is involved", "XXX", 999, -1),
//        new ISO4217Currency("Zz08_Gold", "Gold", "XAU", 959, -1),
//        new ISO4217Currency("Zz09_Palladium", "Palladium", "XPD", 964, -1),
//        new ISO4217Currency("Zz10_Platinum", "Platinum", "XPT", 962, -1),
//        new ISO4217Currency("Zz11_Silver", "Silver", "XAG", 961, -1)
        };
      }

    ~ISO4217CurrencyList()
      {
      // PKR. 23/03/2015. ABSEXCH-16215. Free up resources to speed up Garbage Collection
      Currencies.Clear();
      Currencies = null;
      }

    /// <summary>
    /// Return the ISO code for a country
    /// </summary>
    /// <param name="country"></param>
    /// <returns></returns>
    public string GetCurrencyCodeFromCountry(string country)
      {
      string result = "";

      foreach (ISO4217Currency currency in Currencies)
        {
        if (string.Compare(currency.CountryName, country, true) == 0)
          {
          // Found it
          result = currency.CurrencyCode;
          }
        }

      return result;
      }
    }
  }