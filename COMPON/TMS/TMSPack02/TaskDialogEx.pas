{***************************************************************************}
{ TTaskDialogEx component                                                   }
{ for Delphi & C++Builder                                                   }
{ version 1.0                                                               }
{                                                                           }
{ written by TMS Software                                                   }
{            copyright © 2007                                               }
{            Email : info@tmssoftware.com                                   }
{            Web : http://www.tmssoftware.com                               }
{                                                                           }
{ The source code is given as is. The author is not responsible             }
{ for any possible damage done due to the use of this code.                 }
{ The component can be freely used in any application. The complete         }
{ source code remains property of the author and may not be distributed,    }
{ published, given or sold in any form as such. No parts of the source      }
{ code can be included in any other component or application without        }
{ written authorization of the author.                                      }
{***************************************************************************}

unit TaskDialogEx;

{$I TMSDEFS.INC}                  

interface

uses
  Classes, Windows, Messages, Forms, Dialogs, SysUtils, StdCtrls, Graphics, Consts, Math,
  ExtCtrls, Controls, TaskDialog, AdvGlowButton;

type

  TAdvTaskDialogEx = class(TAdvTaskDialog)
  protected
    function CreateButton(AOwner: TComponent): TWinControl; override;
    procedure SetButtonCaption(aButton: TWinControl; Value: TCaption); override;
    procedure SetButtonCancel(aButton: TWinControl; Value: Boolean); override;
    procedure SetButtonDefault(aButton: TWinControl; Value: Boolean); override;
    procedure SetButtonModalResult(aButton: TWinControl; Value: Integer); override;
    function GetButtonModalResult(aButton: TWinControl): Integer; override;
  end;

procedure Register;

implementation

//------------------------------------------------------------------------------

procedure Register;
begin
  RegisterComponents('TMS',[TAdvTaskDialogEx]);
end;

//------------------------------------------------------------------------------

{ TAdvTaskDialogEx }

function TAdvTaskDialogEx.CreateButton(AOwner: TComponent): TWinControl;
begin
  Result := TAdvGlowButton.Create(AOwner);
  (Result as TAdvGlowButton).TabStop := true;
end;

//------------------------------------------------------------------------------

function TAdvTaskDialogEx.GetButtonModalResult(
  aButton: TWinControl): Integer;
begin
  Result := mrNone;
  if not Assigned(aButton) or not (aButton is TAdvGlowButton) then
    Exit;

  Result := TAdvGlowButton(aButton).ModalResult;
end;

//------------------------------------------------------------------------------

procedure TAdvTaskDialogEx.SetButtonCancel(aButton: TWinControl;
  Value: Boolean);
begin
  if not Assigned(aButton) or not (aButton is TAdvGlowButton) then
    Exit;

  TAdvGlowButton(aButton).Cancel := Value;
end;

//------------------------------------------------------------------------------

procedure TAdvTaskDialogEx.SetButtonCaption(aButton: TWinControl;
  Value: TCaption);
begin
  if not Assigned(aButton) or not (aButton is TAdvGlowButton) then
    Exit;

  TAdvGlowButton(aButton).Caption := Value;
end;

//------------------------------------------------------------------------------

procedure TAdvTaskDialogEx.SetButtonDefault(aButton: TWinControl;
  Value: Boolean);
begin
  if not Assigned(aButton) or not (aButton is TAdvGlowButton) then
    Exit;

  TAdvGlowButton(aButton).Default := Value;
end;

//------------------------------------------------------------------------------

procedure TAdvTaskDialogEx.SetButtonModalResult(aButton: TWinControl;
  Value: Integer);
begin
  if not Assigned(aButton) or not (aButton is TAdvGlowButton) then
    Exit;

  TAdvGlowButton(aButton).ModalResult := Value;
end;

//------------------------------------------------------------------------------

end.
