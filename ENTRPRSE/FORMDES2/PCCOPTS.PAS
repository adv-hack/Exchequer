unit PCCOpts;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, GlobVar, VarConst, GlobType, RpDevice, PrintU, ComCtrls;

type
  TForm_PCCOpts = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    UpDown1: TUpDown;
    Edit3: TEdit;
    UpDown2: TUpDown;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label4: TLabel;
    Edit4: TEdit;
    CheckBox3: TCheckBox;
    Edit1: TComboBox;
    Label5: TLabel;
    ComboBox1: TComboBox;
    CheckBox4: TCheckBox;
    Label6: TLabel;
    Edit5: TEdit;
    UpDown3: TUpDown;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

Uses TestU;

procedure TForm_PCCOpts.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

{ Validate Info & Print }
procedure TForm_PCCOpts.Button1Click(Sender: TObject);
Const
  LabelKeys : Array [1..29] Of ShortString = ('A1HI01', 'ABSC01',
                                              'ACCO01', 'AMBE01',
                                              'BAXT01', 'BSIQ01',
                                              'CASH01', 'DIRE01',
                                              'DIRE02', 'FABU01',
                                              'FAIR01', 'GAIN01',
                                              'GRIG01', 'HACK01',
                                              'HALL01', 'KEY01 ',
                                              'LANW01', 'MACD01',
                                              'MARI01', 'NATI01',
                                              'NAYL01', 'OAKL01',
                                              'ONLI01', 'PCM001',
                                              'POCK01', 'QUAD01',
                                              'SHAN01', 'TRAD01',
                                              'UNIC01');


Var
  PrBatch         : PrintBatchRecType;
  DevInfo         : TSBSPrintSetupInfo;
  LI              : LongInt;
  Lbl1,
  I, Invs, Copies : SmallInt;
  ErrCode         : Integer;
  LblIdx          : Byte;
begin
  { Check form name }
  if FileExists (BasePath + 'Forms\' + Trim(Edit1.Text) + '.DEF') or
{$IFDEF EX600}
     FileExists (BasePath + 'Forms\' + Trim(Edit1.Text) + '.EFX') or
{$ENDIF}
     FileExists (BasePath + 'Forms\' + Trim(Edit1.Text) + '.EFD') then
  begin
    { Check number of invoices to print }
    Val(Edit3.Text, Invs, ErrCode);

    If (ErrCode = 0) And (Invs In [1..100]) Then Begin
      { Check number of invoices to print }
      Val(Edit2.Text, Copies, ErrCode);

      If (ErrCode = 0) And (Copies In [1..100]) Then Begin
        { Clear any existing items out of batch }
        If PrintBatch_ClearBatch Then ;

        LblIdx := Low(LabelKeys);
        For I := 1 To Invs Do
          If (Not CheckBox3.Checked) Then Begin
            { Form - Add batch entries }
            Case ComboBox1.ItemIndex Of
              { Customer Statement }
              0 : With PrBatch Do Begin
                    pbDefMode   := 3;
                    pbEFDName   := Trim(Copy(Edit1.Text,1,8));
                    pbMainFNum  := 1;
                    pbMainKPath := 0;
                    pbMainKRef  := 'A1HI01';
                    pbTablFNum  := 2;
                    pbTablKPath := 1;
                    pbTablKRef  := 'A1HI01C';
                    pbLabel1    := 0;
                    pbLbCopies  := 1;
                    pbTestMode  := CheckBox2.Checked;
                  End;
              { Trading History }
              1 : With PrBatch Do Begin
                    pbDefMode   := 5;
                    pbEFDName   := Trim(Copy(Edit1.Text,1,8));
                    pbMainFNum  := 1;
                    pbMainKPath := 0;
                    pbMainKRef  := 'A1HI01';
                    pbTablFNum  := 2;
                    pbTablKPath := 1;
                    pbTablKRef  := 'A1HI01C';
                    pbLabel1    := 0;
                    pbLbCopies  := 1;
                    pbTestMode  := CheckBox2.Checked;
                  End;
              { Invoice }
              2 : With PrBatch Do Begin
                    pbDefMode   := 1;          { Invoice }
                    pbEFDName   := Trim(Copy(Edit1.Text,1,8));
                    pbMainFNum  := 2;          { InvF }
                    pbMainKPath := 2;          { Our Ref }
                    pbMainKRef  := 'SIN000294';
                    pbTablFNum  := 3;          { IDetailF }
                    pbTablKPath := 0;          { Folio }
                    pbTablKRef  := '****';
                    LI := 1066;            { folio number }
                    Move (LI, pbTablKRef[1], 4);
                    pbLabel1    := 0;
                    pbLbCopies  := 1;
                    pbTestMode  := CheckBox2.Checked;
                  End;
              { Stock Adjustment }
              3 : With PrBatch Do Begin
                    pbDefMode   := 12;
                    pbEFDName   := Trim(Copy(Edit1.Text,1,8));
                    pbMainFNum  := 2;          { InvF }
                    pbMainKPath := 2;          { Our Ref }
                    pbMainKRef  := 'ADJ000058';
                    pbTablFNum  := 3;          { IDetailF }
                    pbTablKPath := 0;          { Folio }
                    pbTablKRef  := '****';
                    LI := -2147482565;            { folio number }
                    Move (LI, pbTablKRef[1], 4);
                    pbLabel1    := 0;
                    pbLbCopies  := 1;
                    pbTestMode  := CheckBox2.Checked;
                  End;
              { SIN + Backing Sheet }
              4 : Begin
                    With PrBatch Do Begin
                      pbDefMode   := 1;
                      pbEFDName   := 'SIN_SBS';
                      pbMainFNum  := 2;          { InvF }
                      pbMainKPath := 2;          { Our Ref }
                      pbMainKRef  := 'SIN000279';
                      pbTablFNum  := 3;          { IDetailF }
                      pbTablKPath := 0;          { Folio }
                      pbTablKRef  := #57#4#0#0;
                      pbLabel1    := 0;
                      pbLbCopies  := 1;
                      pbTestMode  := CheckBox2.Checked;
                    End;
                    PrintBatch_AddJob (PrBatch);

                    With PrBatch Do Begin
                      pbDefMode   := 24;
                      pbEFDName   := 'JBACKSHT';
                      pbMainFNum  := 2;          { InvF }
                      pbMainKPath := 2;          { Our Ref }
                      pbMainKRef  := 'SIN000279';
                      pbTablFNum  := 12;         { IDetailF }
                      pbTablKPath := 0;          { Folio }
                      pbTablKRef  := 'JECAM-PLOT 2'#1;
                      pbLabel1    := 0;
                      pbLbCopies  := 1;
                      pbTestMode  := CheckBox2.Checked;
                    End;
                  End; { With }
              { Delivery Labels }
              5 : With PrBatch Do Begin
                    pbDefMode   := 26;
                    pbEFDName   := 'DELB_SBS';
                    pbMainFNum  := 2;          { InvF }
                    pbMainKPath := 2;          { Our Ref }
                    pbMainKRef  := 'SDN000062';
                    pbTablFNum  := 3;         { IDetailF }
                    pbTablKPath := 0;          { Folio }
                    pbTablKRef  := '';
                    pbLabel1    := 2;
                    pbLbCopies  := 3;
                    pbTestMode  := CheckBox2.Checked;
                  End;
              { Sales Order }
              6 : With PrBatch Do Begin
                    pbDefMode   := 1;          { Invoice }
                    pbEFDName   := Trim(Copy(Edit1.Text,1,8));
                    pbMainFNum  := 2;          { InvF }
                    pbMainKPath := 2;          { Our Ref }
                    pbMainKRef  := 'SOR000126';
                    pbTablFNum  := 3;          { IDetailF }
                    pbTablKPath := 0;          { Folio }
                    pbTablKRef  := '****';
                    LI := -2147482589;            { folio number }
                    Move (LI, pbTablKRef[1], 4);
                    pbLabel1    := 0;
                    pbLbCopies  := 1;
                    pbTestMode  := CheckBox2.Checked;
                  End;  
            End; { Case }
            PrintBatch_AddJob (PrBatch);
          End { If }
          Else Begin
            { Labels (Customer) - Add batch entries }
            With PrBatch Do Begin
              pbDefMode   := 26;          { Invoice }
              pbEFDName   := Trim(Copy(Edit1.Text,1,8));
              pbMainFNum  := 1;          { CustF }
              pbMainKPath := 0;          { Code }
              pbMainKRef  := LabelKeys[LblIdx];
              pbTablFNum  := 8;          { IDetailF }
              pbTablKPath := 0;          { Folio }
              pbTablKRef  := 'ÿ';
              pbLabel1    := 1;
              pbLbCopies  := 1;
              pbTestMode  := CheckBox2.Checked;
            End; { With }
            PrintBatch_AddJob (PrBatch);

            Inc (LblIdx);
            If (LblIdx > High(LabelKeys)) Then
              LblIdx := Low(LabelKeys);
          End; { Else }

        { Print }
        DevInfo := RPDev.SBSSetupInfo;
        With DevInfo Do Begin
          LabelMode := True;
          NoCopies := Copies;

          Val(Edit5.Text, Lbl1, ErrCode);
          If (ErrCode = 0) And (Lbl1 In [1..10]) Then
            pbLabel1 := Lbl1
          Else
            pbLabel1 := 1;
          Preview := CheckBox1.Checked;
          TestMode := CheckBox2.Checked;
          ChequeMode := CheckBox4.Checked;
        End; { With }
        PrintBatch_Print (Edit4.Text, DevInfo);

        Close;
      End { If }
      Else
        ShowMessage ('Invalid Number of Copies');
    End { If }
    Else
      ShowMessage ('Invalid Number of Invoices');
  End { If }
  Else
    ShowMessage ('Invalid Invoice Name');
end;

procedure TForm_PCCOpts.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm_PCCOpts.FormCreate(Sender: TObject);
begin
  ClientHeight := 247;
  ClientWidth := 210;

  ComboBox1.ItemIndex := 1;
end;

end.
