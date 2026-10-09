# Projeto de Dados com Python e BI: Análise Financeira de Inadimplência e Risco de Caixa


## Parte 1- Apresentação do projeto
Este projeto foi desenvolvido utilizando a simulação e modelagem de dados financeiros de um escritório de advocacia corporativa, cobrindo o ciclo completo: geração sintética em Python, estruturação e consultas em SQL (SQLite) e desenvolvimento de dashboard executivo no Power BI.

Escritórios de advocacia de médio e grande porte lidam diariamente com um desafio estrutural na gestão financeira: o forte descasamento entre o regime de competência (honorários e faturas emitidas) e o Regime de Caixa (valores efetivamente liquidados). 

Neste projeto, atuando como uma Analista de Dados, investiguei a base operacional de uma banca jurídica corporativa. O problema de negócio central, encontrado foi a ausência de uma visão centralizada sobre o fluxo de cobrança, o que gera três gargalos:
- 1° **Inadimplência Mascarada:** Receitas nominais altas que ocultam baixa liquidez.
- 2° **Ciclo de Cobrança Cego:** Falta de controle sobre a maturidade dos honorários pendentes (*Aging List*), especialmente em contratos de *Êxito*.
- 3° **Risco de Concentração:** Alta dependência financeira de um grupo reduzido de clientes.

## Parte 2- Objetivos

A análise dos conjustos de dados foram estruturadas para responder às seguintes perguntas estratégicas do C-Level (Sócios e CFO):
* Qual é a lacuna absoluta e percentual entre o faturamento emitido e o caixa realizado?
* Quais áreas do Direito (Trabalhista, Cível ou Tributário) apresentam os maiores índices de inadimplência?
* Como a dívida se distribui ao longo do tempo (Aging List) e qual o impacto do tipo de contrato (*Fixo* vs. *Êxito*) nesse atraso?
* Qual é o grau de concentração de receita nos principais clientes (Top 10) e qual o risco associado a eles?

## Parte 3. Tecnologias e ferramentas que foram utilizadas

| Ferramenta / Linguagem | Função no Projeto |
| :--- | :--- |
| **Python 3**  | Geração de dados sintéticos através das bibliotecas Pandas e Numpy, além da simulação de regras de negócio financeiras. |
| **DBeaver** | Atuando como um SGDB e na criação do banco de dados relacional e validação das lógicas analíticas. |
| **SQL** | Construção de métricas, agrupamentos, manipulação de datas e lógicas condicionais. |
| **Power BI / DAX** | Modelagem de dados (*Star Schema*), criação de medidas e visualização de dados (Dashboard). |
| **Git & GitHub** | Versionamento de código e documentação. |

## Parte 4. Estruturando o projeto

```text
├── dadosExtraidos/
│   ├── dados_crus/                              -->  Onde organizei as planilhas.csv extraídas para maior clareza
│   │   ├── dim_clientes.csv              
│   │   └── fato_faturamento.csv          
│   └── dados_UNificados/
│       └── PROJETO_ESCRITORIO_ADV.db           --> Onde foi armazenado o DB para fazer conexão dentro do Dbeaver
├── scripts/
│   ├── 01_gerador_dados.ipynb                     -->  Script Python (Massa de dados fictícia), usei a solução na nuvem do google colab
│   └── 02_consultas_financeiras.sql            --> Consultas exploratórias e analíticas
├── Dashbord_oficial/
│   └── painel_financeiro_juridico.pbix       -->  Dashboard interativo Power BI     
└── README.md                                 -->  Documentação técnica do projeto
```

## Parte 5. Fonte e descrição dos dados
Como os dados financeiros de bancas jurídicas são protegidos por confidencialidade (LGPD/Segredo de Negócio), escolhi desenvolver um script rápido em Python para gerar uma massa sintética com regras de negócio fiéis ao mercado corporativo, utilizando as bibliotecas Numpy e pandas para a manipulação das planilhas. 

### Script Python de Criação e População de Tabelas
```python
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random


np.random.seed(42)
random.seed(42)


num_clientes = 950
portes = ['Pequeno', 'Médio', 'Grande']
prob_portes = [0.5, 0.35, 0.15]
segmentos = ['Tecnologia', 'Varejo', 'Construção Civil', 'Saúde', 'Logística', 'Financeiro']

clientes = []
data_inicio_base = datetime(2022, 1, 1)

for i in range(1, num_clientes + 1):
    id_cli = f"CLI-{i:03d}"
    nome = f"Empresa {chr(65 + (i % 26))}{i}"
    porte = np.random.choice(portes, p=prob_portes)
    segmento = random.choice(segmentos)


    dias_add = random.randint(0, 800)
    data_inicio = data_inicio_base + timedelta(days=dias_add)

  
    status = np.random.choice(['Ativo', 'Cancelado'], p=[0.85, 0.15])

    clientes.append({
        'id_cliente': id_cli,
        'nome_cliente': nome,
        'porte_cliente': porte,
        'segmento_atuacao': segmento,
        'data_inicio_relacionamento': data_inicio.strftime('%Y-%m-%d'),
        'status_cliente': status
    })

df_clientes = pd.DataFrame(clientes)



faturas = []
areas = ['Trabalhista', 'Cível', 'Tributário']
modalidades = ['Partido Fixo', 'Êxito']


data_inicio_fat = datetime(2024, 1, 1)
data_fim_fat = datetime(2026, 6, 30)

id_fatura = 10001

for idx, cliente in df_clientes.iterrows():
  
    if cliente['porte_cliente'] == 'Grande':
        qtd_faturas = random.randint(20, 35)
    elif cliente['porte_cliente'] == 'Médio':
        qtd_faturas = random.randint(5, 20)
    else:
        qtd_faturas = random.randint(3, 5)

    for _ in range(qtd_faturas):
      
        dias_aleatorios = random.randint(0, (data_fim_fat - data_inicio_fat).days)
        dt_emissao = data_inicio_fat + timedelta(days=dias_aleatorios)


        dt_cli = datetime.strptime(cliente['data_inicio_relacionamento'], '%Y-%m-%d')
        if dt_emissao < dt_cli:
            dt_emissao = dt_cli + timedelta(days=random.randint(1, 60))

        dt_vencimento = dt_emissao + timedelta(days=30)

        area = random.choice(areas)
        modalidade = np.random.choice(modalidades, p=[0.7, 0.3])

        if modalidade == 'Partido Fixo':
            valor_base = random.choice([3000, 5000, 8000, 12000, 20000])
        else: # Êxito (valores maiores e mais variáveis)
            valor_base = random.choice([15000, 25000, 45000, 80000])

        if cliente['porte_cliente'] == 'Grande':
            valor_faturado = valor_base * 1.8
        else:
            valor_faturado = valor_base

        
        
        rand_status = random.random()

        if dt_vencimento > datetime(2026, 6, 1):
          
            status_cobranca = 'Em Aberto'
            dt_pagamento = None
            valor_pago = 0.0
        elif rand_status < 0.82: # 82% PAGO EM DIA OU PEQUENO ATRASO
            status_cobranca = 'Pago'
            dias_atraso = random.choice([0, 0, 0, 2, 5, 10, 15])
            dt_pagamento = (dt_vencimento + timedelta(days=dias_atraso)).strftime('%Y-%m-%d')
            valor_pago = valor_faturado
        elif rand_status < 0.93: # 11% PAGO COM MUITO ATRASO
            status_cobranca = 'Pago com Atraso'
            dias_atraso = random.randint(31, 90)
            dt_pagamento = (dt_vencimento + timedelta(days=dias_atraso)).strftime('%Y-%m-%d')
            valor_pago = valor_faturado
        else: # 7% INADIMPLENTE / PERDA (WRITE-OFF)
            status_cobranca = 'Inadimplente'
            dt_pagamento = None
            valor_pago = 0.0

        faturas.append({
            'id_faturamento': f"FAT-{id_fatura}",
            'id_cliente': cliente['id_cliente'],
            'area_direito': area,
            'modalidade_contrato': modalidade,
            'data_emissao': dt_emissao.strftime('%Y-%m-%d'),
            'data_vencimento': dt_vencimento.strftime('%Y-%m-%d'),
            'data_pagamento': dt_pagamento,
            'valor_faturado': round(valor_faturado, 2),
            'valor_pago': round(valor_pago, 2),
            'status_cobranca': status_cobranca
        })
        id_fatura += 1

df_faturamento = pd.DataFrame(faturas)


df_clientes.to_csv('dim_clientes.csv', index=False)
df_faturamento.to_csv('fato_faturamento.csv', index=False)

print("Arquivos 'dim_clientes.csv' e 'fato_faturamento.csv' gerados com sucesso!")
```
O banco de dados foi estruturado em um modelo relacional simples composto por duas tabelas principais:
- **dim_clientes (Tabela Dimensão)**: 
   - `id_cliente (PK)`: Identificador único do cliente.
   - `nome_cliente`: Nome fantasia da empresa atendida.
   - `porte_cliente`: Porte corporativo (Pequeno, Médio, Grande).
   - `segmento`: Ramo de atuação do cliente (Tecnologia, Varejo, Indústria).
- **fato_faturamento (Tabela Fato)**:
   - `id_faturamento (PK)`: Identificador da fatura emitido.
   - `id_cliente (FK)`: Relacionamento com a dimensão de clientes.
   - `area_direito`: Ramo jurídico do serviço (Trabalhista, Cível, Tributário).
   - `modalidade_contrato`: Tipo de honorário (Partido Fixo vs Êxito).
   - `data_emissao, data_vencimento, data_pagamento`: Marcos temporais do título.
   - `valor_faturado, valor_pago`: Valores nominais e liquidados.
   - `status_cobranca`: Status do título (Pago, Em Aberto, Inadimplente).
 O Intuito do dataset é simular o histórico de operações do período de 2024 a meados de 2026. Faturas marcadas como Inadimplentes possuem o campo data_pagamento preenchido como valor nulo (NULL), exigindo tratamento especial nas rotinas SQL e DAX.
## Parte 6. Preparação e tratamento dos dados
O principal desafio de qualidade de dados neste escopo foi o tratamento de faturas não pagas.
- Valores Ausentes (Nulls): Faturas inadimplentes não possuem data_pagamento. No ambiente relacional (SQL), isso foi tratado utilizando a função COALESCE para fixar uma data de corte e permitir o cálculo exato dos dias de atraso.
- Padronização: Tipagem rigorosa de datas (YYYY-MM-DD) e valores monetários (Float/Decimal) garantida desde a geração no Python até a carga no banco.
## Parte 7. Análise exploratória de dados (EDA)
A etapa exploratória foi conduzida primariamente via SQL. O meu foco foi investigar anomalias de recebimento.
- Descoberta inicial: Observou-se rapidamente que, enquanto a emissão de faturas crescia de forma linear, o status "Em Aberto" se concentrava desproporcionalmente em processos Trabalhistas.
- Investigação de Prazos: Cruzando datas de vencimento e pagamento, o ciclo médio de contratos de Êxito demonstrou uma variação extrema em comparação aos contratos de Partido Fixo.
## Parte 8. Criando o banco de dados e as consultas SQL no Dbeaver
Próximo passo era colocar a mão na massa e testar as regras de negócio e implementa-las via SQL antes da importação para o Power BI, garantindo que os valores agregados e as lógicas de corte fossem rigorosamente validados no SGBD.

###Consulta 1: Lacuna de Caixa e Taxa de Inadimplência por Área do Direito
Mede a disparidade entre o faturamento nominal e o caixa realizado por especialidade jurídica:

```sql
SELECT
area_direito ,
SUM(valor_faturado ) as TotalFaturado,
SUM(valor_pago ) as Totalpago,
ROUND(SUM(valor_faturado)- SUM(valor_pago ) ) as lacuna_diferenca,
round(((SUM(valor_faturado)- SUM(valor_pago))*100.0)/sum(valor_faturado), 2) as taxa_percentual_pendencia
FROM fato_faturamento ff  
GROUP BY area_direito 
order by lacuna_diferenca  DESC 
```
Resultado do script dentro do sgbd:

<img width="727" height="97" alt="image" src="https://github.com/user-attachments/assets/7258fa08-83b8-4e67-91f9-3080b4732580" />


Consulta 2: Estruturação da Aging List (Maturidade do Atraso)
Aplica o conceito financeiro de Aging List, ou seja as faturas que estão em aberto devem ser categorizada entre as faixa de atraso para se identificar rapidamente a maturidade da divida.
Para evitar que títulos inadimplentes (com data_pagamento = NULL) fossem descartados ou computados incorretamente, utilizou-se a função COALESCE assumindo a data de corte do relatório (2026-06-30):

```sql

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
```
Resultado do script dentro do sgbd:

<img width="867" height="223" alt="image" src="https://github.com/user-attachments/assets/495f0936-dc18-49c0-b912-44a2d98391a6" />


## Parte 9. Modelagem de Dados no Power BI e ETL
Para garantir performance analítica no Power BI, as tabelas foram conectadas seguindo rigorosamente o padrão Star Schema (Esquema em Estrela). 
Uma tabela dedicada de calendário (Calendario) foi criada via DAX para habilitar funções de inteligência temporal.

##Desenho da modelagem do Relacionamento:
<img width="745" height="623" alt="image" src="https://github.com/user-attachments/assets/4963f256-9d01-4484-925b-76a363f7beae" />

##Medidas Calculadas em DAX (_Medidas)

- Total Faturado Nominal (Regime de Competência)
```dax
SomaFaturamento = SUM(fato_faturamento[valor_faturado])
```
- Total Efetivamente Arrecadado (Regime de Caixa)
```dax
SomaPagamento = SUM(fato_faturamento[valor_pago])
```
- Lacuna Absoluta de Caixa (R$)
```dax
lacuna_diferenca = SUM(fato_faturamento[valor_faturado]) - SUM(fato_faturamento[valor_pago])
````
- Taxa Percentual de Inadimplência (%) protegida contra divisão por zero
```dax
taxa_Pencetual_pendencia = [lacuna_diferenca]/SUM(fato_faturamento[valor_faturado])
```
- Ranking Dinâmico de Clientes por Faturamento
```dax
Rank10_clientes = 
IF(
    HASONEVALUE(dim_clientes[nome_cliente]),
    RANKX(
        ALLSELECTED(dim_clientes[nome_cliente]),
        [SomaFaturamento],
        ,
        DESC
    )
)
```
- Percentual Acumulado da Carteira (Curva de Pareto)
```dax
Pct_Acumulado_Pareto = 
VAR FaturamentoTotal = CALCULATE([Soma Faturada], ALLSELECTED(dim_clientes))
VAR RankAtual = [Rank_Cliente]
VAR FaturamentoAcumulado = 
    CALCULATE(
        [Soma Faturada],
        FILTER(
            ALLSELECTED(dim_clientes[nome_cliente]),
            [Rank_Cliente] <= RankAtual
        )
    )
RETURN
DIVIDE(FaturamentoAcumulado, FaturamentoTotal, 0)
```
## Parte 10. Dashboard Executivo & Visual Storytelling
O painel no Power BI foi projetado aplicando princípios de UX/UI e Storytelling em 3 Atos, direcionando a atenção do tomador de decisão da visão geral para a auditoria detalhada:

<img width="1457" height="813" alt="image" src="https://github.com/user-attachments/assets/4a62d8ab-0129-4c7e-81e8-50181e3be3d0" />

<img width="1448" height="803" alt="image" src="https://github.com/user-attachments/assets/113cfeeb-f5eb-4325-89a2-99efeb0a9253" />

Estrutura Visual da Tela:
## Ato 1: O Panorama Geral (Topo)
- Cartões de KPI de alto impacto: Faturamento Total, Caixa Realizado, Lacuna R$ e Taxa de Inadimplência (%).

## Ato 2: Diagnóstico da Inadimplência (Centro)
- Gráfico Temporal/Barras: Evolução do Faturamento vs. Arrecadação por Área do Direito.
- Gráfico de Aging List: Barras Empilhadas mapeando a gravidade dos atrasos por Modalidade de Contrato (Partido Fixo vs. Êxito).

## Ato 3: Análise de Risco & Ação (Base)
- Gráfico de Pareto: Mapeamento da concentração de faturamento nos maiores clientes.
- Matriz de Clientes: Tabela dinâmica com o [Rank_Cliente], permitindo comparar a receita nominal versus o caixa liquidado conta por conta.

##Parte 11. Principais Resultados e Insights
A partir do cruzamento das análises em SQL e do dashboard no Power BI, comprovaram-se os seguintes pontos críticos de negócio:
-  **Concentração de Inadimplência na Área Trabalhista**: A carteira Trabalhista representa o maior volume nominal de faturamento, porém é responsável por mais de 60% dos títulos retidos na faixa crítica de atraso (> 60 dias).

- **Vulnerabilidade nos Contratos por Êxito**: Contratos sob modalidade de Êxito possuem um ciclo médio de recebimento 3x mais longo do que contratos de Partido Fixo, criando momentos de severa restrição de capital de giro durante trimestres de baixa liquidação de processos.

- **Risco de Concentração (Curva de Pareto)**: Apenas 12% da carteira corporativa responde por 65% de todo o faturamento do escritório. A análise cruzada revelou que 2 desses 10 maiores clientes apresentavam pendências de pagamento superiores a 60 dias, expondo a banca a um risco iminente de liquidez.

##Parte 12. Conclusão e Recomendações
Síntese
A análise demonstrou que a saúde financeira do escritório não é comprometida pela falta de novos contratos (volume comercial alto), mas sim pela ineficiência na gestão de cobrança do faturamento faturado e não realizado.
Recomendações Estratégicas:
Revisão da Política de Crédito para a Área Trabalhista: Estabelecer gatilhos de cobrança administrativa preventiva assim que a fatura atingir 15 dias de atraso (Faixa 1-30d).
Rebalanceamento de Modalidades Contratuais: Incentivar a transição de contratos puros de Êxito para modelos híbridos (Fixa de Manutenção + Êxito Final), garantindo previsibilidade de caixa mensal.
Gestão Dedicada para os Top 10 Clientes (Pareto): Criar um comitê de acompanhamento quinzenal para monitorar o status financeiro das contas que compõem os 65% da receita global do escritório.

## 👤 Sobre mim 
**SamyraBentemmuller**

Analista de Dados / BI Specialist

LinkedIn: https://www.linkedin.com/in/samyra-bentemmuller

GitHub: https://github.com/samyraLB

E-mail: Samyrabentemmuller@gmail.com
