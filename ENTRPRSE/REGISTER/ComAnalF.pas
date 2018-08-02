unit ComAnalF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registry, ComCtrls, Menus;

type
  TfrmCOMRegAnal = class(TForm)
    reResults: TRichEdit;
    PopupMenu1: TPopupMenu;
    Refresh1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
  private
    { Private declarations }
    Indent : ShortString;
    Procedure AddMsg (Const Msg : ShortString; Const Error : Boolean = False);
    Procedure CheckCOMServer(Const ServerDesc, ServerName : ShortString; Const InProc : Boolean);
    procedure CheckCOMObjects;
    Procedure ChkDotNetAsssembly(Const ServerDesc, ServerName : ShortString);
    Procedure CheckHTMLHelp  (Const ServerDesc, HelpName : ShortString);
  public
    { Public declarations }
  end;

var
  frmCOMRegAnal: TfrmCOMRegAnal;

implementation

{$R *.dfm}

//=========================================================================

procedure TfrmCOMRegAnal.FormCreate(Sender: TObject);
begin
  Indent := '';

  Caption := Application.Title;

  CheckCOMObjects;
end;

//-------------------------------------------------------------------------

procedure TfrmCOMRegAnal.FormResize(Sender: TObject);
begin
  reResults.Top := 5;
  reResults.Left := 5;
  reResults.Width := ClientWidth - (reResults.Left * 2);
  reResults.Height := ClientHeight - (reResults.Top * 2);
end;

//-------------------------------------------------------------------------

procedure TfrmCOMRegAnal.CheckCOMObjects;
Begin // CheckCOMObjects
  reResults.Text := '';

  // Exchequer objects
  CheckComServer ('Exchequer COM Customisation', 'Enterprise.COMCustomisation', False);
  CheckComServer ('VCFI Graph Control', 'VCFI.VCFiCtrl.1', True);
  ChkDotNetAsssembly ('Exchequer Excel Utilities Library', 'Exchequer.ExcelUtilities');

  // OLE Server Objects
  CheckComServer ('Exchequer OLE Server', 'Enterprise.OLEServer', False);
  CheckHTMLHelp  ('Exchequer OLE Help (v6.00)', 'EnterOLE.CHM');
  CheckComServer ('Excel Data Query COM DLL (->v6.3)', 'Enterprise.DataQuery', True);
  CheckComServer ('Excel Data Query COM EXE (v6.4->)', 'Enterprise.DataQuery', False);
  CheckComServer ('Excel Drill-Down COM Object', 'Enterprise.DrillDown', False);

  // COM Toolkit & Forms Toolkit
  CheckComServer ('Exchequer COM Toolkit (v5.71 EXE)', 'Enterprise01.Toolkit', False);
  CheckComServer ('Exchequer COM Toolkit (v6.00 EXE)', 'Enterprise04.Toolkit', False);
  CheckComServer ('Exchequer COM Toolkit (DLL)', 'Enterprise01.Toolkit', True);
  CheckComServer ('Enterprise Library', 'EnterpriseBeta.Test', True);
  CheckComServer ('Exchequer Form Printing toolkit', 'EnterpriseForms.PrintingToolkit', False);
  CheckComServer ('Exchequer Preview ActiveX Control', 'entPrevX.entPreviewX', True);

  // Misc
  CheckComServer ('Report Writer DBF Object', 'EnterpriseDBF.DBFWriter', True);
  CheckComServer ('Plug-In Security Object', 'EnterpriseSecurity.ThirdParty', True);
  CheckComServer ('Outlook Today Host', 'IKPIHost.KPIAddin', True);
  CheckComServer ('Scheduler Interfaces', 'ExScheduler.ScheduledTask', False);

  // v6.00 Faxing
  CheckComServer ('Faxing - ClassX', 'DevProps.DevProps.1', True);
  //CheckComServer ('Faxing - ClassXPS', '?', True); - No com object name!
  CheckComServer ('Faxing - FMJr10', 'FaxJr.FaxJr.1', True);
  CheckComServer ('Faxing - PrtCtl30 OCX', 'FmPrint.FmPrint.1', True);
  CheckComServer ('Faxing - ImageViewer2 OCX', 'SCRIBBLE.ScribbleCtrl.1', True);
End; // CheckCOMObjects

//-------------------------------------------------------------------------

// Check that a particular .NET Assembly is registered to the current directory
Procedure TfrmCOMRegAnal.ChkDotNetAsssembly(Const ServerDesc, ServerName : ShortString);
Var
  ClsId, CLSIDPath, SvrPath : ShortString;
Begin { ChkDotNetAsssembly }
  AddMsg (ServerDesc + '  (' + ServerName + ')');

  With TRegistry.Create Do
    Try
      Access := KEY_READ;
      RootKey := HKEY_CLASSES_ROOT;

      If KeyExists(ServerName) Then Begin
        If KeyExists(ServerName + '\Clsid') Then Begin
          // Key exists - Open key and get the CLSID (aka OLE/COM Server GUID)
          If OpenKey(ServerName + '\Clsid', False) Then Begin
            If KeyExists('') Then Begin
              { CLSID stored in default entry }
              ClsId := ReadString ('');
              AddMsg ('  GUID: ' + ClsId);
              CloseKey;

              { Got CLSID - find entry in CLSID Section and check registered .EXE/.DLL }
              CLSIDPath := 'Clsid\'+ClsId+'\InprocServer32';
              If KeyExists (CLSIDPath) Then Begin
                { Got Server details - read .EXE/.DLL details and check it exists }
                If OpenKey(CLSIDPath, False) Then Begin
                  SvrPath := ReadString ('CodeBase');
                  // Strip off 'file:///' from start of path
                  Delete (SvrPath, 1, 8);
                  AddMsg ('  File: ' + SvrPath);

                  If Not FileExists (SvrPath) Then
                    // File missing
                    AddMsg ('  Error - Server Missing', True);
                End { If }
                Else
                  AddMsg ('  Cannot open Server Details in CLSID', True);
              End { If (SvrPath <> '') }
              Else
                AddMsg ('  CLSID section missing for GUID', True);
            End { If KeyExists('') }
            Else
              AddMsg ('  Server Class Id Missing', True);
          End { If OpenKey(ServerName + '\Clsid', False) }
          Else
            AddMsg ('  Cannot open Server Class Id', True);
        End { If KeyExists(ServerName + '\Clsid') }
        Else
          AddMsg ('  Server Class Id Entry Missing', True);
      End { If KeyExists(ServerName + '\Clsid') }
      Else
        AddMsg ('  Server Not Registered', True);

      CloseKey;
    Finally
      Free;
    End;

    AddMsg ('');
End; { ChkDotNetAsssembly }

//-------------------------------------------------------------------------

// Check that a particular server is registered to the current directory
Procedure TfrmCOMRegAnal.CheckCOMServer(Const ServerDesc, ServerName : ShortString; Const InProc : Boolean);
Var
  ClsId, CLSIDPath, SvrPath : ShortString;
Begin { ChkCOMServer }
  AddMsg (ServerDesc + '  (' + ServerName + ')');

  With TRegistry.Create Do
    Try
      Access := KEY_READ;
      RootKey := HKEY_CLASSES_ROOT;

      If KeyExists(ServerName) Then Begin
        If KeyExists(ServerName + '\Clsid') Then Begin
          // Key exists - Open key and get the CLSID (aka OLE/COM Server GUID)
          If OpenKey(ServerName + '\Clsid', False) Then Begin
            If KeyExists('') Then Begin
              { CLSID stored in default entry }
              ClsId := ReadString ('');
              AddMsg ('  GUID: ' + ClsId);
              CloseKey;

              { Got CLSID - find entry in CLSID Section and check registered .EXE/.DLL }
              If InProc Then
                CLSIDPath := 'Clsid\'+ClsId+'\InprocServer32'
              Else
                CLSIDPath := 'Clsid\'+ClsId+'\LocalServer32';

              If KeyExists (CLSIDPath) Then Begin
                { Got Server details - read .EXE/.DLL details and check it exists }
                If OpenKey(CLSIDPath, False) Then Begin
                  SvrPath := ReadString ('');
                  AddMsg ('  File: ' + SvrPath);

                  If Not FileExists (SvrPath) Then
                    // File missing
                    AddMsg ('  Error - Server Missing', True);
                End { If }
                Else
                  AddMsg ('  Cannot open Server Details in CLSID', True);
              End { If (SvrPath <> '') }
              Else
                AddMsg ('  CLSID section missing for GUID', True);
            End { If KeyExists('') }
            Else
              AddMsg ('  Server Class Id Missing', True);
          End { If OpenKey(ServerName + '\Clsid', False) }
          Else
            AddMsg ('  Cannot open Server Class Id', True);
        End { If KeyExists(ServerName + '\Clsid') }
        Else
          AddMsg ('  Server Class Id Entry Missing', True);
      End { If KeyExists(ServerName + '\Clsid') }
      Else
        AddMsg ('  Server Not Registered', True);

      CloseKey;
    Finally
      Free;
    End;

    AddMsg ('');
End; { ChkCOMServer }

//-------------------------------------------------------------------------

Procedure TfrmCOMRegAnal.CheckHTMLHelp  (Const ServerDesc, HelpName : ShortString);
Const
  HTMLHelpKey = 'SOFTWARE\Microsoft\Windows\HTML Help';
Var
  FilePath : ShortString;
Begin // CheckHTMLHelp
  AddMsg (ServerDesc + '  (' + HelpName + ')');

  With TRegistry.Create Do
    Try
      Access := KEY_READ;
      RootKey := HKEY_LOCAL_MACHINE;

      If KeyExists(HTMLHelpKey) Then
      Begin
        // Key exists - Open key and check for the help file
        If OpenKey(HTMLHelpKey, False) Then
        Begin
          If ValueExists(HelpName) Then
          Begin
            FilePath := ReadString (HelpName);
            AddMsg ('  HelpPath: ' + FilePath);

            If DirectoryExists(FilePath) Then
            Begin
              If (Not FileExists (IncludeTrailingPathDelimiter(FilePath) + HelpName)) Then
                AddMsg ('  Error - Help File Missing', True);
            End // If DirectoryExists(FilePath)
            Else
              AddMsg ('  Error - Directory Missing', True);
          End // If ValueExists(HelpName)
          Else
            AddMsg ('  Help File Not Registered', True);

          CloseKey;
        End // If OpenKey(HTMLHelpKey, False)
        Else
          AddMsg ('  Cannot open HTMLHelp section', True);
      End // If KeyExists(HTMLHelpKey) Then
      Else
        AddMsg ('  HTMLHelp section missing', True);

      CloseKey;
    Finally
      Free;
    End;

    AddMsg ('');
End; // CheckHTMLHelp

//-------------------------------------------------------------------------

Procedure TfrmCOMRegAnal.AddMsg (Const Msg : ShortString; Const Error : Boolean = False);
Begin
  If Error Then
  Begin
    reResults.SelAttributes.Color := clRed;
    reResults.SelAttributes.Style := [fsBold];
  End; // If Error

  reResults.Lines.Add (Indent + Msg);

  reResults.SelAttributes.Color := clBlack;
  reResults.SelAttributes.Style := [];
End;

//-------------------------------------------------------------------------


procedure TfrmCOMRegAnal.Refresh1Click(Sender: TObject);
begin
  CheckCOMObjects;
end;

end.
