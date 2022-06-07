object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'FrmPrincipal'
  ClientHeight = 361
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object btnGetToken: TButton
    Left = 8
    Top = 35
    Width = 75
    Height = 25
    Caption = 'btnGetToken'
    TabOrder = 0
    OnClick = btnGetTokenClick
  end
  object edtToken: TEdit
    Left = 8
    Top = 8
    Width = 568
    Height = 21
    TabOrder = 1
  end
end
