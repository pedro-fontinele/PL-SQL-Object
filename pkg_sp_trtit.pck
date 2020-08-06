create or replace package pkg_sp_trtit is

        procedure sp_trtit(pnumerodf in tr_notas.numerodf%type,
                                      pseriedf in tr_notas.seriedf%type,
                                      pnroempresa in tr_notas.nroempresa%type,
                                      pnroserieecf in tr_notas.nroserieecf%type,
                                      pnroformapagto in tr_notaspagto.nroformapagto%type);

end  pkg_sp_trtit;
/
create or replace package body pkg_sp_trtit is

       procedure sp_trtit(pnumerodf in tr_notas.numerodf%type,
                                                           pseriedf in tr_notas.seriedf%type,
                                                           pnroempresa in tr_notas.nroempresa%type,
                                                           pnroserieecf in tr_notas.nroserieecf%type,
                                                           pnroformapagto in tr_notaspagto.nroformapagto%type) is
                begin

                  insert
                  into tr_titulo t
                  select s_trpessoa.nextval, tb1.*
                  from (select a.nrodf,
                                      a.serie,
                                      a.empresa,
                                      a.pessoa,
                                      'V',
                                      a.total,
                                      a.vlrdesconto,
                                      a.acrescimo,
                                      f_calc_vencto(pnumerodf,
                                                             pseriedf,
                                                             pnroserieecf,
                                                             pnroempresa,
                                                             pnroformapagto)
                              from trv_notastot a
                              where a.nrodf = pnumerodf
                              and a.serie = pseriedf
                              and a.empresa = pnroempresa
                              and a.numeroserieecf = pnroserieecf) tb1;

                              commit;

                end sp_trtit;

end pkg_sp_trtit;
/
