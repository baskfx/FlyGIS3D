object DLL1frm: TDLL1frm
  Left = 261
  Top = 94
  Width = 328
  Height = 227
  AutoSize = True
  Caption = '����������� ����������� �������'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PopupMenu = PopMnuTraektory
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 320
    Height = 200
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
  end
  object PopMnuTraektory: TPopupMenu
    Left = 24
    Top = 16
    object PopMnuEnding: TMenuItem
      Caption = '&��������� ����������'
      ShortCut = 16453
      OnClick = PopMnuEndingClick
    end
    object PopMnuUndo: TMenuItem
      Caption = '&�������� ��������� �����'
      ShortCut = 16474
      OnClick = PopMnuUndoClick
    end
    object PopMnuDelete: TMenuItem
      Caption = '&������� ���������� '
      ShortCut = 46
      OnClick = PopMnuDeleteClick
    end
  end
end
