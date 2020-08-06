create or replace function f_nome_pessoa (p_status ge_pessoa.status%type)

return varchar2 is

       v_nomerazao ge_pessoa.nomerazao%type;

begin

       select max(a.nomerazao)
       into v_nomerazao
       from ge_pessoa a
       where a.status = p_status
       and a.seqpessoa = 200;

       return (v_nomerazao);

end f_nome_pessoa;
/
