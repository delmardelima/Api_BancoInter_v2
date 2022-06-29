object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Exemple Api Banco Inter v2'
  ClientHeight = 421
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
  object Shape2: TShape
    Left = -5
    Top = 282
    Width = 600
    Height = 1
    Brush.Style = bsClear
    Pen.Color = clGray
  end
  object Label8: TLabel
    Left = 8
    Top = 217
    Width = 148
    Height = 17
    Caption = 'Procedure DownloadPDF:'
  end
  object Label9: TLabel
    Left = 45
    Top = 246
    Width = 46
    Height = 17
    Caption = 'ArqPDF:'
  end
  object Label10: TLabel
    Left = 488
    Top = 8
    Width = 88
    Height = 17
    Caption = 'Primeira Etapa:'
  end
  object Label11: TLabel
    Left = 485
    Top = 81
    Width = 91
    Height = 17
    Caption = 'Segunda Etapa:'
  end
  object Label12: TLabel
    Left = 490
    Top = 217
    Width = 86
    Height = 17
    Caption = 'Terceira Etapa:'
  end
  object Label13: TLabel
    Left = 8
    Top = 289
    Width = 147
    Height = 17
    Caption = 'Procedure ConsultBoleto:'
  end
  object Label14: TLabel
    Left = 496
    Top = 289
    Width = 80
    Height = 17
    Caption = 'Quarta Etapa:'
  end
  object Label15: TLabel
    Left = 39
    Top = 318
    Width = 52
    Height = 17
    Caption = 'Situacao:'
  end
  object Label16: TLabel
    Left = 297
    Top = 318
    Width = 63
    Height = 17
    Caption = 'ValorPago:'
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
    Enabled = False
    NumbersOnly = True
    TabOrder = 3
    Text = '0'
  end
  object edtCodigoBarras: TEdit
    Left = 97
    Top = 139
    Width = 398
    Height = 25
    Enabled = False
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
    Enabled = False
    TabOrder = 6
  end
  object edtArqPDF: TEdit
    Left = 97
    Top = 243
    Width = 384
    Height = 25
    TabOrder = 7
  end
  object btnDownloadPDF: TButton
    Left = 487
    Top = 243
    Width = 89
    Height = 25
    Caption = 'DownloadPDF'
    TabOrder = 8
    OnClick = btnDownloadPDFClick
  end
  object edtSituacao: TEdit
    Left = 97
    Top = 315
    Width = 168
    Height = 25
    Enabled = False
    TabOrder = 9
  end
  object edtValorPago: TEdit
    Left = 366
    Top = 315
    Width = 129
    Height = 25
    Enabled = False
    TabOrder = 10
  end
  object btnConsultBoleto: TButton
    Left = 501
    Top = 315
    Width = 75
    Height = 25
    Caption = 'Consult'
    TabOrder = 11
    OnClick = btnConsultBoletoClick
  end
end
