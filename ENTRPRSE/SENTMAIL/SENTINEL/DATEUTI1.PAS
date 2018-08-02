unit dateutil;

interface

procedure SetLabel(Sender : TComboBox; ALabel : TLabel);

implementation

procedure SetLabel(Sender : TComboBox; ALabel : TLabel);
begin
  Case DataType of
    1   :  if Sender.Text[1] = 'T' then
              ALabel.Caption := 'Offset (Days)'
           else
              ALabel.Caption := 'Increment by (Days)';
    2   :  if Sender.Text[1] = 'C' then
              ALabel.Caption := 'Offset'
           else
              ALabel.Caption := 'Increment';
  end;
end;


end.
 