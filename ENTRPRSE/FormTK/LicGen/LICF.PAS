unit LicF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mask, ComCtrls, Menus, oFTKLic;

type
  TForm1 = class(TForm)
    edtLicenceeProduct: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    mskShortDesc: TMaskEdit;
    btnCalcLicenceStrings: TButton;
    Bevel1: TBevel;
    edtProductName: TEdit;
    Label3: TLabel;
    edtLicenceNo: TEdit;
    Label4: TLabel;
    dtpExpiry: TDateTimePicker;
    Label5: TLabel;
    chkInfiniteLicence: TCheckBox;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Bevel2: TBevel;
    chkDemo: TCheckBox;
    btnTestLicence: TButton;
    ListBox1: TListBox;
    procedure btnCalcLicenceStringsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnTestLicenceClick(Sender: TObject);
  private
    { Private declarations }
    oFTKLic : TFormsTKLicence;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//------------------------------------------------------------------------

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;

  dtpExpiry.Date := Now + 1;

  oFTKLic := TFormsTKLicence.Create;
end;

//-----------------------------------

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(oFTKLic);
end;

//------------------------------------------------------------------------

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

//-----------------------------------

procedure TForm1.About1Click(Sender: TObject);
begin
  MessageDlg('Forms Toolkit Licencing Utility'#13#10'Build 501.001',
             mtInformation, [mbOK], 0);
end;

//------------------------------------------------------------------------

procedure TForm1.btnCalcLicenceStringsClick(Sender: TObject);
Var
  OK : Boolean;
begin
  // Product Name must be set
  OK := (Trim(edtLicenceeProduct.Text) <> '');
  If OK Then
    oFTKLic.ProductName := edtLicenceeProduct.Text
  Else Begin
    ShowMessage ('The Product Name must be set');
    If edtLicenceeProduct.CanFocus Then edtLicenceeProduct.SetFocus;
  End; { If (Not OK) }

  If OK Then Begin
    // Short Desc must be set
    OK := (Trim(mskShortDesc.Text) <> '');
    If OK Then
      oFTKLic.ProductShortDesc := mskShortDesc.Text
    Else Begin
      ShowMessage ('The Short Description must be set');
      If mskShortDesc.CanFocus Then mskShortDesc.SetFocus;
    End; { Else }
  End; { If OK }

  If OK Then Begin
    // Expiry Date must be set > today
    OK := (dtpExpiry.Date > Now);
    If OK Then
      oFTKLic.ExpiryDate := dtpExpiry.Date
    Else Begin
      ShowMessage ('The Expiry Date must be set > today');
      If dtpExpiry.CanFocus Then dtpExpiry.SetFocus;
    End; { Else }
  End; { If OK }

  If OK Then Begin
    oFTKLic.ExpiryDate := dtpExpiry.Date;
    oFTKLic.LicenceFlags[FlgIdxPerpetualLicence] := chkInfiniteLicence.Checked;
    oFTKLic.LicenceFlags[FlgIdxDemoLicence] := chkDemo.Checked;

    // Product Name
    edtProductName.Text := edtLicenceeProduct.Text;

    // Licence No
    edtLicenceNo.Text := oFTKLic.LicenceNo;
  End; { If OK }
end;

procedure TForm1.btnTestLicenceClick(Sender: TObject);
Var
  I : Byte;
begin
  // Decode
  With TFormsTKLicence.Create Do
    Try
      // Set ProductName and LicenceNo - exception will be raised if there is a problem
      ProductName := edtProductName.Text;
      LicenceNo := edtLicenceNo.Text;

      // Copy details into Memo
      With ListBox1.Items Do Begin
        Clear;

        Add ('ProductName' + #9 + ProductName);
        Add ('LicenceNo' + #9 + LicenceNo);
        Add ('');
        Add ('Version' + #9 + IntToStr(Version));
        Add ('ShortDesc' + #9 + ProductShortDesc);
        Add ('Expiry Date' + #9 + FormatDateTime ('DD/MM/YYYY', ExpiryDate));
        Add ('');
        Add ('Flags:-');
        For I := 1 To 20 Do
          Case I Of
            FlgIdxPerpetualLicence : Add ('  NeverExpires' + #9 + IntToStr(Ord(LicenceFlags[I])));
            FlgIdxDemoLicence      : Add ('  Demo' + #9 + IntToStr(Ord(LicenceFlags[I])));
          Else
            Add ('  Spare' + IntToStr(I) + #9 + IntToStr(Ord(LicenceFlags[I])));
          End; { Case }
      End; { With memDecode.Lines }
    Finally
      Free;
    End;
end;

end.
