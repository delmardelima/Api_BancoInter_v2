# Consumo da API Banco Inter v2
Um exemplo em Delphi para consumo da API do Banco Inter v2 com autenticação OAUTH 2.0
## Documentação
Neste projeto é apresentado como consumir a API Banco Inter v2, usando a IDE Delphi VCL e o componente Indy.
Compatibilidade testada na versão do Delphi Rio, mas poderá funcionar em versão diferente.

Apresentado por Delmar de Lima (Cortes DEV).
### Token
#### Obter token oAuth
| Metodo                     | Link                                                         | Tipo                 |
| -------------------------- | ------------------------------------------------------------ | -------------------- |
| POST                       | https://cdpj.partners.bancointer.com.br/oauth/v2/token       | FORM DATA            |


| Parametro                  | Tipo            | Observação                                                        |
| -------------------------- | --------------- | ----------------------------------------------------------------- |
| client_id*                 | string          | obtido no detalhe da tela de aplicações no IB                     |
| client_secret*             | string          | obtido no detalhe da tela de aplicações no IB                     |
| grant_type*                | string          | GrantType que utilizamos, o default é (client_credentials)        |
| scope*                     | string          | Escopos cadastrados na tela de aplicações.                        |

Escopos disponíveis:
====================
extrato.read - Consulta de Extrato e Saldo
boleto-cobranca.read - Consulta de boletos e exportação para PDF
boleto-cobranca.write - Emissão e cancelamento de boletos

### Extrato
#### Consultar extrato
Metodo GET
https://cdpj.partners.bancointer.com.br/banking/v2/extrato
QUERY PARAMS
dataInicio* string
Data início da consulta de extrato.
Formato: YYYY-MM-DD

dataFim* string
Data fim da consulta de extrato.
Formato: YYYY-MM-DD

### Saldo
#### Consultar saldo
Metodo GET
https://cdpj.partners.bancointer.com.br/banking/v2/saldo
QUERY PARAMS
dataSaldo string
Data de consulta para o saldo posicional.
Formato: YYYY-MM-DD
OBS: Caso não seja informada, leva-se em consideração a data atual, assim, o retorno será o saldo atual.

### Boletos
#### Incluir boleto de cobrança
Método utilizado para incluir/emitir um novo boleto registrado.
O boleto incluído estará disponível para consulta e pagamento, após um tempo apróximado de 5 minutos da sua inclusão. Esse tempo é necessário para o registro do boleto na CIP.
Metodo POST
https://cdpj.partners.bancointer.com.br/cobranca/v2/boletos
BODY PARAMS
seuNumero* string
Campo Seu Número do título

valorNominal* float
Valor Nominal do título

valorAbatimento float
Valor de abatimento do título, expresso na mesma moeda do Valor Nominal

dataVencimento* string
Data de vencimento do título
Formato aceito: YYYY-MM-DD

numDiasAgenda* int32
Número de dias corridos após o vencimento para o cancelamento efetivo automático do boleto. (de 0 até 60)

pagador* object
{
cpfCnpj* string
CPF/CNPJ do pagador do título

tipoPessoa* string
Tipo do pagador: FISICA - Pessoa Física / JURIDICA - Pessoa Jurídica

nome* string
Nome do pagador

endereco* string
Endereço do pagador

numero string
Número no logradouro do pagador

complemento string
Complemento do endereço do pagador

bairro string
Bairro do pagador

cidade* string
Cidade do pagador

uf* string
UF do pagador

cep* string
CEP do pagador

email string
E-mail do pagador

ddd string
DDD do telefone do pagador

telefone string
Telefone do pagador
} 

mensagem object
{
linha1 string
Linha 1 do campo de texto do título

linha2 string
Linha 2 do campo de texto do título

linha3 string
Linha 3 do campo de texto do título

linha4 string
Linha 4 do campo de texto do título

linha5 string
Linha 5 do campo de texto do título
}

desconto1 object
{
codigoDesconto* string
Código de Desconto do título.
NAOTEMDESCONTO - Não tem desconto.
VALORFIXODATAINFORMADA - Valor fixo até a data informada.
PERCENTUALDATAINFORMADA - Percentual até a data informada.
VALORANTECIPACAODIACORRIDO - Valor por antecipação dia corrido.
VALORANTECIPACAODIAUTIL - Valor por antecipação dia útil.
PERCENTUALVALORNOMINALDIACORRIDO - Percentual sobre o valor nominal dia corrido.
PERCENTUALVALORNOMINALDIAUTIL - Percentual sobre o valor nominal dia útil.
PERCENTUALVALORNOMINALDIAUTIL

data string
Data de Desconto do título.
Obrigatório para códigos de desconto VALORFIXODATAINFORMADA e PERCENTUALDATAINFORMADA. Não informar para os demais
Formato aceito: YYYY-MM-DD

taxa float
Taxa Percentual de Desconto do título.
Obrigatório para códigos de desconto PERCENTUALDATAINFORMADA, PERCENTUALVALORNOMINALDIACORRIDO e PERCENTUALVALORNOMINALDIAUTIL

valor float
Valor de Desconto, expresso na moeda do título.
Obrigatório para códigos de desconto VALORFIXODATAINFORMADA, VALORANTECIPACAODIACORRIDO e VALORANTECIPACAODIAUTIL
}

multa object
{
codigoMulta* string
Código de Multa do título.
NAOTEMMULTA - Não tem multa
VALORFIXO – Valor fixo
PERCENTUAL - Percentual
VALORFIXO

data string
Data da Multa do título.
Obrigatório se informado código de multa VALORFIXO ou PERCENTUAL.
Deve ser maior que o vencimento e marca a data de início de cobrança de multa (incluindo essa data)
Formato aceito: YYYY-MM-DD

taxa float
Taxa Percentual de Multa do título. Obrigatória se informado código de multa PERCENTUAL
Deve ser 0 para código de multa NAOTEMMULTA

valor float
Valor de Multa expresso na moeda do título.
Obrigatório se informado código de multa VALORFIXO
Deve ser 0 para código de multa NAOTEMMULTA
}

mora object
{
codigoMora* string
Código de Mora do título.
VALORDIA - Valor ao dia
TAXAMENSAL - Taxa mensal
ISENTO - Isento
CONTROLEDOBANCO - Controle do banco
ISENTO

data string
Data da Mora do título.
Obrigatório se informado código de mora VALORDIA, TAXAMENSAL ou CONTROLEDOBANCO.
Deve ser maior que o vencimento e marca a data de início de cobrança de mora (incluindo essa data)
Formato aceito: YYYY-MM-DD

taxa float
Percentual de Mora do título.
Obrigatória se informado código de mora TAXAMENSAL

valor float
Valor de Mora expresso na moeda do título.
Obrigatório se informado código de mora TAXAMENSAL
Deve ser 0 para código de mora ISENTO
}

## Exemplos


## Suporte
Sinta-se à vontade para fazer perguntas através do WhatsApp: https://wa.me/5597991442486

## Doação
### Doações via PIX / Donations PIX: 
#### Email: delmar.apui@gmail.com
#### Celular: (97) 99144-2486

## Conheça
### YouTube: https://bit.ly/SeguirCortesDev
### WhatsApp: https://wa.me/5597991442486
### Instagram: https://www.instagram.com/cortesdevoficial/
### Facebook: https://www.fb.com/cortesdevoficial
### Layout Moderno em Delphi: https://bit.ly/LayoutModerno
### Site: https://amil.cnt.br/

## Licença
GNU General Public License v3.0 [GNU General][].

[GNU General]: https://raw.githubusercontent.com/delmardelima/Api_BancoInter_v2/main/LICENSE

Conheça mais no nosso blog: <br/>
**[>> CONHEÇA MAIS](https://www.amil.cnt.br/blog)**
