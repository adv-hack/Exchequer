unit pccdeflt;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  bkgroup, StdCtrls, TEditVal;

type
  TForm_PCCDefaults = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Label81: Label8;
    Label4: TLabel;
    Label5: TLabel;
    List_Bins: TListBox;
    List_Papers: TListBox;
    List_Printers: TListBox;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure List_PrintersClick(Sender: TObject);
    procedure List_BinsClick(Sender: TObject);
    procedure List_PapersClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    OK : Boolean;
  end;

Procedure PCCDefaulDlg; Export;

implementation

{$R *.DFM}

Uses RpDevice, PrnCodes;

Procedure PCCDefaulDlg;
var
  Form_PCCDefaults : TForm_PCCDefaults;
  PrnStr           : ShortString;
  PrnNo, I         : SmallInt;
  BinNo, PaperNo   : LongInt;
Begin
  Form_PCCDefaults := TForm_PCCDefaults.Create(Application.MainForm);
  Try
    With Form_PCCDefaults Do Begin
      { Load Defaults }
      GetDefPCCInfo (PrnStr, PrnNo, BinNo, PaperNo);

      If (PrnNo In [0..Pred(RpDev.Printers.Count)]) Then Begin
        List_Printers.ItemIndex := PrnNo;
        List_PrintersClick(Application);
      End; { If }

      If (List_Printers.ItemIndex >= 0) Then Begin
        { Bin }
        If (List_Bins.Items.Count > 0) Then
          For I := 0 To Pred (List_Bins.Items.Count) Do
            If (BinNo = LongInt(List_Bins.Items.Objects[I])) Then
              List_Bins.ItemIndex := I;


        { Paper }
        If (List_Papers.Items.Count > 0) Then
          For I := 0 To Pred (List_Papers.Items.Count) Do
            If (PaperNo = LongInt(List_Papers.Items.Objects[I])) Then
              List_Papers.ItemIndex := I;
      End; { If }
    End; { With }

    Form_PCCDefaults.ShowModal;

    If Form_PCCDefaults.Ok Then
      With Form_PCCDefaults Do Begin
        { Save new defaults }
        PrnStr := List_Printers.Items.Strings[List_Printers.ItemIndex];
        BinNo := LongInt(List_Bins.Items.Objects[List_Bins.ItemIndex]);
        PaperNo := LongInt(List_Papers.Items.Objects[List_Papers.ItemIndex]);

        WriteDefPCCInfo (PrnStr, BinNo, PaperNo);
      End; { With }
  Finally
    Form_PCCDefaults.Free;
  End;
End;

{-----------------------------------------------------------------------------}

procedure TForm_PCCDefaults.FormCreate(Sender: TObject);
Var
  I : SmallInt;
begin
  OK := False;

  { Load Printers }
  List_Printers.Clear;
  If (RpDev.Printers.Count > 0) Then Begin
    For I := 0 To Pred(RpDev.Printers.Count) Do
      List_Printers.Items.Add (RpDev.Printers[I]);
  End { If }
  Else
    List_Printers.Items.Add ('No Printers Defined');

  { Display Active Printer }
  If (RpDev.DeviceIndex <= Pred(List_Printers.Items.Count)) Then
    List_Printers.ItemIndex := RpDev.DeviceIndex
  Else
    MessageDlg ('Active printer doesn''t exist', mtError, [mbOk], 0);
end;


procedure TForm_PCCDefaults.btnOKClick(Sender: TObject);
begin
  If (List_Printers.ItemIndex >= 0) Then Begin
    If (List_Bins.ItemIndex >= 0) Then Begin
      If (List_Papers.ItemIndex >= 0) Then Begin
        Ok := True;
        Close;
      End { If }
      Else
        MessageDlg ('The Default Paper must be set', mtWarning, [mbOk], 0);
    End { If }
    Else
      MessageDlg ('The Default Bin must be set', mtWarning, [mbOk], 0);
  End { If }
  Else
    MessageDlg ('The Default Printer must be set', mtWarning, [mbOk], 0);
end;

procedure TForm_PCCDefaults.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_PCCDefaults.List_PrintersClick(Sender: TObject);
Var
  I       : SmallInt;
  BinNo   : Integer;       { Windows Bin Id }
  BinName : String;        { Windows Bin Description }
begin
  { Printer Selected - Load Bins and Forms }
  If (List_Printers.ItemIndex >= 0) Then Begin
    Try
      { Set Active Printer }
      RpDev.DeviceIndex := List_Printers.ItemIndex;

      { Load Bins }
      List_Bins.Clear;
      If (RpDev.Bins.Count > 0) Then Begin
        For I := 0 To Pred(RpDev.Bins.Count) Do Begin
          List_Bins.Items.AddObject (RpDev.Bins[I], RpDev.Bins.Objects[I]);

          { Select Current Bin }
          If (LongInt(RpDev.Bins.Objects[I]) = RpDev.DevMode.dmDefaultSource) Then
            List_Bins.ItemIndex := I;
        End; { If }
      End { If }
      Else
        List_Bins.Items.Add ('No Bins Defined');

      { Load Forms }
      List_Papers.Clear;
      If (RpDev.Papers.Count > 0) Then Begin
        For I := 0 To Pred(RpDev.Papers.Count) Do Begin
          List_Papers.Items.AddObject (RpDev.Papers[I], RpDev.Papers.Objects[I]);

          { Select Current Paper }
          If (LongInt(RpDev.Papers.Objects[I]) = RpDev.DevMode.dmPaperSize) Then
            List_Papers.ItemIndex := I;
        End; { For }
      End { If }
      Else
        List_Papers.Items.Add ('No Bins Defined');
    Except
      On Ex:Exception Do
        MessageDlg ('The following error occured setting the active printer:' +
                          #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                          'Please notify Technical Support', mtError, [mbOk], 0);
    End;
  End; { If }
end;

procedure TForm_PCCDefaults.List_BinsClick(Sender: TObject);
Var
  Section : Byte;
begin
  If (List_Bins.ItemIndex >= 0) Then
    Try
      { Set Default Bin }
      Section := 1;
      RPDev.DevMode.dmDefaultSource := LongInt(List_Bins.Items.Objects[List_Bins.ItemIndex]);
    Except
      On Ex:Exception Do
        Case Section Of
          1 : MessageDlg ('The following error occured setting the default bin:' +
                          #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                          'Please notify Technical Support', mtError, [mbOk], 0);
        End; { Case }
    End;
end;

procedure TForm_PCCDefaults.List_PapersClick(Sender: TObject);
begin
  If (List_Papers.ItemIndex >= 0) Then
    Try
      { Set Default Paper }
      RPDev.DevMode.dmPaperSize := LongInt(List_Papers.Items.Objects[List_Papers.ItemIndex]);
    Except
      On Ex:Exception Do
        MessageDlg ('The following error occured setting the default bin:' +
                    #10#13#10#13 + '"' + Ex.Message + '"' + #10#13#10#13 +
                    'Please notify Technical Support', mtError, [mbOk], 0);
    End;
end;

end.
