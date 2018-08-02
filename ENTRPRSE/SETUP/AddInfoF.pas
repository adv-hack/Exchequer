unit AddInfoF;

{ Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SetupBas, ExtCtrls, StdCtrls, SetupU, TEditVal;

type
  TfrmAdditionalInfo = class(TSetupTemplate)
    ScrollBox1: TScrollBox;
    panWorkstation: TPanel;
    Label811: Label8;
    Label1: TLabel;
    Label2: TLabel;
    Label810: Label8;
    panExcelAddIns: TPanel;
    Label81: Label8;
    Label3: TLabel;
    panImport: TPanel;
    Label82: Label8;
    Label5: TLabel;
    Label6: TLabel;
    panSentimail: TPanel;
    Label83: Label8;
    Label7: TLabel;
    Label8: TLabel;
    panCRWAddIn: TPanel;
    Label84: Label8;
    Label9: TLabel;
    Label10: TLabel;
    panTradeCounter: TPanel;
    Label85: Label8;
    Label11: TLabel;
    Label12: TLabel;
    panSDK: TPanel;
    Label86: Label8;
    Label13: TLabel;
    Label14: TLabel;
    panEBusiness: TPanel;
    Label87: Label8;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    panODBC: TPanel;
    Label88: Label8;
    Label4: TLabel;
    Label18: TLabel;
    procedure LoadHelp(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Procedure BuildList;
  public
    { Public declarations }
    W_MainDir : String;
  end;

function SCD_InfoDialog(var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;

implementation

{$R *.dfm}

Uses Brand, CompUtil;

function SCD_InfoDialog(var DLLParams: ParamRec): LongBool;
Var
  W_AddInfo  : String;
  DLLStatus  : LongInt;
Begin { SCD_InfoDialog }
  DLLStatus := 0;

  Try
    With TfrmAdditionalInfo.Create (Application) Do
      Try
        If (Branding.pbProduct <> ptLITE) Then
          // Exchequer - Resize form for max usable height
          AutoResize (1, 0);

        // Disable abort messages if they close the window
        ExitMsg := 255;

        // Get main Exchequer directory
        GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
        FixPath (W_MainDir);

        Application.HelpFile := W_MainDir + 'WSTATION\SETUP.HLP';

        // Get Details of modules that need Addition Info displayed this time
        GetVariable(DLLParams, 'V_ADDINFO', W_AddInfo);
        W_AddInfo := UpperCase(W_AddInfo);

        // Hide sections as required by licencing
        panWorkstation.Visible := (Pos('A', W_AddInfo) > 0);
        panExcelAddIns.Visible := (Pos('F', W_AddInfo) > 0);
        panImport.Visible := (Pos('H', W_AddInfo) > 0);
        panSentimail.Visible := (Pos('D', W_AddInfo) > 0);
        panSDK.Visible := (Pos('B', W_AddInfo) > 0);
        panTradeCounter.Visible := (Pos('C', W_AddInfo) > 0);
        panCRWAddIn.Visible := (Pos('E', W_AddInfo) > 0);
        panEBusiness.Visible := (Pos('G', W_AddInfo) > 0);
        panODBC.Visible := (Pos('I', W_AddInfo) > 0);

        // Reposition panels to hide missing elements
        BuildList;

        ShowModal;

      Finally
        Free;
      End;
  Except
    On Ex:Exception Do Begin
      //GlobExceptHandler(Ex);
      DLLStatus := 1000;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_InfoDialog }

//---------------------------------------------------------------------------

procedure TfrmAdditionalInfo.FormCreate(Sender: TObject);
begin
  inherited;

  // Configure Scroll-Box Scroll Bar - doesn't work if you set them at Design-Time!
  With ScrollBox1.VertScrollBar Do Begin
    Position := 0;
    Tracking := True;
  End; { With ScrollBox1.VertScrollBar }
end;


Procedure TfrmAdditionalInfo.BuildList;
Var
  NextTopL : LongInt;                                                          

  Procedure SetupPanel (Const ThePanel :  TControl; Var NextTop : LongInt);
  Begin { SetupPanel }
    If ThePanel.Visible Then
      With ThePanel Do Begin
        Top := NextTop;
        Inc (NextTop, Height);

        Left := 1;
        Width := 380;
      End; { With }
  End; { SetupPanel }

Begin { BuildList }
  NextTopL := 1;

  SetupPanel (panWorkstation, NextTopL);
  SetupPanel (panExcelAddIns, NextTopL);
  SetupPanel (panImport, NextTopL);
  SetupPanel (panODBC, NextTopL);
  SetupPanel (panSentimail, NextTopL);
  SetupPanel (panTradeCounter, NextTopL);
  SetupPanel (panCRWAddIn, NextTopL);
  SetupPanel (panSDK, NextTopL);
  SetupPanel (panEBusiness, NextTopL);
End; { BuildList }

procedure TfrmAdditionalInfo.LoadHelp(Sender: TObject);
Var
  HelpUtilPath, HelpPath  : ShortString;
  ContextId : THelpContext;
begin
  If Sender Is TLabel Then
    With Sender As TLabel Do
      If (Tag > 0) Then Begin
        HelpUtilPath := W_MainDir;
        HelpPath := '';

        Case Tag Of
          // Workstation Setup
          1  : Begin
                 HelpPath := W_MainDir + 'Wstation\Setup.Hlp';
                 ContextId := 10;
               End;
          // Excel Add-In
          2  : Begin
                 HelpPath := W_MainDir + 'EnterOle.Hlp';
                 ContextId := 16;
               End;
          // Import Modules
          3  : Begin
                 HelpPath := W_MainDir + 'Import\Importer.Hlp';
                 ContextId := 1;
               End;
          // Sentimail
          4  : Begin
                 HelpPath := W_MainDir + 'SentMail.Hlp';
                 ContextId := 3;
               End;
          // Trade Counter
          5  : Begin
                 HelpPath := W_MainDir + 'Trade\Trade.Hlp';
                 ContextId := 63;
               End;
          // CRW Add-In
          6  : Begin
                 HelpPath := W_MainDir + 'EntODBC.Hlp';
                 ContextId := 1;
               End;
          // SDK
          7  : Begin
                 HelpPath := W_MainDir + 'SDK\EntSDK.Hlp';
                 ContextId := 1;
               End;
          // E-Business
          8  : Begin
                 HelpPath := W_MainDir + 'EBus.Hlp';
                 ContextId := 150;
               End;
          // ODBC
          9  : Begin
                 HelpPath := W_MainDir + 'EntODBC.Hlp';
                 ContextId := 2;
               End;
        End; { Case }

        {$IF Defined(HTMLHELP)}
          ExecuteHelp (HelpUtilPath, HelpPath, ContextId);
        {$ELSE}
          // Run Help File
          If (HelpPath <> '') And FileExists(HelpPath) Then Begin
            Application.HelpFile := HelpPath;
            Application.HelpContext (ContextId);
          End { If (HelpPath <> '') And FileExists (... }
          Else
            MessageDlg ('The file containing the additional information is not available', mtError, [MbOk], 0);
        {$IFEND}
      End; { If (Tag > 0) }
end;

end.
