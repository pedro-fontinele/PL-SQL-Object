create or replace procedure sp_clona_pedido_venda (p_nropedvenda in mad_pedvenda.nropedvenda%type,
                                                                                p_nroempresa in mad_pedvenda.nroempresa%type)

as

                                                                 
         v_nropedvenda mad_pedvenda.nropedvenda%type;
         v_nroempresa  mad_pedvenda.nroempresa%type;
         v_seqcliente  mad_pedvenda.seqcliente%type;
         v_nomerazao   mad_pedvenda.nomerazao%type;
         v_statusped   mad_pedvenda.statusped%type;
         v_seqitem mad_pedvendaitem.seqitem%type;

begin
  
                   select  seq_mad_pedvenda.nextval,
                                     a.nroempresa,
                                     a.seqcliente,
                                     a.nomerazao,
                                     a.statusped 
                        into      v_nropedvenda,
                                     v_nroempresa,
                                     v_seqcliente,
                                     v_nomerazao,
                                     v_statusped       
                        from mad_pedvenda a  
                        where a.nropedvenda  = p_nropedvenda
                        and a.nroempresa =  p_nroempresa;       
                        
                        insert
                        into  mad_pedvenda (
                              nropedvenda, nroempresa, seqcliente, nomerazao, statusped
                          )
                         values (
                               v_nropedvenda, v_nroempresa, v_seqcliente, v_nomerazao,  v_statusped
                         );

            select count (*)
            into  v_seqitem
            from mad_pedvendaitem b
            where b.nropedvenda = p_nropedvenda
            and b.nroempresa = p_nroempresa;
                        
           while v_seqitem >= 1 loop
             
                          insert
                          into mad_pedvendaitem (
                               nropedvenda, nroempresa, seqproduto, descricao, quantidade, preco, statusped, seqitem
                          )
                          select 
                                 v_nropedvenda,
                                 b.nroempresa,
                                 b.seqproduto,
                                 b.descricao,
                                 b.quantidade,
                                 b.preco,
                                 b.statusped,
                                 b.seqitem
                          from mad_pedvendaitem b
                          where b.nropedvenda = p_nropedvenda
                          and b.nroempresa = p_nroempresa
                          and b.seqitem = v_seqitem;
                         
                    v_seqitem := v_seqitem- 1;
                               
             end loop;
             
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
end sp_clona_pedido_venda;
/
