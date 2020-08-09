create or replace procedure sp_clona_pedido (p_nropedvenda in mad_pedvenda.nropedvenda%type,
                                                                                p_nroempresa in mad_pedvenda.nroempresa%type)

as

          v_nropedvenda mad_pedvenda.nropedvenda%type;
         v_nroempresa  mad_pedvenda.nroempresa%type;
         v_seqcliente  mad_pedvenda.seqcliente%type;
         v_nomerazao   mad_pedvenda.nomerazao%type;
         v_statusped   mad_pedvenda.statusped%type;
         v_seqproduto  mad_pedvendaitem.seqproduto%type;
         v_descricao    mad_pedvendaitem.descricao%type;
         v_quantidade  mad_pedvendaitem.quantidade%type;
         v_preco  mad_pedvendaitem.preco%type;

begin

           select  seq_mad_pedvenda.nextval,
                       a.nroempresa,
                       a.seqcliente,
                       a.nomerazao,
                       a.statusped,
                       b.seqproduto,
                       b.descricao,
                       b.quantidade,
                       b.preco
           into     v_nropedvenda,
                       v_nroempresa,
                       v_seqcliente,
                       v_nomerazao,
                       v_statusped,
                       v_seqproduto,
                       v_descricao,
                       v_quantidade,
                       v_preco
          from mad_pedvenda a
          inner join mad_pedvendaitem b
          on a.nroempresa = b.nroempresa
          and a.nropedvenda = b.nropedvenda
          where a.nropedvenda  = p_nropedvenda
          and a.nroempresa =  p_nroempresa;

          insert
          into  mad_pedvenda (
                nropedvenda, nroempresa, seqcliente, nomerazao, statusped
            )
           values (
                 v_nropedvenda, v_nroempresa, v_seqcliente, v_nomerazao,  v_statusped
           );

            insert
            into mad_pedvendaitem (
                 nropedvenda, nroempresa, seqproduto, descricao, quantidade, preco, statusped
            )
            values (
                   v_nropedvenda, v_nroempresa, v_seqproduto, v_descricao, v_quantidade, v_preco, v_statusped
            );

            commit;
            
             exception  
                   when others then
                                raise_application_error(-20001,
                                                    'Erro faltal '||sqlcode||' '||sqlerrm);
                                                    
                /*
                  create table MAD_PEDVENDA
                  (
                    nropedvenda NUMBER,
                    nroempresa  NUMBER,
                    seqcliente  NUMBER,
                    nomerazao   VARCHAR2(100),
                    statusped   VARCHAR2(1)
                  );
                  
                  create table MAD_PEDVENDAITEM
                  (
                    nropedvenda NUMBER,
                    nroempresa  NUMBER,
                    seqproduto  NUMBER,
                    descricao   VARCHAR2(100),
                    quantidade  NUMBER,
                    preco       NUMBER,
                    statusped   VARCHAR2(1)
                  );                  
                  */                                                 

end sp_clona_pedido;
/
