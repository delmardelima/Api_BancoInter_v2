# Consumo da API Banco Inter v2
Um exemplo em Delphi para consumo da API do Banco Inter v2 com autenticação OAUTH 2.0
## Documentação Oficial do Banco Inter
**[>> CLICK PARA CONHECER](https://developers.bancointer.com.br/reference/)**
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

Escopos disponíveis: <br/>
extrato.read - Consulta de Extrato e Saldo <br/>
boleto-cobranca.read - Consulta de boletos e exportação para PDF <br/>
boleto-cobranca.write - Emissão e cancelamento de boletos <br/>

##### OBS: Parametro em asterisco "*" é obrigatorio. <br/>

### Extrato
#### Consultar extrato
| Metodo                     | Link                                                         | Tipo                 |
| -------------------------- | ------------------------------------------------------------ | -------------------- |
| GET                        | https://cdpj.partners.bancointer.com.br/banking/v2/extrato   | QUERY PARAMS         |


| Parametro                  | Tipo            | Observação                                                        |
| -------------------------- | --------------- | ----------------------------------------------------------------- |
| dataInicio*                | string          | Data início da consulta de extrato. Formato: YYYY-MM-DD           |
| dataFim*                   | string          | Data fim da consulta de extrato. Formato: YYYY-MM-DD              |

### Saldo
#### Consultar saldo
| Metodo                     | Link                                                         | Tipo                 |
| -------------------------- | ------------------------------------------------------------ | -------------------- |
| GET                        | https://cdpj.partners.bancointer.com.br/banking/v2/saldo     | QUERY PARAMS         |


| Parametro                  | Tipo            | Observação                                                        |
| -------------------------- | --------------- | ----------------------------------------------------------------- |
| dataSaldo                  | string          | Data de consulta para o saldo posicional. Formato: YYYY-MM-DD     |

OBS: Caso *dataSaldo* não seja informada, leva-se em consideração a data atual, assim, o retorno será o saldo atual.

### Boletos
#### Incluir boleto de cobrança
Método utilizado para incluir/emitir um novo boleto registrado.<br/>
O boleto incluído estará disponível para consulta e pagamento, após um tempo apróximado de 5 minutos da sua inclusão. Esse tempo é necessário para o registro do boleto na CIP.<br/>
| Metodo                     | Link                                                         | Tipo                 |
| -------------------------- | ------------------------------------------------------------ | -------------------- |
| POST                       | https://cdpj.partners.bancointer.com.br/cobranca/v2/boletos  | BODY PARAMS          |


| Parametro                  | Tipo            | Observação                                                              |
| -------------------------- | --------------- | ----------------------------------------------------------------------- |
| seuNumero*                 | string          | Campo Seu Número do título                                              |
| valorNominal*              | float           | Valor Nominal do título                                                 |
| valorAbatimento            | float           | Valor de abatimento do título, expresso na mesma moeda do Valor Nominal |
| dataVencimento*            | string          | Data de vencimento do título. Formato aceito: YYYY-MM-DD                |
| numDiasAgenda*             | int32           | Número de dias corridos para o cancelamento do boleto. (de 0 até 60)    |
| pagador*                   | object          | Dados do pagador                                                        |
| mensagem                   | object          | Mensagem de instrução de pagamento                                      |
| desconto1                  | object          | Tipo de desconto de pagamento                                           |
| multa                      | object          | Multa por falta de pagamento                                            |
| mora                       | object          | Mora por falta de pagmento                                              |

##### Object Pagador
| Parametro                  | Tipo            | Observação                                                              |
| -------------------------- | --------------- | ----------------------------------------------------------------------- |
| cpfCnpj*                   | string          | CPF/CNPJ do pagador do título                                           |
| tipoPessoa*                | string          | Tipo do pagador: FISICA - Pessoa Física / JURIDICA - Pessoa Jurídica    |
| nome*                      | string          | Nome do pagador                                                         |
| endereco*                  | string          | Endereço do pagador                                                     |
| numero                     | string          | Número no logradouro do pagador                                         |
| complemento                | string          | Complemento do endereço do pagador                                      |
| bairro                     | string          | Bairro do pagador                                                       |
| cidade*                    | string          | Cidade do pagador                                                       |
| uf*                        | string          | UF do pagador                                                           |
| cep*                       | string          | CEP do pagador                                                          |
| email                      | string          | E-mail do pagador                                                       |
| ddd                        | string          | DDD do telefone do pagador                                              |
| telefone                   | string          | Telefone do pagador                                                     |

##### Object Mensagem
| Parametro                  | Tipo            | Observação                                                              |
| -------------------------- | --------------- | ----------------------------------------------------------------------- |
| linha1                     | string          | Linha 1 do campo de texto do título. Até a Linha 5                      |

##### Object Desconto1
| Parametro                  | Tipo            | Observação                                                              |
| -------------------------- | --------------- | ----------------------------------------------------------------------- |
| codigoDesconto*            | string          | Código de Desconto do título.                                           |
| data                       | string          | Data de Desconto do título. Formato aceito: YYYY-MM-DD                  |
| taxa                       | float           | Taxa Percentual de Desconto do título.                                  |
| valor                      | float           | Valor de Desconto, expresso na moeda do título.                         |

Código de Desconto disponíveis: <br/>
NAOTEMDESCONTO - Não tem desconto.  <br/>
VALORFIXODATAINFORMADA - Valor fixo até a data informada. <br/>
PERCENTUALDATAINFORMADA - Percentual até a data informada. <br/>
VALORANTECIPACAODIACORRIDO - Valor por antecipação dia corrido. <br/>
VALORANTECIPACAODIAUTIL - Valor por antecipação dia útil. <br/>
PERCENTUALVALORNOMINALDIACORRIDO - Percentual sobre o valor nominal dia corrido. <br/>
PERCENTUALVALORNOMINALDIAUTIL - Percentual sobre o valor nominal dia útil. <br/>

OBS: *data* obrigatória para códigos de desconto VALORFIXODATAINFORMADA e PERCENTUALDATAINFORMADA. Não informar para os demais <br/>
OBS: *taxa* obrigatória para códigos de desconto PERCENTUALDATAINFORMADA, PERCENTUALVALORNOMINALDIACORRIDO e PERCENTUALVALORNOMINALDIAUTIL <br/>
OBS: *valor* obrigatória para códigos de desconto VALORFIXODATAINFORMADA, VALORANTECIPACAODIACORRIDO e VALORANTECIPACAODIAUTIL <br/>

##### Object Multa
| Parametro                  | Tipo            | Observação                                                              |
| -------------------------- | --------------- | ----------------------------------------------------------------------- |
| codigoMulta*               | string          | Código de Multa do título.                                              |
| data                       | string          | Data da Multa do título. Formato aceito: YYYY-MM-DD                     |
| taxa                       | float           | Taxa Percentual de Multa do título.                                     |
| valor                      | float           | Valor de Multa, expresso na moeda do título.                            |

Código de Multa disponíveis: <br/>
NAOTEMMULTA - Não tem multa <br/>
VALORFIXO – Valor fixo <br/>
PERCENTUAL - Percentual <br/>

OBS: *data* obrigatória se informado código de multa VALORFIXO ou PERCENTUAL. <br/>
Deve ser maior que o vencimento e marca a data de início de cobrança de multa (incluindo essa data) <br/>

OBS: *taxa* obrigatória se informado código de multa PERCENTUAL <br/>
Deve ser 0 para código de multa NAOTEMMULTA <br/>

OBS: *valor* obrigatório se informado código de multa VALORFIXO <br/>
Deve ser 0 para código de multa NAOTEMMULTA <br/>

##### Object Mora
| Parametro                  | Tipo            | Observação                                                              |
| -------------------------- | --------------- | ----------------------------------------------------------------------- |
| codigoMora*                | string          | Código de Mora do título.                                              |
| data                       | string          | Data da Mora do título. Formato aceito: YYYY-MM-DD                     |
| taxa                       | float           | Taxa Percentual de Mora do título.                                     |
| valor                      | float           | Valor de Mora, expresso na moeda do título.                            |

Código de Mora disponíveis: <br/>
VALORDIA - Valor ao dia <br/>
TAXAMENSAL - Taxa mensal <br/>
ISENTO - Isento <br/>
CONTROLEDOBANCO - Controle do banco <br/>

OBS: *data* obrigatório se informado código de mora VALORDIA, TAXAMENSAL ou CONTROLEDOBANCO. <br/>
Deve ser maior que o vencimento e marca a data de início de cobrança de mora (incluindo essa data) <br/>

OBS: *taxa* obrigatória se informado código de mora TAXAMENSAL <br/>

OBS: *valor* obrigatório se informado código de mora TAXAMENSAL <br/>
Deve ser 0 para código de mora ISENTO <br/>

## Exemplos

## Suporte
Sinta-se à vontade para fazer perguntas através do WhatsApp: https://wa.me/5597991442486

## Doação
### Doações via PIX / Donations PIX: 
#### Email: delmar.apui@gmail.com
#### Celular: (97) 99144-2486

## Conheça
##### [YouTube][]. 
##### [WhatsApp][].
##### [Instagram][].
##### [Facebook][]. 
##### [Layout Moderno em Delphi][].
##### [Site][]. <br/>

Conheça mais no nosso blog: <br/>
**[>> CONHEÇA MAIS](https://www.amil.cnt.br/blog)**

## Licença
GNU General Public License v3.0 [GNU General][].

[GNU General]: https://raw.githubusercontent.com/delmardelima/Api_BancoInter_v2/main/LICENSE
[YouTube]: https://bit.ly/SeguirCortesDev
[WhatsApp]: https://wa.me/5597991442486
[Instagram]: https://www.instagram.com/cortesdevoficial/
[Facebook]: https://www.fb.com/cortesdevoficial
[Layout Moderno em Delphi]: https://bit.ly/LayoutModerno
[Site]: https://amil.cnt.br/
