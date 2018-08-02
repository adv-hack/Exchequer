{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPExeFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, RPRave, ExtCtrls;

type
  TExeForm = class(TForm)
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    ClearBtn: TBitBtn;
    SaveBtn: TBitBtn;
    LoadBtn: TBitBtn;
    CloseBtn: TBitBtn;
    Label1: TLabel;
    FileNameEdit: TEdit;
    Bevel1: TBevel;
    Panel2: TPanel;
    DateTimeLabel: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    SaveDialog1: TSaveDialog;
    procedure LoadBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FRaveProject: TRaveProject;
    FRaveProjectModified: boolean;
    procedure UpdateForm;
  public
    property RaveProject: TRaveProject read FRaveProject write FRaveProject;
    property RaveProjectModified: boolean read FRaveProjectModified
     write FRaveProjectModified;
  end;

var
  ExeForm: TExeForm;

implementation

{$R *.DFM}

procedure TExeForm.LoadBtnClick(Sender: TObject);

var
  Stream: TFileStream;

begin
  If FileExists(FileNameEdit.Text) then begin
    Stream := TFileStream.Create(FileNameEdit.Text,fmOpenRead);
    try
      RaveProject.LoadRaveBlob(Stream);
    finally
      Stream.Free;
    end; { tryf }
    UpdateForm;
    RaveProjectModified := true;
  end else begin
    ShowMessage(#13'File Does Not Exist:'#13 + FileNameEdit.Text);
  end; { else }
end;

procedure TExeForm.SaveBtnClick(Sender: TObject);

var
  Stream: TFileStream;

begin
  SaveDialog1.InitialDir := ExpandFileName(FileNameEdit.Text);
  SaveDialog1.FileName := ExtractFileName(FileNameEdit.Text);
  If SaveDialog1.Execute then begin
    try
      Stream := TFileStream.Create(SaveDialog1.FileName,fmCreate);
      try
        RaveProject.SaveRaveBlob(Stream);
        FileNameEdit.Text := SaveDialog1.FileName;
      finally
        Stream.Free;
      end; { tryf }
    except
      ShowMessage('Error Saving Report To'#13 + FileNameEdit.Text);
    end; { tryx }
  end; { if }
end;

procedure TExeForm.ClearBtnClick(Sender: TObject);
begin
  RaveProject.ClearRaveBlob;
  UpdateForm;
  RaveProjectModified := true;
end;

procedure TExeForm.UpdateForm;

begin { UpdateForm }
  If RaveProject.RaveBlobDateTime < 1.0 then begin { Check for 0 w/ buffer }
    DateTimeLabel.Caption := '(none)';
  end else begin
    DateTimeLabel.Caption := FormatDateTime('ddddd t',RaveProject.RaveBlobDateTime);
  end; { else }
end;  { UpdateForm }

procedure TExeForm.FormShow(Sender: TObject);
begin
  FileNameEdit.Text := RaveProject.ProjectFile;
  UpdateForm;
end;

procedure TExeForm.SpeedButton1Click(Sender: TObject);
begin
  If ExtractFilePath(FileNameEdit.Text) <> '' then begin
    OpenDialog1.InitialDir := ExtractFilePath(FileNameEdit.Text);
  end else begin
    OpenDialog1.InitialDir := GetCurrentDir;
  end; { else }
  If OpenDialog1.Execute then begin
    FileNameEdit.Text := Trim(OpenDialog1.FileName);
    If MessageDlg('Do you want to use this as your ProjectFile?',
     mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
      RaveProject.ProjectFile := FileNameEdit.Text;
    end; { if }
  end; { if }
end;

end.
 