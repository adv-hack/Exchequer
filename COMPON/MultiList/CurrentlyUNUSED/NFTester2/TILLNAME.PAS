unit tillname;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, VarConst, TillDet, CardProc;

type
  TFrmTillNames = class(TForm)
    lvTills: TListView;
    btnClose: TButton;
    btnEdit: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  FrmTillNames: TFrmTillNames;}

implementation

{$R *.DFM}

procedure TFrmTillNames.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmTillNames.FormShow(Sender: TObject);
var
  iTill : integer;
  NewItem : TListItem;
begin
  with Syss do begin
    for iTill := 1 to NoTills do begin
      NewItem := lvTills.Items.Add;
      NewItem.Caption := IntToStr(iTill);
      NewItem.SubItems.Add(Syss.Till[iTill].Name);
      NewItem.SubItems.Add(Syss.Till[iTill].IdCode);
    end;{for}
  end;{with}
  lvTills.selected := lvTills.Items[0];
end;

procedure TFrmTillNames.btnEditClick(Sender: TObject);
var
  FrmTillDetails : TFrmTillDetails;
begin
  if lvTills.selected <> nil then begin
    try
      FrmTillDetails := TFrmTillDetails.Create(Self);
      with FrmTillDetails do begin
        lTillNo.Caption := 'Till No ' + lvTills.selected.Caption;
        edTillDesc.Text := lvTills.selected.subitems[0];
        edTillName.Text := lvTills.selected.subitems[1];
        if ShowModal = mrOK then begin
          TechSuppLog('TillId ' + lvTills.selected.Caption + ' changed from '
          + Syss.Till[lvTills.selected.Index + 1].IdCode  + ' to ' + edTillName.Text);

          lvTills.selected.subitems[0] := edTillDesc.Text;
          lvTills.selected.subitems[1] := edTillName.Text;
          Syss.Till[lvTills.selected.Index + 1].IdCode := edTillName.Text;
          Syss.Till[lvTills.selected.Index + 1].Name := edTillDesc.Text;
        end;{if}
      end;{with}
    finally
      FrmTillDetails.Release;
    end;{try}
  end;{if}
end;

end.
