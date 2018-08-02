unit DatePick;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TfrmDatePick = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Cal: TMonthCalendar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


function SelectDate(const s : String) : String;

procedure SetLabel(Sender : TComboBox; ALabel : TLabel; DataType : Byte);
function ValidateComboExit(Sender : TComboBox; DataType : Byte) : Boolean;
procedure AddDropDown(Sender : TComboBox; DataType : Byte);


implementation

{$R *.dfm}

function SelectDate(const s : String) : String;
begin
  with TfrmDatePick.Create(Application) do
  Try
    Try
      Cal.Date := StrToDate(s);
    Except
      Cal.Date := Date;
    End;
    ShowModal;
    if ModalResult = mrOK then
      Result := DateToStr(Cal.Date)
    else
      Result := s;
  Finally
    Free;
  End;
end;

procedure SetLabel(Sender : TComboBox; ALabel : TLabel; DataType : Byte);
begin
  Case DataType of
    1   :  if (Length(Sender.Text) = 0) or (Sender.Text[1] = 'T') then
              ALabel.Caption := 'Offset (Days)'
           else
              ALabel.Caption := 'Increment by (Days)';
    2   :  if (Length(Sender.Text) = 0) or (Sender.Text[1] = 'C') then
              ALabel.Caption := 'Offset'
           else
              ALabel.Caption := 'Increment';
  end;
  ALabel.Update;
  Application.ProcessMessages;
end;

function ValidateComboExit(Sender : TComboBox; DataType : Byte) : Boolean;
var
  d : TDateTime;
  s : AnsiString;
begin
  Result := true;
  Case  DataType of
    1   : begin
            if UpperCase(Sender.Text) <> 'TODAY' then
            begin
              Try
                d := StrToDate(Sender.Text);
              Except
                s := QuotedStr(Sender.Text) + ' is not a valid date'#10 +
                                             'Please use format ' + ShortDateFormat;
                Application.MessageBox(PChar(s), 'Sentimail', MB_OK or MB_ICONEXCLAMATION);
                Result := False;
              End;
            end;
          end;
    2   : begin
          end;
   end;//case

end;

procedure AddDropDown(Sender : TComboBox; DataType : Byte);
begin
   Sender.Items.Clear;
   if DataType = 1 then
   begin
     Sender.Items.Add('Today');
     Sender.Items.Add(DateToStr(Date));
   end
   else
   begin
     Sender.Items.Add('Current Period');
//     Sender.Items.Add('Current Period');
   end;
end;



end.
