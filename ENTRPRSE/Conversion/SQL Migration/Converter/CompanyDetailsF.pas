unit CompanyDetailsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseF, EnterToTab, StdCtrls, ExtCtrls, CompanyDetailsFrame;

type
  TfrmReportingUsers = class(TfrmCommonBase)
    Panel1: TPanel;
    panIntro: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    panBody: TPanel;
    panFooter: TPanel;
    btnContinue: TButton;
    btnClose: TButton;
    scrlCompanies: TScrollBox;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnContinueClick(Sender: TObject);
  private
    // Array of frames containing company details
    FrameAry   : Array Of TframCompanyDetails;

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

Uses oConvertOptions;

//=========================================================================

procedure TfrmReportingUsers.FormCreate(Sender: TObject);
Var
  iCompanies, NextTop : LongInt;
begin
  inherited;

  Caption := Application.Title;

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := (Width - ClientWidth) + 741;        // take border sizing &
  MinSizeY := (Height - ClientHeight) + 290;      // captions into account

  // Load company details into separate frames in scrollbox
  NextTop := 1;
  SetLength (FrameAry, ConversionOptions.coCompanyCount);
  For iCompanies := 0 To (ConversionOptions.coCompanyCount - 1) Do
  Begin
    FrameAry[iCompanies] := TframCompanyDetails.Create(Self);
    With FrameAry[iCompanies] Do
    Begin
      Name := Name + IntToStr(iCompanies);
      Parent := scrlCompanies;
      Top := NextTop;
      Left := 1;

      Index := iCompanies + 1;
      CompanyDets := ConversionOptions.coCompanies[iCompanies];

      NextTop := NextTop + Height;
    End; // With FrameAry[iCompanies]
  End; // For iCompanies
end;

//-------------------------------------------------------------------------

Procedure TfrmReportingUsers.WMGetMinMaxInfo(Var Message : TWMGetMinMaxInfo);
Begin
  With Message.MinMaxInfo^ Do
  Begin
    ptMinTrackSize.X:=MinSizeX;
    ptMinTrackSize.Y:=MinSizeY;
  End; // With Message.MinMaxInfo^

  Message.Result:=0;

  Inherited;
end;

//-------------------------------------------------------------------------

procedure TfrmReportingUsers.btnContinueClick(Sender: TObject);
Var
  PreviousUsers : TStringList;
  iFrames : LongInt;
  OK : Boolean;
begin
  OK := True;

  // Run through the Frames validating the UID/Pwd and update ConversionOptions
  PreviousUsers := TStringList.Create;
  Try
    If (Length(FrameAry) > 0) Then
    Begin
      For iFrames := 0 To Pred(Length(FrameAry)) Do
      Begin
        If Not FrameAry[iFrames].ValidateReportingUser(PreviousUsers) Then
        Begin
          OK := False;
          Break;
        End; // If Not FrameAry[iFrames].ValidateReportingUser(PreviousUsers)
      End; // For iFrames
    End; // If (Length(FrameAry) > 0)
  Finally
    PreviousUsers.Free;
  End; // Try..Finally

  If OK Then
    ModalResult := mrOK;
end;

//-------------------------------------------------------------------------


end.
