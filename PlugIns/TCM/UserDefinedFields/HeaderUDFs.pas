unit HeaderUDFs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  CustABSU, Dialogs, StdCtrls, IAeverButton, UDefProc, EnterpriseTrade_TLB,
  ExtCtrls;

const
  WM_MyExitRtn = WM_USER + 1001;

type
  TfrmHeaderUDFs = class(TForm)
    edUserDef1: TEdit;
    edUserDef2: TEdit;
    edUserDef3: TEdit;
    btnOK: TIAeverButton;
    btnCancel: TIAeverButton;
    lUser1: TLabel;
    lUser2: TLabel;
    lUser3: TLabel;
    shSeparator: TShape;
    procedure edUserDefExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    sText, sFieldName : string;
    bStatus : boolean;
    WinPos : TWinPos;
    TXType : cuDocTypes;
    bIgnoreExits : boolean;
  public
    oBaseData: ITradeConnectionPoint;
    oEventData: ITradeEventData;
    _ExecuteTXPlugIn : TExecuteTXPlugIn;
    Procedure WMMyExitRtn(Var msg:TMessage); message WM_MyExitRtn;
  end;

var
  frmHeaderUDFs: TfrmHeaderUDFs;

implementation

uses
  JPeg, oClient, APIUtil, GfxUtil, UserKey;

{$R *.dfm}

procedure TfrmHeaderUDFs.edUserDefExit(Sender: TObject);
begin
  if not bIgnoreExits then PostMessage(Handle,WM_MyExitRtn,TWinControl(Sender).Tag,LongInt(Sender));
end;

procedure TfrmHeaderUDFs.FormShow(Sender: TObject);

  function HowManyAreVisible(Field1Visible, Field2Visible, Field3Visible, Field4Visible : boolean) : byte;
  begin
    Result := Ord(Field1Visible) + Ord(Field2Visible) + Ord(Field3Visible) + Ord(Field4Visible);
  end;

begin
  With WinPos do begin
    wpHeight := Height;
    wpLeft := Left;
    wpTop := Top;
    wpWidth := Width;
  end;{if}

  with oBaseData.SystemSetup do begin
    if (oEventData.Transaction.thNetValue < 0)
    or (ssTradeCounter.ssTill[ssTradeCounter.ssCurrentTillNo].ssCreateTransType = ctSINSRI) then
      begin
        TXType := cuSIN;
        lUser1.Caption := ssEnterprise.ssUserFields.ufSINDesc[1];
        lUser2.Caption := ssEnterprise.ssUserFields.ufSINDesc[2];
        lUser3.Caption := ssEnterprise.ssUserFields.ufSINDesc[3];
        edUserDef1.Visible := ssEnterprise.ssUserFields.ufSINEnabled[1];
        edUserDef2.Visible := ssEnterprise.ssUserFields.ufSINEnabled[2];
        edUserDef3.Visible := ssEnterprise.ssUserFields.ufSINEnabled[3];
      end
    else begin
      TXType := cuSOR;
      lUser1.Caption := ssEnterprise.ssUserFields.ufSORDesc[1];
      lUser2.Caption := ssEnterprise.ssUserFields.ufSORDesc[2];
      lUser3.Caption := ssEnterprise.ssUserFields.ufSORDesc[3];
      edUserDef1.Visible := ssEnterprise.ssUserFields.ufSOREnabled[1];
      edUserDef2.Visible := ssEnterprise.ssUserFields.ufSOREnabled[2];
      edUserDef3.Visible := ssEnterprise.ssUserFields.ufSOREnabled[3];
    end;{if}

    lUser1.Visible := edUserDef1.Visible;
    lUser2.Visible := edUserDef2.Visible;
    lUser3.Visible := edUserDef3.Visible;

    edUserDef2.Top := 8 + (32 * HowManyAreVisible(edUserDef1.Visible, FALSE, FALSE, FALSE));
    edUserDef3.Top := 8 + (32 * HowManyAreVisible(edUserDef1.Visible, edUserDef2.Visible, FALSE, FALSE));

    lUser2.Top := edUserDef2.Top + 4;
    lUser3.Top := edUserDef3.Top + 4;

    ClientHeight := 56 + (32 * HowManyAreVisible(edUserDef1.Visible, edUserDef2.Visible
    , edUserDef3.Visible, FALSE));
    btnOK.Top := ClientHeight - 40;
    btnCancel.Top := btnOK.Top;

    shSeparator.Height := (32 * HowManyAreVisible(edUserDef1.Visible
    , edUserDef2.Visible, edUserDef3.Visible, FALSE)) - 12;

    if edUserDef3.Visible then ActiveControl := edUserDef3;
    if edUserDef2.Visible then ActiveControl := edUserDef2;
    if edUserDef1.Visible then ActiveControl := edUserDef1;

(*    if edUserDef1.Visible then
      begin
        ActiveControl := edUserDef1;
        if edUserDef2.Visible then
          begin
            if not edUserDef3.Visible then begin
              // 1=Y / 2=Y / 3=N
              Height := 180 - 32;
            end;{if}
          end
        else begin
          if edUserDef3.Visible then
            begin
              // 1=Y / 2=N / 3=Y
              edUserDef3.Top := edUserDef2.Top;
              lUser3.Top := lUser2.Top;
              Height := 180 - 32;
            end
          else begin
            // 1=Y / 2=N / 3=N
            Height := 180 - 64;
          end;{if}
        end;{if}
      end
    else begin
      if edUserDef2.Visible then
        begin
          ActiveControl := edUserDef2;
          edUserDef2.Top := edUserDef1.Top;
          lUser2.Top := lUser1.Top;
          if edUserDef3.Visible then
            begin
              // 1=N / 2=Y / 3=Y
              edUserDef3.Top := edUserDef2.Top;
              lUser3.Top := lUser2.Top;
              Height := 180 - 32;
            end
          else begin
            // 1=N / 2=Y / 3=N
            Height := 180 - 64;
          end;{if}
        end
      else begin
        if edUserDef3.Visible then
          begin
            // 1=N / 2=N / 3=Y
            ActiveControl := edUserDef3;
            edUserDef3.Top := edUserDef1.Top;
            lUser3.Top := lUser1.Top;
            Height := 180 - 64;
          end
        else begin
          // 1=N / 2=N / 3=N
          MsgBox('There are no user defined fields enabled for use for the current transaction type.'
          ,mtInformation,[mbOK],mbOK,'No Fields Available');
          PostMessage(Self.Handle,WM_Close,0,0);// Close Window
          Exit;
        end;{if}
      end;{if}
    end;{if}*)


  end;{with}
  bIgnoreExits := FALSE;
end;


procedure TfrmHeaderUDFs.WMMyExitRtn(var msg:TMessage);
begin
  bIgnoreExits := TRUE;
  if ActiveControl <> btnCancel then begin

    with oBaseData.SystemSetup, ssTradeCounter do begin

      case msg.WParam of
        1 : begin
          sText := edUserDef1.Text;
          sFieldName := lUser1.Caption;
          edUserDef1.Text := _ExecuteTXPlugIn(TXType, 'Head', 1, sText, sFieldName
          , ssTill[ssCurrentTillNo].ssCompany.coPath
          , oBaseData.UserProfile.upUserID, bStatus, WinPos, nil , FALSE, FALSE);
          if not bStatus then ActiveControl := edUserDef1;
        end;

        2 : begin
          sText := edUserDef2.Text;
          sFieldName := lUser2.Caption;
          edUserDef2.Text := _ExecuteTXPlugIn(TXType, 'Head', 2, sText, sFieldName
          , ssTill[ssCurrentTillNo].ssCompany.coPath
          , oBaseData.UserProfile.upUserID, bStatus, WinPos, nil , FALSE, FALSE);
          if not bStatus then ActiveControl := edUserDef2;
        end;

        3 : begin
          sText := edUserDef3.Text;
          sFieldName := lUser3.Caption;
          edUserDef3.Text := _ExecuteTXPlugIn(TXType, 'Head', 3, sText, sFieldName
          , ssTill[ssCurrentTillNo].ssCompany.coPath
          , oBaseData.UserProfile.upUserID, bStatus, WinPos, nil , FALSE, FALSE);
          if not bStatus then ActiveControl := edUserDef3;
        end;
      end;{case}
    end;{with}
  end;{if}
  bIgnoreExits := FALSE;
end;

procedure TfrmHeaderUDFs.FormCreate(Sender: TObject);
var
  TmpJPEG : TJPEGImage;
  bitFormBackground : TBitmap;
begin
  bIgnoreExits := TRUE;
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

procedure TfrmHeaderUDFs.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  if (Key <> VK_CONTROL) then begin
    UserKey.GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
    LocalKey := Key;
    Key := 0;
    {Trap function keys}
    If (LocalKey = VK_F9) and (Not (ssAlt In Shift)) then ModalResult := mrOK
    else Key := LocalKey;
  end;{if}
end;

end.
