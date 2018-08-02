unit ILConfig_Default;

interface

uses
  {$IFDEF Linux}
  QGraphics, QControls, QForms, QDialogs, QStdCtrls, QExtCtrls, QComCtrls,
  {$ELSE}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls,ExtCtrls, ComCtrls,
  {$ENDIF}
  SysUtils, Classes, ILConfig;
  

type
  TformILConfigDefault = class(TILConfig)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    butnOk: TButton;
    butnCancel: TButton;
    Label3: TLabel;
    editUsername: TEdit;
    editPassword: TEdit;
    Label4: TLabel;
    Label1: TLabel;
    editDatasource: TEdit;
    Label2: TLabel;
    memoOptions: TMemo;
  private
  public
    class function Edit(var VDatasource, VOptions, VUsername, VPassword: string): boolean; override;
  end;

implementation
{$IFDEF Linux}{$R *.xfm}{$ELSE}{$R *.DFM}{$ENDIF}

{ TformILConfigBDE }

class function TformILConfigDefault.Edit(var VDatasource, VOptions, VUsername
 , VPassword: string): boolean;
begin
  with TFormILConfigDefault.Create(nil) do try
    editDatasource.Text := VDatasource;
    memoOptions.Lines.Text := VOptions;
    editUsername.Text := VUsername;
    editPassword.Text := VPassword;
    result := ShowModal = mrOK;
    if result then begin
      VDatasource := editDatasource.Text;
      VOptions := memoOptions.Lines.Text;
      VUsername := editUsername.Text;
      VPassword := editPassword.Text;
    end;
  finally free; end;
end;

end.
