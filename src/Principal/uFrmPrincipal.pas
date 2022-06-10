{ *****************************************************************
  *****************************************************************
  ** Neste projeto é apresentado como consumir a API v2 do       **
  ** Banco Inter com autenticação OAUTH 2.0, utilizando o Delphi **
  ** e o componente Indy. Compatibilidade testada na versão do   **
  ** Delphi Rio, mas poderá funcionar em versão diferente.       **
  ** Desenvolvido por Delmar de Lima (CortesDEV).                **
  *****************************************************************
  ** Segue CortesDEV nas redes sociais                           **
  ** Youtube:   https://bit.ly/SeguirCortesDev                   **
  ** Instagram: https://www.instagram.com/cortesdevoficial/      **
  ** Facebook:  https://www.fb.com/cortesdevoficial              **
  ** WhatsApp:  https://wa.me/5597991442486                      **
  ** Site:      https://amil.cnt.br/cortesdev                    **
  *****************************************************************
  ***************************************************************** }

unit uFrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uClasseBancoInter, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, Vcl.StdCtrls, Vcl.ExtCtrls, DateUtils;

type
  TFrmPrincipal = class(TForm)
    btnGetToken: TButton;
    edtToken: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtSeuNumero: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    spTop: TShape;
    edtNossoNumero: TEdit;
    Label5: TLabel;
    edtCodigoBarras: TEdit;
    Label6: TLabel;
    btnPostBoleto: TButton;
    Label7: TLabel;
    edtLinhaDigitavel: TEdit;
    Shape1: TShape;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGetTokenClick(Sender: TObject);
    procedure btnPostBoletoClick(Sender: TObject);
  private
    { Private declarations }
    BancoInter: TBancoInter;
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

procedure TFrmPrincipal.btnGetTokenClick(Sender: TObject);
begin
  BancoInter.GetToken;
  if BancoInter.Token = '' then
    BancoInter.Token := 'Error GetToken!';
  edtToken.Text := BancoInter.Token;
end;

procedure TFrmPrincipal.btnPostBoletoClick(Sender: TObject);
begin
  BancoInter.SeuNumero := edtSeuNumero.Text;
  BancoInter.ValorNominal := 10;
  BancoInter.DataVencimento := incDay(date, 30);
  // Dados fictícios, retirado do site 4devs.com.br/gerador_de_pessoas
  BancoInter.CpfCnpj := '0000000000';
  BancoInter.TipoPessoa := 'FISICA'; // JURIDICA
  BancoInter.Nome := 'DELMAR DE LIMA';
  BancoInter.Endereco := 'Rua Bahia';
  BancoInter.Numero := '493';
  BancoInter.Complemento := 'Casa';
  BancoInter.Bairro := 'Centro';
  BancoInter.Cidade := 'Manaus';
  BancoInter.UF := 'Amazonas';
  BancoInter.CEP := '69265000';
  BancoInter.Email := 'delmar.apui@gmail.com';
  BancoInter.DDD := '97';
  BancoInter.Telefone := '991442486';
  BancoInter.Linha1 := 'Curti nosso canal | CortesDEV';
  BancoInter.Linha2 := 'Desenvolvido por Delmar de Lima';
  BancoInter.DtDesconto := incDay(date, 20);
  BancoInter.TaxaDesconto := 1; // 0 -> 100
  BancoInter.DtMulta := incDay(date, 31);
  BancoInter.PostBoleto;
  edtSeuNumero.Text := BancoInter.SeuNumero;
  edtNossoNumero.Text := BancoInter.NossoNumero;
  edtCodigoBarras.Text := BancoInter.CodigoBarras;
  edtLinhaDigitavel.Text := BancoInter.LinhaDigitavel;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
  BancoInter := TBancoInter.Create(Self);
  BancoInter.CertFile := ExtractFilePath(ParamStr(0)) + 'certificado.crt';
  BancoInter.KeyFile := ExtractFilePath(ParamStr(0)) + 'chave.key';
  BancoInter.ClientID := '';
  BancoInter.ClientSecret := '';
  BancoInter.Scope := 'extrato.read boleto-cobranca.read boleto-cobranca.write';
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
  BancoInter.Free;
end;

end.
