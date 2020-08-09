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
              
end sp_gera_deseconto;