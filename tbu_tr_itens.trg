create or replace trigger tbu_tr_itens
       before update of statusdf on tr_notas for each row

       --> Esta trigger cancela os itens no momento que a nota fiscal � cancelada
       --> Pedro Fontinele

begin

  if (:new.statusdf = 'C' and :old.statusdf = 'V') then

  update tr_itens b
  set b.statusitem = 'C'
  where b.numerodf = :new.numerodf
  and b.seriedf = :new.seriedf
  and b.nroempresa = :new.nroempresa
  and b.nroserieecf = :new.nroserieecf;

  end if;

     /*create table TR_NOTAS
        (
          numerodf                NUMBER(10) not null,
          seriedf                 VARCHAR2(3) not null,
          nroserieecf             VARCHAR2(40) not null,
          nroempresa              NUMBER(3) not null,
          nroecf                  VARCHAR2(5),
          statusdf                VARCHAR2(1) not null,
          seqpessoa               NUMBER not null,
          seqpessoaend            NUMBER(4),
          versaopessoa            NUMBER(2) not null,
          seqvendedor             NUMBER(5),
          nropedidovenda          NUMBER(10),
          origempedido            VARCHAR2(1),
          codoperador             VARCHAR2(12),
          codgeraloper            NUMBER(3) not null,
          modelodf                VARCHAR2(2),
          nroformapagto           NUMBER(5),
          nrocondicaopagto        NUMBER(3),
          dtavencimento           DATE,
          ufdestino               VARCHAR2(2) not null,
          cfop                    NUMBER(5) not null,
          dtahoremissao           DATE not null,
          dtamovimento            DATE not null,
          dtabasevencimento       DATE,
          dtalancamento           DATE,
          origemdocumento         VARCHAR2(1),
          prazomediovencto        NUMBER(7,2),
          prazoadicional          NUMBER(5),
          seqoperador             INTEGER not null,
          nrocheckout             NUMBER(3),
          indfechamento           VARCHAR2(1) not null,
          indusaverbabonif        VARCHAR2(1),
          dtacancelamento         DATE,
          usucancelou             VARCHAR2(12),
          versaoaplicacao         VARCHAR2(10),
          indemissaonf            VARCHAR2(1),
          observacao              VARCHAR2(500),
          observacaolf            VARCHAR2(2000),
          nrosegmento             NUMBER(2),
          nrocarga                NUMBER(8),
          indreplicacao           VARCHAR2(1),
          indgeroureplicacao      VARCHAR2(1),
          vlrindenizacao          NUMBER(12,2),
          seqtransportador        NUMBER,
          placaveiculo            VARCHAR2(15),
          tipofrete               VARCHAR2(1),
          nrobancocobr            NUMBER(4),
          nrocarteiracobr         NUMBER(3),
          nroempresacobr          NUMBER(3),
          vlrfreteterc            NUMBER(15,2),
          vlrbaseicmsfreteterc    NUMBER(15,2),
          peraliqicmsfreteterc    NUMBER(4,2),
          indgeramovtoautowms     VARCHAR2(1),
          qtdtotvolume            NUMBER(5),
          pesototbruto            NUMBER(10,3),
          pesototliquido          NUMBER(10,3),
          nropedcliente           VARCHAR2(20),
          statusrefatura          VARCHAR2(1),
          dtarefatura             DATE,
          usurefatura             VARCHAR2(12),
          seqpagador              NUMBER,
          motivocancelou          VARCHAR2(1000),
          linkerp                 NUMBER(15),
          seqctacorrente          NUMBER(15),
          seqgnre                 NUMBER(10),
          indexpafv               VARCHAR2(1),
          geradescicms            VARCHAR2(1),
          geradescpis             VARCHAR2(1),
          geradesccofins          VARCHAR2(1),
          geradescir              VARCHAR2(1),
          geradesccsll            VARCHAR2(1),
          dtahorsaida             DATE,
          seqtranspredesp         NUMBER,
          ufplacaveiculo          VARCHAR2(2),
          apporigem               NUMBER(2),
          geradescinss            VARCHAR2(1),
          nroregtributacao        NUMBER(5),
          geradesciss             VARCHAR2(1),
          indgerouedi             VARCHAR2(1),
          nronsunf                NUMBER(10),
          nfreferencianro         NUMBER(10),
          nfreferenciaserie       VARCHAR2(3),
          nroformini              NUMBER(15),
          nroformfim              NUMBER(15),
          nroseloini              NUMBER(15),
          nroselofin              NUMBER(15),
          serieselo               VARCHAR2(3),
          nroaidf                 VARCHAR2(60),
          nrointernoreceb         NUMBER(10),
          dtaimpressao            DATE,
          nrocgccpf               NUMBER(13),
          digcgccpf               NUMBER(2),
          nomerazao               VARCHAR2(100),
          indconcdescbaseicms     VARCHAR2(1),
          seqnotafiscal           NUMBER(15),
          nfechaveacesso          VARCHAR2(44),
          statusnfe               NUMBER(2),
          nfeambiente             VARCHAR2(1),
          nfenroprotenvio         VARCHAR2(20),
          nfedtaenv               DATE,
          nfedtacanc              DATE,
          nfenroprotcanc          VARCHAR2(20),
          danfeemitida            VARCHAR2(1),
          indsusppiscofins        VARCHAR2(1),
          usuemitiu               VARCHAR2(12),
          indmercpdterc           VARCHAR2(1),
          seqreceitarendto        INTEGER,
          qtdponto                NUMBER(12,3),
          peraliqicmssimplesnac   NUMBER(5,2),
          codclasscomerc          VARCHAR2(5),
          pontoimpressaosel       VARCHAR2(40),
          dotzid                  VARCHAR2(20),
          dotzpontos              NUMBER(5),
          placaveiculoaux         VARCHAR2(15),
          ufplacaveiculoaux       VARCHAR2(2),
          vlrbaseicmsfretetransp  NUMBER(15,2),
          vlricmsfretetransp      NUMBER(15,2),
          peraliqicmsfretetransp  NUMBER(4,2),
          usucancelouaux          VARCHAR2(12),
          dtacancelamentoaux      DATE,
          codgeraloperdevaux      NUMBER(3),
          ocorrenciadevaux        VARCHAR2(5),
          indretornocancsefaz     VARCHAR2(1),
          apporigemcanc           NUMBER(2),
          indgeravdadevol         VARCHAR2(1),
          ocorrenciadev           VARCHAR2(5),
          vlrfrete_maxtransp      NUMBER(15,2),
          seqlocalterc            NUMBER(3),
          seqnf                   NUMBER,
          indnfbasecp             VARCHAR2(1),
          nfechaveabort           VARCHAR2(44),
          seqnfref                NUMBER,
          nropromotor             NUMBER(5),
          indrevisaostatus        VARCHAR2(1),
          obsdenuncianfe          VARCHAR2(250),
          indmaxprazocancel       VARCHAR2(1),
          dtahoralteratransp      DATE,
          pontoimpressaoautoriza  VARCHAR2(40),
          indnfremessamerc        VARCHAR2(1),
          seqprontaentrega        NUMBER(8),
          obsnfref                VARCHAR2(500),
          seqprodintauxnotafiscal NUMBER(15),
          indretornoevento        VARCHAR2(1),
          indgeranfdevfornsubst   VARCHAR2(1),
          nfechavenova            VARCHAR2(44),
          indavaliaentrega        NUMBER(1),
          dtahorctrlentrega       DATE,
          usuarioctrlentrega      VARCHAR2(12),
          vlrfreteabc             NUMBER(15,4),
          jobnfeuser              VARCHAR2(30),
          jobnfeseg               VARCHAR2(30),
          jobnfeenvio             VARCHAR2(30),
          nroequiperepdtamovto    NUMBER(3),
          codareageograficavda    NUMBER,
          codsubareageograficavda NUMBER,
          nfreferenciaseqpessoa   NUMBER,
          inddepositofechado      VARCHAR2(1),
          nfedtaprotcancextemp    DATE,
          nfenroprotcancextemp    VARCHAR2(20),
          indreplicanfref         VARCHAR2(1),
          seqauxnotafiscalorigem  NUMBER(15),
          nfrefnfechaveacesso     VARCHAR2(44),
          indfatcruzado           VARCHAR2(1),
          indnfintegrafiscal      NUMBER(3),
          qtddiasprazoregra       NUMBER(3),
          dtahormovimento         DATE,
          geralivrocprod          VARCHAR2(1),
          geralteracaoestqfisc    VARCHAR2(1),
          tracknumber             VARCHAR2(80),
          nfesegcodbarra          VARCHAR2(36),
          indemissaonfprogponto   VARCHAR2(1),
          indtitulofingerado      VARCHAR2(1),
          indconsumidorfinal      VARCHAR2(1),
          nfefinalidadeemissao    VARCHAR2(20),
          cfechaveacesso          VARCHAR2(44),
          inddevtransf            VARCHAR2(1),
          geralteracaoestq        VARCHAR2(1),
          observacaonfe           VARCHAR2(4000),
          indexportacaofisci      VARCHAR2(1),
          seqexportacaofisci      NUMBER(15),
          qtdvolumeredespachodig  NUMBER,
          pdvorigem               INTEGER,
          medpacientenome         VARCHAR2(40),
          medpacientedatanasc     DATE,
          medpacientesexo         VARCHAR2(1),
          medcompradornome        VARCHAR2(40),
          medcompradortipdocto    NUMBER,
          medcompradornrodocto    VARCHAR2(20),
          medcompradororgdocto    VARCHAR2(6),
          medcompradorufdocto     VARCHAR2(2),
          seqpessoarep            NUMBER,
          execinclusao            VARCHAR2(100),
          execalteracao           VARCHAR2(100),
          indtransbordomdfe       VARCHAR2(1),
          nroempresatransbordo    NUMBER(3)
        );*/


         /*create table TR_ITENS
        (
          numerodf                     NUMBER(10) not null,
          nroempresa                   NUMBER(3) not null,
          seriedf                      VARCHAR2(3) not null,
          seqitemdf                    NUMBER(6) not null,
          nroserieecf                  VARCHAR2(40) not null,
          nrorepitem                   NUMBER(5),
          seqproduto                   INTEGER not null,
          seqprodutobase               INTEGER,
          embalagem                    VARCHAR2(2),
          qtdembalagem                 NUMBER(12,6) not null,
          qtdvolume                    NUMBER(12,6),
          codproduto                   VARCHAR2(14) not null,
          codtributacao                NUMBER(5) not null,
          situacaonf                   VARCHAR2(3),
          locatuestq                   NUMBER(3) not null,
          quantidade                   NUMBER(12,3) not null,
          vlritem                      NUMBER(15,2) not null,
          vlrtotisento                 NUMBER(15,2) not null,
          vlrtotoutra                  NUMBER(15,2) not null,
          bascalcicms                  NUMBER(15,2) not null,
          peraliquotaicms              NUMBER(4,2) not null,
          seqmovtoestq                 NUMBER,
          basecalcicmsst               NUMBER(12,2),
          peraliquotaicmsst            NUMBER(4,2),
          vlricmsst                    NUMBER(15,2),
          basecalcipi                  NUMBER(15,2),
          peraliquotaipi               NUMBER(4,2),
          vlripi                       NUMBER(15,2),
          vlrpis                       NUMBER(19,6),
          vlrcofins                    NUMBER(19,6),
          vlrdesconto                  NUMBER(15,2),
          vlracrescimo                 NUMBER(15,2),
          vlracrfinanceiro             NUMBER(15,2),
          vlrtotcomissao               NUMBER(15,4),
          vlrdescforanf                NUMBER(15,2),
          vlracrforanf                 NUMBER(15,2),
          statusitem                   VARCHAR2(1),
          supcancelou                  VARCHAR2(12),
          cfop                         NUMBER(5),
          indimpressonf                VARCHAR2(1),
          indreplicacao                VARCHAR2(1),
          indgeroureplicacao           VARCHAR2(1),
          vlrtotisentoipi              NUMBER(15,2),
          vlrtotoutraipi               NUMBER(15,2),
          vlrtotiss                    NUMBER(15,2),
          vlrcomissaoempr              NUMBER(15,2),
          vlrimpcomissaoempr           NUMBER(15,2),
          vlrdespoperacional           NUMBER(19,6),
          vlritemtabpreco              NUMBER(15,2),
          vlritemtabpromoc             NUMBER(15,2),
          classifabcfamseg             VARCHAR2(3),
          observacaoitem               VARCHAR2(2000),
          indissretido                 VARCHAR2(1),
          percmaxdesccomerc            NUMBER(5,2),
          vlrfecp                      NUMBER(15,2),
          peraliquotafecp              NUMBER(4,2),
          bascalcfecp                  NUMBER(15,2),
          vlrfretetransp               NUMBER(13,6),
          vlrdescicms                  NUMBER(15,2),
          vlrir                        NUMBER(15,2),
          vlrcsll                      NUMBER(15,2),
          vlrdescpis                   NUMBER(15,2),
          vlrdesccofins                NUMBER(15,2),
          vlrdesccsll                  NUMBER(15,2),
          vlrdescir                    NUMBER(15,2),
          vlricmsantecipado            NUMBER(15,2),
          baseicmsantecipado           NUMBER(15,2),
          aliqicmsantecipado           NUMBER(4,2),
          vlrseguro                    NUMBER(15,2),
          vlrtotdespacessoria          NUMBER(15,2),
          qtdprodbase                  NUMBER(12,3),
          peraliqicmsorig              NUMBER(4,2),
          peraliqicmsdif               NUMBER(7,4),
          vlrinss                      NUMBER(15,2),
          seqloteestoque               NUMBER,
          vlrdescinss                  NUMBER(15,2),
          vlrdesciss                   NUMBER(15,2),
          nrosegitem                   NUMBER(2),
          vlricmscalc                  NUMBER(15,2),
          peraliqicmscalc              NUMBER(4,2),
          qtddevolvida                 NUMBER(12,3),
          seqpromocpdv                 NUMBER,
          vlrembpmc                    NUMBER(13,2),
          peraliquotafecop             NUMBER(4,2),
          percredcalcvpe               NUMBER(7,4),
          peraliquotavpe               NUMBER(4,2),
          vlrvpe                       NUMBER(15,2),
          vlricmsvpe                   NUMBER(15,2),
          peraliquotatare              NUMBER(4,2),
          vlricmstare                  NUMBER(15,2),
          codtare                      VARCHAR2(3),
          vlrtotcomissaosup            NUMBER(17,4),
          vlrdescsf                    NUMBER(15,2),
          situacaonfpis                VARCHAR2(2),
          situacaonfcofins             VARCHAR2(2),
          nropedidovenda               NUMBER(10),
          perdespoperacionalitem       NUMBER(6,4),
          vlrdespoperacionalitem       NUMBER(19,6),
          seqregraincentivo            INTEGER,
          nroregtributacao             NUMBER(5),
          tiptributacao                VARCHAR2(2),
          codantecipst                 NUMBER(2),
          diavenctost                  NUMBER(2),
          tipocalcicmsfisci            NUMBER(2),
          indbaseicmslf                VARCHAR2(1),
          vlricmsoppropria             NUMBER(12,2),
          bascalcicmsoppropria         NUMBER(15,2),
          aliqdifpis                   NUMBER(7,4),
          aliqdifcofins                NUMBER(7,4),
          vlrpisdif                    NUMBER(19,6),
          vlrcofinsdif                 NUMBER(19,6),
          versaoprod                   NUMBER(3),
          peraliquotastcargagliq       NUMBER(4,2),
          indcreddebicmsopst           VARCHAR2(1),
          indpautast                   VARCHAR2(1),
          situacaonfipi                VARCHAR2(3),
          lancamentost                 VARCHAR2(1),
          codrea                       VARCHAR2(3),
          bascalcpis                   NUMBER(12,2),
          bascalcofins                 NUMBER(12,2),
          peraliquotapis               NUMBER(14,4),
          peraliquotacofins            NUMBER(14,4),
          seqordemnfe                  NUMBER(4),
          vlrdescsubtotal              NUMBER(13,2),
          aliqpiscalc                  NUMBER(7,4),
          aliqcofinscalc               NUMBER(7,4),
          vlrpiscalc                   NUMBER(19,2),
          vlrcofinscalc                NUMBER(19,2),
          vlrtotcomissaotele           NUMBER(15,4),
          vlrtotultcompra              NUMBER(15,2),
          indtipodescbonif             VARCHAR2(1),
          seqbonifprod                 VARCHAR2(1),
          seqbonifgrupo                VARCHAR2(1),
          vlritemnormal                NUMBER(15,2),
          vlrbaseicmsretido            NUMBER(13,2),
          aliqicmsretido               NUMBER(5,2),
          vlricmsretido                NUMBER(13,2),
          indcalcicmsretido            VARCHAR2(1),
          vlrbaseiss                   NUMBER(15,2),
          peraliqiss                   NUMBER(5,2),
          basicmscalc                  NUMBER(12,2),
          vlrtotisentocalc             NUMBER(12,2),
          vlrtotoutracalc              NUMBER(12,2),
          indpautaicms                 VARCHAR2(1),
          vlrtotisentost               NUMBER(15,2),
          vlrtotoutrost                NUMBER(15,2),
          perisentost                  NUMBER(7,4),
          peroutrost                   NUMBER(7,4),
          inddevcargacancel            VARCHAR2(1),
          vlricmsstdistrib             NUMBER(15,2),
          basicmsstdistrib             NUMBER(15,2),
          tipotabvenda                 VARCHAR2(1),
          indbasecempercreduzida       VARCHAR2(1),
          vlrtse                       NUMBER(15,2),
          vlrdescbasepis               NUMBER(15,2),
          vlrdescbasecofins            NUMBER(15,2),
          vlrfreteitemrateio           NUMBER(15,2),
          indusaprecofixo              VARCHAR2(1),
          vlricmsoppropdistrib         NUMBER(12,2),
          indsomentevda                VARCHAR2(1),
          vlrdescincondic              NUMBER(19,6),
          vlrdescntribpis              NUMBER(19,6),
          vlrdescntribcofins           NUMBER(19,6),
          dtamovtoitem                 DATE,
          ocorrenciadevitem            VARCHAR2(5),
          seqordem                     NUMBER(4),
          seqpessoaterceiro            NUMBER,
          seqlocalterc                 NUMBER(3),
          vlrembdescressarcst          NUMBER(13,2),
          vlrdesptributitem            NUMBER(12,2),
          vlrdespntributitem           NUMBER(12,2),
          nrobico                      VARCHAR2(3),
          situacaonforig               VARCHAR2(3),
          vlrdescsuframaicms           NUMBER(12,2),
          vlrdescsuframapis            NUMBER(12,2),
          vlrdescsuframacofins         NUMBER(12,2),
          vlrdescsuframa               NUMBER(12,2),
          indsuframado                 VARCHAR2(1),
          seqnf                        NUMBER,
          bascalcicmsorigsuframa       NUMBER(12,2),
          seqconvprotocolognre         INTEGER,
          codnatrec                    NUMBER(5),
          vlrdescpistransf             NUMBER(15,2),
          vlrdesccofinstransf          NUMBER(15,2),
          indcalcicmsvpe               VARCHAR2(1),
          vlrindicerestorno            NUMBER(9,6),
          vlrrestorno                  NUMBER(13,2),
          baseicmspresumido            NUMBER(15,2),
          pericmspresumido             NUMBER(7,4),
          vlricmspresumido             NUMBER(12,2),
          seqprocesso                  INTEGER,
          vlrsegurorateiodanfe         NUMBER(15,2),
          vlrdespesarateiodanfe        NUMBER(15,2),
          indcfaonline                 VARCHAR2(1),
          vlrdescbonif                 NUMBER(15,2),
          vlrdescbonifabc              NUMBER(15,2),
          vlricmsstemporig             NUMBER(15,2),
          vlrcustobrutoemporig         NUMBER(15,6),
          vlrcalcicmsvpe               NUMBER(15,2),
          embconvnfe                   VARCHAR2(2),
          fatorconvembnfe              NUMBER(10,6),
          inddeduzdescbasest           VARCHAR2(1),
          basecalcicmsvpe              NUMBER(15,2),
          bascalcicmssimples           NUMBER(15,2),
          peraliqicmssimples           NUMBER(4,2),
          vlricmssimples               NUMBER(15,2),
          peraliqirpjsimples           NUMBER(4,2),
          peraliqcsllsimples           NUMBER(4,2),
          peraliqcppsimples            NUMBER(4,2),
          peraliqipisimples            NUMBER(4,2),
          situacaocsosn                VARCHAR2(3),
          vlrpissimples                NUMBER(19,6),
          peraliquotapissimples        NUMBER(14,2),
          vlrcofinssimples             NUMBER(19,6),
          peraliquotacofinssimples     NUMBER(14,2),
          vlripisimples                NUMBER(15,2),
          sitpiscofinssimples          VARCHAR2(1),
          bascalcicmsstsubst           NUMBER(12,2),
          vlricmsstsubst               NUMBER(15,2),
          seqccacordopromoc            INTEGER,
          indgeradebcredpis            VARCHAR2(1),
          indgeradebcredcofins         VARCHAR2(1),
          vlricmsvpecalc               NUMBER(15,2),
          pericmsresolucao13           NUMBER(7,4),
          peraliquotaicmsdif           NUMBER(4,2),
          basicmsdif                   NUMBER(15,2),
          vlricmsdif                   NUMBER(15,2),
          vlrdescipitransf             NUMBER(15,2),
          vlrdesclucrotransf           NUMBER(15,2),
          indconvertcomponente         VARCHAR2(1),
          vlrfreteabc                  NUMBER(15,4),
          indtribsaidadevol            VARCHAR2(1),
          nfreferencianro              NUMBER(10),
          nfreferenciaserie            VARCHAR2(3),
          seqidprescritor              INTEGER,
          dtareceita                   DATE,
          indsomafretetransppedvenda   VARCHAR2(1),
          tipo_preco_syspdv            NUMBER(1),
          nronotificacao               INTEGER,
          seqgnreitem                  NUMBER,
          peracrescst                  NUMBER(7,4),
          vlropcontratodesc            NUMBER(18,5),
          inddebicms                   VARCHAR2(1),
          vlrdescindenizacao           NUMBER(17,6),
          vlrtotcomissaoger            NUMBER(15,4),
          vlrdescfornec                NUMBER(13,2),
          vlrdescverbafornec           NUMBER(13,2),
          vlrgarantia                  NUMBER(12,2),
          basestctsultent              NUMBER(12,2),
          peracrescstajust             NUMBER(12,2),
          percargatribmedia            NUMBER(4,2),
          vlrtotcomissaogar            NUMBER(15,4),
          nroequiperepitemdtamovto     NUMBER(3),
          vlrdescverbatransf           NUMBER(15,2),
          perminicmsstret              NUMBER(4,2),
          peraliquotaicmsatac          NUMBER(4,2),
          basicmsatac                  NUMBER(15,2),
          vlricmsatac                  NUMBER(15,2),
          indpromocao                  VARCHAR2(1),
          vlrdescdiferencatransf       NUMBER(15,2),
          indboniffornec               VARCHAR2(1),
          vlricmsdistrib               NUMBER(15,2),
          basicmsdistrib               NUMBER(15,2),
          vlrtotisentoantec            NUMBER(12,2),
          vlrtotoutraantec             NUMBER(12,2),
          pertributadoantec            NUMBER(7,4),
          indmotivodesoicms            NUMBER(2),
          indsomafreteicms             VARCHAR2(1),
          vlrverbacompra               NUMBER(15,6),
          vlrverbabonifincid           NUMBER(15,6),
          vlrverbabonifsemincid        NUMBER(15,6),
          qtdverbavda                  NUMBER(12,3),
          vlrverbavda                  NUMBER(19,6),
          vlrverbavdaacr               NUMBER(19,6),
          seqprodutofinal              INTEGER,
          quantidadeprodfinal          NUMBER,
          codgeraloper                 NUMBER(3),
          indutilcgobonif              VARCHAR2(1),
          seqpagador                   NUMBER,
          vlrdescicmstransf            NUMBER(15,6),
          vlricmstransf                NUMBER(15,6),
          vlrdespfixatransf            NUMBER(15,6),
          geralivrocprod               VARCHAR2(1),
          seqpromocao                  NUMBER(10),
          qtdverbapdv                  NUMBER(12,3),
          vlrverbapdv                  NUMBER(15,6),
          vlrpiscofinsverbapdv         NUMBER(15,6),
          vlrdescmedalha               NUMBER(15,4),
          indcalcstembutprod           VARCHAR2(1),
          basecalcicmsstembutprod      NUMBER(15,2),
          peraliquotaicmsstembutprod   NUMBER(4,2),
          vlricmsstembutprod           NUMBER(13,2),
          vlrcustoliq                  NUMBER(19,6),
          vlrcustobruto                NUMBER(19,6),
          vlrcustobrutocimp            NUMBER(19,6),
          percmargemliq                NUMBER(19,6),
          percmarkup                   NUMBER(19,6),
          percmarkdown                 NUMBER(19,6),
          peraliqicmssolicit           NUMBER(6,4),
          vlricmssolicit               NUMBER(17,2),
          vlrtotalvdanormal            NUMBER(13,2),
          tipopromocpdv                VARCHAR2(1),
          qtdseloipi                   NUMBER(12),
          classeenquadramentoipi       VARCHAR2(5),
          codigoseloipi                VARCHAR2(60),
          codigoenquadramentoipi       VARCHAR2(3),
          indcalcicmsdesonoutros       VARCHAR2(1),
          vlrtoticmsdesonoutros        NUMBER(13,2),
          peraliqipitabela             NUMBER(4,2),
          peraliqstcargaliqresolucao13 NUMBER(4,2),
          indpistabela                 VARCHAR2(1),
          indcofinstabela              VARCHAR2(1),
          indipitabela                 VARCHAR2(1),
          vlrunitarioecf               NUMBER,
          bascalcicmsoppropriadistrib  NUMBER(12,2),
          seqnfrefentr                 NUMBER,
          peraliquotaicmsentr          NUMBER(4,2),
          indcalcicmsdif               VARCHAR2(1),
          vlrunitariodev               NUMBER,
          vlricmsantecipadotransf      NUMBER(15,2),
          baseicmsantecipadotransf     NUMBER(15,2),
          aliqicmsantecipadotransf     NUMBER(4,2),
          codcest                      NUMBER(7),
          seqcenariotrib               INTEGER,
          seqcluster                   NUMBER,
          peraliqintpartilhaicms       NUMBER(4,2),
          perpartilhaicms              NUMBER(5,2),
          vlricmscalcdestino           NUMBER(15,2),
          vlricmscalcorigem            NUMBER(15,2),
          bascalcicmspartilha          NUMBER(15,2),
          bascalcfecppartilha          NUMBER(15,2),
          peraliquotafecppartilha      NUMBER(4,2),
          vlrfecppartilha              NUMBER(15,2),
          tipocalcicmspartilha         VARCHAR2(1),
          bascalcicmspartinterest      NUMBER(15,2),
          vlracresnfbasecupom          NUMBER(15,2),
          vlrdescnfbasecupom           NUMBER(15,2),
          peraliquotaisssimples        NUMBER(4,2),
          vlrbasecredicmsentr          NUMBER(12,4),
          vlrdifcreddebicms            NUMBER(12,4),
          tipocalficiocstbrutobasest   VARCHAR2(1),
          vlrdescresticmstransf        NUMBER(15,2),
          vlrresticms                  NUMBER(15,2),
          vlrdifcampanhapreco          NUMBER(9,2),
          seqcampanha                  NUMBER(10),
          vlrcustonfprecocamp          NUMBER(19,6),
          vlrprecomargemzero           NUMBER(12,2),
          indtransfcustobonif          VARCHAR2(1),
          cgoremessa                   NUMBER(3),
          indcomptotnfremessa          VARCHAR2(1),
          vlricmsressarc               NUMBER(13,3),
          vlricmsstressarc             NUMBER(13,3),
          indressarcimento             VARCHAR2(1),
          vlricmsopreembolso           NUMBER(12,2),
          vlricmsstreembolso           NUMBER(12,2),
          vlricmsreembolso             NUMBER(12,2),
          peraliquotaicmsstdistrib     NUMBER(4,2),
          medpacientecid               VARCHAR2(6),
          usoprolongado                VARCHAR2(1),
          seqpessoarepitem             NUMBER,
          vlrdesctosazonal             NUMBER(18,5),
          percdescsazonal              NUMBER(15,2),
          qtddotznormal                INTEGER,
          vlrvendadotznormal           NUMBER(8,2),
          qtddotzextra                 INTEGER,
          vlrvendadotzextra            NUMBER(8,2),
          qtddotztotal                 INTEGER,
          vlrvendadotztotal            NUMBER(8,2),
          vlrdesccontratodev           NUMBER(15,2),
          percdesccontrdev             NUMBER(5,2)
        );*/

end tbu_tr_itens;

