create or replace procedure sp_valida_edipedvenda (pnseqedipedvenda in edi_pedvenda.seqedipedvenda%type,
                                                   pnnrorepresentante in edi_pedvenda.nrorepresentante%type default null) is

  v_dtabaseexportacao edi_pedvenda.dtabaseexportacao%type;

begin

  select a.dtabaseexportacao
    into v_dtabaseexportacao
    from edi_pedvenda a
   where a.seqedipedvenda = pnseqedipedvenda
     and a.nrorepresentante = pnnrorepresentante;

  if v_dtabaseexportacao is null then
  
    sp_imp_edipedvenda(pnseqedipedvenda, pnnrorepresentante);
  
  else
  
    update edi_pedvenda a
       set a.statuspedido = 'F'
     where a.seqedipedvenda = pnseqedipedvenda
       and a.nrorepresentante = pnnrorepresentante;
  
    commit;
  
  end if;

exception
  when others then
    raise_application_error(-20200, sqlerrm);
  
end sp_valida_edipedvenda;
/
