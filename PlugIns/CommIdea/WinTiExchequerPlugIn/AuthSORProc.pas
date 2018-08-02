unit AuthSORProc;

interface
uses
  strUtil, CustABSU, Enterprise01_TLB;

const
  INIFileName = 'AuthSOR.ini';

  AM_PAYMENT = 1;
  AM_UPFRONT = 2;
  AM_REFUND = 3;

  procedure StartToolkit(LEventData : TAbsEnterpriseSystem);
  procedure AddNote(oTX : ITransaction; sUserName, sNote : string);

type
  TSetupRec = record
    SalesLineGLCode : integer;
    SalesLineCC : string3;
    SalesLineDept : string3;
    SterlingCcy : integer;
  end;

var
  oToolkit : IToolkit;
  SetupRec : TSetupRec;

implementation
uses
  Windows, Dialogs, Controls, SysUtils, SecCodes, Forms, COMObj;

procedure StartToolkit(LEventData : TAbsEnterpriseSystem);
var
  a, b, c : LongInt;
  FuncRes : integer;
begin{StartToolkit}
  // Create COM Toolkit object
  oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin
    With oToolkit Do Begin
      EncodeOpCode(97, a, b, c);
      oToolkit.Configuration.SetDebugMode(a, b, c);

      // Open Default Company
      oToolkit.Configuration.DataDirectory := LEventData.Setup.ssDataPath;
      oToolkit.Configuration.AutoSetTransCurrencyRates := TRUE;

      FuncRes := OpenToolkit;

      // Check it opened OK
      If (FuncRes = 0) then {DoUpdates}
      else begin
        // Error opening Toolkit - display error
        ShowMessage ('The following error occurred opening the Toolkit:-'#13#13
        + QuotedStr(oToolkit.LastErrorString));
      end;{if}

    End; { With OToolkit }

  End { If Assigned(oToolkit) }
  Else
    // Failed to create COM Object
    ShowMessage ('Cannot create COM Toolkit instance');

end;{StartToolkit}

procedure AddNote(oTX : ITransaction; sUserName, sNote : string);
var
  iNewLineNo, iStatus : integer;
begin {AddNote}
  if oTX.thNotes.GetLast = 0
  then iNewLineNo := oTX.thNotes.ntLineNo + 1
  else iNewLineNo := 1;

  with oTX.thNotes.add do
  begin
    ntType := ntTypeDated;
    ntDate := DateToStr8(Date);
    ntOperator := sUserName;
    ntLineNo := iNewLineNo;
    ntText := sNote;
    iStatus := Save;
    if iStatus <> 0
    then ShowMessage('Could not save note.'#13#13'Error No : ' + IntToStr(iStatus));
  end;{with}
end;{AddNote}



end.
