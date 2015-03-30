unit StringConvertImp;
{$DEFINE STRINGCONVERTLIB}

interface
uses SysUtils;
{$I StrConvert.inc}

function InitStrConvert(APrepend, AAppend: String): TStringConvert; stdcall;

implementation

constructor TStringConvert.Create(APrepend, AAppend: String);
begin
  inherited Create;
  FPrepend := APrepend;
  FAppend  := AAppend;
end;

destructor TStringConvert.Destroy;
begin
  inherited Destroy;
end;

function TStringConvert.ConvertString(AConvertType: TConvertType; AString: String): String;
begin
  case AConvertType of
    ctUpper: Result := Format('%s%s%s', [FPrepend, UpperCase(AString), FAppend]);
    ctLower: Result := Format('%s%s%s', [FPrepend, LowerCase(AString), FAppend]);
  end;
end;

function InitStrConvert(APrepend, AAppend: String): TStringConvert;
begin
  Result := TStringConvert.Create(APrepend, AAppend);
end;

end.
