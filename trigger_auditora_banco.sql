/*create table ge_auditoriaddl
(
  dtahorevento date,
  username     varchar2(30),
  ipclient     varchar2(256),
  osuser       varchar2(128),
  terminal     varchar2(60),
  modulo       varchar2(60),
  tipoevento   varchar2(30),
  tipoobjeto   varchar2(18),
  ownerobjeto  varchar2(30),
  nomeobjeto   varchar2(128),
  cmdsql       clob
);*/ 
   

create or replace trigger ta_c5_auditoriaddl
  after create or drop or alter or rename or grant or revoke on schema
declare
   vssqlddl                     clob;
   vlddl                        ora_name_list_t;
begin
  for i in 1 .. ora_sql_txt(vlddl)
  loop
    vssqlddl := vssqlddl || vlddl(i);
  end loop;
  
  insert 
  into ge_auditoriaddl (dtahorevento, 
                        username, 
                        ipclient, 
                        osuser, 
                        terminal, 
                        modulo,
                        tipoevento, 
                        tipoobjeto, 
                        ownerobjeto, 
                        nomeobjeto, 
                        cmdsql)
  values (sysdate, 
          nvl(ora_login_user, '{oracle}'), 
          sys_context('userenv', 'ip_address'),
          sys_context('userenv', 'os_user'), 
          sys_context('userenv', 'host'),
          sys_context('userenv', 'module'), 
          ora_sysevent, 
          ora_dict_obj_type, 
          ora_dict_obj_owner,
          ora_dict_obj_name, 
          vssqlddl);
          
  exception
    when others then null;
end;
/
