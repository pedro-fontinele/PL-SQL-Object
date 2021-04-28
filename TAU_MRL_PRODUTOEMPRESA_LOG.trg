CREATE OR REPLACE TRIGGER TAU_MRL_PRODUTOEMPRESA_LOG
  AFTER UPDATE OF DATAHORINTEGRACAOECOMMERCEPREC ON MRL_PRODUTOEMPRESA
  FOR EACH ROW
DECLARE
BEGIN
  /*CREATE TABLE MRL_PRODUTOEMPRESA_LOG
  (
    SEQPRODUTO                                   INTEGER NOT NULL,
    NROEMPRESA                                   NUMBER(3) NOT NULL,
    DATAHORINTEGRACAOECOMMERCEPREC               DATE,
    DATAHORAECOMPREC_VELHO                       DATE,
    MODULO                                       VARCHAR2(600),
    OSUSER                                       VARCHAR2(600),
    IPADDRESS                                    VARCHAR2(600),
    SESSAOID                                     VARCHAR2(600),
    SESSIONUSER                                  VARCHAR2(600),
    INSTANCENAME                                 VARCHAR2(600),
    COLUMSID                                     VARCHAR2(600),
    HOST                                         VARCHAR2(600),
    DTAHORA                                      DATE 
  );*/ 
  
  --> TRIGGER DE MONITORAMENTO E AUDITORIA DE BANCO, PROCESSO DE VALIDACAO DE PRECO ECOMMMERCE
  --> CRIADOR PEDRO FONTINELE
  
  IF UPDATING THEN
    INSERT
    INTO MRL_PRODUTOEMPRESA_LOG
      (SEQPRODUTO,
       NROEMPRESA,
       DATAHORINTEGRACAOECOMMERCEPREC,
       DATAHORAECOMPREC_VELHO,
       MODULO,
       OSUSER,
       IPADDRESS,
       SESSAOID,
       SESSIONUSER,
       INSTANCENAME,
       COLUMSID,
       HOST,
       DTAHORA)
    VALUES
      (:OLD.SEQPRODUTO,
       :OLD.NROEMPRESA,
       SYSDATE,
       :OLD.DATAHORINTEGRACAOECOMMERCEPREC,
       SYS_CONTEXT('USERENV', 'MODULE'),
       SYS_CONTEXT('USERENV', 'OS_USER'),
       SYS_CONTEXT('USERENV', 'IP_ADDRESS'),
       SYS_CONTEXT('USERENV', 'SESSIONID'),
       SYS_CONTEXT('USERENV', 'SESSION_USER'),
       SYS_CONTEXT('USERENV', 'INSTANCE_NAME'),
       SYS_CONTEXT('USERENV', 'SID'),
       SYS_CONTEXT('USERENV', 'HOST'),
       SYSDATE);
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20200, SQLERRM);
END TAU_MRL_PRODUTOEMPRESA_LOG;
/
