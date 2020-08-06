create or replace trigger taius_map_produto
        after insert or update of indusanfdespesa,
                                               desccompleta,
                                               geralivrocprod
on map_produto

declare
  vnok integer;

begin

  sp_geraversaoproduto (vnok);

      /*create table MAP_PRODUTO
    (
      seqproduto                     INTEGER not null,
      seqfamilia                     INTEGER not null,
      complemento                    VARCHAR2(50),
      desccompleta                   VARCHAR2(50) not null,
      descreduzida                   VARCHAR2(24) not null,
      reffabricante                  VARCHAR2(60),
      especificdetalhada             VARCHAR2(2000),
      desccomposicao                 VARCHAR2(2000),
      pzovalidadedia                 NUMBER(4),
      indprocfabricacao              VARCHAR2(1) not null,
      qtdfabricadalote               NUMBER(12,3),
      seqprodutobase                 INTEGER,
      percacrespreco                 NUMBER(5,2),
      indprecozerobalanca            VARCHAR2(1),
      fatorconversao                 NUMBER(9,3),
      seqprodutoinsumo               INTEGER,
      dtahorinclusao                 DATE,
      usuarioinclusao                VARCHAR2(12),
      dtahoralteracao                DATE,
      usuarioalteracao               VARCHAR2(12),
      indreplicacao                  VARCHAR2(1),
      indgeroureplicacao             VARCHAR2(1),
      pzovalidademes                 NUMBER(4),
      nroregminsaude                 VARCHAR2(30),
      codprodfiscal                  VARCHAR2(14),
      descgenerica                   VARCHAR2(60),
      propqtdprodutobase             NUMBER(8,6),
      nrodiasadverrecbto             NUMBER(4),
      percaltprecrelac               NUMBER(5,3),
      nroitemfixo                    NUMBER(3),
      geralivrocprod                 VARCHAR2(1),
      indusanfdespesa                VARCHAR2(1),
      seqbulario                     INTEGER,
      seqprodutotmp                  INTEGER,
      indemitecodprodfiscalnfe       VARCHAR2(1),
      percdiasadverrecbto            NUMBER(5,2),
      codigoanp                      NUMBER(9),
      codigoif                       NUMBER(21),
      indintegraecommerce            VARCHAR2(1),
      qtdlimitepromocecommerce       NUMBER(12,3),
      youtubecodeecommerce           VARCHAR2(50),
      datahorintegracaoecommerce     DATE,
      indres3166                     VARCHAR2(1),
      impdatavalidadebalanc          VARCHAR2(1),
      impdataembbalanc               VARCHAR2(1),
      dtahoralteracargapdv           DATE,
      seqinfnutricprod               INTEGER,
      indpartcotatac                 VARCHAR2(1),
      tituloecommerce                VARCHAR2(200),
      descecommerce                  VARCHAR2(500),
      palavrachaveecommerce          VARCHAR2(500),
      urlecommerce                   VARCHAR2(500),
      indreplicainfofornec           VARCHAR2(1),
      percgasnatural                 NUMBER(5,2),
      percacresccustorelacvig        NUMBER(8,6),
      indemiteetqhort                VARCHAR2(1),
      indcontrolatemperatura         VARCHAR2(1),
      percacresccustorelac           NUMBER(8,6),
      qtdmultiplovdaecommerce        NUMBER(14,6),
      persimiliarecommerce           VARCHAR2(1),
      datahorintegracaoecommerceestq DATE,
      pzovalidlote                   NUMBER(4),
      seqprodrelaclote               INTEGER,
      aliqadjud                      NUMBER(4,2),
      seqprodutosecundario           INTEGER,
      seqprodutobaseantigo           INTEGER,
      indcalcflexpositivo            VARCHAR2(1),
      centrocustoprod                NUMBER(6),
      indcalccomisindicemgm          VARCHAR2(1),
      seqprodutoembalagem            INTEGER,
      indactfaixatoleranciacargarec  VARCHAR2(1),
      codimagem                      VARCHAR2(4),
      indcadastroativo               VARCHAR2(1),
      pzovalidadenatimorto           NUMBER(4),
      propqtdperdaauto               NUMBER(8,6),
      indenviaqtdmaxtranspnfe        VARCHAR2(1),
      descricaoanp                   VARCHAR2(95),
      indgeraressarcicmsstprodinsumo VARCHAR2(1),
      pzovalidadediasaida            NUMBER(4),
      percgasnaturalnacional         NUMBER(5,2),
      percgasnaturalimportado        NUMBER(5,2),
      vlrpartidaglp                  NUMBER(13,2),
      indescalarelevante             VARCHAR2(1) default 'S' not null,
      nrodiasvalprodresfriado        INTEGER,
      nrodiasvalprodaberto           INTEGER,
      tempidealmin                   NUMBER(5,2),
      tempidealmax                   NUMBER(5,2),
      descencarte                    VARCHAR2(60),
      nomeprodutoecomm               VARCHAR2(500),
      motivoisencaominsaude          VARCHAR2(255),
      obsencarte                     VARCHAR2(250)
    );*/

  /*create or replace procedure sp_geraversaoproduto(
          pnRetornoOK   IN OUT INTEGER ) is
 vnSequencia INTEGER;
 vnVersaoProd INTEGER;
 Begin
 FOR vtLOOP IN
 (
 SELECT DISTINCT PRD.CODPRODUTO,
        PRD.NROEMPRESA,
        (
         SELECT NVL(MAX(VRS.VERSAOPROD), 0) + 1
         FROM   RF_VERSAOPRODUTO VRS
         WHERE  PRD.CODPRODUTO = VRS.CODPRODUTO
                AND PRD.NROEMPRESA = VRS.NROEMPRESA
        ) VERSAOPROD,
        PRD.DESCRICAO,
        PRD.CODSTF,
        PRD.ALIQIPI,
        PRD.ALIQICMS,
        PRD.PERCREDBASEICMS,
        PRD.VLRBASEICMSST,
        PRD.CODNCM,
        PRD.UNIDADEPADRAO,
        PRD.GERAARQUIVO,
        PRD.VEICULO,
        PRD.MARGEM,
        PRD.SERVICO,
        PRD.GRUPOCONTABIL,
        NVL(PRD.USUALTERACAO, 'CONSINCO') USUALTERACAO,
        NVL(PRD.DTAALTERACAO, SYSDATE) DTAALTERACAO,
        PRD.GERALIVROCPROD,
        PRD.VLRICMSPAUTA,
        PRD.CODGISS,
        PRD.CODDES,
        PRD.ISENTOPISCOFINS,
        PRD.INDISENTODEBPISCOFINS,
        PRD.TIPORECEITA,
        PRD.CODATIVIDADE,
        PRD.CFPS,
        PRD.CODTARE,
        PRD.INDUSANFDESPESA,
        PRD.INDALIQZPISCOFINS,
        PRD.INDSTPISCOFINS,
        PRD.INDCONFAZ,
        PRD.CODSERVICO,
        PRD.COMPCESTABASICA,
        PRD.QTDDENTROEMB,
        PRD.GERADOARQMAGNET,
        PRD.IDENTTIPOPRODUTO,
        PRD.INDCOMPLVLRIMP,
        PRD.SITUACAONFPIS,
        PRD.SITUACAONFCOFINS,
        PRD.CODTIPI,
        PRD.FINALIDADE,
        PRD.INDMONOPISCOFINS,
        PRD.CODREA,
        PRD.CODSEFAZCOMBLUB,
        PRD.PERBASECOFINS,
        PRD.PERBASEPIS,
        PRD.CODCEST
 FROM   RF_PRODUTO PRD, RFX_SELECPRODUTOALTER ALT
 WHERE  PRD.CODPRODUTO = ALT.CODPRODUTO
        AND PRD.NROEMPRESA = ALT.NROEMPRESA
        AND NOT EXISTS
        (
         SELECT 1
         FROM   RF_VERSAOPRODUTO VRS
         WHERE  VRS.CODPRODUTO                            = PRD.CODPRODUTO
                AND  VRS.NROEMPRESA                       = PRD.NROEMPRESA
                AND  NVL(VRS.INDISENTOPISCOFINS,'N')      = NVL(PRD.ISENTOPISCOFINS,'N')
                AND  NVL(VRS.INDISENTODEBPISCOFINS,'N')   = NVL(PRD.INDISENTODEBPISCOFINS,'N')
                AND  NVL(VRS.INDSTPISCOFINS,'N')          = NVL(PRD.INDSTPISCOFINS,'N')
                AND  NVL(VRS.INDALIQZPISCOFINS,'N')       = NVL(PRD.INDALIQZPISCOFINS,'N')
                AND  NVL(VRS.INDMONOPISCOFINS,'N')        = NVL(PRD.INDMONOPISCOFINS,'N')
                AND  NVL(VRS.INDUSANFDESPESA,'N')         = NVL(PRD.INDUSANFDESPESA,'N')
                AND  NVL(VRS.CFPS,0)                      = NVL(PRD.CFPS,0)
                AND  NVL(VRS.CODATIVIDADE,0)              = NVL(PRD.CODATIVIDADE,0)
                AND  NVL(VRS.SERVICO,'N')                 = NVL(PRD.SERVICO,'N')
                AND  NVL(VRS.CODGISS,'.')                 = NVL(PRD.CODGISS,'.')
                AND  NVL(VRS.CODDES,'.')                  = NVL(PRD.CODDES,'.')
                AND  NVL(VRS.TIPORECEITA,0)               = NVL(PRD.TIPORECEITA,0)
                AND  NVL(VRS.CODTIPI,0)                   = NVL(PRD.CODTIPI,0)
                AND  NVL(VRS.INDCOMPLVLRIMP,0)            = NVL(PRD.INDCOMPLVLRIMP,0)
                AND  NVL(VRS.CODREA, 0)                   = NVL(PRD.CODREA, 0)
                AND  NVL(VRS.CODSEFAZCOMBLUB, 0)          = NVL(PRD.CODSEFAZCOMBLUB, 0)
                AND  NVL(VRS.CODNCM,0)                    = NVL(PRD.CODNCM, 0)
                AND  NVL(VRS.DESCRICAO,'XXX')             = NVL(PRD.DESCRICAO,'XXX')
                AND  NVL(VRS.GRUPOCONTABIL,'XXX')         = NVL(PRD.GRUPOCONTABIL,'XXX')--RC47790
                AND  ROUND(NVL(VRS.PERBASEPIS,0),2)       = ROUND(NVL(PRD.PERBASEPIS, 0),2)
                AND  ROUND(NVL(VRS.PERBASECOFINS, 0),2)   = ROUND(NVL(PRD.PERBASECOFINS, 0),2)
                AND  ROUND(NVL(VRS.ALIQICMS, 0) ,2)       = ROUND(NVL(PRD.ALIQICMS, 0),2)
                AND  ROUND(NVL(VRS.PERCREDBASEICMS, 0),2) = ROUND(NVL(PRD.PERCREDBASEICMS, 0),2)
                AND  NVL(VRS.CODCEST,0)                   = NVL(PRD.CODCEST,0)
        )
 )
 LOOP
     INSERT INTO MAP_VERSAOPRODUTO
            (
            CODPRODUTO,
            NROEMPRESA,
            VERSAOPROD,
            DESCRICAO,
            CODSTF,
            ALIQIPI,
            ALIQICMS,
            PERCREDBASEICMS,
            VLRBASEICMSST,
            CODNCM,
            UNIDADEPADRAO,
            GERAARQUIVO,
            VEICULO,
            MARGEM,
            SERVICO,
            GRUPOCONTABIL,
            USUALTERACAO,
            DTAALTERACAO,
            GERALIVROCPROD,
            VLRICMSPAUTA,
            CODGISS,
            CODDES,
            INDISENTOPISCOFINS,
            INDISENTODEBPISCOFINS,
            TIPORECEITA,
            CODATIVIDADE,
            CFPS,
            CODTARE,
            INDUSANFDESPESA,
            INDALIQZPISCOFINS,
            INDSTPISCOFINS,
            INDCONFAZ,
            CODSERVICO,
            COMPCESTABASICA,
            QTDDENTROEMB,
            GERADOARQMAGNET,
            IDENTTIPOPRODUTO,
            INDCOMPLVLRIMP,
            SITUACAONFPIS,
            SITUACAONFCOFINS,
            CODTIPI,
            FINALIDADE,
            INDMONOPISCOFINS,
            CODREA,
            CODSEFAZCOMBLUB,
            PERBASEPIS,
            PERBASECOFINS,
            CODCEST
            )
     VALUES (
            vtLOOP.CODPRODUTO,
            vtLOOP.NROEMPRESA,
            vtLOOP.VERSAOPROD,
            vtLOOP.DESCRICAO,
            vtLOOP.CODSTF,
            vtLOOP.ALIQIPI,
            vtLOOP.ALIQICMS,
            vtLOOP.PERCREDBASEICMS,
            vtLOOP.VLRBASEICMSST,
            vtLOOP.CODNCM,
            vtLOOP.UNIDADEPADRAO,
            vtLOOP.GERAARQUIVO,
            vtLOOP.VEICULO,
            vtLOOP.MARGEM,
            vtLOOP.SERVICO,
            vtLOOP.GRUPOCONTABIL,
            vtLOOP.USUALTERACAO,
            vtLOOP.DTAALTERACAO,
            vtLOOP.GERALIVROCPROD,
            vtLOOP.VLRICMSPAUTA,
            vtLOOP.CODGISS,
            vtLOOP.CODDES,
            vtLOOP.ISENTOPISCOFINS,
            vtLOOP.INDISENTODEBPISCOFINS,
            vtLOOP.TIPORECEITA,
            vtLOOP.CODATIVIDADE,
            vtLOOP.CFPS,
            vtLOOP.CODTARE,
            vtLOOP.INDUSANFDESPESA,
            vtLOOP.INDALIQZPISCOFINS,
            vtLOOP.INDSTPISCOFINS,
            vtLOOP.INDCONFAZ,
            vtLOOP.CODSERVICO,
            vtLOOP.COMPCESTABASICA,
            vtLOOP.QTDDENTROEMB,
            vtLOOP.GERADOARQMAGNET,
            vtLOOP.IDENTTIPOPRODUTO,
            vtLOOP.INDCOMPLVLRIMP,
            vtLOOP.SITUACAONFPIS,
            vtLOOP.SITUACAONFCOFINS,
            vtLOOP.CODTIPI,
            vtLOOP.FINALIDADE,
            vtLOOP.INDMONOPISCOFINS,
            vtLOOP.CODREA,
            vtLOOP.Codsefazcomblub,
            vtLOOP.Perbasepis,
            vtLOOP.Perbasecofins,
            vtLOOP.CodCest
            );
 END LOOP;
 FOR vtLOOP IN
  (
   SELECT MIN(VRS.VERSAOPROD) VERSAOPROD,
          PRD.SEQPRODUTO,
          PRD.NROEMPRESA,
          PRD.CODPRODUTO,
          PRD.DTAALTERACAO,
          PRD.USUALTERACAO,
          ALT.INDALTDESC
   FROM   RF_PRODUTO PRD,
          RF_VERSAOPRODUTO VRS,
          RFX_SELECPRODUTOALTER ALT
   WHERE  PRD.CODPRODUTO                            = ALT.CODPRODUTO
          AND  PRD.NROEMPRESA                       = ALT.NROEMPRESA
          AND  VRS.CODPRODUTO                       = PRD.CODPRODUTO
          AND  VRS.NROEMPRESA                       = PRD.NROEMPRESA
          AND  NVL(VRS.INDISENTOPISCOFINS,'N')      = NVL(PRD.ISENTOPISCOFINS,'N')
          AND  NVL(VRS.INDISENTODEBPISCOFINS,'N')   = NVL(PRD.INDISENTODEBPISCOFINS,'N')
          AND  NVL(VRS.INDSTPISCOFINS,'N')          = NVL(PRD.INDSTPISCOFINS,'N')
          AND  NVL(VRS.INDALIQZPISCOFINS,'N')       = NVL(PRD.INDALIQZPISCOFINS,'N')
          AND  NVL(VRS.INDMONOPISCOFINS,'N')        = NVL(PRD.INDMONOPISCOFINS,'N')
          AND  NVL(VRS.INDUSANFDESPESA,'N')         = NVL(PRD.INDUSANFDESPESA,'N')
          AND  NVL(VRS.CFPS,0)                      = NVL(PRD.CFPS,0)
          AND  NVL(VRS.CODATIVIDADE,0)              = NVL(PRD.CODATIVIDADE,0)
          AND  NVL(VRS.SERVICO,'N')                 = NVL(PRD.SERVICO,'N')
          AND  NVL(VRS.CODGISS,'.')                 = NVL(PRD.CODGISS,'.')
          AND  NVL(VRS.CODDES,'.')                  = NVL(PRD.CODDES,'.')
          AND  NVL(VRS.TIPORECEITA,0)               = NVL(PRD.TIPORECEITA,0)
          AND  NVL(VRS.CODTIPI,0)                   = NVL(PRD.CODTIPI,0)
          AND  NVL(VRS.INDCOMPLVLRIMP,0)            = NVL(PRD.INDCOMPLVLRIMP,0)
          AND  NVL(VRS.CODREA, 0)                   = NVL(PRD.CODREA, 0)
          AND  NVL(VRS.CODSEFAZCOMBLUB, 0)          = NVL(PRD.CODSEFAZCOMBLUB, 0)
          AND  NVL(VRS.CODNCM,0)                    = NVL(PRD.CODNCM, 0)
          AND  NVL(VRS.DESCRICAO,'XXX')             = NVL(PRD.DESCRICAO,'XXX')
          AND  NVL(VRS.GRUPOCONTABIL,'XXX')         = NVL(PRD.GRUPOCONTABIL,'XXX')--RC47790
          AND  ROUND(NVL(VRS.PERBASEPIS, 0),2)      = ROUND(NVL(PRD.PERBASEPIS, 0),2)
          AND  ROUND(NVL(VRS.PERBASECOFINS, 0),2)   = ROUND(NVL(PRD.PERBASECOFINS, 0),2)
          AND  ROUND(NVL(VRS.ALIQICMS, 0),2)        = ROUND(NVL(PRD.ALIQICMS, 0),2)
          AND  ROUND(NVL(VRS.PERCREDBASEICMS, 0),2) = ROUND(NVL(PRD.PERCREDBASEICMS, 0),2)
          AND  NVL(VRS.CODCEST,0)                   = NVL(PRD.CODCEST,0)
   GROUP  BY
          PRD.SEQPRODUTO,
          PRD.NROEMPRESA,
          PRD.CODPRODUTO,
          PRD.DTAALTERACAO,
          PRD.USUALTERACAO,
          ALT.INDALTDESC
   ORDER  BY
          PRD.SEQPRODUTO,
          PRD.NROEMPRESA
  )
 LOOP
  UPDATE MRL_PRODUTOEMPRESA PEM
  SET    PEM.VERSAO          =     vtLOOP.VERSAOPROD
  WHERE  PEM.SEQPRODUTO      =     vtLOOP.SEQPRODUTO
         AND PEM.NROEMPRESA  =     vtLOOP.NROEMPRESA;
  UPDATE MAP_VERSAOPRODUTO VRS
  SET    VRS.DTAALTERACAO    =     vtLOOP.Dtaalteracao,
         VRS.USUALTERACAO    =     vtLOOP.Usualteracao
  WHERE  vrs.codproduto      =     vtLOOP.CODPRODUTO
  AND    VRS.NROEMPRESA      =     vtLOOP.NROEMPRESA
  AND    VRS.VERSAOPROD      =     vtLOOP.VERSAOPROD;
  SELECT NVL(MAX(VERSAOPROD),0)
  INTO   vnVersaoProd
  FROM   MAP_VERSAOPRODUTOLOG
  WHERE  NROEMPRESA = vtLOOP.NROEMPRESA
  AND    CODPRODUTO = vtLOOP.CODPRODUTO
  AND    DTAFINAL IS NULL;
  IF vnVersaoProd != vtLOOP.VERSAOPROD THEN
      UPDATE MAP_VERSAOPRODUTOLOG
      SET DTAFINAL = SYSDATE,
          INDALTDESC = vtLoop.INDALTDESC
      WHERE NROEMPRESA = vtLOOP.NROEMPRESA
      AND   CODPRODUTO = vtLOOP.CODPRODUTO
      AND   DTAFINAL IS NULL;
      SELECT MAX(SEQUENCIA)
      INTO vnSequencia
      FROM MAP_VERSAOPRODUTOLOG
      WHERE NROEMPRESA = vtLOOP.NROEMPRESA
      AND   CODPRODUTO = vtLOOP.CODPRODUTO;
      IF vnSequencia IS NULL THEN
         vnSequencia := 0;
      END IF;
      INSERT INTO MAP_VERSAOPRODUTOLOG a
             (NROEMPRESA, CODPRODUTO, VERSAOPROD, DTAINICIAL, SEQUENCIA)
       VALUES(vtLOOP.NROEMPRESA, vtLOOP.CODPRODUTO, vtLOOP.VERSAOPROD, SYSDATE, vnSequencia+1);
  END IF;
 END LOOP;
 pnRetornoOK := 1;
 exception
        when others then
             pnRetornoOK := 0;
             raise_application_error (-20200, 'Erro ao gerar versão dos produtos.' || sqlerrm );
end sp_geraversaoproduto;*/


end taius_map_produto ;
/
