create or replace view trv_notastot
       (nrodf, serie, empresa, pessoa, dtamov, total, vlrdesconto, acrescimo, vlrpis, vlrcofins, numeroserieecf)
as
select 
       a.numerodf, 
       a.seriedf, 
       a.nroempresa, 
       a.seqpessoa, 
       a.dtamovimento, 
       b.vlritem, 
       b.vlrdesconto, 
       b.vlracrescimo, 
       b.vlrpis, 
       b.vlrcofins, 
       a.nroserieecf
from   tr_notas a, tr_itens b
where  a.numerodf = b.numerodf
and    a.seriedf = b.seriedf
and    a.nroserieecf = b.nroserieecf
and    a.nroempresa = b.nroempresa
and    b.statusitem = 'V';
