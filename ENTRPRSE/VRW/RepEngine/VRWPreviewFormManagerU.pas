unit VRWPreviewFormManagerU;
{
  Maintains a list of the open Preview Forms, so that they can all be shut
  down tidily when the Visual Report Writer is closed.

  There is a Singleton TVRWPreviewFormManager which is available through
  the global PreviewFormManager function.
}
interface

uses Classes, Forms;

type
  TVRWPreviewFormManager = class(TObject)
  private
    FList: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(PreviewForm: TForm);
    procedure Remove(PreviewForm: TForm);
    procedure CloseAll;
  end;

function PreviewFormManager: TVRWPreviewFormManager;

implementation

var
  Manager: TVRWPreviewFormManager;

function PreviewFormManager: TVRWPreviewFormManager;
{ Returns the single instance of the TVRWPreviewFormManager }
begin
  Result := Manager;
end;

{ TVRWPreviewFormManager }

procedure TVRWPreviewFormManager.Add(PreviewForm: TForm);
{ Adds a preview form to the list }
begin
  if FList.IndexOf(PreviewForm) = -1 then
    FList.Add(PreviewForm);
end;

procedure TVRWPreviewFormManager.CloseAll;
{ Closes all the preview forms in the list and clears the list }
var
  Form: TForm;
begin
  while FList.Count > 0 do
  begin
    Form := TForm(FList[0]);
    { Remove the form from the list. Strictly speaking this should not be
      necessary as the form should call Remove when it is closed, but we'll
      do this anyway, just in case the call to Remove has been missed out }
    Remove(Form);
    { Close and release the form }
    Form.Close;
    Form.Free;
  end;
end;

constructor TVRWPreviewFormManager.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TVRWPreviewFormManager.Destroy;
begin
  FList.Free;
  FList := nil;
  inherited;
end;

procedure TVRWPreviewFormManager.Remove(PreviewForm: TForm);
{ Removes the specified preview form from the list. This should be called when
  the preview form is freed }
var
  ItemIndex: Integer;
begin
  ItemIndex := FList.IndexOf(PreviewForm);
  if ItemIndex <> -1 then
    FList.Delete(ItemIndex);
end;

initialization

  Manager := TVRWPreviewFormManager.Create;

finalization

  Manager.Free;
  Manager := nil;

end.
