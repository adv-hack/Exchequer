unit TestF;

interface
//Test program for FSH backdoor to toolkit.
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  COMObj, Enterprise01_TLB, StdCtrls;

type
  TfrmCustList = class(TForm)
    btnOpen: TButton;
    Label1: TLabel;
    lblVersion: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOpenClick(Sender: TObject);
  private
    { Private declarations }
    oToolkit : IToolkit;
  public
    { Public declarations }
  end;

var
  frmCustList: TfrmCustList;

implementation

{$R *.DFM}


procedure TfrmCustList.FormCreate(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  // Create COM Toolkit object
  oToolkit := CreateOLEObject ('Enterprise01.Toolkit') as IToolkit;

  if Assigned(oToolkit) then
    lblVersion.Caption := oToolkit.Version
  else
    btnOpen.Enabled := False;
end;

//-----------------------------------------------------------------------

procedure TfrmCustList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If Assigned(oToolkit) Then Begin
    // Close COM Toolkit and remove reference
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  End; { If Assigned(oToolkit) }
end;

procedure TfrmCustList.btnOpenClick(Sender: TObject);
var
  _ExchFSH : THandle;
  _FSH_CTKDebugMode : Procedure (Var I1, I2, I3 : LongInt); StdCall;

  i1, i2, i3 : longint;
  Res : integer;
begin
  // Dynamically load the EXCHFSH DLL - Note: .DLL removed from the physical filename for
  // security by obscurity reasons
  _ExchFSH := LoadLibrary('ExchFSH.');
  Try
    If (_ExchFSH > HInstance_Error) Then
    Begin
      // Get a handle to the FSH_CTKDebugMode procedure which is exported as Index 1 with no name
      i1 := 1;
      _FSH_CTKDebugMode := GetProcAddress(_ExchFSH, PCHAR(1));

      // Call the FSH_CTKDebugMode function to calculate today's backdoor passwords on this PC
      i1 := 1970;
      i2 := 937482;
      i3 := -611306;
      _FSH_CTKDebugMode(i1, i2, i3);

      // Pass the backdoor passwords into SetDebugMode to disable the COM Toolkit's licensing
      // subsystem, if the passwords are invalid you will get a fake Access Violation in Kernel32.dll
      // message
      oToolkit.Configuration.SetDebugMode(i1, i2, i3);

      // Note: Comment out the SetDebugMode call to check that you don't already have a Toolkit
      // Licence, OpenToolkit should return a 32767 error with SetDebugMode commented out if
      // you don't have a Toolkit Licence

      // Open the Toolkit to check it worked - should return 0
      Res := oToolkit.OpenToolkit;

      if Res = 0 then
        ShowMessage('Toolkit opened successfully')
      else
        ShowMessage('Unable to open toolkit: ' + IntToStr(Res) + #10#10 + QuotedStr(oToolkit.LastErrorString));
    End // If (_ExchFSH > HInstance_Error)
    Else
      ShowMessage ('Failed to load ExchFSH');
  Finally
    FreeLibrary(_ExchFSH);
  End; // Try..Finally
end;

end.
