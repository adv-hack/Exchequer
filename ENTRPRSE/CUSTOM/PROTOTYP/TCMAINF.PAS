unit TCMainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    btnCustom1: TButton;
    btnCustom2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure btnCustom2Click(Sender: TObject);
    procedure btnCustom1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure CommonCustomButton(Const BtnHandlerId : LongInt);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{$IFDEF TCCU}  // Trade Counter Customisation
Uses
  CustIntU,
  EnterpriseTrade_TLB,
  PIAboutF;
{$ENDIF}

procedure TForm1.FormCreate(Sender: TObject);
begin
{$IFDEF TCCU}  // Trade Counter Customisation
  StartCustomisation;

  // Check to see if the Custom Buttons have been enabled by a Plug-In
  btnCustom1.Visible := TradeCustomisation.GotEvent (twiTransaction, 101);
  If btnCustom1.Visible Then btnCustom1.Caption := TradeCustomisation.CustomText (twiTransaction, 101, btnCustom1.Caption);

  btnCustom2.Visible := TradeCustomisation.GotEvent (twiTransaction, 102);
  If btnCustom2.Visible Then btnCustom2.Caption := TradeCustomisation.CustomText (twiTransaction, 102, btnCustom2.Caption);
{$ENDIF}
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
{$IFDEF TCCU}  // Trade Counter Customisation
  KillCustomisation;
{$ENDIF}
end;

procedure TForm1.Edit1Exit(Sender: TObject);
begin
  {$IFDEF TCCU}  // Trade Counter Customisation
    // Check to see if the event has been enabled by a Plug-In
    If TradeCustomisation.GotEvent (twiTransaction, 1) Then Begin
      // Update EventData with current data values
      TradeCustomisation.EventDataO.Assign (Self.Handle, twiTransaction, 1, Edit1.Text, Edit2.Text, Edit3.Text);

      // Execute the Hook Point Event
      TradeCustomisation.ExecuteEvent;

      // Check the Plug-In changed something
      If TradeCustomisation.EventDataO.DataChanged Then Begin
        // Update form with changes
        Edit1.Text := TradeCustomisation.EventDataI.Transaction.Edit1;
      End; { If TradeCustomisation.ExecuteEvent... }
    End; { If TradeCustomisation.GotEvent... }
  {$ENDIF}
end;

procedure TForm1.CommonCustomButton(Const BtnHandlerId : LongInt);
begin
  {$IFDEF TCCU}  // Trade Counter Customisation
    // Check to see if the event has been enabled by a Plug-In
    If btnCustom1.Visible And TradeCustomisation.GotEvent (twiTransaction, BtnHandlerId) Then Begin
      // Update EventData with current data values
      TradeCustomisation.EventDataO.Assign (Self.Handle, twiTransaction, BtnHandlerId, Edit1.Text, Edit2.Text, Edit3.Text);

      // Execute the Hook Point Event
      TradeCustomisation.ExecuteEvent;

      // Check the Plug-In changed something
      If TradeCustomisation.EventDataO.DataChanged Then Begin
        // Update form with changes
        Edit1.Text := TradeCustomisation.EventDataI.Transaction.Edit1;
        Edit2.Text := TradeCustomisation.EventDataI.Transaction.Edit2;
        Edit3.Text := TradeCustomisation.EventDataI.Transaction.Edit3;
      End; { If TradeCustomisation.ExecuteEvent... }
    End; { If TradeCustomisation.GotEvent... }
  {$ENDIF}
end;

procedure TForm1.btnCustom1Click(Sender: TObject);
begin
  CommonCustomButton(101);
end;

procedure TForm1.btnCustom2Click(Sender: TObject);
begin
  CommonCustomButton(102);
end;

procedure TForm1.Button1Click(Sender: TObject);
Var
  I : SmallInt;
begin
  {$IFDEF TCCU}  // Trade Counter Customisation
    If CustomisationEnabled Then
      With TfrmPlugInList.Create(Self) Do
        Try
          // Add the Plug-Ins into the About dialog
          If (TradeCustomisation.PlugInCount > 0) Then
            For I := 0 To Pred(TradeCustomisation.PlugInCount) Do
              AddPlugIn (TradeCustomisation.PlugIns[I]);

          ShowModal;
        Finally
          Free;
        End;
  {$ENDIF}
end;

end.

