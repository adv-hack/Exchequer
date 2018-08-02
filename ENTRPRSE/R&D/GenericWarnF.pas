unit GenericWarnF;

{******************************************************************************}
{                                                                              }
{             ====----> E X C H E Q U E R <----===                             }
{                                                                              }
{                      Created : 01/12/2015                                    }
{                                                                              }
{   Generic unit to display Warning message and process Password to proceed.   }
{                                                                              }
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, TEditVal, TCustom, ExtCtrls, SBSPanel, GlobVar, VarConst;

type
  TfrmGenericWarning = class(TForm)
    Panel1: TPanel;
    btnCancel: TSBSButton;
    btnOK: TSBSButton;
    Image1: TImage;
    SBSPanel2: TSBSPanel;
    CLMsgL: Label8;
    Label86: Label8;
    Label85: Label8;
    Label2: TLabel;
    Label3: TLabel;
    Panel2: TPanel;
    Label1: TLabel;
    edtPassword: Text8Pt;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure edtPasswordChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  
{ Add public function to access}
function AuthoriseCCListChange(Const ACCListCode, ACCListDesc : String) : Boolean;

implementation

uses
  Crypto, ApiUtil, SecSup2U, SQLUtils, SysU1, ETDateU;

{$R *.dfm}

//=========================================================================

procedure WriteCCListChangeLogFile(Const ACCListCode, ACCListDesc : String);
const
  S_FILENAME = 'DOCS\CCList.DAT';
var
  sFile : string;
  F : TextFile;
  Attr : Integer;
begin
  sFile := SetDrive + S_FILENAME;
  AssignFile(F, sFile);


  if FileExists(sFile) then
    Append(F)
  else
    Rewrite(F);

  WriteLn(F, '  ');
  WriteLn(F, 'CCList deleted ');
  WriteLn(F, '=========================');
  WriteLn(F, 'Date/Time:         ' + FormatDateTime('c', Now));
  WriteLn(F, 'CCList Code  ' + ACCListCode );
  WriteLn(F, 'CCList Desc  ' + ACCListDesc );
  WriteLn(F, 'Workstation:       ' + WinGetComputerName);
  WriteLn(F, 'Windows User ID:   ' + WinGetUserName);
  WriteLn(F, 'Exchequer User ID: ' + EntryRec.LogIn);
  WriteLn(F, '  ');

  CloseFile(F);
end;

//=========================================================================

Function AuthoriseCCListChange(Const ACCListCode, ACCListDesc : String) : Boolean;
Begin // AuthoriseCCListChange
  Result := False;

  With TfrmGenericWarning.Create(nil) Do
  begin
    Try
      CLMsgL.Caption := 'Deleting CC and Dept Codes';
      Label2.Caption  := 'You are attempting to delete a Cost Centre or Department Code. ' +
                'Please check that there are no transactions or records using ' +
                'this code as this may impact any future reports. Only delete ' +
                'the code if you are sure that this CC or Dept code has not been ' +
                'used and is no longer required.' ;
      Label3.Caption := 'If you are certain that you need to delete ' +
                'this code then you must enter the Daily ' +
                'Password to continue.' ;
      ActiveControl := edtPassword;
      ShowModal;
      Result := ModalResult = mrOK;
      if Result then
        WriteCCListChangeLogFile(ACCListCode, ACCListDesc);
    Finally
      Free;
    End;
  end;
End; // AuthoriseCCListChange

//-------------------------------------------------------------------------

procedure TfrmGenericWarning.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOK then
  begin
    CanClose := edtPassWord.Text = Get_TodaySecurity; //This checks Daily Password
    if not CanClose then
    begin
      ShowMessage('Invalid Password');
      ActiveControl := edtPassword;
    end;
  end;
end;

procedure TfrmGenericWarning.FormShow(Sender: TObject);
Var
  BMap1       :  TBitMap;
  RectD       :  TRect;
begin
  If Not NoXLogo then
  Begin
    BMap1:=TBitMap.Create;

    BMap1.Handle:=LoadBitMap(HInstance,'EXCLAM_2');

    With BMap1 do
      RectD:=Rect(0,0,Width,Height);


    With Image1.Picture.Bitmap do
    Begin
      Width:=BMap1.Width;
      Height:=BMap1.Height;

      Canvas.Brush.Color:=clBtnFace;
      Canvas.BrushCopy(RectD,BMap1,RectD,clSilver);
    end;

    BMap1.Free;
  end;{If..}

end;

procedure TfrmGenericWarning.edtPasswordChange(Sender: TObject);
begin
  btnOK.Enabled := Trim(edtPassword.Text) <> '';
end;

end.
