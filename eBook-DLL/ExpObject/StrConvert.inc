type

  TConvertType = (ctUpper, ctLower);

  TStringConvert = class(TObject)
{$IFDEF STRINGCONVERTLIB}
  private
    FPrepend: String;
    FAppend : String;
{$ENDIF}
  public
    function ConvertString(AConvertType: TConvertType; AString: String): String;
      virtual; stdcall; {$IFNDEF STRINGCONVERTLIB} abstract; {$ENDIF}
{$IFDEF STRINGCONVERTLIB}
    constructor Create(APrepend, AAppend: String);
    destructor Destroy; override;
{$ENDIF}
  end;

{ For any application using this class, STRINGCONVERTLIB is not defined and
  therefore, the class definition will be equivalent to:

  TStringConvert = class(TObject)
  public
    function ConvertString(AConvertType: TConvertType; AString: String): String;
      virtual; stdcall; abstract;
  end;
}
