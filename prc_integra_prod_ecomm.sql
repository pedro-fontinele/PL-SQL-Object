create or replace procedure prc_integra_prod_ecomm(p_ind_ecomm in map_produto.indintegraecommerce%type)

 as

  v_linha              number;
  v_seqproduto         map_produto.seqproduto%type;
  v_nomeproduto        map_produto.desccompleta%type;
  v_brevedescricao     map_produto.descecommerce%type;
  v_descricaocompleta  map_produto.especificdetalhada%type;
  v_modeloproduto      map_produto.descreduzida%type;
  v_seqmarca           map_marca.seqmarca%type;
  v_urlamigavel        map_produto.desccompleta%type;
  v_metakeyword        map_produto.palavrachaveecommerce%type;
  v_titulo             map_produto.tituloecommerce%type;
  v_metadescription    map_produto.descecommerce%type;
  v_qtdlimitevenda     map_produto.qtdlimitepromocecommerce%type;
  v_ean                map_prodcodigo.codacesso%type;
  v_videoyoutube       map_produto.youtubecodeecommerce%type;
  v_pesavel            map_familia.pesavel%type;
  v_fatormultiplicacao map_produto.qtdmultiplovdaecommerce%type;

begin

  select count(*) 
  into v_linha 
  from ecmv_integra_produto 
  where rownum = 1;

  while v_linha = 1 loop

    select a.seqproduto,
           nvl(case
                 when nvl(fc5maxparametro('EXPORTACAO_GERAL',
                                          0,
                                          'EXPORTA_DESC_GENERICA_PROD'),
                          'N') = 'S' then
                  decode(fc5maxparametro('EXPORTACAO_GERAL', 0, 'USA_PRIMEIRA_LETRA_MAISC'),
                         'S',
                         initcap(coalesce(a.nomeprodutoecomm,
                                          a.descgenerica,
                                          a.desccompleta)),
                         coalesce(a.nomeprodutoecomm, a.descgenerica, a.desccompleta))
                 else
                  decode(fc5maxparametro('EXPORTACAO_GERAL', 0, 'USA_PRIMEIRA_LETRA_MAISC'),
                         'S',
                         initcap(nvl(a.nomeprodutoecomm, a.desccompleta)),
                         nvl(a.nomeprodutoecomm, a.desccompleta))
               end,
               ' ') nomeproduto,
           nvl(a.descecommerce, ' ') brevedescricao,
           decode(fc5maxparametro('EXPORTACAO_GERAL',
                                  0,
                                  'USA_PRIMEIRA_LETRA_MAISC'),
                  'S',
                  initcap(nvl(a.especificdetalhada, ' ')),
                  nvl(a.especificdetalhada, ' ')) descricaocompleta,
           nvl(decode(fc5maxparametro('EXPORTACAO_GERAL',
                                      0,
                                      'USA_PRIMEIRA_LETRA_MAISC'),
                      'S',
                      initcap(a.descreduzida),
                      a.descreduzida),
               ' ') modeloproduto,
           nvl(ma.seqmarca, 0) seqmarca,
           lower(replace(fc5limpatexto(a.desccompleta || '-' ||
                                       a.seqproduto),
                         ' ',
                         '-')) urlamigavel,
           nvl(a.palavrachaveecommerce, ' ') metakeyword,
           nvl(a.tituloecommerce, ' ') titulo,
           nvl(a.descecommerce, ' ') metadescription,

           nvl(a.qtdlimitepromocecommerce, 0) qtdlimitevenda,
           nvl(fcodacessoproduto(a.seqproduto, 'E', 'S', null), ' ') ean,
           nvl(a.youtubecodeecommerce, ' ') videoyoutube,
           nvl(case
                 when f.pesavel = 'S' and f.pmtdecimal = 'S' then
                  'S'
                 else
                  'N'
               end,
               'N') pesavel,
           trim(to_char(decode(f.pesavel,
                               'S',
                               nvl(a.qtdmultiplovdaecommerce, 0),
                               1.00),
                        '999999990.00')) fatormultiplicacao
      into v_seqproduto,
           v_nomeproduto,
           v_brevedescricao,
           v_descricaocompleta,
           v_modeloproduto,
           v_seqmarca,
           v_urlamigavel,
           v_metakeyword,
           v_titulo,
           v_metadescription,
           v_qtdlimitevenda,
           v_ean,
           v_videoyoutube,
           v_pesavel,
           v_fatormultiplicacao

      from map_produto a, map_familia f, map_marca ma

     where (a.indintegraecommerce = 'S' or (a.datahorintegracaoecommerce is not null and
           a.indintegraecommerce = 'N'))
       and nvl(a.datahorintegracaoecommerce, a.dtahoralteracao) <=
           a.dtahoralteracao
       and a.seqfamilia = f.seqfamilia
       and f.seqmarca = ma.seqmarca(+)
       and a.indintegraecommerce = p_ind_ecomm
       and rownum = 1;

    update map_produto a
       set a.datahorintegracaoecommerce = sysdate
     where a.seqproduto = v_seqproduto;
     
    commit;
     
  end loop;

exception
  when others then
    raise_application_error(-20001,
                            'Erro faltal ' || sqlcode || ' ' || sqlerrm);

end prc_integra_prod_ecomm;