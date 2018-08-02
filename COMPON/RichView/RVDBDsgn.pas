unit RVDBDsgn;

interface

{$I RV_Defs.inc}
uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  {$IFDEF RICHVIEWDEF6}
  DesignIntf, DesignEditors,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  TypInfo, RVSEdit, RichView,
  DBRV, Dialogs, RVDsgn, StdCtrls, Graphics, ExtCtrls, ComCtrls;


type
  TfrmDBRVDesign = class(TfrmRVDesign)
    TabSheet3: TTabSheet;
    GroupBox4: TGroupBox;
    cbDBAutoDeleteUnusedStyles: TCheckBox;
    cbDBReadOnly: TCheckBox;
    cbDBEscape: TCheckBox;
    Label7: TLabel;
    cmbDBFieldFormat: TComboBox;
    procedure FormActivate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TDBRVEEditor = class (TRVEEditor)
    public
      procedure ExecuteVerb(Index: Integer); override;
  end;

procedure Register;

implementation

{$R *.DFM}

{============================= TDBRVSEditor ===================================}

procedure TDBRVEEditor.ExecuteVerb(Index: Integer);
var frm:TfrmDBRVDesign;
begin
  case Index of
   0:
     begin
       frm := TfrmDBRVDesign.Create(Application);
       try
         frm.SetRichView(Component as TCustomRichView);
         if frm.ShowModal=mrOk then begin
           Designer.Modified;
         end;
       finally
         frm.Free;
       end;
     end;
   else
    inherited ExecuteVerb(Index);
  end;
end;

procedure Register;
begin
  RegisterComponentEditor(TDBRichViewEdit, TDBRVEEditor);
end;

{============================= TfrmDBRVDesign =================================}
procedure TfrmDBRVDesign.FormActivate(Sender: TObject);
begin
//  if FInitialized then
//    exit;
  inherited;
  cbDBAutoDeleteUnusedStyles.Checked := (rv as TDBRichViewEdit).AutoDeleteUnusedStyles;
  cbDBReadOnly.Checked := (rv as TDBRichViewEdit).ReadOnly;
  cbDBEscape.Checked := not (rv as TDBRichViewEdit).IgnoreEscape;
  cmbDBFieldFormat.ItemIndex := ord((rv as TDBRichViewEdit).FieldFormat);
end;

procedure TfrmDBRVDesign.btnOkClick(Sender: TObject);
begin
  inherited;
  (rv as TDBRichViewEdit).AutoDeleteUnusedStyles := cbDBAutoDeleteUnusedStyles.Checked;
  (rv as TDBRichViewEdit).ReadOnly := cbDBReadOnly.Checked;
  (rv as TDBRichViewEdit).IgnoreEscape := not cbDBEscape.Checked;
  (rv as TDBRichViewEdit).FieldFormat := TRVDBFieldFormat(cmbDBFieldFormat.ItemIndex);
end;

end.
