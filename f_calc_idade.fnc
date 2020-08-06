create or replace function f_calc_idade (p_seqpessoa number)

return number is

--> Pedro Fontinele

/*Esta function foi criada para calcular idade de um cliente uma vez localizado em minha base de dados*/

v_seqpessoa ge_pessoa.seqpessoa%type;

begin

            select  trunc ((sysdate - a.dtanascfund) / 365)
            into v_seqpessoa
            from ge_pessoa a
            where a.seqpessoa = p_seqpessoa;

            return (v_seqpessoa);

end f_calc_idade;

