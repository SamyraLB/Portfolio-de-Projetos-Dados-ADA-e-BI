-- total faturado
SELECT 
status_cobranca, SUM(valor_faturado ) as TotalFaturado
FROM fato_faturamento ff   
GROUP BY ff.status_cobranca 

--total pago
SELECT SUM(valor_pago ) as Totalpago
FROM fato_faturamento ff   

--taxa de inadimplência-- por areas de atuação
SELECT
area_direito ,
SUM(valor_faturado-valor_pago  ) as Taxa_perda
FROM fato_faturamento ff  
GROUP BY area_direito 

--->"Quantos clientes temos por seguimentos?"->  seleciona a coluna de segmento e fazer o count() em nome cliente para contabilizar o total de linhas e ordenar pelo segmento
SELECT 
segmento_atuacao, count(nome_cliente )
FROM dim_clientes dc 
GROUP by segmento_atuacao 

--->"Quantos clientes por porte?"

SELECT 
porte_cliente , COUNT (nome_cliente ) as qut
FROM dim_clientes dc 
GROUP BY dc.porte_cliente

SELECT 
area_direito ,status_cobranca 
from fato_faturamento ff 
WHERE status_cobranca like 'Em aberto'
GROUP BY area_direito 

--quantidade de inadiplencia de pagamento por area
SELECT 
area_direito , 
count(status_cobranca  ) as Qut_falta_de_pagamento
from fato_faturamento ff 
where valor_pago <1
GROUP BY area_direito 

--QUal cliente com maior falta de pagamento
SELECT 
id_cliente, 
count(status_cobranca  ) as Qut_falta_de_pagamento
from fato_faturamento ff 
where valor_pago <1
GROUP BY ff.id_cliente 
ORDER BY Qut_falta_de_pagamento  DESC 


--QUal cliente com maior pagamento realizado
SELECT 
area_direito ,valor_faturado ,valor_pago, 
sum(valor_pago  ) as Qut_pagamento
from fato_faturamento ff 
---where valor_pago >1
GROUP BY ff.area_direito 
ORDER BY ff.valor_pago   DESC 

-- faturamento X caixa realizado- percentual de pendencia
--round()--> função para arredondar o valor
SELECT
area_direito ,
SUM(valor_faturado ) as TotalFaturado,
SUM(valor_pago ) as Totalpago,
ROUND(SUM(valor_faturado)- SUM(valor_pago ) ) as lacuna_diferenca,
round(((SUM(valor_faturado)- SUM(valor_pago))*100.0)/sum(valor_faturado), 2) as taxa_percentual_pendencia
FROM fato_faturamento ff  
GROUP BY area_direito 
order by lacuna_diferenca  DESC 
-----------------------------------------------------------------------
-- teste com julianday e date ('now')
SELECT (JULIANDAY(date('now'))-(JULIANDAY('2026-09-01'))) as diferenca
-----------------------------------------------------------------------

-- inadiplencia e risco (aging list)-- inadimplência por modalidade de contrato e tempo de atraso.

SELECT 
modalidade_contrato,
COUNT(id_faturamento) AS 'QT_FATURAS',
SUM(valor_faturado ) as TotalFaturado,
SUM(valor_pago ) as Totalpago,
ROUND(SUM(valor_faturado)- SUM(valor_pago ) ) as TOTAL_PERDIDO,
CASE 
	-- intervalo - em dias - atraso <=0
	wHEN (JULIANDAY(COALESCE(data_pagamento,CURRENT_DATE)) - JULIANDAY(data_vencimento)) <= 0 THEN 'EM DIAS'
	-- intervalo - em dias - atraso <=30
	wHEN (JULIANDAY(COALESCE(data_pagamento,CURRENT_DATE)) - JULIANDAY(data_vencimento)) <= 30 THEN '1-30 DIAS'
	-- intervalo - em dias - atraso <=60
	wHEN (JULIANDAY(COALESCE(data_pagamento,CURRENT_DATE)) - JULIANDAY(data_vencimento)) <= 60 THEN '30-60 DIAS'
	-- intervalo - em dias - atraso <=90
	wHEN (JULIANDAY(COALESCE(data_pagamento,CURRENT_DATE)) - JULIANDAY(data_vencimento)) <= 90 THEN '60-90 DIAS'
	ELSE '90+ DIAS(CRITICO)'
END FAIXA_ATRASO

FROM fato_faturamento ff 
group by modalidade_contrato, FAIXA_ATRASO
ORDER BY modalidade_contrato, FAIXA_ATRASO

SELECT 


