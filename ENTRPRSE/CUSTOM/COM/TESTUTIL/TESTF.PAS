unit TestF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, EntCustom, Enterprise_TLB;

type
  TForm1 = class(TForm)
    EntCustom1: TEntCustom;
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure EntCustom1Connect(ComCustomisation: ICOMCustomisation);
    procedure EntCustom1Hook(EventData: ICOMEventData);
    procedure EntCustom1Close;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  EntCustom1.Connect;
end;

procedure TForm1.EntCustom1Connect(ComCustomisation: ICOMCustomisation);
begin
  With ComCustomisation Do Begin
    { Trans Head - Exit Account - Set Delivery Address }
    //EnableHook (wiTransaction, 9);

    { Trans Head - Period Hooks }
    EnableHook (wiTransaction, 8);  { Exit - Period/Year }
    EnableHook (wiTransaction, 80);  { Set Period/Year from TransDate }
    EnableHook (wiTransaction, 81);  { Set TransDate from Period/Year }

    (*
    { Trans Line - Set Stock Code }
    EnableHook (wiTransLine, 15);

    { Trans Line - Enter Unit Price }
    EnableHook (wiTransLine, 9);

    { Trans Line - Exit Cost Centre }
    EnableHook (wiTransLine, 16);

    { Trans Line - Exit Department }
    EnableHook (wiTransLine, 17);

    { Sales Daybook - Custom Button 1 + 2 }
    EnableHook (wiTransaction, 10);
    EnableHook (wiTransaction, 20);
    *)
  End; { With CustomConfig }
end;

procedure TForm1.EntCustom1Hook(EventData: ICOMEventData);
begin
  Try
    With EventData Do Begin
      ListBox1.Items.Add (Format('%10.10d  %3.3d', [WindowId, HandlerId]));
      ListBox1.Items.Add ('DataPath: ' + EntCustom1.IntF.SystemSetup.ssDataPath);
      ListBox1.Items.Add ('CcyVer:   ' + IntToStr(EntCustom1.IntF.VersionInfo.CurrencyVer));

      If (WindowId = wiTransLine) And (HandlerId = 15) Then Begin
        { TL - Exit Stock Code - Before Validation }
        Transaction.thLines.thCurrentLine.tlStockCode := 'BLUE';
      End { If }
      Else Begin
        If (WindowId = wiTransaction) And (HandlerId = 8) Then Begin
          { TH - Exit Period/Year }
          Transaction.thPeriod := 7;  { July }
          Transaction.thYear := 105;  { 2005 }
        End { If }
        Else Begin
          If (WindowId = wiTransaction) And (HandlerId = 80) Then Begin
            { TH - Set Period/Year from TransDate }
            Transaction.thPeriod := 6;  { June }
            Transaction.thYear := 104;  { 2004 }
          End { If }
          Else Begin
            If (WindowId = wiTransaction) And (HandlerId = 81) Then Begin
              { TH - Set TransDate from Period/Year }
              Transaction.thTransDate := '19860518';  { 18/05/1986 }
            End { If }
            Else Begin
              If (WindowId = wiTransLine) And (HandlerId = 9) Then Begin
                { Trans Line - Enter Unit Price }
                Transaction.thLines.thCurrentLine.tlNetValue := 1.23;
              End { If }
              Else Begin
                If (WindowId = wiTransLine) And (HandlerId = 16) Then Begin
                  { Trans Line - Exit Cost Centre }
                  Transaction.thLines.thCurrentLine.tlCostCentre := 'HM1';
                End { If }
                Else Begin
                  If (WindowId = wiTransLine) And (HandlerId = 17) Then Begin
                    { Trans Line - Exit Department }
                    Transaction.thLines.thCurrentLine.tlDepartment := 'HM2';
                  End { If }
                  Else Begin
                    If (WindowId = wiTransaction) And (HandlerId = 10) Then Begin
                      { Sales Daybook - Custom Button 1 }
                      Transaction.thUser1 := 'THUD1a';
                      Transaction.thUser2 := 'THUD2a';
                      Transaction.thUser3 := 'THUD3a';
                      Transaction.thUser4 := 'THUD4a';

                      Transaction.thDelAddr[1] := 'Deliver To Jim';
                      Transaction.thDelAddr[2] := 'At Jim''s House';
                      Transaction.thDelAddr[3] := 'On Wednesday Morning';
                      Transaction.thDelAddr[4] := '(Before 9am)';
                      Transaction.thDelAddr[5] := '';
                    End { If }
                    Else Begin
                      If (WindowId = wiTransaction) And (HandlerId = 20) Then Begin
                        { Sales Daybook - Custom Button 2 }
                        Transaction.thUser1 := 'THUD1b';
                        Transaction.thUser2 := 'THUD2b';
                        Transaction.thUser3 := 'THUD3b';
                        Transaction.thUser4 := 'THUD4b';

                        Transaction.thDelAddr[1] := 'Deliver To Neil';
                        Transaction.thDelAddr[2] := 'At Neil''s House';
                        Transaction.thDelAddr[3] := 'On Thursday Evening';
                        Transaction.thDelAddr[4] := '(After 7pm)';
                        Transaction.thDelAddr[5] := '';
                      End { If }
                      Else Begin
                        If (WindowId = wiTransaction) And (HandlerId = 9) Then Begin
                          { TH - Exit Account Code - Set Delivery Address }
                          Transaction.thDelAddr[1] := 'Deliver To Sandra';
                          Transaction.thDelAddr[2] := 'c/o Exchequer Software Ltd';
                          Transaction.thDelAddr[3] := 'Exchequer Grange';
                          Transaction.thDelAddr[4] := 'Wootton Gardens';
                          Transaction.thDelAddr[5] := 'Bournemouth, BH1 1PW';
                        End { If }
                      End; { Else }
                    End; { Else }
                  End; { Else }
                End; { Else }
              End; { Else }
            End; { Else }
          End; { Else }
        End; { Else }
      End; { Else }
    End; { With EnterpriseSystem }
  Except
    On Ex:Exception Do
      MessageDlg ('The following error occured processing a hook:-' + #13#13 + Ex.Message, mtError, [mbOk], 0);
  End;
end;

procedure TForm1.EntCustom1Close;
begin
  Application.Terminate;
end;

end.
