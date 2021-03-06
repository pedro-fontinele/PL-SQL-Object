create or replace trigger tad_mrl_prodlocal
       after delete on mrl_prodlocal for each row

declare
  vnnumrow integer;

begin

    select count(1)
    into vnnumrow
    from mrl_lanctoestoque a
    where a.seqproduto = :old.seqproduto
    and a.nroempresa = :old.nroempresa
    and a.local = :old.seqlocal;

   if vnnumrow > 0 then

      raise_application_error(-20200, 'Este local possui movimenta��es e n�o pode ser excluido');

  end if;

exception
  
  when others then
      raise_application_error(-20200, sqlerrm);
      
      
        /*      create table mrl_prodlocal
        (
          seqproduto        integer not null,
          seqlocal          number(3) not null,
          nroempresa        number(3) not null,
          estoque           number(15,3) not null,
          nrorua            varchar2(3),
          nropredio         varchar2(3),
          nrovao            varchar2(3),
          nrosala           varchar2(3),
          localtura         number(5),
          loclargura        number(5),
          locprofundidade   number(5),
          dtaalteracao      date,
          usualteracao      varchar2(12),
          nrobaseexportacao number(10) default 1 not null,
          prodlocalpadrao   varchar2(1)
        );*/
        
        
               /* create table mrl_lanctoestoque
        (
          seqmovtoestq                  number(15) not null,
          nroempresa                    number(3) not null,
          dtaentradasaida               date not null,
          seqproduto                    integer not null,
          seqprodutobase                integer,
          tiplancto                     varchar2(1) not null,
          local                         number(3) not null,
          codgeraloper                  number(3) not null,
          tipusocgo                     varchar2(1) not null,
          qtdlancto                     number(12,3) not null,
          valorvlrnf                    number(19,6) not null,
          valoripi                      number(19,6) not null,
          valoricms                     number(19,6) not null,
          valoricmsst                   number(19,6) not null,
          valordespnf                   number(19,6) not null,
          valordespforanf               number(19,6) not null,
          valordctoforanf               number(19,6) not null,
          valorcomissao                 number(15,4) not null,
          valoriss                      number(15,2),
          valorpis                      number(19,6),
          valorcofins                   number(19,6),
          nronfcupom                    number(5) not null,
          recalcustomedio               varchar2(1) not null,
          acmcompravenda                varchar2(1) not null,
          acmmediavenda                 varchar2(1),
          geralteracaoestq              varchar2(1),
          geralteracaoestqfisc          varchar2(1),
          indusaverbabonif              varchar2(1) not null,
          nrodocumento                  number(10),
          dtahorlancto                  date not null,
          usulancto                     varchar2(12) not null,
          indgeracredipi                varchar2(1),
          vlricmsantecipado             number(19,6),
          vlricmspresumido              number(19,6),
          historico                     varchar2(250),
          motivomovto                   varchar2(5),
          seqloteestoque                number,
          nrosegmento                   number(2),
          perdespoperacional            number(6,4),
          ressarcstvenda                varchar2(1),
          seqmovtoorig                  number(15),
          vlricmsvpe                    number(15,2),
          seqlanctoavaria               integer,
          apporigem                     number(2),
          seqoperador                   integer,
          perdespoperacionalitem        number(6,4),
          qtdprodbase                   number(12,3),
          cmdiacusliquidoemp            number(19,6),
          cmdiacredicmsemp              number(19,6),
          cmdiacredpisemp               number(19,6),
          cmdiacredcofinsemp            number(19,6),
          cmdiacredicmsantemp           number(19,6),
          cmdiacredicmspresemp          number(19,6),
          indgeracustotabfornec         varchar2(1),
          vlricmsstdistrib              number(15,6),
          basicmsstdistrib              number(15,6),
          peraliquotapis                number(7,4),
          peraliquotacofins             number(7,4),
          vlrcompror                    number(10,2),
          indsomentevda                 varchar2(1),
          vlrdescincondic               number(19,6),
          seqmovestqterc                number(15),
          colteste                      varchar2(1),
          seqprocesso                   integer,
          vlrdescpistransf              number(15,2),
          vlrdesccofinstransf           number(15,2),
          vlrdescicmstransf             number(15,2),
          indusaverbatransf             varchar2(1),
          vlrverbanf                    number(12,6),
          motivomovtolocus              varchar2(5),
          indcfaonline                  varchar2(1),
          vlricmsestorno                number(12,2),
          seqprodintauxnotafiscal       number(15),
          cmdiacredipiemp               number(15,6),
          vlrdescipitransf              number(15,2),
          vlrdesclucrotransf            number(15,2),
          percipivirtual                number(7,4),
          vlripivirtual                 number(19,6),
          vlripivirtualdif              number(19,6),
          nroecf                        varchar2(5),
          seqfinalidademovto            number,
          nrodoctr                      integer,
          dtahorexpsngpc                date,
          usuexpsngpc                   varchar2(12),
          centrocusto                   number(15),
          bascalcicmsstultentunit       number(16,6),
          peraliquotaultentunit         number(12,2),
          indentufdifemp                varchar2(1),
          valordespforanfsemincid       number(19,6),
          acmcompravendadevol           varchar2(1),
          seqatividadeusuario           number(15),
          vlrdescverbatransf            number(15,2),
          seqnfcomplopint               integer,
          valorverbacompra              number(19,6),
          valorverbabonifincid          number(19,6),
          valorverbabonifsemincid       number(19,6),
          valorvlrnfbonif               number(19,6),
          valoripibonif                 number(19,6),
          valoricmsbonif                number(19,6),
          valoricmsstbonif              number(19,6),
          valordespnfbonif              number(19,6),
          valordespforanfbonif          number(19,6),
          valordctoforanfbonif          number(19,6),
          recalcustomediobonif          varchar2(1),
          valorpisbonif                 number(19,6),
          valorcofinsbonif              number(19,6),
          valordespforanfsemincidbonif  number(19,6),
          indutilcalccustofiscbonifdif  varchar2(1),
          vlrvdapromocao                number(15,2),
          vlrdescdiferencatransf        number(15,2),
          indsomafecpcustoprod          varchar2(1),
          indsomafecpcustofis           varchar2(1),
          indsomafecpcustoger           varchar2(1),
          vlrfecp                       number(15,2),
          seriedocto                    varchar2(3),
          nroserieecf                   varchar2(40),
          seqnf                         number(15),
          indutilizadecreto46517        varchar2(1),
          indsomaicmsantecipadocusto    varchar2(1),
          seqreceitarendto              number(9),
          tiporeg                       varchar2(1),
          indsomadespdescfixacustoger   varchar2(1),
          indsomadespdescfixacustofis   varchar2(1),
          valordespfixa                 number(15,6),
          valordescfixo                 number(15,6),
          valorfreteforanf              number(12,2),
          indsomavlrfreteforanfcustoger varchar2(1),
          indsomavlrfreteforanfcustofis varchar2(1),
          qtdverbapdv                   number(12,3),
          vlrverbapdv                   number(15,6),
          vlrpiscofinsverbapdv          number(15,6),
          valordescverbasellin          number(15,6),
          vlrtotalvdanormal             number(13,2),
          tipopromocpdv                 varchar2(1),
          seqpromocpdv                  number,
          vlrdescfornec                 number(13,2),
          vlrdescfornecdevol            number(13,2),
          valoricmscalc                 number(19,6),
          cmdiacredicmscalcemp          number(19,6),
          vlrfreteitemrateio            number(15,2),
          vlricmsstembutprod            number(13,2),
          seqcluster                    number,
          seqprodutogerinsumo           integer,
          seqlanctoproducao             number,
          vlrdescresticmstransf         number(15,2),
          indbaixaverba                 varchar2(1),
          vlrdescacordoverbapdv         number(15,2),
          indsomaicmsantecipadocustofis varchar2(1),
          valoricmscustofiscal          number(19,6),
          vlricmsantecipadobruto        number(19,6),
          testecc5                      number(15,2),
          seqprodautomovto              number,
          vlricmssolicit                number(17,2),
          seqordproducao                number(15),
          vlrdescverbatransfsellin      number(15,6),
          valorfreteforanfcusto         number(15,2),
          seqnfultentrorig              number,
          inddevtotal                   varchar2(1),
          seqnfultentrcompra            number(15),
          seqnfultentrada               number(15),
          seqnfultcompracusto           number(15),
          seqnfultentrcusto             number(15),
          pzopagamento                  varchar2(40),
          vlrdesccontrato               number(15,6),
          tippedidosuprim               varchar2(1),
          vlrdesccontratogcprecif       number(18,5),
          vlrdesccontratogccomerc       number(18,5),
          basicmsdistrib                number(15,6),
          vlricmsdistrib                number(15,6),
          inddevtotalpd                 varchar2(1),
          vlrdesccontratogcprecifpis    number(15,6),
          vlrdesccontratogcprecifcofins number(15,6),
          vlrdesccontratogccomercpis    number(15,6),
          vlrdesccontratogccomerccofins number(15,6),
          basefcpdistrib                number(15,2),
          vlrfcpdistrib                 number(15,2),
          basefcpicms                   number(15,2),
          vlrfcpicms                    number(15,2),
          basefcpst                     number(15,2),
          vlrfcpst                      number(15,2),
          valorbasest                   number(19,6),
          valoricmsorig                 number(19,6),
          valoricmsstorig               number(19,6),
          versao                        number(3),
          vlrdesctransfcontgcprecif     number(18,5),
          vlrdesctransfcontgccomerc     number(18,5),
          vlrdivergpednf                number(18,5),
          vlrdivergpednfotp             number(18,5),
          vlrdivergpednfotc             number(18,5),
          vlrimpostopresum              number(19,6),
          cmdiaimpostopresumemp         number(19,6),
          indcontrapartidast            varchar2(1),
          indverbaassincrona            varchar2(1),
          dtahoraprocverbaassinc        date,
          indproximovencto              varchar2(1),
          indvdaproximovencto           varchar2(1),
          valoricmsstultentrada         number(19,6),
          valoricmsultentrada           number(19,6)
        );*/

end tad_mrl_prodlocal;
/
