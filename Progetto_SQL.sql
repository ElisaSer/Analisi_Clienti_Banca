
create table dati_clienti as
select distinct
cl.id_cliente,
timestampdiff(year, cl.data_nascita, current_date()) as età,
sum(case when tr.id_tipo_trans > 2 then 1 else 0 end) as num_trans_uscita,
sum(case when tr.id_tipo_trans <= 2 then 1 else 0 end) as num_trans_entrata,
sum(case when tr.importo < 0 then -tr.importo else 0 end) as importo_trans_uscita,
sum(case when tr.importo > 0 then tr.importo else 0 end) as importo_trans_entrata,

count(distinct conto.id_conto) num_Conti,
count(distinct case when tc.desc_tipo_conto = 'Conto Base' then conto.id_conto else null end) num_Conti_Base,
count(distinct case when tc.desc_tipo_conto = 'Conto Business' then conto.id_conto else null end) num_Conti_Business,
count(distinct case when tc.desc_tipo_conto = 'Conto Privati' then conto.id_conto else null end) num_Conti_Privati,
count(distinct case when tc.desc_tipo_conto = 'Conto Famiglie' then conto.id_conto else null end) num_Conti_Famiglie,

sum(case when tipo_tr.desc_tipo_trans = 'Acquisto su Amazon' then 1 else 0 end) Acquisti_Amazon,
sum(case when tipo_tr.desc_tipo_trans = 'Rata Mutuo' then 1 else 0 end) Rata_Mutuo,
sum(case when tipo_tr.desc_tipo_trans = 'Hotel' then 1 else 0 end) Hotel,
sum(case when tipo_tr.desc_tipo_trans = 'Biglietto aereo' then 1 else 0 end) Biglietto_aereo,
sum(case when tipo_tr.desc_tipo_trans = 'Supermercato' then 1 else 0 end) Supermercato,
sum(case when tipo_tr.desc_tipo_trans = 'Stipendio' then 1 else 0 end) Stipendio,
sum(case when tipo_tr.desc_tipo_trans = 'Pensione' then 1 else 0 end) Pensione,
sum(case when tipo_tr.desc_tipo_trans = 'Dividendi' then 1 else 0 end) Dividendi,

sum(case when tc.desc_tipo_conto = 'Conto Base' and tr.importo < 0 then -tr.importo else 0 end) as importo_trans_uscita_conto_base,
sum(case when tc.desc_tipo_conto = 'Conto Base' and tr.importo > 0 then tr.importo else 0 end) as importo_trans_entrata_conto_base,
sum(case when tc.desc_tipo_conto = 'Conto Business' and tr.importo < 0 then -tr.importo else 0 end) as importo_trans_uscita_conto_business,
sum(case when tc.desc_tipo_conto = 'Conto Business' and tr.importo > 0 then tr.importo else 0 end) as importo_trans_entrata_conto_business,
sum(case when tc.desc_tipo_conto = 'Conto Privati' and tr.importo < 0 then -tr.importo else 0 end) as importo_trans_uscita_conto_privati,
sum(case when tc.desc_tipo_conto = 'Conto Privati' and tr.importo > 0 then tr.importo else 0 end) as importo_trans_entrata_conto_privati,
sum(case when tc.desc_tipo_conto = 'Conto Famiglie' and tr.importo < 0 then -tr.importo else 0 end) as importo_trans_uscita_conto_famiglie,
sum(case when tc.desc_tipo_conto = 'Conto Famiglie' and tr.importo > 0 then tr.importo else 0 end) as importo_trans_entrata_conto_famiglie


from banca.cliente cl
left join banca.conto conto on cl.id_cliente = conto.id_cliente
left join banca.tipo_conto tc on conto.id_tipo_conto= tc.id_tipo_conto
left join banca.transazioni tr on conto.id_conto = tr.id_conto
left join banca.tipo_transazione tipo_tr on tr.id_tipo_trans = tipo_tr.id_tipo_transazione
group by 
	1,2;