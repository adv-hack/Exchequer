{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit NDRVStream;

interface

uses
	Classes;

Type
  TNDStream = class(TStream)
  // IMPORTANT!!!!!!!!
  // NO data members may exist in this class
  // This class is used to "hackcast" a TStream to add functionality
  public
    procedure Write(const AData: string); reintroduce;
    procedure Writeln(const AData: string = ''); overload;
    procedure Writeln(const AData: string; const AArgs: array of const); overload;
  end;

	TTempFileStream = Class(TFileStream)
	private
	protected
		FsFileName: String;
	public
		property FileName: String read FsFileName;
		//
		constructor Create(const FileName: string; Mode: Word);
		destructor Destroy; Override;
	published
	end;

implementation

uses
  SysUtils;

destructor TTempFileStream.Destroy;
begin
	inherited;
	// After, file has to be closed first
  SysUtils.DeleteFile(fsFilename)
end;

constructor TTempFileStream.Create;
begin
	inherited;
	fsFileName := FileName;
end;

{ TNDStream }

procedure TNDStream.Write(const AData: string);
begin
  WriteBuffer(AData[1], Length(AData));
end;

procedure TNDStream.Writeln(const AData: string = '');
begin
  Write(AData + #13#10);
end;

procedure TNDStream.Writeln(const AData: string; const AArgs: array of const);
begin
  Writeln(Format(AData, AArgs));
end;

end.