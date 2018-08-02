{*********************************************************}
{* ABBREVIA: AbPeCol.inc 3.02                            *}
{* Copyright (c) TurboPower Software Co 1997, 2002       *}
{* All rights reserved.                                  *}
{*********************************************************}
{* ABBREVIA: Property Editor -                           *}
{*   Zip/CabView column headings (Source)                *}
{*   See AbPeCol.pas for the VCL header                  *}
{*   See AbQPeCol.pas for the CLX header                 *}
{*********************************************************}

{$I AbDefine.inc}

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF UsingClx}
  QGraphics,
  QForms,
  QControls,
  QStdCtrls,
  QButtons,
  QExtCtrls,
  AbQView,
  AbBseCLX,
{$ELSE}
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  Buttons,
  ExtCtrls,
  AbView,
  AbBseVcl,
{$ENDIF}

{$IFDEF LINUX}
  DesignIntf,
  DesignEditors,
{$ELSE}
{$IFDEF VERSION6}
  DesignIntf,
  DesignEditors,
{$ELSE}
  DsgnIntf,
{$ENDIF VERSION6}
{$ENDIF LINUX}
  AbConst,
  SysUtils,
  Classes;

type
  TAbColHeadingsEditor = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Attribute1: TComboBox;
    Done1: TBitBtn;
    Apply1: TBitBtn;
    Label2: TLabel;
    Heading1: TEdit;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure Attribute1Click(Sender: TObject);
    procedure Apply1Click(Sender: TObject);
    procedure Heading1Exit(Sender: TObject);
  private
    { Private declarations }
  public
    Viewer : TAbBaseViewer;

  end;

  TAbColHeadingsProperty = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;


var
  AbColHeadingsEditor: TAbColHeadingsEditor;

implementation

type
  TAbViewerFriend = class(TAbBaseViewer)
end;


{===TAbColHeadingsProperty==========================================}
procedure TAbColHeadingsProperty.Edit;
var
  hEditor : TAbColHeadingsEditor;
begin
  hEditor := TAbColHeadingsEditor.Create(Application);
  try
    hEditor.Viewer := TAbViewerFriend(GetComponent(0));
    hEditor.ShowModal;
    Designer.Modified;
  finally
    hEditor.Free;
  end;
end;
{ -------------------------------------------------------------------------- }
function TAbColHeadingsProperty.GetAttributes: TPropertyAttributes;
  begin
    Result := inherited GetAttributes + [paDialog, paAutoUpdate];
  end;


{===TAbColHeadingsEditor============================================}

procedure TAbColHeadingsEditor.FormShow(Sender: TObject);
var
  i : TAbViewAttribute;
begin
  with Attribute1 do begin
    Clear;
    for i := Low(TAbViewAttribute) to High(TAbViewAttribute) do
{$IFDEF WIN32}
      Items.Add(AbStrRes(AbDefColHeadings + Ord(i)));
{$ENDIF}
{$IFDEF LINUX}
      Items.Add(AbStrRes(AbDefColHeadings + Ord(i)));
{$ENDIF}

    ItemIndex := 0;
  end;
  Attribute1Click(nil);
end;

procedure TAbColHeadingsEditor.Attribute1Click(Sender: TObject);
begin
  if (Attribute1.ItemIndex > -1) then
    Heading1.Text := TAbViewerFriend(Viewer).Headings[Attribute1.ItemIndex];
end;

procedure TAbColHeadingsEditor.Apply1Click(Sender: TObject);
begin
  if (Attribute1.ItemIndex > -1) then begin
    TAbViewerFriend(Viewer).Headings[Attribute1.ItemIndex] := Heading1.Text;
    TAbViewerFriend(Viewer).InvalidateRow(0);
  end;
end;

procedure TAbColHeadingsEditor.Heading1Exit(Sender: TObject);
begin
  Apply1Click(nil);
end;
end.
