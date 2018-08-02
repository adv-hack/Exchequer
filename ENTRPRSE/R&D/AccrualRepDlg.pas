{ unit is added to show a pop up which enables a user to either include the transaction which are hold}
unit AccrualRepDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, EnterToTab, StdCtrls;

type
  TfrmAccrualRepDlg = class(TForm)
    btnOk: TButton;
    btnCancle: TButton;
    chkInclude: TCheckBox;    
    EnterToTab1: TEnterToTab;
  private
    { Private declarations }
  public    
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
