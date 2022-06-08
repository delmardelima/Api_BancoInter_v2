object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exemple Api Banco Inter v2'
  ClientHeight = 371
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 17
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 109
    Height = 17
    Caption = 'Function GetToken:'
  end
  object Label2: TLabel
    Left = 8
    Top = 81
    Width = 129
    Height = 17
    Caption = 'Procedure PostBoleto:'
  end
  object Label3: TLabel
    Left = 19
    Top = 111
    Width = 72
    Height = 17
    Caption = 'SeuNumero:'
  end
  object Label4: TLabel
    Left = 54
    Top = 38
    Width = 37
    Height = 17
    Caption = 'Token:'
  end
  object spTop: TShape
    Left = 0
    Top = 74
    Width = 600
    Height = 1
    Brush.Style = bsClear
    Pen.Color = clGray
  end
  object Label5: TLabel
    Left = 280
    Top = 111
    Width = 89
    Height = 17
    Caption = 'NossoNumero:'
  end
  object Label6: TLabel
    Left = 8
    Top = 142
    Width = 83
    Height = 17
    Caption = 'CodigoBarras:'
  end
  object Label7: TLabel
    Left = 8
    Top = 173
    Width = 83
    Height = 17
    Caption = 'LinhaDigitavel:'
  end
  object Shape1: TShape
    Left = 0
    Top = 210
    Width = 594
    Height = 1
    Brush.Style = bsClear
    Pen.Color = clGray
  end
  object btnGetToken: TButton
    Left = 501
    Top = 35
    Width = 75
    Height = 25
    Caption = 'GetToken'
    TabOrder = 0
    OnClick = btnGetTokenClick
  end
  object edtToken: TEdit
    Left = 97
    Top = 35
    Width = 398
    Height = 25
    TabOrder = 1
  end
  object edtSeuNumero: TEdit
    Left = 97
    Top = 108
    Width = 120
    Height = 25
    Alignment = taCenter
    NumbersOnly = True
    TabOrder = 2
    Text = '1'
  end
  object edtNossoNumero: TEdit
    Left = 375
    Top = 108
    Width = 120
    Height = 25
    Alignment = taCenter
    NumbersOnly = True
    TabOrder = 3
    Text = '0'
  end
  object edtCodigoBarras: TEdit
    Left = 97
    Top = 139
    Width = 398
    Height = 25
    TabOrder = 4
  end
  object btnPostBoleto: TButton
    Left = 501
    Top = 170
    Width = 75
    Height = 25
    Caption = 'PostBoleto'
    TabOrder = 5
    OnClick = btnPostBoletoClick
  end
  object edtLinhaDigitavel: TEdit
    Left = 97
    Top = 170
    Width = 398
    Height = 25
    TabOrder = 6
  end
end
