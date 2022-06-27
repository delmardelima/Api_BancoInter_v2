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

unit uFrm.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uClasseBancoInter, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, Vcl.StdCtrls, Vcl.ExtCtrls, DateUtils, ShellApi;

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
    Shape2: TShape;
    Label8: TLabel;
    Label9: TLabel;
    edtArqPDF: TEdit;
    btnDownloadPDF: TButton;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGetTokenClick(Sender: TObject);
    procedure btnPostBoletoClick(Sender: TObject);
    procedure btnDownloadPDFClick(Sender: TObject);
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

procedure TFrmPrincipal.btnDownloadPDFClick(Sender: TObject);
begin
  BancoInter.NossoNumero := edtNossoNumero.Text;
  BancoInter.DownloadPDF;
  edtArqPDF.Text := BancoInter.ArqPDF;
  if FileExists(BancoInter.ArqPDF) then
    ShellExecute(Handle, nil, PChar(BancoInter.ArqPDF), nil, nil,
      SW_SHOWNORMAL);
end;

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
  BancoInter.CpfCnpj := '96730102268';
  BancoInter.TipoPessoa := 'FISICA'; // JURIDICA
  BancoInter.Nome := 'Thomas Cláudio Bernardes';
  BancoInter.Endereco := 'Avenida 13 de Novembro';
  BancoInter.Numero := '697';
  BancoInter.Complemento := 'Casa';
  BancoInter.Bairro := 'Centro';
  BancoInter.Cidade := 'Apui';
  BancoInter.UF := 'AM';
  BancoInter.CEP := '69265000';
  BancoInter.Email := 'thomas_claudio_bernardes@lidertel.com.br';
  BancoInter.DDD := '97';
  BancoInter.Telefone := '981200415';
  BancoInter.Linha1 := 'Curti nosso canal | CortesDEV';
  BancoInter.Linha2 := 'Desenvolvido por Delmar de Lima';
  BancoInter.DtDesconto := incDay(date, 20);
  BancoInter.TaxaDesconto := 1; // 0 -> 100
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
  BancoInter.ClientID := 'e9f9df86-3478-47c0-b720-30e6c373b85d';
  BancoInter.ClientSecret := '040ba175-76ea-40d9-9375-0dd093a77624';
  BancoInter.Scope := 'extrato.read boleto-cobranca.read boleto-cobranca.write';
end;

procedure TFrmPrincipal.FormDestroy(Sender: TObject);
begin
  BancoInter.Free;
end;

end.
