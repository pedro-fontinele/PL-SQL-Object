create or replace procedure sp_gera_deseconto (p_valor_desc number, 
                                               p_cod_curso number)

is

    v_valor_curso_c_desc number;

begin

    select (a.valor - p_valor_desc)
    into v_valor_curso_c_desc
    from tcurso a
    where a.cod_curso = p_cod_curso;
    
    if v_valor_curso_c_desc > 0 then
       
       update tcurso a
       set a.valor = v_valor_curso_c_desc
       where a.cod_curso = p_cod_curso;
       
       commit;
           
    end if;
    
  exception  
    when others then
        raise_application_error(-20001,
            'Erro faltal '||sqlcode||' '||sqlerrm);
            
  /*
    CREATE TABLE FONTINELE.TCURSO 
   (	
	COD_CURSO NUMBER(*,0) NOT NULL ENABLE, 
	NOME VARCHAR2(30 BYTE), 
	VALOR NUMBER(8,2), 
	CARGA_HORARIA NUMBER(*,0), 
	PRE_REQ NUMBER(*,0), 
	PRIMARY KEY ("COD_CURSO")
	USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
        STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  	PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  	TABLESPACE TBS_DADOS  ENABLE
   );
  */
              
end sp_gera_deseconto;
