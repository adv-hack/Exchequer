unit CustDet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, Enterprise01_TLB, EnterpriseTrade_TLB, StdCtrls, IAeverButton
  , COMObj, ExtCtrls, CTKUtil, APIUtil, UserKey, StrUtil, UAFDCODE, SecCodes;

type
  TfrmAddCust = class(TForm)
    lUser1: TLabel;
    lUser2: TLabel;
    lUser3: TLabel;
    Shape1: TShape;
    edName: TEdit;
    edAddress1: TEdit;
    edPhoneNo: TEdit;
    btnOK: TIAeverButton;
    btnCancel: TIAeverButton;
    edAddress2: TEdit;
    edAddress3: TEdit;
    edAddress4: TEdit;
    edAddress5: TEdit;
    edAccountCode: TEdit;
    Label1: TLabel;
    edPostcode: TEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edNameExit(Sender: TObject);
    procedure edPostcodeExit(Sender: TObject);
    procedure edAccountCodeExit(Sender: TObject);
  private
    oToolkit : IToolkit;
    Function Auto_GetCompCode(CompName : ShortString) : ShortString;
  public
    oBaseData : ITradeConnectionPoint;
    oEventData : ITradeEventData
  end;

var
  frmAddCust: TfrmAddCust;

implementation
uses
  GfxUtil, JPeg;

{$R *.dfm}
{$R EXCHBACK.RES}

procedure TfrmAddCust.FormCreate(Sender: TObject);
var
  TmpJPEG : TJPEGImage;
  bitFormBackground : TBitmap;
begin
  if ColorMode(canvas) in [cm64Bit, cm32Bit, cm24Bit, cm16Bit] then begin
    {Load Background JPEG}
    TmpJPEG := TJPEGImage.Create;
    bitFormBackground := TBitmap.create;
    if LoadJPEGFromRes('FORMBAK2', TmpJPEG) then begin
      bitFormBackground.Assign(TmpJPEG);
      DrawFormBackground(self, bitFormBackground);
    end;{if}
    TmpJPEG.Free;
    bitFormBackground.Free;
  end;{if}
end;

procedure TfrmAddCust.FormDestroy(Sender: TObject);
begin
  If Assigned(oToolkit) Then Begin
    oToolkit.CloseToolkit;
    oToolkit := NIL;
  End; { If Assigned(oToolkit) }
end;

procedure TfrmAddCust.FormShow(Sender: TObject);

  procedure InitToolkit;
  var
    FuncRes : integer;
    Code1, Code2, Code3: longint;
  begin{InitToolkit}
    // Create COM Toolkit object
    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;

    // Check it created OK
    If Assigned(oToolkit) Then Begin

      With oToolkit Do Begin
        // Backdoor
        EncodeOpCode(97, Code1, Code2, Code3);
        Configuration.SetDebugMode(Code1, Code2, Code3);

        // Open Default Company

        oToolkit.Configuration.DataDirectory := oBaseData.SystemSetup.ssTradeCounter.ssTill[oBaseData.SystemSetup.ssTradeCounter.ssCurrentTillNo].ssCompany.coPath;
        FuncRes := OpenToolkit;

        // Check it opened OK
        If (FuncRes <> 0) Then
          // Error opening Toolkit - display error
          ShowMessage ('The following error occured opening the Toolkit:-'#13#13 +
                       QuotedStr(oToolkit.LastErrorString));
      End; { With OToolkit }
    End { If Assigned(oToolkit) }
    Else
      // Failed to create COM Object
      ShowMessage ('Cannot create COM Toolkit instance');
  end;{InitToolkit}

begin
  InitToolkit;
end;

procedure TfrmAddCust.btnOKClick(Sender: TObject);
var
  iResult : integer;
begin
  if Trim(edAccountCode.Text) = '' then begin
    MsgBox('You need to specify an Account Code for your new Customer.'
    ,mtError,[mbOK],mbOK,'Account Code Error');
    ActiveControl := edAccountCode;
    Exit;
  end;{if}

  with oToolkit.Customer.Add do begin
    acCode := edAccountCode.Text;
    acCompany := edName.Text;
    acAddress[1] := edAddress1.Text;
    acAddress[2] := edAddress2.Text;
    acAddress[3] := edAddress3.Text;
    acAddress[4] := edAddress4.Text;
    acAddress[5] := edAddress5.Text;
    acPostCode := edPostcode.Text;
    acPhone := edPhoneNo.Text;
    iResult := Save;
    if iResult <> 0 then begin
      MsgBox('The following error occured whilst saving your new customer :'#13#13
      + QuotedStr(oToolkit.LastErrorString),mtError,[mbOK],mbOK,'Customer.Save Error');
    end;{if}
  end;{with}
  ModalResult := mrOK
end;

procedure TfrmAddCust.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  if (Key <> VK_CONTROL) then begin
    UserKey.GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
    LocalKey := Key;
    Key := 0;
    {Trap function keys}
    If (LocalKey = VK_F9) and (Not (ssAlt In Shift)) then btnOKClick(btnOK)
    else Key := LocalKey;
  end;{if}
end;

Function TfrmAddCust.Auto_GetCompCode(CompName : ShortString) : ShortString;
//  Const
//    FNum    = CompF;
//    KeyPath : Integer = CompCodeK;
Var
//    KeyS       : Str255;
  sCode       : string;
//    TmpComp    : CompRec;
  TmpStat, Stat : Integer;
  TmpRecAddr : LongInt;
  iChar, n : Byte;
Begin
//    TmpComp:=Company^;
//    TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],TmpRecAddr,BOff,BOff);

  For iChar := 0 to 32 do CompName := RemoveAllChars(CompName, Chr(iChar));

  CompName := Copy (UpperCase (CompName), 1, 4);
  n:=1;

  Repeat
//      KeyS := FullCompCodeKey(cmCompDet, CompName + SetPadNo(IntToStr(n), 2));
//      Stat:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    sCode := CompName + PadString(psLeft,IntToStr(n),'0',2);
    Stat := oToolkit.Customer.GetEqual(oToolkit.Customer.BuildCodeIndex(sCode));

    If (Stat = 0) then
      Inc(n);
  Until (Stat <> 0) or (n=99);

//    TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],TmpRecAddr,BOn,BOff);

//    Company^ := TmpComp;

//  Result:=Copy (KeyS, 2, 6);
  Result := sCode;
end; {Func..}


procedure TfrmAddCust.edNameExit(Sender: TObject);
begin
  edAccountCode.Text := Auto_GetCompCode(edName.Text);
end;

procedure TfrmAddCust.edPostcodeExit(Sender: TObject);
var
  Details : TDetailRec;
begin
  with TAFDPostcode.Create, Details do begin
    Details.drPostCode := edPostcode.Text;
    try
      if DoPostcode(Details) then begin
        edAddress1.Text := drStreet;
        edAddress2.Text := drLocality;
        edAddress3.Text := drTown;
        edAddress4.Text := drCounty;
        edAddress5.Text := drPostCode;
        edPostCode.Text := drPostCode;
        edPhoneNo.Text := drSTD;
      end;{if}
    except
      Free;
    end;
  end;{with}
end;

procedure TfrmAddCust.edAccountCodeExit(Sender: TObject);
var
  sNewCode : string;

  Function CompanyExists(sCode : ShortString) : boolean;
  Begin
    Result := oToolkit.Customer.GetEqual(oToolkit.Customer.BuildCodeIndex(sCode)) = 0;
  end; {Func..}

begin
  edAccountCode.Text := Trim(edAccountCode.Text);
  if CompanyExists(edAccountCode.Text)
  then edAccountCode.Text := Auto_GetCompCode(edAccountCode.Text);
end;

end.
