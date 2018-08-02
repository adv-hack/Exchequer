unit enBureauIntF;

interface

Uses Classes, EnterpriseBeta_TLB;

Type
  // Interface declaration for the Bureau Module data object for use
  // in Exchequer Enterprise to display the company list. The interface
  // descends from IBtrieveFunctions2 declared in the COM TK so that
  // the standard TDBMultiList/TCOMTKDataSet components can be used to
  // display the data.
  //
  // The Bureau Module data object is implemented in EnBureau.Dll.
  IBureauDataObject = Interface (IDatabaseFunctions)
    ['{985F95DA-C35C-45E3-8D77-47AFC3BBFC34}']

    // --- Internal Methods to implement Public Properties ---

    // Property Get methods for bdoCompanyCode
    Function GetCompanyCode : ShortString;
    // Property Get methods for bdoCompanyName
    Function GetCompanyName : ShortString;
    // Property Get methods for bdoCompanyPath
    Function GetCompanyPath : ShortString;
    // Property Get methods for bdoErrorStatus
    Function GetErrorStatus : SmallInt;
    // Property Get methods for bdoErrorString
    Function GetErrorString : ShortString;
    // Property Get methods for bdoDemoSystem
    Function GetDemoSystem : Boolean;

    // Property Get methods for bdoAllowEnterprise
    Function GetAllowEnterprise : Boolean;
    // Property Get methods for bdoAllowExchequer
    Function GetAllowExchequer : Boolean;
    // Property Get methods for bdoAllowEBusiness
    Function GetAllowEBusiness : Boolean;
    // Property Get methods for bdoAllowSentimail
    Function GetAllowSentimail : Boolean;

    // Property Get methods for bdoExchWin9xCmdLine
    Function GetExchWin9xCmdLine : ShortString;
    // Property Get methods for bdoExchWinNTCmdLine
    Function GetExchWinNTCmdLine : ShortString;

    // ------------------ Public Properties ------------------

    // Company Properties
    Property bdoCompanyCode : ShortString Read GetCompanyCode;
    Property bdoCompanyName : ShortString Read GetCompanyName;
    Property bdoCompanyPath : ShortString Read GetCompanyPath;
    Property bdoErrorStatus : SmallInt Read GetErrorStatus;
    Property bdoErrorString : ShortString Read GetErrorString;
    Property bdoDemoSystem  : Boolean Read GetDemoSystem;

    // User Security Properties
    Property bdoAllowEnterprise : Boolean Read GetAllowEnterprise;
    Property bdoAllowExchequer  : Boolean Read GetAllowExchequer;
    Property bdoAllowEBusiness  : Boolean Read GetAllowEBusiness;
    Property bdoAllowSentimail  : Boolean Read GetAllowSentimail;

    // Exchequer Command Lines
    Property bdoExchWin9xCmdLine : ShortString Read GetExchWin9xCmdLine;
    Property bdoExchWinNTCmdLine : ShortString Read GetExchWinNTCmdLine;

    // ------------------- Public Methods --------------------

    // Returns TRUE if the specified company dataset has an error
    Function CompanyStatus (CompCode : ShortString) : Boolean;
  End; // IBureauDataObject


implementation

end.
