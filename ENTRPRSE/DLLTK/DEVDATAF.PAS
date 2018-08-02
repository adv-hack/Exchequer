unit DevDataF;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ComCtrls, bkgroup;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    edtSystemDir: TEdit;
    btnGetDevInfo: TButton;
    Label1: TLabel;
    edtCompany: TEdit;
    Label2: TLabel;
    SBSBackGroup1: TSBSBackGroup;
    SBSBackGroup2: TSBSBackGroup;
    Label3: TLabel;
    edtSysId: TEdit;
    procedure btnGetDevInfoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses UseDllU;

{$I ExchDll.Inc}

procedure TForm1.btnGetDevInfoClick(Sender: TObject);
Var
  DevInfo   : DeveloperInfoType;
  SystemDir : ANSIString;
  Res       : SmallInt;
begin
  SystemDir := edtSystemDir.Text;

  FillChar (DevInfo, SizeOf(DevInfo), #0);
  DevInfo.diDevName := edtCompany.Text;

  Res := EX_GetDeveloperInfo (@DevInfo, SizeOf(DevInfo), PChar(SystemDir));

  If (Res = 0) Then
    { AOK - Display sysId }
    edtsysId.Text := IntToStr(DevInfo.diSysId)
  Else Begin
    { SNAFU - Display Error }
    edtsysId.Text := '';
    ShowMessage ('Ex_GetDeveloperInfo: ' + IntToStr(Res));
  End; { Else }
end;

end.
