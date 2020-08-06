CREATE OR REPLACE TRIGGER Taiud_Mad_Pedvendaitem_Log
  AFTER UPDATE OF Qtdatendida ON Mad_Pedvendaitem
  FOR EACH ROW
DECLARE
BEGIN

--> Esta trigger monitora alterações caso ocorram e grava log da mesma
--> Pedro Fontinele

/*  create table mad_pedvendaitem_log
  (
    nropedvenda                    NUMBER(10) not null,
    nroempresa                     NUMBER(3) not null,
    seqproduto                     INTEGER not null,
    qtdpedida                      NUMBER(12,3) not null,
    qtdatendida                    NUMBER(12,3) not null,
    qtdatendida_novo                    NUMBER(12,3) not null,
    qtdconferida                   NUMBER(12,3),
    qtdembalagem                   NUMBER(12,6) not null,
    dtainclusao                    DATE not null,
    usuinclusao                    VARCHAR2(12) not null,
    dtaalteracao                   DATE,
    usualteracao                   VARCHAR2(12)
  );*/
  
  IF Updating THEN
    INSERT INTO Mad_Pedvendaitem_Log
      (Nropedvenda, Nroempresa, Seqproduto, Qtdpedida, Qtdatendida,
       Qtdatendida_Novo, Qtdconferida, Qtdembalagem, Dtainclusao,
       Usuinclusao, Dtaalteracao, Usualteracao)
    VALUES
      (:old.nropedvenda, :old.nroempresa , :old.seqproduto, :old.qtdpedida, :old.qtdatendida, :new.qtdatendida,
       :old.qtdconferida, :old.qtdembalagem, :old.dtainclusao, :old.usuinclusao, :old.dtaalteracao, :old.usualteracao);
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    Raise_Application_Error(-20200, SQLERRM);
END Taiud_Mad_Pedvendaitem_Log;
