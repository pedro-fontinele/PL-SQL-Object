create or replace procedure SP_IMP_EDIPEDVENDA(pnseqedipedvenda in edi_pedvenda.seqedipedvenda%type,
                                                 pnnrorepresentante in edi_pedvenda.nrorepresentante%type default null) is
  vnseqpessoa ge_pessoa.seqpessoa%type;
  vscodcritica mad_criticapedconfig.codcritica%type; -----anterior
  vnseqitem integer;
  vnpercdescfinanc mrl_clienteseg.percmaxdescfinanc%type;
  vspd_descfincliente max_parametro.valor%type;
  vspd_usaregraincentivo max_parametro.valor%type;
  vnnropedvenda mad_pedvenda.nropedvenda%type;
  vnprazoregra mad_pedvendaregra.prazoadicional%type;
  vngeraalteracaoestq max_codgeraloper.geralteracaoestq%type;
  vspd_utiltransfoutempresa max_parametro.valor%type;
  vspd_utilpeditemmultiempresa max_parametro.valor%type;
  vnnewnropedvenda mad_pedvenda.nropedvenda%type;
  vnindexigeestoque mad_parametro.indexigeestoque%type;
  vnnropedvendaref mad_pedvenda.nropedvenda%type;
  vnsituacaopedref mad_pedvenda.situacaoped%type;
  vsindusaindenizacao mad_parametro.indusaindenizacao%type;
  vstipoindenizacao mad_parametro.tipoindenizacao%type;
  vspedidoindeniz varchar2(1);
  vnseqpessoaend mad_pedvenda.seqpessoaend%type;
  vnnrotabvenda mad_tabvenda.nrotabvenda%type;
  vnnroempresamultiemppedpalm mad_tabvenda.nroempresamultiemppedpalm%type;
  vnnropedvendatransf mad_pedvenda.nropedvenda%type;
  vspdatualizaacresdesccli max_parametro.valor%type;
  vsindexigeestoquecgo max_codgeraloper.indexigeestoquecgo%type;
  vninconsistencia number default 0;
  vspdverifsaldopromoc max_parametro.valor%type;
  vnnrosegmento mad_pedvenda.nrosegmento%type;
  vnqtdpromo mrl_promocaoitem.qtdlimiteuso%type;
  vnseqrecado number;
  vnnrorepresentante mad_pedvenda.nrorepresentante%type;
  vnqtdpedida mad_pedvendaitem.qtdpedida%type;
  vncount number default 0;
  vnqtdlimitepromoc mrl_promocaoitem.qtdlimiteuso%type;
  vnvlritens number;
  vnnrocondpagto mad_gradepedwebcondpagto.nrocondicaopagto%type;
  vnnrocondpagtopadrao mad_pedvendaitem.nrocondicaopagto%type;
  vssituacaopedido edi_pedvenda.statuspedecommerce%type;
  vsindecommerce edi_pedvenda.indecommerce%type;
  vnexistepromoc integer;
  vsgeradigseqpessoa ge_parametro.geradigseqpessoa%type;
  vspdinscomponentesprodcompvar max_parametro.valor%type;
  vscgoboniffornec max_parametro.valor%type;
  vnpdcgoboniffornec number;
  vnvlrtotpedido mad_pedvendaitem.vlrembinformado%type;
  vnvlrtotverba mad_pedvendaverbaafv.vlrverba%type;
  vnqtdbonificada mad_pedvendaitem.qtdbonificada%type;
  vncountpessoa number;
  vnnrocgccnpj number;
  vnseqpessoacliente number;
  vsindpreseparapedido mad_parametro.indpreseparapedido%type;
  vspdgravastatussepauto max_parametro.valor%type;
  vspdcgostatussepauto max_parametro.valor%type;
  vslistacgossepauto max_parametro.valor%type;
  vspd_recalcdesconto max_parametro.valor%type;
  vnseqpessoasemdig ge_pessoa.seqpessoa%type;
  vspdusadescmaxfornecedor max_parametro.valor%type;
  vnpercmaxdescforn mad_famsegmento.percmaxdescforn%type;
  vnpercdescforn mad_famsegmento.percmaxdescforn%type;
  vnvlrembdescfornec mad_pedvendaitem.vlrembdescfornec%type;
  vserro varchar2(1000);
  obj_param_smtp c5_tp_param_smtp;
  vdpdemailerroimportacao max_parametro.valor%type;
  vsmensagem clob;
  vspdedidiasverifsefaz number;
  vddtaultconssefaz mrl_cliente.dtaultconssefaz%type;
  vsindrestricaosefaz mrl_cliente.indrestricaosefaz%type;
  vsufsefaz ge_pessoa.uf%type;
  vsresultsefaz mrl_cliente.indrestricaosefaz%type;
  vnexisteconfigsefazws number;
  vnexisteconfigsefazemp number;
  vnseqpessoaemp max_empresa.seqpessoaemp%type;
  vnvlrdespacessoria edi_pedvenda.vlrdespacessoria%type;
  vncalcdespacessoria edi_pedvenda.vlrdespacessoria%type;
  vnaliqrateiodespacessoria number;
  vnformataxaconv mad_parametro.formataxaconv%type;
  vnminseqpedvendaitem edi_pedvendaitem.seqpedvendaitem%type;
  vsindtiposeparacaoecom varchar2(1);
  vsusugeracao varchar2(20);
  vsnropedvendacarga edi_pedvenda.nropedvenda%type;
  vspdufclientesubtrairicmsst max_parametro.valor%type;
  vnclienteecommerce ge_pessoa.seqpessoa%type;
  vsnomerazaopadraosubst max_parametro.valor%type;
  vnseqcidade ge_cidade.seqcidade%type;
  vnseqlogradouro ge_logradouro.seqlogradouro%type;
  vnseqbairro ge_bairro.seqbairro%type;
  vsnomerazaoold ge_pessoa.nomerazao%type;
  vsusuario varchar2(12);
  vnnrosegmentoecommerce max_parametro.valor%type;
  vsstatussegecommerce mrl_clienteseg.status%type;
  vnseqtituloecommerce mrl_titulofin.seqtitulo%type;
  vnstatuspedido mad_statuspedvdaecommerce.statusc5ecommerce%type;
  vncgoecommerce mad_parametroecommerce.codgeraloper%type;
  vscgccpf varchar2(20);
  vsfisicajuridica ge_pessoa.fisicajuridica%type;
  vsinscricaorg ge_pessoa.inscricaorg%type;
  vsmsgconsulta varchar2(4000);
  vspdimportacomissaoafv varchar2(1);
  vnnroempresasec max_empresaatendimentosec.nroempresasec%type;
  vsindfaturaautopedecomm mad_parametro.indfaturaautopedecomm%type;
  vsstatusseparacao mad_pedvenda.statusseparacao%type;
  vnexistensu integer;
  vncountcritica integer;
  vrtpessoa ge_pessoa%rowtype;
  vnnropedvendarateio mad_pedvenda.nropedvenda%type;
  vnnroemprateio max_empresa.nroempresa%type;
  vnnroemppedido max_empresa.nroempresa%type;
  v_numero_itens_edi number;
  v_numero_itens_mad number;
  v_erro exception;
begin
  --o pd abaixo é utilizado na view madv_pedvendasemnsu
  sp_checaparamdinamico('EXPORTACAO_GERAL', 0, 'NROFORMAPAGTO_NSU', 'S',
                        '999999',
                        'INFORMA O NUMERO DA FORMA DE PAGAMENTO PARA VERIFICAÇÃO DAS NOTAS SEM NSU VINCULADO NO E-COMMERCE?' ||
                         chr(13) || chr(10) || '999999-NÃO USA.' || chr(13) ||
                         chr(10) ||
                         'OBS: MAIS DE UMA FORMA SEPARAR POR VÍRGULA. Ex: 1,2,3 ');
  sp_buscaparamdinamico('EDI_CAPTURA_PEDIDO', 0,
                        'NOMERAZAO_PADRAO_PARA_SUBST', 'S',
                        'CADASTRADO PELO CPF\CNPJ, INCLUIDO DIRETAMENTE PELO SISTEMA, CADASTRADO AUTOMATICAMENTE',
                        'INFORMA A DESCRIÇÃO PADRÃO PARA SUBSTITUIÇÃO DOS DADOS DA PESSOA QUANDO ESTA JÁ EXISTIR ' ||
                         chr(13) || chr(10) ||
                         'NA GE_PESSOA. INFORMAR OS NOMES RAZÃO SEPARADOS POR VÍRGULA.',
                        vsnomerazaopadraosubst);
  sp_buscaparamdinamico('EDI_CAPTURA_PEDIDO', 0, 'IMPORTA_COMISSAO_AFV',
                        'S', 'N',
                        'IMPORTA VALOR DE COMISSÃO ENVIADO PELO AFV?' ||
                         chr(13) || chr(10) || 'S-SIM' || chr(13) || chr(10) ||
                         'N-NÃO(PADRÃO)', vspdimportacomissaoafv);
  -- parametros
  sp_buscaparamdinamico('EDI_CAPTURA_PEDIDO', 0,
                        'DESC_CLIENTE_EDI_PEDVENDA', 'S', 'N',
                        'BUSCA DESCONTO FINANCEIRO DO CLIENTE NO EDI_PEDVENDA?(S/N) VALOR PADRÃO = N.' ||
                         chr(13) || chr(10) ||
                         'OBS:VALOR ''N'' = CONSIDERA APENAS DESC ENVIADO NA TABELA EDI_PEDVENDA.' ||
                         chr(13) || chr(10) ||
                         '        VALOR ''S'' =  VERIFICA SE EXISTE PERC.DE DESC NO CADASTRO CLIENTE/SEGMENTO E O PRIORIZA',
                        vspd_descfincliente);
  sp_buscaparamdinamico('EDI_CAPTURA_PEDIDO', 0, 'USA_REGRA_INCENTIVO', 'S',
                        'N',
                        'APLICA REGRA DE INCENTIVO NOS PEDIDOS CAPTURADOS PELO EDI?(S=SIM/N=NÃO) VALOR PADRÃO = N.',
                        vspd_usaregraincentivo);
  sp_checaparamdinamico('EDI_CAPTURA_PEDIDO', 0, 'IMP_PED_ERRO_EMAIL', 'S',
                        'N',
                        'IMPORTA PEDIDOS CAPTURADOS PELO EDI MESMO QUE O EMAIL AUTOMÁTICO FOI ENVIADO DEVIDO ALGUM ERRO NO SERVIÇO DE SMTP? S-SIM/N-NÃO. VALOR PADRÃO N.');
  sp_buscaparamdinamico('EDI_CAPTURA_PEDIDO', 0,
                        'ATUALIZA_ACRES_DESC_CLIENTE', 'S', 'N',
                        'ATUALIZA ACRESCIMO/DESCONTO ASSOCIADO AO CLIENTE NOS PEDIDOS CAPTURADOS PELO EDI? (S=SIM/N=NAO)' ||
                         chr(13) || '
      VALOR PADRAO N.', vspdatualizaacresdesccli);
  sp_buscaparamdinamico('EDI_CAPTURA_PEDIDO', 0, 'VERIFICA_SALDO_PROMOC',
                        'S', 'N',
                        'VERIFICAR SALDO DA PROMOÇÃO PARA REALIZAR CORTE NOS PEDIDO? S-SIM/N-NÃO. VALOR PADRÃO N.',
                        vspdverifsaldopromoc);
  sp_buscaparamdinamico('EDI_CAPTURA_PEDIDO', 0, 'USA_DESC_MAX_FORNECEDOR',
                        'S', 'N',
                        'UTILIZA PERCENTUAL MÁXIMO DE DESCONTO DE FORNECEDOR?' ||
                         chr(13) || chr(10) || 'S-SIM' || chr(13) || chr(10) ||
                         'N-NÃO(PADRÃO)', vspdusadescmaxfornecedor);
  sp_buscaparamdinamico('EDI_CAPTURA_PEDIDO', 0, 'DIAS_VERIF_CLIENTE_SEFAZ',
                        'N', '-1',
                        'QUANTIDADE EM DIAS PARA VERIFICAR A SITUAÇÃO CADASTRAL DO CLIENTE NA SEFAZ.' ||
                         chr(13) || chr(10) ||
                         '-1 - NÃO VERIFICA(VALOR PADRÃO)' || chr(13) ||
                         chr(10) ||
                         'OBS: SERÁ UTILIZADO A DATA ATUAL MENOS A DATA DE ÚLTIMA VERIFICAÇÃO.',
                        vspdedidiasverifsefaz);
  sp_buscaparamdinamico('EDI_CAPTURA_PEDIDO', 0, 'EMAIL_ERRO_IMPORT', 'S',
                        'N',
                        'ENVIAR EMAIL QUANDO DER ERRO DE BANCO NA IMPORTACAO DO PEDIDO. DIGITAR EMAILS SEPARADOS POR VIRGULA. N-NÃO ENVIA(VALOR PADRÃO)',
                        vdpdemailerroimportacao);
  -- rc 154452
  sp_buscaparamdinamico('EDI_CAPTURA_PEDIDO', 0, 'RECALC_DESC_EDI_PEDVDA',
                        'S', 'N',
                        'RECALCULA VALOR DE DESCONTO NO PEDIDO NO MESMO FORMATO EFETUADO PELO APLICATIVO VENDA.',
                        vspd_recalcdesconto);
  for t in (select a.*
              from edi_pedvendacliente a
             where a.statusimportacao = 'P'
               and a.nrorepresentante =
                   nvl(pnnrorepresentante, a.nrorepresentante))
  loop
    vninconsistencia := 0;
    sp_imp_edipedvendacritica(null, t.seqedipedvendacliente, null, 'C',
                              vninconsistencia, to_number(t.nrocgccpf),
                              to_number(t.digcgccpf)); --faz consistencia do cliente
    if vninconsistencia = 0 then
      select count(1)
        into vnclienteecommerce
        from edi_pedvenda x
       where x.nroempresa = t.nroempresa
         and x.nropedidoafv = t.nropedidoafv
         and x.indecommerce = 'S';
      --busca a pessoa exclusivamente por cpf/cnpj
      if vnclienteecommerce > 0 then
        vsusuario := 'PED_WEB';
        select coalesce(max(a.seqpessoa), 0), coalesce(max(a.nomerazao), '')
          into vnseqpessoa, vsnomerazaoold
          from ge_pessoa a
         where a.nrocgccpf = to_number(t.nrocgccpf)
           and a.digcgccpf = to_number(t.digcgccpf);
      else
        vsusuario := 'AFV';
        select coalesce(max(p.seqpessoa), 0)
          into vnseqpessoa
          from ge_pessoa p
         where p.nrocgccpf = t.nrocgccpf;
      end if;
      if vnclienteecommerce > 0 then
        --verificação se o endereço informado já existe no catálogo de endereços
        select coalesce(max(a.seqpessoaend), 0)
          into vnseqpessoaend
          from ge_pessoaend a
         where a.seqpessoa = vnseqpessoa
           and a.cep = t.cep
           and a.uf = upper(t.uf)
           and fc5limpaacento(upper(a.cidade)) =
               fc5limpaacento(upper(t.cidade))
           and fc5limpaacento(upper(a.logradouro)) =
               fc5limpaacento(upper(t.logradouro))
           and fc5limpaacento(upper(a.nrologradouro)) =
               fc5limpaacento(upper(t.nrologradouro));
        --seleciona a cidade levando em consideração os dados informados
        --caso não encontrada, será inserida uma nova cidade baseada na uf informada
        select max(a.seqcidade)
          into vnseqcidade
          from ge_cidade a
         where fc5limpaacento(upper(a.cidade)) =
               fc5limpaacento(upper(t.cidade))
           and upper(a.uf) = upper(t.uf);
        if vnseqcidade is null then
          vnseqcidade := s_seqcidade.nextval;
          insert into ge_cidade
            (exglogradouro, exgbairro, dtaalteracao, nrobaseexportacao,
             usualteracao, uf, cidade, seqcidade)
          values
            ('N', 'N', sysdate, 0, vsusuario, fc5limpaacento(upper(t.uf)),
             fc5limpaacento(upper(t.cidade)), vnseqcidade);
        end if;
        --seleciona o bairro baseado na cidade informada
        --caso não encontrado, será inserido um novo bairro baseado na cidade informada
        select max(a.seqbairro)
          into vnseqbairro
          from ge_bairro a
         where a.seqcidade = vnseqcidade
           and fc5limpaacento(upper(a.bairro)) =
               fc5limpaacento(upper(t.bairro));
        if vnseqbairro is null then
          vnseqbairro := s_seqbairro.nextval;
          insert into ge_bairro
            (seqcidade, seqbairro, bairro)
          values
            (vnseqcidade, vnseqbairro, fc5limpaacento(upper(t.bairro)));
        end if;
        --verifica se existe o logradouro na cidade informada
        --caso não encontrado, será inserido um novo logradouro baseado na cidade informada
        select max(a.seqlogradouro)
          into vnseqlogradouro
          from ge_logradouro a
         where a.seqcidade = vnseqcidade
           and fc5limpaacento(upper(a.logradouro)) =
               fc5limpaacento(upper(t.logradouro));
        if vnseqlogradouro is null then
          vnseqlogradouro := s_seqlogradouro.nextval;
          insert into ge_logradouro
            (seqcidade, seqlogradouro, logradouro)
          values
            (vnseqcidade, vnseqlogradouro,
             fc5limpaacento(upper(t.logradouro)));
        end if;
        --parâmetro dinâmico: nomerazao_padrao_para_subst
        --caso o nomerazao da pessoa esteja dentro de algum elemento deste parâmetro dinâmico
        --será gerada uma versão da pessoa com os dados antes de atualizar
        select count(1)
          into vncount
          from (select a.column_value
                   from table(cast(c5_complexin.c5intable(vsnomerazaopadraosubst) as
                                    c5instrtable)) a
                  where upper(a.column_value) = upper(vsnomerazaoold));
        if vncount > 0 and vnseqpessoa > 0 then
          insert into ge_pessoaversao
            (seqpessoa, versao, nomerazao, cidade, uf, bairro,
             enderecocompleto, cep, nrocgccpf, digcgccpf, inscricaorg,
             dtaatualizacao, usualterou, justificativa, indreplicacao,
             indgeroureplic, fisicajuridica, indmicroempresa, email,
             emailnfe, inscinss)
            select seqpessoa, versao, nomerazao, cidade, uf, bairro,
                   logradouro || ' ' || nrologradouro || ' ' ||
                    a.cmpltologradouro, cep, nrocgccpf, digcgccpf,
                   inscricaorg, trunc(sysdate), vsusuario,
                   'Importação de Pedidos WEB.', null, null, fisicajuridica,
                   indmicroempresa, email, emailnfe, inscinss
              from ge_pessoa a
             where seqpessoa = vnseqpessoa;
        end if;
      end if;
      if vnseqpessoa = 0 then
        select nvl(max(a.geradigseqpessoa), 'N')
          into vsgeradigseqpessoa
          from ge_parametro a
         where a.nroempresa = t.nroempresa;
        if vsgeradigseqpessoa = 'S' then
          select a.sequencia + 1
            into vnseqpessoa
            from ge_sequencia a
           where a.nometabela = 'GE_PESSOA'
             for update;
          vnseqpessoasemdig := vnseqpessoa;
          vnseqpessoa := substr(vnseqpessoa || fc5_digmodulo11(vnseqpessoa),
                                1, 8);
        else
          select a.sequencia + 1
            into vnseqpessoa
            from ge_sequencia a
           where a.nometabela = 'GE_PESSOA'
             for update;
        end if;
        insert into ge_pessoa
          (seqpessoa, versao, status, dtaativacao, nomerazao, fantasia,
           palavrachave, fisicajuridica, sexo, seqcidade, cidade, uf, pais,
           seqbairro, bairro, seqlogradouro, logradouro, nrologradouro,
           cmpltologradouro, cep, foneddd1, fonenro1, fonecmpl1, foneddd2,
           fonenro2, fonecmpl2, foneddd3, fonenro3, fonecmpl3, faxddd,
           faxnro, nrocgccpf, digcgccpf, inscricaorg, dtanascfund, origem,
           codclientefora, email, homepage, estadocivil, atividade,
           rendafaturamento, grauinstrucao, grupo, porte, dtainclusao,
           usuinclusao, dtaalteracao, usualteracao, dtainativacao,
           usuinativacao, obsinativacao, indcontribicms, indreplicacao,
           indgeroureplic, indprodrural, inscmunicipal, emailnfe)
          select vnseqpessoa, 0 versao,
                 decode(vnclienteecommerce, 0, 'P', 'A') status,
                 null dtaativacao, t.nomerazao, t.fantasia,
                 null palavrachave, t.fisicajuridica, t.sexo,
                 vnseqcidade seqcidade, t.cidade, t.uf, t.pais,
                 vnseqbairro seqbairro, t.bairro,
                 vnseqlogradouro seqlogradouro, t.logradouro,
                 t.nrologradouro, t.cmpltologradouro, t.cep, t.foneddd1,
                 t.fonenro1, t.fonecmpl1, t.foneddd2, t.fonenro2,
                 t.fonecmpl2, t.foneddd3, t.fonenro3, t.fonecmpl3, t.faxddd,
                 t.faxnro, t.nrocgccpf, t.digcgccpf, t.inscricaorg,
                 t.dtanascfund, 'AFV' origem, null codclientefora, t.email,
                 t.homepage, t.estadocivil, null atividade,
                 null rendafaturamento, null grauinstrucao, null grupo,
                 null porte, sysdate dtainclusao, 'AFV' usuinclusao,
                 null dtaalteracao, null usualteracao, null dtainativacao,
                 null usuinativacao, null obsinativacao,
                 decode(t.fisicajuridica, 'J', 'S', 'N') indcontribicms,
                 'S' indreplicacao, null indgeroureplic, null indprodrural,
                 t.inscmunicipal, t.emailnfe
            from dual;
        update ge_sequencia a
           set a.sequencia = decode(vsgeradigseqpessoa, 'S',
                                     vnseqpessoasemdig, vnseqpessoa)
         where a.nometabela = 'GE_PESSOA';
      else
        select a.*
          into vrtpessoa
          from ge_pessoa a
         where a.seqpessoa = vnseqpessoa;
        update ge_pessoa a
           set a.nomerazao = nvl(t.nomerazao, a.nomerazao),
               a.fantasia = nvl(t.fantasia, a.fantasia),
               a.fisicajuridica = nvl(t.fisicajuridica, a.fisicajuridica),
               a.sexo = nvl(t.sexo, a.sexo),
               a.cidade = nvl(t.cidade, a.cidade), a.uf = nvl(t.uf, a.uf),
               a.pais = nvl(t.pais, a.pais),
               a.bairro = nvl(t.bairro, a.bairro),
               a.logradouro = nvl(t.logradouro, a.logradouro),
               a.nrologradouro = nvl(t.nrologradouro, a.nrologradouro),
               a.cmpltologradouro = nvl(t.cmpltologradouro,
                                         a.cmpltologradouro),
               a.cep = nvl(t.cep, a.cep),
               a.foneddd1 = nvl(t.foneddd1, a.foneddd1),
               a.fonenro1 = nvl(t.fonenro1, a.fonenro1),
               a.fonecmpl1 = nvl(t.fonecmpl1, a.fonecmpl1),
               a.foneddd2 = nvl(t.foneddd2, a.foneddd2),
               a.fonenro2 = nvl(t.fonenro2, a.fonenro2),
               a.fonecmpl2 = nvl(t.fonecmpl2, a.fonecmpl2),
               a.foneddd3 = nvl(t.foneddd3, a.foneddd3),
               a.fonenro3 = nvl(t.fonenro3, a.fonenro3),
               a.fonecmpl3 = nvl(t.fonecmpl3, a.fonecmpl3),
               a.faxddd = nvl(t.faxddd, a.faxddd),
               a.faxnro = nvl(t.faxnro, a.faxnro),
               a.nrocgccpf = nvl(t.nrocgccpf, a.nrocgccpf),
               a.digcgccpf = nvl(t.digcgccpf, a.digcgccpf),
               a.inscricaorg = nvl(t.inscricaorg, a.inscricaorg),
               a.dtanascfund = nvl(t.dtanascfund, a.dtanascfund),
               a.email = nvl(t.email, a.email),
               a.homepage = nvl(t.homepage, a.homepage),
               a.estadocivil = nvl(t.estadocivil, a.estadocivil),
               a.dtaalteracao = sysdate, a.usualteracao = 'AFV',
               a.indcontribicms = decode(t.fisicajuridica, 'J', 'S', 'N'),
               a.inscmunicipal = nvl(t.inscmunicipal, a.inscmunicipal),
               a.emailnfe = nvl(t.emailnfe, a.emailnfe),
               --o processo de atualização de endereço está apenas habilitado para o e-commerce.
               a.seqcidade = decode(vnclienteecommerce, 0, a.seqcidade,
                                     vnseqcidade),
               a.seqlogradouro = decode(vnclienteecommerce, 0,
                                         a.seqlogradouro, vnseqlogradouro),
               a.seqbairro = decode(vnclienteecommerce, 0, a.seqbairro,
                                     vnseqbairro),
               a.versao = decode(vncount, 0, a.versao, a.versao + 1),
               a.status = decode(vnclienteecommerce, 0, a.status, 'A')
         where a.seqpessoa = vnseqpessoa;
        -- gerando versão da pessoa
        if (vrtpessoa.cidade != t.cidade or vrtpessoa.bairro != t.bairro or
           vrtpessoa.cep != t.cep or vrtpessoa.logradouro != t.logradouro or
           vrtpessoa.nrologradouro != t.nrologradouro or
           vrtpessoa.cmpltologradouro != t.cmpltologradouro or
           vrtpessoa.inscricaorg != t.inscricaorg or
           vrtpessoa.nomerazao != t.nomerazao or
           vrtpessoa.digcgccpf != t.digcgccpf or
           vrtpessoa.nrocgccpf != t.nrocgccpf or
           vrtpessoa.fisicajuridica != t.fisicajuridica or
           vrtpessoa.email != t.email or vrtpessoa.emailnfe != t.emailnfe) then
          --gera a versão da pessoa com os dados atuais
          insert into ge_pessoaversao
            (seqpessoa, versao, nomerazao, cidade, uf, bairro,
             enderecocompleto, cep, nrocgccpf, digcgccpf, inscricaorg,
             dtaatualizacao, usualterou, justificativa, fisicajuridica,
             indmicroempresa, email, emailnfe, inscinss)
          values
            (vrtpessoa.seqpessoa, vrtpessoa.versao, vrtpessoa.nomerazao,
             vrtpessoa.cidade, vrtpessoa.uf, vrtpessoa.bairro,
             vrtpessoa.logradouro || ' ' || vrtpessoa.nrologradouro || ' ' ||
              vrtpessoa.cmpltologradouro, vrtpessoa.cep, vrtpessoa.nrocgccpf,
             vrtpessoa.digcgccpf, vrtpessoa.inscricaorg, trunc(sysdate),
             'EDI_PEDVDA', 'Alterado via integração.',
             vrtpessoa.fisicajuridica, vrtpessoa.indmicroempresa,
             vrtpessoa.email, vrtpessoa.emailnfe, vrtpessoa.inscinss);
          update ge_pessoa a
             set a.versao = a.versao + 1
           where a.seqpessoa = vnseqpessoa;
        end if;
      end if;
      --no final da importação da pessoa, a mesma é sempre transformada em cliente
      merge into mrl_cliente a
      using (select xx.seqpessoa
               from ge_pessoa xx
              where xx.seqpessoa = vnseqpessoa) x
      on (x.seqpessoa = a.seqpessoa)
      when matched then
        update
           set a.statuscliente = decode(vnclienteecommerce, 0,
                                         a.statuscliente, 'A')
      when not matched then
        insert
          (seqpessoa, nrocondpagtopadrao, nroregtributacaocli, nroempresa,
           indenviomaladireta, indenviofax, indenvioemail, indcontatofone,
           dtacadastro, usucadastro, statuscliente, empultcadastro,
           tipocobranca, pzopagtomaximo, actpedtelefone, senhapedtelefone,
           actpedeletronico, senhapedeletronico, observacao,
           obsromaneioentrega, codclasscomerc, dtaativou, dtainativou,
           usuativou, usuinativou, dtaalteracao, usualteracao,
           dtabaseexportacao, indreplicacao, indgeroureplicacao,
           dtaultcompra, nroalvaramunic, dtavencalvmunic, nroalvarafederal,
           dtavencalvfederal, situacaocomercial, contatocomprador,
           dtasintegra, dtaserasa, dtabloqsintegra, dtabloqserasa,
           seqlocalidade, indquebranfpedido, indreconferecarga)
        values
          (vnseqpessoa, null, null, t.nroempresa, 'S', 'S', 'S', 'S',
           sysdate, vsusuario, 'A', t.nroempresa, null, null, 'S', null, 'S',
           null, null, null, null, sysdate, null, vsusuario, null, sysdate,
           vsusuario, sysdate, 'S', null, null, null, null, null, null, null,
           null, null, null, null, null, null, null, null);
      if vnclienteecommerce > 0 then
        --endereço da pessoa não foi encontrado,
        --é feito o cadastro com os novos dados informados
        if vnseqpessoaend = 0 and vnseqpessoa > 0 then
          select coalesce(max(seqpessoaend), 0) + 1
            into vnseqpessoaend
            from ge_pessoaend
           where seqpessoa = vnseqpessoa;
          --os endereços de entrega(tipo 'E') começam sempre a partir do sequence 3
          --esse funcionamento vem da aplicação e é um tratamento antigo que existe
          --na aplicação de pessoas
          if vnseqpessoaend < 3 then
            vnseqpessoaend := 3;
          end if;
          insert into ge_pessoaend
            (seqpessoa, seqpessoaend, tipoendereco, uf, cep, cidade,
             logradouro, cmpltologradouro, nrologradouro, bairro,
             dtaalteracao, usualteracao, nrobaseexportacao, seqcidade,
             seqlogradouro, seqbairro)
          values
            (vnseqpessoa, vnseqpessoaend, 'E', t.uf, t.cep, t.cidade,
             t.logradouro, substr(t.cmpltologradouro, 1, 10),
             t.nrologradouro, t.bairro, trunc(sysdate), vsusuario, 0,
             vnseqcidade, vnseqlogradouro, vnseqbairro);
          insert into mad_clienteend
            (seqpessoa, seqpessoaend)
          values
            (vnseqpessoa, vnseqpessoaend);
        else
          if vnseqpessoa > 0 then
            update ge_pessoaend a
               set a.seqcidade = decode(sign(a.seqcidade), 1, a.seqcidade,
                                         vnseqcidade),
                   a.seqlogradouro = decode(sign(a.seqlogradouro), 1,
                                             a.seqlogradouro, vnseqlogradouro),
                   a.seqbairro = decode(sign(a.seqbairro), 1, a.seqbairro,
                                         vnseqbairro)
             where a.seqpessoaend = vnseqpessoaend
               and a.seqpessoa = vnseqpessoa
               and (a.seqcidade is null or a.seqlogradouro is null or
                   a.seqbairro is null);
          end if;
        end if;
      end if;
      sp_buscaparamdinamico('EDI_CAPTURA_PEDIDO', t.nroempresa,
                            'NRO_SEGMENTO_ECOMMERCE', 'N', '0',
                            'INFORMA O NUMERO DO SEGMENTO PARA INTEGRAÇÃO COM E-COMMERCE. SE CASO FOR ZERO NÃO UTILIZA.',
                            vnnrosegmentoecommerce);
      if vnclienteecommerce > 0 and vnnrosegmentoecommerce > 0 then
        select max(a.status)
          into vsstatussegecommerce
          from mrl_clienteseg a
         where a.seqpessoa = vnseqpessoa
           and a.nrosegmento = vnnrosegmentoecommerce;
        if vsstatussegecommerce is null then
          insert into mrl_clienteseg
            (seqpessoa, nrosegmento, nrorepresentante, status)
          values
            (coalesce(vnseqpessoa, vnseqpessoa), vnnrosegmentoecommerce,
             vnnrorepresentante, 'A');
          --req.141701
          spmad_insereclisegtabvenda(coalesce(vnseqpessoa, vnseqpessoa),
                                     t.nroempresa, vnnrosegmentoecommerce);
        end if;
      end if;
      --finalização do processo
      update edi_pedvendacliente a
         set a.statusimportacao = 'F'
       where a.seqedipedvendacliente = t.seqedipedvendacliente;
      commit;
    end if;
  end loop;
  -- importação dos pedidos
  for t in (select *
              from edi_pedvenda a
             where nvl(a.nrorepresentante, 1) = case
                     when a.nrorepresentante is null then
                      1
                     else
                      nvl(pnnrorepresentante, a.nrorepresentante)
                   end
               and a.statuspedido = 'L'
               and nvl(a.situacaopedimportacao, 'F') = 'F'
               and a.seqedipedvenda =
                   nvl(pnseqedipedvenda, a.seqedipedvenda)
             order by a.nropedidoafvref desc)
  loop
    begin
      -- faz o update para verificar se o registro está disponível.
      update edi_pedvenda a
         set a.statuspedido = 'I'
       where a.seqedipedvenda = t.seqedipedvenda
         and a.statuspedido = 'L';
      -- se conseguir fazer o update quer dizer que o registro está disponível e não tem outra sessão alocando.
      if sql%rowcount > 0 then
        -- rc erro 129510
        sp_buscaparamdinamico('PED_VENDA', t.nroempresa,
                              'GRAVA_STATUS_SEPARACAO_AUTO', 'S', 'N',
                              'AO FECHAR O PEDIDO SEMPRE GRAVAR O STATUS DE SEPARAÇAO COMO G (GERAR SEPARAÇÃO AUTOMATICAMENTE)? ' ||
                               chr(13) || chr(10) || 'S-SIM ' || chr(13) ||
                               chr(10) || 'N-NÃO(PADRÃO) ' || chr(13) ||
                               chr(10) ||
                               'C-CONFORME CGO(PD CGO_STATUS_SEPARACAO_AUTO) ' ||
                               chr(13) || chr(10) ||
                               'OBS:UTILIZADO PARA O CASO DE EXPEDIÇÃO DE PEDIDOS PELO VENDA.',
                              vspdgravastatussepauto);
        sp_buscaparamdinamico('PED_VENDA', 0, 'CGO_STATUS_SEPARACAO_AUTO',
                              'S', ' ',
                              'CONFIGURA QUAIS CGOS ALTERAM O STATUS DE SEPARAÇAO COMO G (GERAR SEPARAÇÃO AUTOMATICAMENTE). ' ||
                               chr(13) || chr(10) ||
                               'OBS:SEPARE OS NUMEROS DOS CGOS POR VIRGULAS. ' ||
                               chr(13) || chr(10) ||
                               'DEPENDE DO PARAMETRO DINAMICO "GRAVA_STATUS_SEPARACAO_AUTO" IGUAL A "C"',
                              vspdcgostatussepauto);
        vninconsistencia := 0;
        -- verifica se o cliente da edi_pedvenda está cadastrado
        select count(1)
          into vncountpessoa
          from ge_pessoa p
         where p.seqpessoa = t.seqpessoa;
        if (vncountpessoa = 0) then
          select max(a.nrocgccpf)
            into vnnrocgccnpj
            from edi_pedvendacliente a
           where a.nropedidoafv = t.nropedidoafv
             and a.nroempresa = t.nroempresa;
          select max(seqpessoa)
            into vnseqpessoacliente
            from ge_pessoa p
           where p.nrocgccpf = vnnrocgccnpj;
          if (vnseqpessoacliente is not null) then
            update edi_pedvenda p
               set p.seqpessoa = vnseqpessoacliente
             where p.seqedipedvenda = t.seqedipedvenda;
          end if;
        end if;
        sp_imp_edipedvendacritica(t.seqedipedvenda, null, null, 'P',
                                  vninconsistencia, null, null); --faz consistencia do pedido
        if vninconsistencia = 0 then
          vnnroempresasec := fverificaempresaatendimento(t.nroempresa,
                                                         t.seqpessoa,
                                                         t.nrorepresentante,
                                                         'T');
          -- rc 73490 - pedidos de indenização
          vspedidoindeniz := 'N'; -- n = não; s = sim; i = ignora
          if t.nropedidoafvref is not null then
            select nvl(a.indusaindenizacao, 'N'), a.tipoindenizacao
              into vsindusaindenizacao, vstipoindenizacao
              from mad_parametro a
             where a.nroempresa = t.nroempresa;
            if vsindusaindenizacao = 'S' and vstipoindenizacao = 'V' then
              select max(a.nropedvenda), max(a.situacaoped)
                into vnnropedvendaref, vnsituacaopedref
                from mad_pedvenda a
               where a.nropedidoafv = t.nropedidoafvref
                 and a.nroempresa = t.nroempresa;
              if vnsituacaopedref = 'D' or vnsituacaopedref = 'L' or
                 vnsituacaopedref = 'A' then
                vspedidoindeniz := 'S';
              else
                vspedidoindeniz := 'I';
              end if;
            else
              vspedidoindeniz := 'I';
            end if;
          end if;
          if vspedidoindeniz != 'I' then
            if vspedidoindeniz = 'N' then
              if t.nropedvenda is null or t.indecommerce is null then
                select s_nropedvenda.nextval
                  into vnnewnropedvenda
                  from dual;
              else
                vnnewnropedvenda := t.nropedvenda;
              end if;
            end if;
            update edi_pedvenda a
               set a.nropedvenda = nvl(vnnewnropedvenda, vnnropedvendaref)
             where a.seqedipedvenda = t.seqedipedvenda;
            if vspd_descfincliente = 'S' then
              select max(b.percmaxdescfinanc)
                into vnpercdescfinanc
                from madv_impedipedvenda a, mrl_clienteseg b
               where a.seqedipedvenda = t.seqedipedvenda
                 and a.seqpessoa = b.seqpessoa
                 and a.nrosegmento = b.nrosegmento;
            else
              vnpercdescfinanc := null;
            end if;
            --rp 76623
            select max(a.seqpessoaend)
              into vnseqpessoaend
              from ge_pessoaend a, mad_clienteend b
             where a.seqpessoa = b.seqpessoa(+)
               and a.seqpessoaend = b.seqpessoaend(+)
               and a.seqpessoaend = t.seqpessoaend
               and a.seqpessoa = t.seqpessoa;
            --rp 76623 fim
            --rc78762
            if nvl(t.seqgradeweb, 0) > 0 then
              select sum(a.vlrembinformado * a.qtdpedida / a.qtdembalagem)
                into vnvlritens
                from edi_pedvendaitem a
               where a.seqedipedvenda = t.seqedipedvenda;
              select max(nrocondicaopagtopadrao)
                into vnnrocondpagtopadrao
                from mad_gradepedweb a
               where a.seqgradeweb = t.seqgradeweb;
              if (vnnrocondpagtopadrao is null) --rc173897
                 and
                 (t.indusagradecliente = 'A' or t.indusagradecliente = 'S' or
                 t.indusagradecliente = 'B') then
                select cp.nrocondicaopagtogradepedweb
                  into vnnrocondpagtopadrao
                  from mrl_cliente cp
                 where cp.seqpessoa = t.seqpessoa;
              end if;
              select nvl(max(a.nrocondicaopagto), vnnrocondpagtopadrao)
                into vnnrocondpagto
                from mad_gradepedwebcondpagto a
               where vnvlritens between a.vlrinicial and a.vlrfinal
                 and a.seqgradeweb = t.seqgradeweb;
              update edi_pedvenda a
                 set a.nrocondpagpreco = vnnrocondpagto
               where a.seqedipedvenda = t.seqedipedvenda;
            end if;
            -- rp 139446
            select max(a.seqtitulo)
              into vnseqtituloecommerce
              from mrl_titulofin a
             where a.nrotitulo = t.nropedidoafv
               and a.nroempresa = t.nroempresa
               and a.apporigem = 28;
            if vnseqtituloecommerce is not null then
              update edi_pedvenda a
                 set a.seqtituloecommerce = vnseqtituloecommerce
               where a.seqedipedvenda = t.seqedipedvenda;
            end if;
            --para e-commerce utilizar o cgo configurado via parametrização
            --existe um pd específico pra isso.
            if t.indecommerce = 'S' and t.codgeraloper is null then
              -- tratamento para cgo
              vncgoecommerce := fbuscadadosecommerce('C', t.tippedido, null,
                                                     t.nroempresa);
              if t.tippedido = 'B' and vncgoecommerce is null then
                select max(a.cgonfbonificacao)
                  into vncgoecommerce
                  from mad_parametro a
                 where a.nroempecommerce = t.nroempresa;
              end if;
            end if;
            insert into mad_pedvenda
              (nropedvenda, nroempresa, seqpessoa, seqpessoaend,
               nrorepresentante, nroformapagto, nrotabvenda, codgeraloper,
               tippedido, percdesctotal, obspedido, dtainclusao,
               dtabasefaturamento, usuinclusao, dtaaprovpreco, usuaprovpreco,
               dtaaprovcredito, usuaprovcredito, dtaroteirizacao,
               dtageracaocarga, dtageracaonf, dtageracaocomiss,
               dtacancelamento, usucancelamento, motcancelamento, nrocarga,
               indusaxfat, nometransp, placatransp, ufplacatransp,
               cnpjcpftransp, inscrrgtransp, endtransp, municipiotransp,
               uftransp, tipfretetransp, indreplicacao, indgeroureplicacao,
               nrosegmento, nrolista, indentregaretira, situacaoped,
               dtaalteracao, usualteracao, geralteracaoestq,
               codrepresentanteafv, nropedidoafv, seqloteseparacao,
               indrelseparacao, indgeraflexpreco, indreplicafv, vlrcreduso,
               dtaanalisecred, sitcredcliente, vlrlimitecred, obsnotafiscal,
               seqlocal, percdescfinanc, indgeramarkup, origempedido,
               indcriticapedido, nropedcliente, idsession, indpednegoc,
               seqtransportador, placaveiculo, tipofrete, nrobancocobr,
               nrocarteiracobr, nroempresacobr, dtabasecotpedido,
               destnomerazao, destlogradouro, destcep, destcidade, destfone,
               destfax, destnrocgccpf, destdigcgccpf, destinscricaorg,
               destuf, destfisicajuridica, nrolistapreco, qtdprodrefrigerado,
               destemail, indavalioucredito, obsavaliacredito, vlrpedidolib,
               usulibcredped, dtalibcredped, statusseparacao,
               dtainiseparacao, dtafimseparacao, usugerouseparacao,
               dtainiconferencia, dtafimconferencia, usuconferencia,
               dtainientrega, dtafimentrega, usuentrega, seqseparador,
               seqconferente, seqentregador, geralteracaoestqfisc,
               seqpagador, indusaregra, seqctacorrente, nropedvendaorigem,
               usuavalcredito, dtaavalcredito, sessaoavalcredito,
               obscancelamento, seqoferta, nrocondpagpreco, percdescsf,
               indmultemppedpalm, indpermfatantecipado, seqgradeweb,
               vlrfreteped, tiporateiofreteped, nroprotocoloweb,
               statuspedecommerce, indenviositevalida, indenviositestatus,
               codoperadoracartao, indrateiadescinditem, dtapedidoafv,
               indprioridadesepar, dtahorinipreventrega,
               dtahorfimpreventrega, dtahorprevexpedicao, nrogiftcard,
               idtransacaoecommerce, vlrarredecommerce, seqtituloecommerce,
               vlrdespacessoria, dtahorretirada, seqpedidoweb,
               nroempresaprinc, tipoatendimento, nroempresaorigafv,
               nrosegmentoorigafv, indsepconfterc, indgeravlrdescnf,
               tipofretedocauxiliar, pedidoid)
              select a.nropedvenda, nvl(vnnroempresasec, a.nroempresa),
                     a.seqpessoa, nvl(vnseqpessoaend, a.seqpessoaend),
                     a.nrorepresentante, a.nroformapagto, a.nrotabvenda,
                     case
                       when t.indecommerce = 'S' and
                            nvl(vncgoecommerce, 0) > 0 then
                        vncgoecommerce
                       else
                        a.codgeraloper
                     end,
                     decode(nvl(a.tippedido, 'V'), 'B', 'V',
                             nvl(a.tippedido, 'V')), a.percdesctotal,
                     a.obspedido, a.dtainclusao, a.dtabasefaturamento,
                     a.usuinclusao, a.dtaaprovpreco, a.usuaprovpreco,
                     a.dtaaprovcredito, a.usuaprovcredito, a.dtaroteirizacao,
                     a.dtageracaocarga, a.dtageracaonf, a.dtageracaocomiss,
                     a.dtacancelamento, a.usucancelamento, a.motcancelamento,
                     a.nrocarga, a.indusaxfat, a.nometransp, a.placatransp,
                     a.ufplacatransp, a.cnpjcpftransp, a.inscrrgtransp,
                     a.endtransp, a.municipiotransp, a.uftransp,
                     a.tipfretetransp, a.indreplicacao, a.indgeroureplicacao,
                     a.nrosegmento, a.nrolista, a.indentregaretira,
                     decode(a.indsepconfterc, 'S', 'W', a.situacaoped),
                     a.dtaalteracao, a.usualteracao, a.geralteracaoestq,
                     a.codrepresentanteafv, a.nropedidoafv,
                     a.seqloteseparacao, a.indrelseparacao,
                     a.indgeraflexpreco, a.indreplicafv, a.vlrcreduso,
                     a.dtaanalisecred, a.sitcredcliente, a.vlrlimitecred,
                     a.obsnotafiscal, a.seqlocal,
                     nvl(vnpercdescfinanc, a.percdescfinanc),
                     a.indgeramarkup, a.origempedido, a.indcriticapedido,
                     a.nropedcliente, a.idsession, a.indpednegoc,
                     a.seqtransportador, a.placaveiculo,
                     fconvertecodigofrete(a.tipofretedocauxiliar),
                     a.nrobancocobr, a.nrocarteiracobr, a.nroempresacobr,
                     a.dtabasecotpedido, a.destnomerazao, a.destlogradouro,
                     a.destcep, a.destcidade, a.destfone, a.destfax,
                     a.destnrocgccpf, a.destdigcgccpf, a.destinscricaorg,
                     a.destuf, a.destfisicajuridica, a.nrolistapreco,
                     a.qtdprodrefrigerado, a.destemail, a.indavalioucredito,
                     a.obsavaliacredito, a.vlrpedidolib, a.usulibcredped,
                     a.dtalibcredped, a.statusseparacao, a.dtainiseparacao,
                     a.dtafimseparacao, a.usugerouseparacao,
                     a.dtainiconferencia, a.dtafimconferencia,
                     a.usuconferencia, a.dtainientrega, a.dtafimentrega,
                     a.usuentrega, a.seqseparador, a.seqconferente,
                     a.seqentregador, a.geralteracaoestqfisc, a.seqpagador,
                     decode(vspd_usaregraincentivo, 'S', 'S', a.indusaregra),
                     a.seqctacorrente, a.nropedvendaorigem, a.usuavalcredito,
                     a.dtaavalcredito, a.sessaoavalcredito,
                     a.obscancelamento, a.seqoferta, a.nrocondpagpreco,
                     a.percdescsf,
                     decode(fbuscaempestqtabvendapalm(a.nrotabvenda), null,
                             'N', 'S') as indmultemppedpalm,
                     a.indpermfatantecipado, a.seqgradeweb, a.vlrtotfrete,
                     a.tiporateiofreteped, a.nroprotocoloweb,
                     a.statuspedecommerce, a.indenviositevalida,
                     a.indenviositestatus, a.codoperadoracartao,
                     decode(a.indgeravlrindeniz, 'I', 'S', 'N'),
                     a.dtapedidoafv, a.indprioridadesepar,
                     a.dtahorinipreventrega, a.dtahorfimpreventrega,
                     a.dtahorprevexpedicao, a.nrogiftcard,
                     a.idtransacaoecommerce, a.vlrarredecommerce,
                     a.seqtituloecommerce,
                     case
                        when a.formataxaconv = 'D' or a.formataxaconv is null then
                         null
                        else
                         a.vlrdespacessoria
                      end vlrdespacessoria, a.dtahorretirada, t.seqpedidoweb,
                     a.nroempresa, 'T', a.nroempresaorigafv,
                     a.nrosegmentoorigafv, a.indsepconfterc,
                     a.indgeravlrdescnf,
                     fconvertecodigofrete(a.tipofretedocauxiliar),
                     a.pedidoid
                from madv_impedipedvenda a
               where a.seqedipedvenda = t.seqedipedvenda
                 and a.nropedidoafvref is null;
            insert into mad_pedvendaverbaafv
              (nropedvenda, nroempresa, seqfornecedor, nrorepresentante,
               vlrverba)
              select b.nropedvenda, nvl(vnnroempresasec, b.nroempresa),
                     a.seqfornecedor, a.nrorepresentante, a.vlrverba
                from edi_pedvendaverba a, edi_pedvenda b
               where a.seqedipedvenda = b.seqedipedvenda
                 and b.seqedipedvenda = t.seqedipedvenda
                 and b.nropedidoafvref is null;
            -- inserindo na tabela da pessoa que vai retirar a compra
            insert into mad_pedvendacliretira
              (nropedvenda, nroempresa, nome, foneddd1, fonenro1, fonecmpl1,
               foneddd2, fonenro2, fonecmpl2, cpfnro, cpfdig, rg)
              select b.nropedvenda, nvl(vnnroempresasec, b.nroempresa),
                     a.nome, a.foneddd1, a.fonenro1, a.fonecmpl1, a.foneddd2,
                     a.fonenro2, a.fonecmpl2, a.cpfnro, a.cpfdig, a.rg
                from edi_pedvendacliretira a, edi_pedvenda b
               where a.seqedipedvenda = b.seqedipedvenda
                 and a.seqedipedvenda = t.seqedipedvenda;
            -- busca nropedvenda que sera passado para procedure de geração de carga
            select a.nropedvenda
              into vsnropedvendacarga
              from edi_pedvenda a
             where a.seqedipedvenda = t.seqedipedvenda;
            vnseqitem := 0;
            /*busca o parametro no cgo de geração de alteração em estoque -
            rc 60122 (foi implementado tratamento para qdo nao utilizar este parametro fazer o tratamento antigo
            e inserir a coluna qtdatendida na coluna qtdatendida)*/
            select x.indexigeestoque, nvl(x.indpreseparapedido, 'N')
              into vnindexigeestoque, vsindpreseparapedido
              from mad_parametro x
             where x.nroempresa = t.nroempresa;
            select a.geralteracaoestq, a.nrotabvenda, a.nrosegmento,
                   a.nrorepresentante, a.seqpessoa
              into vngeraalteracaoestq, vnnrotabvenda, vnnrosegmento,
                   vnnrorepresentante, vnseqpessoa
              from madv_impedipedvenda a
             where a.seqedipedvenda = t.seqedipedvenda;
            select z.indexigeestoquecgo
              into vsindexigeestoquecgo
              from max_codgeraloper z
             where z.codgeraloper = t.codgeraloper;
            if nvl(vsindexigeestoquecgo, 'C') != 'C' then
              vnindexigeestoque := vsindexigeestoquecgo;
            end if;
            -- rc 154452 - processo para refazer o valor de desconto e o valor informado
            -- evitando a diferença entre o pedido de venda e faturamento
            if (vspd_recalcdesconto = 'S') then
              update edi_pedvendaitem a
                 set a.vlrembinformado = trunc(a.vlrembinformado, 2),
                     a.vlrembdesconto = case
                                           when trunc(a.vlrembtabpreco, 2) > trunc(a.vlrembinformado, 2) then
                                            trunc(a.vlrembtabpreco, 2) - trunc(a.vlrembinformado, 2)
                                           else
                                            nvl(a.vlrembdesconto, 0)
                                         end
               where a.seqedipedvenda = t.seqedipedvenda
                 and nvl(a.vlrembdesconto, 0) !=
                     trunc(a.vlrembtabpreco, 2) -
                     trunc(a.vlrembinformado, 2);
            end if;
            -- rc 154452 fim
            --tratamento específico para e-commerce. origem: sp_insereedipedvendaecommerce(descontinuada)
            /*
            * 1-efetuado
            * 4-problemas
            * 5-cancelado
            * 6-aguardando pagamento
            * 7-pagamento confirmado
            * 8-analise risco
            * 17-despachado
            * 92-entregue
            * 99-troca
            * 100-cupom próxima compra
            * 108-alterar forma de pagamento
            */
            if t.indecommerce = 'S' then
              select max(x.statusc5ecommerce)
                into vnstatuspedido
                from mad_statuspedvdaecommerce x
               where x.nroempresa = t.nroempresa
                 and x.statusequivalente = t.statuspedecommerce;
              if vnstatuspedido = 4 then
                update mad_pedvenda a
                   set a.situacaoped = decode(a.indsepconfterc, 'S', 'W', 'A'),
                       a.statuspedecommerce = 4, a.indenviositevalida = 'S',
                       a.indenviositestatus = 'N'
                 where a.nropedvenda =
                       nvl(vnnewnropedvenda, vnnropedvendaref)
                   and a.nroempresa = nvl(vnnroempresasec, t.nroempresa);
              elsif vnstatuspedido = 6 then
                update mad_pedvenda a
                   set a.situacaoped = decode(a.indsepconfterc, 'S', 'W', 'A'),
                       a.statuspedecommerce = 6, a.indenviositevalida = 'S',
                       a.indenviositestatus = 'N'
                 where a.nropedvenda =
                       nvl(vnnewnropedvenda, vnnropedvendaref)
                   and a.nroempresa = nvl(vnnroempresasec, t.nroempresa);
              elsif vnstatuspedido = 8 then
                update mad_pedvenda a
                   set a.situacaoped = decode(a.indsepconfterc, 'S', 'W', 'A'),
                       a.statuspedecommerce = 8, a.indenviositevalida = 'S',
                       a.indenviositestatus = 'N'
                 where a.nropedvenda =
                       nvl(vnnewnropedvenda, vnnropedvendaref)
                   and a.nroempresa = nvl(vnnroempresasec, t.nroempresa);
              elsif vnstatuspedido = 7 then
                update mad_pedvenda a
                   set a.situacaoped = decode(a.indsepconfterc, 'S', 'W', 'L'),
                       a.statuspedecommerce = 7, a.indenviositevalida = 'S',
                       a.indenviositestatus = 'N'
                 where a.situacaoped != 'P'
                   and a.nropedvenda =
                       nvl(vnnewnropedvenda, vnnropedvendaref)
                   and a.nroempresa = nvl(vnnroempresasec, t.nroempresa);
              end if;
            end if;
            for i in (select *
                        from madv_impedipedvendaitem a
                       where a.seqedipedvenda = t.seqedipedvenda
                       order by a.seqproduto)
            loop
              /* cálcula percentual máximo de desconto fornecedor - rc 129908 */
              if nvl(vspdusadescmaxfornecedor, 'N') = 'S' and
                 i.vlrembtabpreco > i.vlrembinformado then
                -- % máximo de desconto fornecedor
                select nvl(max(b.percmaxdescforn), 0)
                  into vnpercmaxdescforn
                  from map_produto a, mad_famsegmento b
                 where b.seqfamilia = a.seqfamilia
                   and b.nrosegmento = t.nrosegmento
                   and a.seqproduto = i.seqproduto;
                vnpercdescforn := 100 -
                                  (i.vlrembinformado / i.vlrembtabpreco * 100);
                if vnpercdescforn <= vnpercmaxdescforn then
                  vnvlrembdescfornec := i.vlrembtabpreco -
                                        i.vlrembinformado;
                else
                  vnvlrembdescfornec := i.vlrembtabpreco *
                                        vnpercmaxdescforn / 100;
                end if;
                -- atualiza edi
                update edi_pedvendaitem a
                   set a.vlrembdescfornec = vnvlrembdescfornec
                 where a.seqedipedvenda = i.seqedipedvenda
                   and a.seqpedvendaitem = i.seqpedvendaitem;
              end if;
              if vspedidoindeniz = 'S' then
                select nvl(max(a.seqpedvendaind), 0)
                  into vnseqitem
                  from mad_pedvendaind a
                 where a.nropedvenda = vnnropedvendaref
                   and a.nroempresa = t.nroempresa;
                vnseqitem := vnseqitem + 1;
                insert into mad_pedvendaind
                  (nropedvenda, nroempresa, seqpedvendaind, seqproduto,
                   qtdindenizar, qtdembalagem, vlrembtabpreco,
                   vlrembinformado, dtainclusao, usuinclusao, dtaalteracao,
                   usualteracao, indreplicacao, indgeroureplicacao)
                  select vnnropedvendaref, a.nroempresa,
                         vnseqitem seqpedvendaind, a.seqproduto,
                         a.qtdatendida * a.qtdembalagem, a.qtdembalagem,
                         a.vlrembtabpreco, a.vlrembinformado, a.dtainclusao,
                         a.usuinclusao, a.dtaalteracao, a.usualteracao,
                         a.indreplicacao, a.indgeroureplicacao
                    from madv_impedipedvendaitem a
                   where a.seqedipedvenda = t.seqedipedvenda
                     and a.seqpedvendaitem = i.seqpedvendaitem;
              elsif vspedidoindeniz = 'N' then
                vnseqitem := vnseqitem + 1;
                --rc 78672
                if nvl(t.seqgradeweb, 0) > 0 then
                  spmad_reservaqtdvdaweb(t.seqgradeweb, t.seqpessoa,
                                         i.seqproduto, 0, 0, 'S');
                end if;
                --rc 78672 fim
                sp_buscaparamdinamico('PED_VENDA', 0,
                                      'INF_UF_CLIENTE_SUBTRAIR_ICMSST', 'S',
                                      'MG',
                                      'INF. UF DOS CLIENTES QUE SERÃO CONSIDERADOS PARA SUBTRAIR O VALOR TOTAL DE ICMS ST DO VALOR TOTAL DO PRODUTO NA DIG. DO PEDIDO DE VENDA OU INTEGRAÇÃO AFV.' ||
                                       chr(13) || chr(10) || 'PADRÃO: MG' ||
                                       chr(13) || chr(10) ||
                                       'OBS: SEPARADO POR VIRGULA.' ||
                                       chr(13) || chr(10) ||
                                       'DEPENDE DO PD "SUBTRAIR_ICMSST_VALOR_PRODUTO".',
                                      vspdufclientesubtrairicmsst);
                insert into mad_pedvendaitem
                  (nropedvenda, nroempresa, seqpedvendaitem, seqproduto,
                   nrocondicaopagto, nrodiavencto, qtdpedida, qtdatendida,
                   qtdembalagem, vlrembtabpreco, vlrembtabpromoc,
                   vlrembinformado, vlrembdesconto, percomissao,
                   vlrtotcomissao, dtainclusao, usuinclusao, indreplicacao,
                   indgeroureplicacao, nroempresadf, numerodf, seriedf,
                   nroserieecf, dtaalteracao, usualteracao, codacesso,
                   nroempresafatura, nrotabvenda, vlrembprecomin,
                   indpercomissinfo, nrorepitem, observacaoitem,
                   nrocondpagtoorig, vlrembtabflex, vlrembinforig, qtdvolume,
                   seqpedvendaitemsub, seqprodutosub, qtdconferida,
                   ocorrenciadev, obsdevolucao, qtddevolvida, dtadevolucao,
                   usudevolucao, seqconferentedev, qtdatendidafisc,
                   percmaxdesccomerc, indgeraflexpreco, tipotabvenda,
                   seqbonifprod, vlrembdescbonif, vlrfretetransp,
                   percfretetransp, vlrtoticms, vlrtoticmsst,
                   vlrtoticmsantec, vlrtotipi, vlrtotfecp, seqconferenteitem,
                   seqseparadoritem, vlrembdescsf, nroempresaestq, grupodesc,
                   vlrembdescgrupo, expedremtipo, vlrembdescfornec,
                   seqpessoager, vlrembdescgerente, nrosupervisor,
                   vlrembdescsupervisor, vlrembdescempresa, qtdbonificada,
                   indsimilarecommerce, vlrembinfecommerce,
                   vlrembdescressarcst, indusaprecovalidnormal,
                   vlrfreteitemrateio, seqtipoacrescdescto,
                   vlroriginalembpreco, seqpedidoweb, indkit,
                    --requisito 167542
                   perccomissaoafv, vlrtotcomissaoafv, nroempresaorigafv,
                   nrosegitemorigafv, nrosegitem, nropedcliente,
                   seqpedclienteitem, codgeraloper)
                  select a.nropedvenda, nvl(vnnroempresasec, a.nroempresa),
                         vnseqitem seqpedvendaitem, a.seqproduto,
                         a.nrocondicaopagto, a.nrodiavencto,
                         nvl(a.qtdsolicitadaweb, a.qtdpedida),
                         decode(vnindexigeestoque, 'N', a.qtdatendida,
                                 /*  else do decode   */
                                 (decode(vngeraalteracaoestq, 'S',
                                          case
                                             when a.qtdpedida <=
                                                  fc5estoquebasedisponivel(a.seqproduto,
                                                                           nvl(a.nroempresaestq,
                                                                                nvl(vnnroempresasec,
                                                                                     a.nroempresa)),
                                                                           (select nvl(r.indusareservafixa,
                                                                                         'N') /*tratamento implementado no rc 59602 */
                                                                               from mad_segmento r
                                                                              where r.nrosegmento =
                                                                                    (select s.nrosegmentoprinc
                                                                                       from max_empresa s
                                                                                      where s.nroempresa =
                                                                                            nvl(a.nroempresaestq,
                                                                                                nvl(vnnroempresasec,
                                                                                                     a.nroempresa))))) then
                                              a.qtdpedida
                                             when (fc5estoquebasedisponivel(a.seqproduto,
                                                                            nvl(a.nroempresaestq,
                                                                                 nvl(vnnroempresasec,
                                                                                      a.nroempresa)),
                                                                            (select nvl(r.indusareservafixa,
                                                                                          'N')
                                                                                from mad_segmento r
                                                                               where r.nrosegmento =
                                                                                     (select s.nrosegmentoprinc
                                                                                        from max_empresa s
                                                                                       where s.nroempresa =
                                                                                             nvl(a.nroempresaestq,
                                                                                                 nvl(vnnroempresasec,
                                                                                                      a.nroempresa))))) < 0 or
                                                  vnindexigeestoque = 'S' and
                                                  a.qtdpedida >
                                                  fc5estoquebasedisponivel(a.seqproduto,
                                                                            nvl(a.nroempresaestq,
                                                                                 nvl(vnnroempresasec,
                                                                                      a.nroempresa)),
                                                                            (select nvl(r.indusareservafixa,
                                                                                          'N')
                                                                                from mad_segmento r
                                                                               where r.nrosegmento =
                                                                                     (select s.nrosegmentoprinc
                                                                                        from max_empresa s
                                                                                       where s.nroempresa =
                                                                                             nvl(a.nroempresaestq,
                                                                                                 nvl(vnnroempresasec,
                                                                                                      a.nroempresa)))))) then
                                              0
                                             else
                                              fc5estoquebasedisponivel(a.seqproduto,
                                                                       nvl(a.nroempresaestq,
                                                                            nvl(vnnroempresasec,
                                                                                 a.nroempresa)),
                                                                       (select nvl(r.indusareservafixa,
                                                                                     'N')
                                                                           from mad_segmento r
                                                                          where r.nrosegmento =
                                                                                (select s.nrosegmentoprinc
                                                                                   from max_empresa s
                                                                                  where s.nroempresa =
                                                                                        nvl(a.nroempresaestq,
                                                                                            nvl(vnnroempresasec,
                                                                                                 a.nroempresa))))) -
                                              mod(fc5estoquebasedisponivel(a.seqproduto,
                                                                           nvl(a.nroempresaestq,
                                                                                nvl(vnnroempresasec,
                                                                                     a.nroempresa)),
                                                                           (select nvl(r.indusareservafixa,
                                                                                         'N')
                                                                               from mad_segmento r
                                                                              where r.nrosegmento =
                                                                                    (select s.nrosegmentoprinc
                                                                                       from max_empresa s
                                                                                      where s.nroempresa =
                                                                                            nvl(a.nroempresaestq,
                                                                                                nvl(vnnroempresasec,
                                                                                                     a.nroempresa))))),
                                                  a.qtdembalagem)
                                           --end
                                           end, a.qtdatendida))),
                         a.qtdembalagem,
                         a.vlrembtabpreco -
                          (case
                           fc5maxparametro('PED_VENDA', a.nroempresa,
                                           'SUBTRAIR_ICMSST_VALOR_PRODUTO')
                            when 'S' then
                             case
                              instr(vspdufclientesubtrairicmsst, a.ufcliente)
                               when 0 then
                                0
                               else
                                fc_calcicmsst_emp(a.nroempresa, a.seqproduto,
                                                  a.vlrembtabpreco,
                                                  a.qtdembalagem,
                                                  a.qtdembalagem, a.seqpessoa)
                             end
                            else
                             0
                          end), a.vlrembtabpromoc,
                         a.vlrembinformado -
                          (case
                           fc5maxparametro('PED_VENDA', a.nroempresa,
                                           'SUBTRAIR_ICMSST_VALOR_PRODUTO')
                            when 'S' then
                             case
                              instr(vspdufclientesubtrairicmsst, a.ufcliente)
                               when 0 then
                                0
                               else
                                fc_calcicmsst_emp(a.nroempresa, a.seqproduto,
                                                  a.vlrembtabpreco,
                                                  a.qtdembalagem,
                                                  a.qtdembalagem, a.seqpessoa)
                             end
                            else
                             0
                          end), a.vlrembdesconto, a.percomissao,
                         a.vlrtotcomissao, a.dtainclusao, a.usuinclusao,
                         a.indreplicacao, a.indgeroureplicacao,
                         a.nroempresadf, a.numerodf, a.seriedf,
                         a.nroserieecf, a.dtaalteracao, a.usualteracao,
                         a.codacesso, a.nroempresafatura, a.nrotabvenda,
                         a.vlrembprecomin, a.indpercomissinfo, a.nrorepitem,
                         a.observacaoitem, a.nrocondpagtoorig,
                         a.vlrembtabflex, a.vlrembinforig, a.qtdvolume,
                         a.seqpedvendaitemsub, a.seqprodutosub,
                         a.qtdconferida, a.ocorrenciadev, a.obsdevolucao,
                         a.qtddevolvida, a.dtadevolucao, a.usudevolucao,
                         a.seqconferentedev, a.qtdatendidafisc,
                         a.percmaxdesccomerc, a.indgeraflexpreco,
                         a.tipotabvenda, a.seqbonifprod, a.vlrembdescbonif,
                         a.vlrfretetransp, a.percfretetransp, a.vlrtoticms,
                         a.vlrtoticmsst, a.vlrtoticmsantec, a.vlrtotipi,
                         a.vlrtotfecp, a.seqconferenteitem,
                         a.seqseparadoritem, a.vlrembdescsf,
                         nvl(fbuscaempestqtabvendapalm(a.nrotabvenda),
                              a.nroempresaestq) as nroempresaestq,
                         a.grupodesc, a.vlrembdescgrupo, a.expedremtipo,
                         nvl(a.vlrembdescfornec, 0), a.seqpessoager,
                         a.vlrembdescgerente, a.nrosupervisor,
                         a.vlrembdescsupervisor, a.vlrembdescempresa,
                         a.qtdbonificada, a.indsimilarecommerce,
                         a.vlrembinformado, a.vlrembdescressarcstsn,
                         'N' indusaprecovalidnormal, 0 vlrfreteitemrateio,
                         a.seqtipoacrescdescto,
                         fprecofinaltabvenda(a.seqproduto, a.nroempresa,
                                              a.nrosegmento, a.qtdembalagem,
                                              a.nrotabvenda,
                                              a.nrocondicaopagto, a.seqpessoa,
                                              (select aa.uf
                                                  from ge_pessoa aa
                                                 where aa.seqpessoa =
                                                       a.seqpessoa),
                                              a.nrorepresentante,
                                              a.indentregaretira, null, null,
                                              'S', null, null, 'I'),
                         t.seqpedidoweb, a.indkit,
                          --requisito 167542
                         decode(vspdimportacomissaoafv, 'S',
                                 ((a.vlrtotcomissaoafv * 100) /
                                  (a.vlrembinformado *
                                  (a.qtdpedida / a.qtdembalagem))), null) perccomissaoafv,
                         decode(vspdimportacomissaoafv, 'S',
                                 a.vlrtotcomissaoafv, null) vlrtotcomissaoafv,
                         a.nroempresaorigafv, a.nrosegmentoorigafv,
                         a.nrosegmento, a.nropedcliente, a.seqpedclienteitem,
                         a.codgeraloper
                    from madv_impedipedvendaitem a
                   where a.seqedipedvenda = t.seqedipedvenda
                     and a.seqpedvendaitem = i.seqpedvendaitem;
              
                -- rc 44091 verificar as criticas do tipo 'Na Atualização do Item no Pedido' e cujo procedimento seja de 'Cortar Item'.
                vscodcritica := null;
                select max(a.codcritica)
                  into vscodcritica
                  from madv_criticapedvendaitem a, mad_criticapedconfig c
                 where a.nropedvenda = t.nropedvenda
                   and a.nroempresa = nvl(vnnroempresasec, t.nroempresa)
                   and a.codcritica = c.codcritica
                   and a.seqpedvenditem = i.seqpedvendaitem
                   and a.seqproduto = i.seqproduto
                   and c.status = 'A'
                   and c.procedimento = 'C'
                   and c.tipoverificacao = 'I';
                if vscodcritica is not null then
                  update mad_pedvendaitem x
                     set x.qtdatendida = 0,
                         x.observacaoitem = x.observacaoitem ||
                                             '* Item cortado devido a critica: ' ||
                                             vscodcritica || ' *'
                   where x.nropedvenda = i.nropedvenda
                     and x.nroempresa = nvl(vnnroempresasec, t.nroempresa)
                     and x.seqpedvendaitem = i.seqpedvendaitem
                     and x.seqproduto = i.seqproduto;
                end if;
                if vspdverifsaldopromoc = 'S' then
                  select nvl(max(b.qtdlimiteuso - nvl(b.qtdreservada, 0)),
                              -1), max(b.qtdlimiteuso)
                    into vnqtdpromo, vnqtdlimitepromoc
                    from mrl_promocao a, mrl_promocaoitem b
                   where a.seqpromocao = b.seqpromocao
                     and a.nroempresa = b.nroempresa
                     and a.nrosegmento = b.nrosegmento
                     and a.nroempresa = t.nroempresa
                     and a.nrosegmento = vnnrosegmento
                     and b.seqproduto = i.seqproduto
                     and trunc(sysdate) between b.dtainicioprom and
                         b.dtafimprom
                     and a.tipopromoc = 'S';
                  select count(1)
                    into vnexistepromoc
                    from mrl_promocao a, mrl_promocaoitem b
                   where a.seqpromocao = b.seqpromocao
                     and a.nroempresa = b.nroempresa
                     and a.nrosegmento = b.nrosegmento
                     and a.nroempresa = t.nroempresa
                     and a.nrosegmento = vnnrosegmento
                     and b.seqproduto = i.seqproduto
                     and trunc(sysdate) between b.dtainicioprom and
                         b.dtafimprom
                     and a.tipopromoc = 'S';
                  select a.qtdpedida
                    into vnqtdpedida
                    from madv_impedipedvendaitem a
                   where a.seqedipedvenda = t.seqedipedvenda
                     and a.seqpedvendaitem = i.seqpedvendaitem;
                  select count(1)
                    into vncount
                    from mad_pedvendaitem a
                   where a.nropedvenda = i.nropedvenda
                     and a.nroempresa = nvl(vnnroempresasec, t.nroempresa)
                     and a.seqpedvendaitem = i.seqpedvendaitem
                     and a.seqproduto = i.seqproduto
                     and a.qtdatendida > 0;
                  if ((vnqtdpedida > vnqtdpromo and vnqtdpromo > 0) and
                     vncount > 0 and vnqtdlimitepromoc > 0) then
                    update mad_pedvendaitem x
                       set x.qtdatendida = vnqtdpromo,
                           x.observacaoitem = x.observacaoitem ||
                                               '* Item cortado devido ao limite de quantidade da promoção *'
                     where x.nropedvenda = i.nropedvenda
                       and x.nroempresa =
                           nvl(vnnroempresasec, t.nroempresa)
                       and x.seqpedvendaitem = i.seqpedvendaitem
                       and x.seqproduto = i.seqproduto;
                    select s_seqrecado.nextval
                      into vnseqrecado
                      from dual;
                    insert into mad_recado
                      (seqrecado, usugeracao, dtageracao, assuntorecado,
                       textorecado, nrorepgeracao, seqpessoa, indenviado,
                       indexcluido)
                    values
                      (vnseqrecado, 'CORTE_EDIAFV', sysdate,
                       'Corte de Item no Pedido ' || i.nropedvenda,
                       'O pedido ' || i.nropedvenda || ' teve o item ' ||
                        i.seqproduto ||
                        ' cortado devido ao limite de quantidade da promoção.',
                       vnnrorepresentante, vnseqpessoa, 'N', 'N');
                    insert into mad_recadopararep
                      (seqrecado, nrorepresentante, dtaleitura, indexcluido,
                       obsleitura)
                    values
                      (vnseqrecado, vnnrorepresentante, null, 'N', null);
                  end if;
                  if vnqtdpromo <= 0 and vncount > 0 and vnexistepromoc > 0 then
                    update mad_pedvendaitem x
                       set x.qtdatendida = x.qtdatendida,
                           x.vlrembinformado = fprecofinaltabvenda(i.seqproduto,
                                                                    t.nroempresa,
                                                                    t.nrosegmento,
                                                                    i.qtdembalagem,
                                                                    i.nrotabvenda,
                                                                    i.nrocondicaopagto,
                                                                    t.seqpessoa,
                                                                    (select a.uf
                                                                        from ge_pessoa a
                                                                       where a.seqpessoa =
                                                                             t.seqpessoa),
                                                                    t.nrorepresentante,
                                                                    t.indentregaretira,
                                                                    null, null,
                                                                    'S', null,
                                                                    null, 'I',
                                                                    null, null,
                                                                    'S', 'S',
                                                                    null, 'S'),
                           x.vlroriginalembpreco = fprecofinaltabvenda(i.seqproduto,
                                                                        t.nroempresa,
                                                                        t.nrosegmento,
                                                                        i.qtdembalagem,
                                                                        i.nrotabvenda,
                                                                        i.nrocondicaopagto,
                                                                        t.seqpessoa,
                                                                        (select a.uf
                                                                            from ge_pessoa a
                                                                           where a.seqpessoa =
                                                                                 t.seqpessoa),
                                                                        t.nrorepresentante,
                                                                        t.indentregaretira,
                                                                        null,
                                                                        null,
                                                                        'S',
                                                                        null,
                                                                        null,
                                                                        'I',
                                                                        null,
                                                                        null,
                                                                        'S',
                                                                        'S',
                                                                        null,
                                                                        'N'),
                           x.observacaoitem = x.observacaoitem ||
                                               '* Alterado para o preço normal de venda devido a acabar o saldo de promoção *'
                     where x.nropedvenda = i.nropedvenda
                       and x.nroempresa =
                           nvl(vnnroempresasec, t.nroempresa)
                       and x.seqpedvendaitem = i.seqpedvendaitem
                       and x.seqproduto = i.seqproduto;
                  end if;
                end if;
                select count(1)
                  into vnqtdlimitepromoc
                  from mrl_prodempseg a, mrl_promocaoitem b, mrl_promocao c
                 where a.seqproduto = b.seqproduto
                   and a.nroempresa = b.nroempresa
                   and a.nrosegmento = b.nrosegmento
                   and b.seqpromocao = c.seqpromocao
                   and a.nroempresa = b.nroempresa
                   and a.nrosegmento = c.nrosegmento
                   and a.precovalidpromoc = b.precopromocional
                   and a.seqproduto = i.seqproduto
                   and a.nroempresa = i.nroempresa
                   and a.nrosegmento = vnnrosegmento
                   and c.tipopromoc = 'S'
                   and (b.qtdlimiteuso / b.qtdembalagem -
                       nvl(b.qtdreservada, 0) / b.qtdembalagem) >= 0
                   and trunc(sysdate) between trunc(c.dtainicio) and
                       trunc(c.dtafim);
                if vnqtdlimitepromoc > 0 then
                  for x in (select a.seqproduto, a.qtdatendida
                              from mad_pedvendaitem a
                             where a.nropedvenda = i.nropedvenda)
                  loop
                    update mrl_promocaoitem p
                       set p.qtdreservada = case
                                               when nvl(p.qtdreservada, 0) + x.qtdatendida <= nvl(p.qtdlimiteuso, 0) then
                                                nvl(p.qtdreservada, 0) + x.qtdatendida
                                               else
                                                nvl(p.qtdlimiteuso, 0)
                                             end
                     where p.seqproduto = x.seqproduto
                       and p.nroempresa = i.nroempresa
                       and p.nrosegmento = vnnrosegmento;
                  end loop;
                end if;
              end if;
            
            end loop;
            if vspedidoindeniz = 'N' then
              -- rateando taxa de conveniencia
              select max(a.formataxaconv)
                into vnformataxaconv
                from mad_parametro a
               where a.nroempresa = t.nroempresa;
              select max(a.vlrdespacessoria)
                into vnvlrdespacessoria
                from edi_pedvenda a
               where a.seqedipedvenda = t.seqedipedvenda;
              if (vnformataxaconv = 'T' or vnformataxaconv = 'N') and
                 nvl(vnvlrdespacessoria, 0) > 0 then
                vncalcdespacessoria := 0;
                vnaliqrateiodespacessoria := 0;
                for i in (select a.nropedvenda, a.seqpedvendaitem,
                                 a.vlrembinformado,
                                 (select sum(b.vlrembinformado)
                                     from madv_impedipedvendaitem b
                                    where b.seqedipedvenda = a.seqedipedvenda) vlrtotal
                            from madv_impedipedvendaitem a
                           where a.seqedipedvenda = t.seqedipedvenda)
                loop
                  if nvl(i.vlrtotal, 0) > 0 then
                    vnaliqrateiodespacessoria := nvl(i.vlrembinformado, 0) /
                                                 i.vlrtotal;
                  end if;
                  update mad_pedvendaitem a
                     set a.vlrdespntributitem = decode(vnformataxaconv, 'N',
                                                        vnvlrdespacessoria *
                                                         vnaliqrateiodespacessoria,
                                                        null),
                         a.vlrdesptributitem = decode(vnformataxaconv, 'T',
                                                       vnvlrdespacessoria *
                                                        vnaliqrateiodespacessoria,
                                                       null)
                   where a.nropedvenda = i.nropedvenda
                     and a.seqpedvendaitem = i.seqpedvendaitem;
                  vncalcdespacessoria := vncalcdespacessoria +
                                         (vnvlrdespacessoria *
                                         vnaliqrateiodespacessoria);
                end loop;
                -- gravando a diferença calculada no item com o maior valor de rateio calculado
                if vncalcdespacessoria != vnvlrdespacessoria then
                  /* verifica o pedido e a empresa para utilização no sql abaixo */
                  select a.nropedvenda, a.nroempresa
                    into vnnropedvendarateio, vnnroemprateio
                    from madv_impedipedvenda a
                   where a.seqedipedvenda = t.seqedipedvenda;
                  /* procura o produto com o maior valor de rateio */
                  select a.seqpedvendaitem, a.nropedvenda, a.nroempresa
                    into vnminseqpedvendaitem, vnnropedvenda, vnnroemppedido
                    from madv_impedipedvendaitem a
                   where a.seqedipedvenda = t.seqedipedvenda
                     and a.seqpedvendaitem =
                         (select seqpedvendaitem
                            from (select ped.seqpedvendaitem as seqpedvendaitem
                                     from mad_pedvendaitem ped
                                    where ped.nropedvenda =
                                          vnnropedvendarateio
                                      and ped.nroempresa = vnnroemprateio
                                    order by case
                                                when vnformataxaconv = 'N' then
                                                 ped.vlrdespntributitem
                                              end desc,
                                             case
                                                when vnformataxaconv = 'T' then
                                                 ped.vlrdesptributitem
                                              end desc)
                           where rownum = 1);
                  /* atualiza a diferença para que a soma dos valores de rateio dos itens fique igual ao valor de rateio definido no
                  cabeçalho do pedido */
                  update mad_pedvendaitem a
                     set a.vlrdespntributitem = nvl(a.vlrdespntributitem, 0) +
                                                 decode(vnformataxaconv, 'N',
                                                        vnvlrdespacessoria -
                                                         vncalcdespacessoria, 0),
                         a.vlrdesptributitem = nvl(a.vlrdesptributitem, 0) +
                                                decode(vnformataxaconv, 'T',
                                                       vnvlrdespacessoria -
                                                        vncalcdespacessoria, 0)
                   where a.nropedvenda = vnnropedvenda
                     and a.seqpedvendaitem = vnminseqpedvendaitem
                     and a.nroempresa = vnnroemppedido;
                end if;
              end if;
              -- fim do rateio
              select max(x.nropedvenda)
                into vnnropedvenda
                from edi_pedvenda x
               where x.seqedipedvenda = t.seqedipedvenda;
              if vspd_usaregraincentivo = 'S' then
                spmad_gerapedvendaregra(vnnropedvenda,
                                        nvl(vnnroempresasec, t.nroempresa));
                spmad_aplicadescpedvendaregra(vnnropedvenda,
                                              nvl(vnnroempresasec,
                                                   t.nroempresa)); -- linha inserida após autorização no chamado n.53263.
              end if;
              if vspdatualizaacresdesccli = 'S' then
                spmad_aplicaacresdesccliente(vnnropedvenda,
                                             nvl(vnnroempresasec,
                                                  t.nroempresa));
              end if;
              -- alterado no rc 60244
              select nvl(max(a.prazoadicional), 0)
                into vnprazoregra
                from mad_pedvendaregra a
               where a.nropedvenda = vnnropedvenda
                 and a.nroempresa = nvl(vnnroempresasec, t.nroempresa);
              insert into mad_pedvendavenc
                (nropedvenda, nroempresa, nroparcela, nrodiavencto,
                 dtavencimento, valor, percvalorparcela)
                select a.nropedvenda, nvl(vnnroempresasec, a.nroempresa),
                       b.nroparcela, b.nrodiavencto + vnprazoregra,
                       b.dtavencimento, b.valor, 0
                  from madv_impedipedvenda a, edi_pedvendavenc b
                 where a.seqedipedvenda = t.seqedipedvenda
                   and b.seqedipedvenda = a.seqedipedvenda;
              -- req. 123878 - inserção dos componentes da receita ao invés do produto final
              sp_buscaparamdinamico('PED_VENDA', t.nroempresa,
                                    'INS_COMPONENTES_PROD_COMP_VAR', 'S',
                                    'N',
                                    'INSERIR OS COMPONENTES DO PRODUTO(AO INVÉS DO PRÓPRIO) QUANDO SE TRATAR DE UM PRODUTO DE COMPOSIÇÃO VARIÁVEL E FOR PRODUTO FINAL NA RECEITA?' ||
                                     chr(13) || chr(10) ||
                                     'S-NO PEDIDO DE VDA' || chr(13) ||
                                     chr(10) || 'N-NÃO USA(PADRÃO)' ||
                                     chr(13) || chr(10) ||
                                     'F-NO FATURAMENTO' || chr(13) ||
                                     chr(10) ||
                                     'B-OPÇÃO "S" E QUANDO FOR BONIFICADO',
                                    vspdinscomponentesprodcompvar);
              if vspdinscomponentesprodcompvar in ('S', 'B') then
                sp_trocaprodporcomponentes(null, vnnropedvenda,
                                           nvl(vnnroempresasec, t.nroempresa),
                                           t.seqpessoa, 'C', 'N', 'A');
              end if;
              sp_buscaparamdinamico('PED_VENDA', t.nroempresa,
                                    'UTIL_TRANSF_OUT_EMPRESA', 'S', 'N',
                                    'UTILIZA RECURSO TRANSFERIR DE OUTRA EMPRESA QUANDO UTILIZADO PARÂMETRO QUE USA ESTOQUE DE OUTRA EMPRESA NA VENDA/TRANSFERÊNCIA (PADRÃO = N).',
                                    vspd_utiltransfoutempresa);
              sp_buscaparamdinamico('PED_VENDA', t.nroempresa,
                                    'UTIL_PED_ITEM_MULTI_EMPRESA', 'S', 'N',
                                    'UTILIZA O RECURSO DE PERMITIR MONTAR OS ITENS DO PEDIDO PEGANDO PRODUTOS/ESTOQUE DE OUTRA EMPRESA ? (S/N) DEFAULT=N.',
                                    vspd_utilpeditemmultiempresa);
              if (vspd_utiltransfoutempresa = 'S') and
                 (vspd_utilpeditemmultiempresa = 'S') then
                select max(a.nroempresamultiemppedpalm)
                  into vnnroempresamultiemppedpalm
                  from mad_tabvenda a
                 where a.nrotabvenda = vnnrotabvenda;
                if vnnroempresamultiemppedpalm is not null then
                  spmad_pedtransfprocmultiempr(vnnewnropedvenda,
                                               nvl(vnnroempresasec,
                                                    t.nroempresa), null,
                                               vnnropedvendatransf);
                  spmad_pedvendaprocmultiempr('V', vnnewnropedvenda,
                                              nvl(vnnroempresasec,
                                                   t.nroempresa), null,
                                              vnnropedvendatransf);
                else
                  if nvl(t.indecommerce, 'N') != 'S' then
                    -- adicionado rc 170174 para usar o estoque outra empresa o pd vspd_utilpeditemmultiempresa tem que s para ecommerce
                    spmad_pedvendaprocmultiempr('T', vnnewnropedvenda,
                                                nvl(vnnroempresasec,
                                                     t.nroempresa), null);
                  end if;
                end if;
              end if;
              -- rc 144311 -- gerar desconto progressivo
              spmad_aplicadescprogprod(vnnropedvenda,
                                       nvl(vnnroempresasec, t.nroempresa));
              spmad_aplicadescprogfam(vnnropedvenda,
                                      nvl(vnnroempresasec, t.nroempresa));
            end if;
            select nvl(max(a.statuspedecommerce), 'L'),
                   nvl(max(a.indecommerce), 'N')
              into vssituacaopedido, vsindecommerce
              from edi_pedvenda a
             where a.seqedipedvenda = t.seqedipedvenda
               and a.nropedvenda > 0
               and a.indecommerce = 'S';
            select nvl(max(1), 0), max(b.seqpessoaemp)
              into vnexisteconfigsefazemp, vnseqpessoaemp
              from mad_parametro a, max_empresa b
             where a.nroempresa = b.nroempresa
               and a.nroempresa = t.nroempresa
               and a.indconsultasitclisefaz like '%P%';
            if vnexisteconfigsefazemp = 1 then
              if vspdedidiasverifsefaz > -1 then
                select a.dtaultconssefaz, a.indrestricaosefaz, b.uf,
                       b.nrocgccpf || lpad(b.digcgccpf, 2, 0),
                       b.fisicajuridica, b.inscricaorg
                  into vddtaultconssefaz, vsindrestricaosefaz, vsufsefaz,
                       vscgccpf, vsfisicajuridica, vsinscricaorg
                  from mrl_cliente a, ge_pessoa b
                 where a.seqpessoa = b.seqpessoa
                   and a.seqpessoa = vnseqpessoa;
                if (vddtaultconssefaz is null or
                   (sysdate - vddtaultconssefaz) > vspdedidiasverifsefaz) and
                   vnseqpessoa != vnseqpessoaemp then
                  select nvl(max(1), 0)
                    into vnexisteconfigsefazws
                    from max_webservice s, max_webserviceevento e,
                         max_webserviceeventojob j
                   where s.seqwebservice = e.seqwebservice
                     and e.seqwebservice = j.seqwebservice(+)
                     and e.seqevento = j.seqevento(+)
                     and e.soapaction = 'ConsultarCadastro'
                     and j.atributoespecifico(+) = vsufsefaz;
                  if vnexisteconfigsefazws = 1 then
                    spmad_restricaosefaz(vscgccpf, vsfisicajuridica,
                                         vsinscricaorg, vsufsefaz,
                                         vsresultsefaz, vsmsgconsulta);
                  end if;
                  if vsresultsefaz != nvl(vsindrestricaosefaz, '.') and
                     vsresultsefaz != 'X' then
                    update mrl_cliente a
                       set a.indrestricaosefaz = vsresultsefaz,
                           a.dtaultconssefaz = sysdate
                     where a.seqpessoa = vnseqpessoa;
                  end if;
                end if;
              end if;
            end if;
            if vsindecommerce = 'S' and vsindpreseparapedido = 'S' then
              update mad_pedvenda a
                 set a.situacaoped = 'L', a.indecommerce = vsindecommerce
               where a.nropedvenda in
                     (select x.nropedvenda
                        from edi_pedvenda x
                       where x.seqedipedvenda = t.seqedipedvenda);
              select count(1)
                into vncountcritica
                from mad_criticapedvenda a
               where a.nropedvenda in
                     (select x.nropedvenda
                        from edi_pedvenda x
                       where x.seqedipedvenda = t.seqedipedvenda);
              if vncountcritica = 0 then
                update mad_pedvenda a
                   set a.situacaoped = decode(a.indsepconfterc, 'S', 'W',
                                               decode(vsindpreseparapedido ||
                                                       vsindecommerce, 'SS', 'P',
                                                       'L')),
                       a.indecommerce = vsindecommerce
                 where a.nropedvenda in
                       (select x.nropedvenda
                          from edi_pedvenda x
                         where x.seqedipedvenda = t.seqedipedvenda);
              end if;
            else
              update mad_pedvenda a
                 set a.situacaoped = decode(a.indsepconfterc, 'S', 'W',
                                             decode(vsindpreseparapedido ||
                                                     vsindecommerce, 'SS', 'P',
                                                     'L')),
                     a.indecommerce = vsindecommerce
               where a.nropedvenda in
                     (select x.nropedvenda
                        from edi_pedvenda x
                       where x.seqedipedvenda = t.seqedipedvenda);
            end if;
            --
            vslistacgossepauto := null;
            if (vspdgravastatussepauto = 'S' or
               (vspdgravastatussepauto = 'C' and
               vspdcgostatussepauto != ' ')) and
               (vsindpreseparapedido = 'S' or vsindecommerce = 'S') then
              if vspdcgostatussepauto != ' ' and
                 vspdgravastatussepauto = 'C' then
                select trim(both ',' from trim(vspdcgostatussepauto))
                  into vslistacgossepauto
                  from dual;
                if vslistacgossepauto is not null then
                  update mad_pedvenda a
                     set a.statusseparacao = 'G'
                   where a.nropedvenda in
                         (select x.nropedvenda
                            from edi_pedvenda x
                           where x.seqedipedvenda = t.seqedipedvenda)
                     and a.codgeraloper in
                         (select column_value
                            from table(cast(c5_complexin.c5intable(vslistacgossepauto) as
                                             c5instrtable)));
                end if;
              else
                update mad_pedvenda a
                   set a.statusseparacao = 'G'
                 where a.nropedvenda in
                       (select x.nropedvenda
                          from edi_pedvenda x
                         where x.seqedipedvenda = t.seqedipedvenda);
              end if;
            end if;
            update edi_pedvenda a
               set a.statuspedido = 'F', a.statusexportacao = 0,
                   a.dtabaseexportacao = sysdate
             where a.seqedipedvenda = t.seqedipedvenda
               and a.nropedvenda > 0;
            -- frete
            select case
                     when nvl(max(a.vlrtotfrete), 0) > 0 and
                          nvl(max(a.indecommerce), 'N') = 'S' then
                      1
                     else
                      0
                   end
              into vncount
              from madv_impedipedvenda a
             where a.seqedipedvenda = t.seqedipedvenda
               and a.nropedidoafvref is null;
            if vncount > 0 then
              update mad_pedvenda a
                 set a.indusafreterateio = 'S'
               where a.nropedvenda in
                     (select x.nropedvenda
                        from edi_pedvenda x
                       where x.seqedipedvenda = t.seqedipedvenda);
              for x in (select a.nropedvenda
                          from edi_pedvenda a
                         where a.seqedipedvenda = t.seqedipedvenda)
              loop
                spmad_rateiaitemfrete(x.nropedvenda,
                                      nvl(vnnroempresasec, t.nroempresa),
                                      'S');
              end loop;
            end if;
            
                       select count(*)
                        into v_numero_itens_edi
                        from edi_pedvendaitem a
                       where a.seqedipedvenda = pnseqedipedvenda;
                      
                      select count(*)
                        into v_numero_itens_mad
                        from mad_pedvenda a
                       inner join mad_pedvendaitem b
                          on a.nropedvenda = b.nropedvenda
                         and a.nroempresa = b.nroempresa
                       where a.nropedvenda = vnnewnropedvenda
                         and a.nrorepresentante = vnnrorepresentante;
                      
                      if v_numero_itens_edi <> v_numero_itens_mad then
                        
                         raise v_erro;
                        
                      end if;
            
            sp_buscaparamdinamico('PED_VENDA', t.nroempresa,
                                  'CGO_BONIFICACAO_FORNECEDOR', 'N', '0',
                                  'CGO QUE SERÁ UTILIZADO PARA BONIFICAÇÃO DE FORNECEDOR QUANDO O VALOR DE VERBA FOR IGUAL AO VALOR TOTAL DO PEDIDO DE VENDA' ||
                                   chr(13) || chr(10) ||
                                   '0-NÃO INFORMADO(VALOR PADRÃO)',
                                  vscgoboniffornec);
            vnpdcgoboniffornec := to_number(vscgoboniffornec);
            for vtverbafornec in (select a.nropedvenda, a.nroempresa
                                    from edi_pedvenda a
                                   where a.seqedipedvenda = t.seqedipedvenda
                                     and exists
                                   (select 1
                                            from edi_pedvendaverba x,
                                                 maf_fornecedor y
                                           where x.seqfornecedor =
                                                 y.seqfornecedor
                                             and x.seqedipedvenda =
                                                 a.seqedipedvenda
                                             and y.indpermdescvenda = 'S'
                                             and x.vlrverba > 0))
            loop
              -- diminui a verba proporcionalmente ao corte
              merge into mad_pedvendaverbaafv a
              using (select a.nropedvenda, a.nroempresa, c.seqfornecedor,
                            sum(a.vlrembinformado * a.qtdpedida /
                                 a.qtdembalagem) vlrpedido,
                            sum(a.vlrembinformado * a.qtdatendida /
                                 a.qtdembalagem) vlratendido
                       from mad_pedvendaitem a, map_produto b,
                            map_famfornec c
                      where a.seqproduto = b.seqproduto
                        and b.seqfamilia = c.seqfamilia
                        and a.nropedvenda = vtverbafornec.nropedvenda
                        and a.nroempresa =
                            nvl(vnnroempresasec, vtverbafornec.nroempresa)
                        and a.qtdpedida > 0
                      group by a.nropedvenda, a.nroempresa, c.seqfornecedor) b
              on (a.nropedvenda = b.nropedvenda and a.nroempresa = b.nroempresa and a.seqfornecedor = b.seqfornecedor)
              when matched then
                update
                   set a.vlrverba = a.vlrverba / b.vlrpedido * b.vlratendido,
                       a.vlrcorteverba = a.vlrverba -
                                          (a.vlrverba / b.vlrpedido *
                                          b.vlratendido);
              -- busca o valor total do pedido
              select sum(b.vlrembinformado * b.qtdatendida / b.qtdembalagem)
                into vnvlrtotpedido
                from mad_pedvenda a, mad_pedvendaitem b
               where a.nropedvenda = b.nropedvenda
                 and a.nroempresa = b.nroempresa
                 and a.nropedvenda = vtverbafornec.nropedvenda
                 and a.nroempresa =
                     nvl(vnnroempresasec, vtverbafornec.nroempresa)
                 and b.qtdatendida > 0;
            
              -- busca o valor total de verba do pedido
              select sum(a.vlrverba)
                into vnvlrtotverba
                from mad_pedvendaverbaafv a
               where a.nropedvenda = vtverbafornec.nropedvenda
                 and a.nroempresa =
                     nvl(vnnroempresasec, vtverbafornec.nroempresa);
              -- caso o valor de verba do pedido for igual ao valor total do pedido o cgo é alterado para o cgo de bonificação
              if vnvlrtotverba > 0 and vnvlrtotverba >= vnvlrtotpedido then
                if vnpdcgoboniffornec > 0 then
                  update mad_pedvenda a
                     set a.codgeraloper = vnpdcgoboniffornec
                   where a.nropedvenda = vtverbafornec.nropedvenda
                     and a.nroempresa =
                         nvl(vnnroempresasec, vtverbafornec.nroempresa);
                end if;
              else
                spmad_rateiadescverbafornec(vtverbafornec.nropedvenda,
                                            nvl(vnnroempresasec,
                                                 vtverbafornec.nroempresa));
              end if;
            end loop;
            select sum(a.qtdbonificada)
              into vnqtdbonificada
              from edi_pedvendaitem a
             where a.seqedipedvenda = t.seqedipedvenda;
            if vnqtdbonificada > 0 then
              spmad_geraitensboniffornec(t.seqedipedvenda);
            end if;
          end if;
          --importação da forma de pagamento
          for vtformapagto in (select a.nropedvenda, a.nroempresa,
                                      b.nroformapagto, b.nrocondpagto,
                                      b.valor, b.linkerp,
                                      b.codoperadoracartao, b.nrogiftcard,
                                      b.nrocartao, b.nroparcela,
                                      b.seqpedvendaformapagto, b.codbandeira,
                                      b.codbin
                                 from edi_pedvenda a,
                                      edi_pedvendaformapagto b
                                where b.seqedipedvenda = a.seqedipedvenda
                                  and a.indecommerce = 'S'
                                  and a.seqedipedvenda = t.seqedipedvenda)
          loop
            insert into mad_pedvendaformapagto
              (nropedvenda, nroempresa, nroformapagto, nrocondpagto, valor,
               linkerp, codoperadoracartao, nrogiftcard, nrocartao,
               nroparcela, seqpedvendaformapagto, codbandeira, codbin)
            values
              (vtformapagto.nropedvenda,
               nvl(vnnroempresasec, vtformapagto.nroempresa),
               vtformapagto.nroformapagto, vtformapagto.nrocondpagto,
               vtformapagto.valor, vtformapagto.linkerp,
               vtformapagto.codoperadoracartao, vtformapagto.nrogiftcard,
               vtformapagto.nrocartao, vtformapagto.nroparcela,
               vtformapagto.seqpedvendaformapagto, vtformapagto.codbandeira,
               vtformapagto.codbin);
          end loop;
        end if;
        select a.indtiposeparacaoecom, nvl(a.indfaturaautopedecomm, 'N')
          into vsindtiposeparacaoecom, vsindfaturaautopedecomm
          from mad_parametro a
         where a.nroempresa = t.nroempresa;
        select max(a.usuinclusao), max(a.statusseparacao)
          into vsusugeracao, vsstatusseparacao
          from mad_pedvenda a
         where a.nropedvenda = vsnropedvendacarga
           and a.nroempresa = nvl(vnnroempresasec, t.nroempresa);
        -- gera carga de expedição se indtiposeparacaoecom = 'P'
        if vsindtiposeparacaoecom = 'P' then
          spmad_geracargapedvenda(nvl(vnnroempresasec, t.nroempresa),
                                  vsnropedvendacarga, vsusugeracao);
        elsif vsindfaturaautopedecomm in ('S', 'E') and
              vsindtiposeparacaoecom != 'P' and vsstatusseparacao = 'F' then
          -- realiza o faturamento do pedido
          pkg_mad_faturamento.sp_fatura_pedido(vsnropedvendacarga,
                                               nvl(vnnroempresasec,
                                                    t.nroempresa),
                                               vsusugeracao);
          -- realiza a emissão dos boletos e nota fiscal, relacionados ao pedido
          if vsindfaturaautopedecomm = 'E' then
            -- busca as notas fiscais geradas pelo faturamento
            for tn in (select a.seqnotafiscal, a.numerodf, a.seriedf,
                              a.nroserieecf, a.dtahoremissao, a.nrocarga,
                              a.nroempresa, a.seqpessoa, a.nropedidovenda,
                              a.nroformapagto, a.nrocondicaopagto, a.seqnf,
                              a.seqvendedor, nvl(b.tipodocto, 'N') tipodocto,
                              nvl(c.tipoemisnfe, 'I') tipoemisnfe,
                              a.codgeraloper, c.cgosaiprontaentrega
                         from mfl_doctofiscal a, max_empserienf b,
                              max_empresa c
                        where a.nroempresa = b.nroempresa
                          and a.seriedf = b.serienf
                          and a.nroempresa = c.nroempresa
                          and a.nropedidovenda = vsnropedvendacarga
                          and a.nroempresa =
                              nvl(vnnroempresasec, t.nroempresa)
                          and a.statusdf != 'C')
            loop
              -- emissão de notas fiscais
              update mfl_doctofiscal a
                 set a.indemissaonf = 'S', a.usuemitiu = vsusugeracao,
                     a.dtahorsaida = tn.dtahoremissao,
                     a.dtaimpressao = trunc(sysdate)
               where a.numerodf = tn.numerodf
                 and a.seriedf = tn.seriedf
                 and a.nroserieecf = tn.nroserieecf
                 and a.nroempresa = tn.nroempresa;
              if tn.tipodocto = 'E' and
                 (tn.tipoemisnfe = 'P' or tn.tipoemisnfe = 'H') then
                sp_exportanfe(tn.seqnotafiscal, 'E');
              end if;
            end loop;
            -- emissão de boletos
            for tb in (select b.seriedf, b.statusnfe, b.numerodf, a.nrocarga
                         from mrl_titulofin a, mfl_doctofiscal b
                        where a.nrodocumento = b.numerodf
                          and a.seriedoc = b.seriedf
                          and a.nroserieecf = b.nroserieecf
                          and a.nroempresa = b.nroempresa
                          and b.nropedidovenda = vsnropedvendacarga
                          and b.nroempresa =
                              nvl(vnnroempresasec, t.nroempresa)
                          and a.seqctacorrente is not null
                          and a.nrobanco is not null
                          and a.nrocarteiracobr is not null
                          and b.nrocarga is not null)
            loop
              update mrl_titulofin a
                 set a.seqboleto = pkg_financeiro.ffip_buscaseq()
               where a.seqctacorrente is not null
                 and a.nrobanco is not null
                 and a.nrocarteiracobr is not null
                 and a.nrocarga = tb.nrocarga;
            end loop;
          end if;
        end if;
      end if;
    exception
      when others then
        -- desfaz as transações em caso de erro e gera os logs.
        rollback;
        vserro := sqlerrm;
        vserro := vserro || ' Nro Pedido AFV ' || t.nropedidoafv;
        sp_gravalog(t.seqedipedvenda, null, sysdate, vserro, 0,
                    'IMP_EDI_VENDA_PEDIDO');
        if lower(vserro) not like '%deadlock%' then
          update edi_pedvenda a
             set a.statuspedido = 'R'
           where a.seqedipedvenda = t.seqedipedvenda;
          if vdpdemailerroimportacao != 'N' then
            obj_param_smtp := c5_tp_param_smtp(t.nroempresa);
            if obj_param_smtp.criadocomsucesso = 0 then
              return;
            end if;
            for w in (select column_value email
                        from table(cast(c5_complexin.c5intable(vdpdemailerroimportacao) as
                                         c5instrtable)))
            loop
              vdpdemailerroimportacao := lower(w.email);
              vsmensagem := fc5_geramsghtmlerroedi(t.seqedipedvenda,
                                                   t.nroempresa,
                                                   t.nropedidoafv,
                                                   t.seqpessoa, vserro);
              -- envia e-mail, e se ocorrer erro no envio continua processamento
              begin
                sp_envia_email(obj_param => obj_param_smtp,
                               psdestinatario => vdpdemailerroimportacao,
                               psassunto => 'ERRO IMPORTACAO PEDIDOS EDI',
                               psmensagem => vsmensagem, psindusahtml => 'S');
              exception
                when others then
                  null;
              end;
            end loop;
          end if;
        else
          -- volta o status do pedido para importar novamente, caso tenha dado erro de deadlock
          update edi_pedvenda a
             set a.statuspedido = 'L'
           where a.seqedipedvenda = t.seqedipedvenda;
        end if;
        --exit;
        if nvl(t.indecommerce, 'N') = 'S' then
          raise_application_error(-20200, vserro);
        end if;
    end;
    commit;
  end loop;
  -- importa nsu de pedido
  for t in (select a.rowid, a.nsu, a.nroformapagto, c.nroempresa,
                   c.nropedvenda, c.seqpessoa, c.nrorepresentante
              from edi_pedvendansu a, edi_pedvenda b, mad_pedvenda c
             where a.seqedipedvenda = b.seqedipedvenda
               and b.nropedvenda = c.nropedvenda
               and b.nroempresa = c.nroempresa
               and b.nropedidoafv = c.nropedidoafv
               and b.indecommerce = 'S'
               and a.seqedipedvenda =
                   nvl(pnseqedipedvenda, a.seqedipedvenda)
               and nvl(a.statusimportacao, 'P') = 'P')
  loop
    if t.nsu is not null then
      select max(1)
        into vnexistensu
        from mad_pedvendansu a
       where a.nropedvenda = t.nropedvenda
         and a.nroempresa = t.nroempresa
         and a.nroformapagto = t.nroformapagto;
      if vnexistensu is not null then
        update mad_pedvendansu a
           set a.nsu = t.nsu, a.dtahorimportacao = sysdate
         where a.nropedvenda = t.nropedvenda
           and a.nroempresa = t.nroempresa
           and a.nroformapagto = t.nroformapagto;
      else
        vnnroempresasec := fverificaempresaatendimento(t.nroempresa,
                                                       t.seqpessoa,
                                                       t.nrorepresentante,
                                                       'T');
        insert into mad_pedvendansu
          (seqnsupedvenda, nropedvenda, nroempresa, nroformapagto, nsu,
           valorparcela, nrocartao, rede, bandeira, bin, dtahorimportacao)
          select b.seqnsupedvenda, a.nropedvenda,
                 nvl(vnnroempresasec, a.nroempresa), b.nroformapagto, b.nsu,
                 b.valorparcela, b.nrocartao, b.rede, b.bandeira, b.bin,
                 sysdate
            from madv_impedipedvenda a, edi_pedvendansu b
           where a.seqedipedvenda = b.seqedipedvenda
             and b.rowid = t.rowid
             and nvl(b.statusimportacao, 'P') = 'P';
      end if;
      update edi_pedvendansu a
         set a.statusimportacao = 'F'
       where a.rowid = t.rowid;
    end if;
  end loop;
  --recados
  vninconsistencia := 0;
  for t in (select a.seqedipedvendarecado
              from edi_pedvendarecado a
             where a.statusimportacao = 'P'
               and a.nrorepgeracao =
                   nvl(pnnrorepresentante, a.nrorepgeracao))
  loop
    sp_imp_edipedvendacritica(null, null, t.seqedipedvendarecado, 'R',
                              vninconsistencia, null, null); --faz consistencia dos recados
    if vninconsistencia = 0 then
      sp_imp_edipedvendarecado(t.seqedipedvendarecado); --integração recados
    end if;
  end loop;

exception
  when v_erro then
    rollback;
    raise_application_error(-20200, 'Pedidos incompleto');
  when others then
    raise_application_error(-20200, sqlerrm);
end sp_imp_edipedvenda;
/
