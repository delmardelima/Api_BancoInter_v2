object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'FrmPrincipal'
  ClientHeight = 355
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnEnviarBoleto: TButton
    Left = 552
    Top = 8
    Width = 75
    Height = 25
    Caption = 'EnviarBoleto'
    TabOrder = 0
    OnClick = btnEnviarBoletoClick
  end
  object mReturn: TMemo
    Left = 0
    Top = 39
    Width = 635
    Height = 316
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = -8
  end
  object btnGetToken: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'GetToken'
    TabOrder = 2
    OnClick = btnGetTokenClick
  end
  object edtToken: TEdit
    Left = 89
    Top = 8
    Width = 457
    Height = 25
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    TextHint = 'Informe o numero de Token'
  end
end
