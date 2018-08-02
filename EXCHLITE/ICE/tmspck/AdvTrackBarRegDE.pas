{********************************************************************}
{ TAdvTrackBar component                                             }
{ for Delphi & C++Builder                                            }
{ version 1.0                                                        }
{                                                                    }
{ written                                                            }
{   TMS Software                                                     }
{   copyright © 2007                                                 }
{   Email : info@tmssoftware.com                                     }
{   Web : http://www.tmssoftware.com                                 }
{                                                                    }
{ The source code is given as is. The author is not responsible      }
{ for any possible damage done due to the use of this code.          }
{ The component can be freely used in any application. The source    }
{ code remains property of the writer and may not be distributed     }
{ freely as such.                                                    }
{********************************************************************}

unit AdvTrackBarRegDE;

interface
{$I TMSDEFS.INC}
uses
  AdvTrackBar, GDIPicDE, Classes, GDIPicture,
{$IFDEF DELPHI6_LVL}
  DesignIntf, DesignEditors
{$ELSE}
  DsgnIntf
{$ENDIF}
  ;


type

  TAdvTrackBarEditor = class(TDefaultEditor)
  protected
  public
    function GetVerb(index:integer):string; override;
    function GetVerbCount:integer; override;
    procedure ExecuteVerb(Index:integer); override;
  end;


procedure Register;

implementation

uses
  Windows, Dialogs, Forms, SysUtils, AdvTrackBarGallery,
  AdvTrackBarPersist, AdvStyleIF, Controls;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TAdvTrackBar, 'BackGround', TGDIPPictureProperty);
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TAdvTrackBar, 'BackGroundDisabled', TGDIPPictureProperty);
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TAdvTrackBar, 'RateActive', TGDIPPictureProperty);
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TAdvTrackBar, 'RateInActive', TGDIPPictureProperty);

  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarThumb, 'Picture', TGDIPPictureProperty);
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarThumb, 'PictureHot', TGDIPPictureProperty);
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarThumb, 'PictureDown', TGDIPPictureProperty);
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarThumb, 'PictureDisabled', TGDIPPictureProperty);

  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarSlider, 'Picture', TGDIPPictureProperty);
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarSlider, 'PictureDisabled', TGDIPPictureProperty);
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarSlider, 'PictureCompleted', TGDIPPictureProperty);
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarSlider, 'PictureCompletedDisabled', TGDIPPictureProperty);

  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarTick, 'Picture', TGDIPPictureProperty);
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarTick, 'PictureDisabled', TGDIPPictureProperty);

  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarButtons, 'MinPicture', TGDIPPictureProperty);
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarButtons, 'MinPictureHot', TGDIPPictureProperty);
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarButtons, 'MinPictureDown', TGDIPPictureProperty);

  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarButtons, 'MaxPicture', TGDIPPictureProperty);
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarButtons, 'MaxPictureHot', TGDIPPictureProperty);
  RegisterPropertyEditor(TypeInfo(TGDIPPicture), TTrackBarButtons, 'MaxPictureDown', TGDIPPictureProperty);

  {$IFDEF DELPHI6_LVL}
  RegisterComponentEditor(TAdvTrackBar,TAdvTrackBarEditor);
  {$ENDIF}
end;


function AddBackslash(const s: string): string;
begin
  if (Length(s) >= 1) and (s[Length(s)]<>'\') then
    Result := s + '\'
  else
    Result := s;
end;

function WinTempDir: string;
var
  buf: array[0..MAX_PATH] of Char;
begin
  GetTempPath(sizeof(buf),buf);
  Result := AddBackslash(StrPas(buf));
end;


{ TAdvTrackBarEditor }

procedure TAdvTrackBarEditor.ExecuteVerb(Index: integer);
var
  tbf: TAdvTrackBarGalleryForm;
  pp: TPropertyPersister;
  r: TRect;
  p: TWinControl;
  o: TComponent;
  atb: TAdvTrackbar;
  n: string;
begin
  inherited;
  if Index = 0 then
  begin
    pp := TPropertyPersister.Create(nil);
    pp.StorePropertiesToFile(Component,WinTempDir + 'temp.prop');
    pp.Free;

    tbf := TAdvTrackBarGalleryForm.Create(Application);
    tbf.Selection := '';
    if tbf.ShowModal = mrOK then
    begin
      r := (Component as TAdvTrackBar).BoundsRect;
      p := (Component as TAdvTrackBar).Parent;
      o := (Component as TAdvTrackBar).Owner;
      n := (Component as TAdvTrackBar).Name;

      pp := TPropertyPersister.Create(nil);
      if tbf.Selection <> '' then
      begin
        Component.Free;

        atb := TAdvTrackBar(Designer.CreateComponent(TAdvTrackBar,o,r.left, r.Top,r.Right - r.Left,r.Bottom - r.Top));
        atb.Parent := p;
        atb.Name := n;

        pp.ReStorePropertiesToFile(atb,tbf.Selection);
      end;
      pp.Free;
    end;
    tbf.Free;
  end;

  case Index of
  1: (Component as TAdvTrackBar).SetComponentStyle(tsOffice2003Blue);
  2: (Component as TAdvTrackBar).SetComponentStyle(tsOffice2003Olive);
  3: (Component as TAdvTrackBar).SetComponentStyle(tsOffice2003Silver);
  4: (Component as TAdvTrackBar).SetComponentStyle(tsOffice2003Classic);
  5: (Component as TAdvTrackBar).SetComponentStyle(tsOffice2007Luna);
  6: (Component as TAdvTrackBar).SetComponentStyle(tsOffice2007Obsidian);
  7: (Component as TAdvTrackBar).SetComponentStyle(tsOffice2007Silver);
  end;

end;

function TAdvTrackBarEditor.GetVerb(index: integer): string;
begin
  case Index of
  0: Result := 'Gallery';
  1: Result := 'Office 2003 Blue';
  2: Result := 'Office 2003 Olive';
  3: Result := 'Office 2003 Silver';
  4: Result := 'Office 2003 Classic';
  5: Result := 'Office 2007 Luna';
  6: Result := 'Office 2007 Obsidian';
  7: Result := 'Office 2007 Silver';
  end;

end;

function TAdvTrackBarEditor.GetVerbCount: integer;
begin
  Result := 8;
end;

end.

