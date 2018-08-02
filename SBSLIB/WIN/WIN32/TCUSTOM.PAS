unit TCustom;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TEditVal, BorBtns, BkGroup, SBSPanel, TCustAbs,

  {$IFDEF PKG_On}
    DesignEditors,
  {$ENDIF}

  StdCtrls;

type
  TSBSButton = Class(TButton)
  Private
    FTextId : LongInt;
  Protected
    constructor Create(AOwner: TComponent); override;
  Published
    Property TextId : LongInt Read FTextId Write FTextId;
  End; { TSBSButton }

  { Type to indicate which Label Customisation DLL to use }
  TCustomisationDLL = (SysDll_Ent,SysDll_2,SysDll_3,SysDll_4,SysDll_5);

  { Must be kept in Sync with TCustAbs.Pas }
  TCustomText = Class(TAbsCustomText)
  Private
    FCaption : ShortString;
    FColor   : TColor;
    FName    : TFontName;
    FSize    : Integer;
    FStyle   : TFontStyles;
    FTextId, FWinId : LongInt;
  Protected
    Function  GetCaption : ShortString; Override;
    Procedure SetCaption(Value : ShortString); Override;
    Function  GetColor : TColor; Override;
    Procedure SetColor(Value : TColor); Override;
    Function  GetName : TFontName; Override;
    Procedure SetName(Value : TFontName); Override;
    Function  GetSize : Integer; Override;
    Procedure SetSize(Value : Integer); Override;
    Function  GetStyle : TFontStyles; Override;
    Procedure SetStyle(Value : TFontStyles); Override;
    Function  GetTextId : LongInt; Override;
    Function  GetWindowId : LongInt; Override;
  Public
    RCBase : LongInt;
    Procedure Build (Const WinId, TextId : LongInt;
                     Const Caption       : ShortString;
                     Const Font          : TFont);
    Function GetLabel (Font : TFont) : ShortString;
  End; { TCustomText }

  { Basic object which provides an interface to the Label Customisation DLL }
  TCustomisationObj = Class(TObject)
  Private
    FDll : TCustomisationDLL;

    FCustObj : TCustomText;

    { Procedure/Function Handles }
    _MyGSRHandle : THandle;
    _DoCustomText  : Function  (Const WindowId : LongInt) : Boolean;
    _GetCustomText : Procedure (CustomLabel : TAbsCustomText);
  Public
    Constructor Create (DLLId : TCustomisationDLL);
    Destructor Destroy; OverRide;

    Function CheckForCustom(WindowId : LongInt) : Boolean;
    Procedure GetCustomise(    WindowId, TextId : LongInt;
                           Var Caption          : ShortString;
                               TheFont          : TFont);
  End; { TCustomisationObj }

  { Component to automate label customisation on forms }
  TCustomisation = class(TComponent)
  private
    { Private declarations }
    FDll : TCustomisationDLL;
    FEnabled : Boolean;
    FExportPath : ShortString;
    FWinId : LongInt;

    { For Hidden Properties }
    FTag : LongInt;

    
  protected
    { Protected declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    Procedure   Loaded; override;

    Procedure SetWinId(Value : LongInt);
  public
    { Public declarations }
    { Interface Object to Label customisation }
    FCustDll : TCustomisationObj;

    Procedure EditText;
    Procedure Execute;
  published
    { Published declarations }
    Property DLLId : TCustomisationDLL Read FDll Write FDll;
    Property Enabled : Boolean Read FEnabled Write FEnabled;
    Property ExportPath : ShortString Read FExportPath Write FExportPath;
    Property WindowId : LongInt Read FWinId Write SetWinId;

    { Hide the following declarations }
    Property Tag : LongInt Read FTag;
  end;

{$IFDEF PKG_On}

  TCustomisationEditor = Class(TComponentEditor)
    Function  GetVerbCount : Integer; Override;
    Function  GetVerb(Index : Integer) : String; Override;
    Procedure ExecuteVerb(Index : Integer); Override;
  End; { TCustomisationEditor }
{$ENDIF}


procedure Register;

implementation

Uses TCustDlg, 

  {$IFDEF PKG_On}
    DesignIntf,
  {$ENDIF}

  WinMapU;

Const
  DLLNames : Array[TCustomisationDLL] Of PChar = ('EntCustm','EntCustm','EntCustm','EntCustm','EntCustm');
  ResNames : Array[1..2] of PChar = ('EntDoCustomText', 'EntGetCustomText');

Var
  CustomOn : Boolean;



{ Checks the Command Line Parameters for Customisation related switches }
Procedure CheckParams;
Var
  I : Word;
Begin
  If (ParamCount > 0) Then
    For I := 1 To ParamCount Do Begin
      { Check for Customisation Disable Flag }
      If CustomOn then
        CustomOn := Not (UpperCase(ParamStr(I)) = '/NOCUSTOM');

    End; { If }
End;


{------------------------------------------------------------------------------}


Constructor TSBSButton.Create(AOwner: TComponent);
Begin
  Inherited Create (AOwner);

  Height := 21;
  Width := 80;
End;


{------------------------------------------------------------------------------}


Function TCustomText.GetCaption : ShortString;
Begin
  Result := FCaption;
End;

Procedure TCustomText.SetCaption(Value : ShortString);
Begin
  FCaption := Value;
End;

Function TCustomText.GetColor : TColor;
Begin
  Result := FColor;
End;

Procedure TCustomText.SetColor(Value : TColor);
Begin
  FColor := Value;
End;

Function TCustomText.GetName : TFontName;
Begin
  Result := FName;
End;

Procedure TCustomText.SetName(Value : TFontName);
Begin
  FName := Value;
End;

Function TCustomText.GetSize : Integer;
Begin
  Result := FSize;
End;

Procedure TCustomText.SetSize(Value : Integer);
Begin
  FSize := Value;
End;

Function TCustomText.GetStyle : TFontStyles;
Begin
  Result := FStyle;
End;

Procedure TCustomText.SetStyle(Value : TFontStyles);
Begin
  FStyle := Value;
End;

Function TCustomText.GetTextId : LongInt;
Begin
  Result := FTextId;
End;

Function TCustomText.GetWindowId : LongInt;
Begin
  Result := FWinId;
End;

Procedure TCustomText.Build (Const WinId, TextId : LongInt;
                             Const Caption       : ShortString;
                             Const Font          : TFont);
Begin
  FWinId := WinId;
  FTextId := TextId;
  FCaption := Caption;
  With Font Do Begin
    FColor   := Color;
    FName    := Name;
    FSize    := Size;
    FStyle   := Style;
  End; { With }
End;

Function TCustomText.GetLabel (Font : TFont) : ShortString;
Begin
  Result := FCaption;
  With Font Do Begin
    Color   := FColor;
    Name    := FName;
    Size    := FSize;
    Style   := FStyle;
  End; { With }
End;


{------------------------------------------------------------------------------}


Constructor TCustomisationObj.Create (DLLId : TCustomisationDLL);
Var
  DLLAddr  :  TFarProc;
Begin
  Inherited Create;

  FDll := DllId;

  If CustomOn Then Begin
    { No point in using unnecessary memory }
    FCustObj := TCustomText.Create;
  End { If }
  Else
    FCustObj := Nil;

  _MyGSRHandle   := 0;
  _DoCustomText  := Nil;
  _GetCustomText := Nil;

  { Check its enabled and its not design-time }
  If CustomOn Then Begin
    { Load the DLL }
    _MyGSRHandle:=LoadLibrary(DLLNames[FDll]);

    Try
      { Check we have got the DLL loaded OK }
      If (_MyGSRHandle > HInstance_Error) Then Begin
        { Get the Address of the ? function }
        DLLAddr := GetProcAddress(_MyGSRHandle, ResNames[1]);

        { Check we got the address OK }
        If Assigned(DLLAddr) then Begin
          { Copy address into function handle }
          _DoCustomText := DLLAddr;

          { Get the Address of the ? function }
          DLLAddr := GetProcAddress(_MyGSRHandle, ResNames[2]);
          If Assigned(DLLAddr) Then Begin
            { Copy address into function handle }
            _GetCustomText := DLLAddr;
          End { If }
          Else Begin
            FreeLibrary(_MyGSRHandle);
            _MyGSRHandle:=0;
            _DoCustomText := Nil;
          End; { Else }
        End { If }
        Else Begin
          FreeLibrary(_MyGSRHandle);
          _MyGSRHandle:=0;
        End; { Else }
      End { If }
      Else
        _MyGSRHandle:=0;
    Except
      FreeLibrary(_MyGSRHandle);
      _MyGSRHandle:=0;

      _DoCustomText  := Nil;
      _GetCustomText := Nil;
    End; { Try }
  End; { If }
End;

Destructor TCustomisationObj.Destroy;
Begin
  { Unload the library }
  If (_MyGSRHandle <> 0) Then Begin
    FreeLibrary(_MyGSRHandle);
    _MyGSRHandle:=0;
  End; { If }

  If Assigned (FCustObj) Then FCustObj.Free;

  Inherited Destroy;
End;

{ Returns True if the Window is marked as customised }
Function TCustomisationObj.CheckForCustom(WindowId : LongInt) : Boolean;
Begin
  Result := False;

  If CustomOn And Assigned(_DoCustomText) Then
    Result := _DoCustomText(WindowId);
End;


{ Gets the Label Customisation }
Procedure TCustomisationObj.GetCustomise(    WindowId, TextId : LongInt;
                                         Var Caption          : ShortString;
                                             TheFont          : TFont);
Begin
  If CustomOn And Assigned(FCustObj) And Assigned(_GetCustomText) Then Begin
    { Build FCustObj object }
    FCustObj.Build (WindowId, TextId, Caption, TheFont);

    { Call DLL to get customisation }
    _GetCustomText(FCustObj);

    { Set result of customisation }
    Caption := FCustObj.GetLabel (TheFont);
  End; { If }
End;


{------------------------------------------------------------------------------}


{ Creates an Instance of the Customisation Class }
Constructor TCustomisation.Create(AOwner: TComponent);
Begin
  Inherited Create (AOwner);

  { Initialise proerties to default values }
  FDll := SysDll_Ent;
  FEnabled := True;
  FExportPath := Copy (Owner.Name, 1, 8);
  FWinId := 0;

  { Initialise Objects }
  FCustDll := Nil;
End;


{ Creates handles to the DLL procedures }
Procedure TCustomisation.Loaded;
begin
  { Check its enabled and its not design-time }
  If (Not (csDesigning in ComponentState)) And FEnabled And CustomOn Then Begin
    { Create Customisation Interface object }
    Try
      FCustDll := TCustomisationObj.Create(FDll);
    Except
      FCustDll := Nil;
    End;
  End; { If }
End;


{ Destroys the instance of the Customisation Class }
Destructor TCustomisation.Destroy;
Begin
  If Assigned(FCustDll) Then FCustDll.Free;

  Inherited Destroy;
End;


{ Executes the Label Customisation }
Procedure TCustomisation.Execute;
Var
  CompPars : TComponentParser;
  Capt     : ShortString;
  I        : SmallInt;
Begin
  { Check its not design-time and customisation is enabled }
  If (Not (csDesigning in ComponentState)) And FEnabled And CustomOn Then
    If FCustDLL.CheckForCustom(FWinId) Then Begin
      { Check to see if customisation is on for this window }
      If (Owner.ComponentCount > 0) Then Begin
        CompPars := TComponentParser.Create;
        Try
          { Step through list of components }
          For I := 0 To Pred(Owner.ComponentCount) Do Begin
            CompPars.Component := Owner.Components[I];

            { And see if they are customisable }
            If CompPars.GotCustomControl And (CompPars.TextId > 0) Then Begin
              { Control is to be customised }
              Capt := CompPars.Caption;
              FCustDLL.GetCustomise(FWinId, CompPars.TextId, Capt, CompPars.Font);
              CompPars.Caption := Capt;
            End; { If }
          End; { For }
        Finally
          CompPars.Free;
        End;
      End; { If }
    End; { If }
End;


{ Displays a dialog containing all th customisable fields on the form }
Procedure TCustomisation.EditText;
Var
  CustomisationDlg : TCustomisationDlg;
Begin
  If (csDesigning In ComponentState) Then Begin
    CustomisationDlg := TCustomisationDlg.Create(Application);
    Try
      { Initialise Customisation Dialog }
      With CustomisationDlg Do Begin
        CustomControl := Self;
      End; { With }

      CustomisationDlg.ShowModal;
    Finally
      CustomisationDlg.Free;
    End; { Try }
  End; { If }
End;


{ Set the WinId - load the ArrayId automatically }
Procedure TCustomisation.SetWinId(Value : LongInt);
Var
  tArrayId, tWinId : LongInt;
Begin
  If (Value <> FWinId) Then Begin
    tArrayId := -1;
    tWinId   := Value;

    If GetWinMapping(tArrayId, tWinId) Then
      FWinId := tWinId
    Else
      MessageDlg ('Invalid Win Id', mtError, [mbOk], 0);
  End; { If }
End;


{------------------------------------------------------------------------------}

{$IFDEF PKG_On}

  Function TCustomisationEditor.GetVerbCount : Integer;
  Begin
    Result:= 1;
  End;

  Function TCustomisationEditor.GetVerb(Index : Integer) : String;
  Begin
    Case Index Of
      0 : Result := 'Edit Text';
    Else
      Result := '';
    End; { Case }
  End;


  Procedure TCustomisationEditor.ExecuteVerb(Index : Integer);
  Begin
    Case Index Of
      0 : Begin
            TCustomisation(Component).EditText;
          End;
    End; { Case }
  End;
{$ENDIF}

{ Registers the Components with Delphi }
procedure Register;
begin
  RegisterComponents('SBS', [TCustomisation, TSBSButton]);

  {$IFDEF PKG_On}
    RegisterComponentEditor(TCustomisation, TCustomisationEditor);
  {$ENDIF}
end;


Initialization
  CustomOn := True;
  CheckParams;
end.
