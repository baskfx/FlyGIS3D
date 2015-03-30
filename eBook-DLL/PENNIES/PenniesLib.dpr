{
Copyright © 1999 by Delphi 5 Developer's Guide - Xavier Pacheco and Steve Teixeira
}

library PenniesLib;
{$DEFINE PENNIESLIB}
uses
  SysUtils,
  Classes,
  PenniesInt;

function PenniesToCoins(TotPennies: word; CoinsRec: PCoinsRec): word; StdCall;
begin
  Result := TotPennies;  // Assign value to Result
  { Calculate the values for quarters, dimes, nickels, pennies }
  with CoinsRec^ do
  begin
    Quarters    := TotPennies div 25;
    TotPennies  := TotPennies - Quarters * 25;
    Dimes       := TotPennies div 10;
    TotPennies  := TotPennies - Dimes * 10;
    Nickels     := TotPennies div 5;
    TotPennies  := TotPennies - Nickels * 5;
    Pennies     := TotPennies;
  end;
end;

{ Export the function by name }
exports
  PenniesToCoins;
end.
