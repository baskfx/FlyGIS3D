{
Copyright © 1998 by Delphi 4 Developer's Guide - Xavier Pacheco and Steve Teixeira
}

unit PenniesInt;
{ Interface routine for PENNIES.DLL }

interface
type

  { This record will hold the denominations after the conversion have
    been made }
  PCoinsRec = ^TCoinsRec;
  TCoinsRec = record
    Quarters,
    Dimes,
    Nickels,
    Pennies: word;
  end;

{$IFNDEF PENNIESLIB}
{ Declare function with export keyword }

function PenniesToCoins(TotPennies: word; CoinsRec: PCoinsRec): word; StdCall;
{$ENDIF}

implementation

{$IFNDEF PENNIESLIB}
{ Define the imported function }
function PenniesToCoins; external 'PENNIESLIB.DLL' name 'PenniesToCoins';
{$ENDIF}

end.
 