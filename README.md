# Projeto de Dados com Python e BI: Análise Financeira de Inadimplência e Risco de Caixa

> **De onde vem o dinheiro que falta no caixa?** Um painel em Power BI que transforma 9.915 faturas em respostas objetivas para o sócio e o CFO: quanto foi faturado, quanto foi recebido, onde está a lacuna e o que fazer a respeito.

![Power BI](https://img.shields.io/badge/Power%20BI-DAX-F2C811?logo=powerbi&logoColor=black)
![Python](https://img.shields.io/badge/Python-3-3776AB?logo=python&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-DBeaver-1C1C1C?logo=dbeaver&logoColor=white)
![Git](https://img.shields.io/badge/Git-GitHub-181717?logo=github&logoColor=white)
![Dados](https://img.shields.io/badge/Dados-sint%C3%A9ticos-lightgrey)

---

##  Sumário

1. [Contexto e problema de negócio](#-contexto-e-problema-de-negócio)
2. [Objetivos](#-objetivos)
3. [Resumo executivo](#-resumo-executivo)
4. [Ferramentas utilizadas](#-ferramentas-utilizadas)
5. [Arquitetura do projeto](#-arquitetura-do-projeto)
6. [Modelo de dados](#-modelo-de-dados)
7. [Limpeza, tratamento e validação dos dados](#-limpeza-tratamento-e-validação-dos-dados)
8. [Medidas DAX](#-medidas-dax)
9. [O dashboard](#-o-dashboard)
10. [Principais insights e conclusões](#-principais-insights-e-conclusões)
11. [Recomendações para a diretoria](#-recomendações-para-a-diretoria)
12. [Limitações e próximos passos](#-limitações-e-próximos-passos)
13. [Estrutura do repositório](#-estrutura-do-repositório)
14. [Autor](#-autor)

---

##  Contexto e problema de negócio

Em escritórios de advocacia, **faturar não é o mesmo que receber**. Honorários fixos mensais e honorários de êxito (de valor alto e pagamento incerto) geram um fluxo de caixa difícil de enxergar em planilhas. A diretoria precisa saber, sem ambiguidade:

- Quanto do que emitimos de fato virou caixa?
- A diferença entre faturado e recebido é um problema de **prazo** (dinheiro que ainda vai entrar) ou de **perda** (dinheiro que dificilmente volta)?
- O risco está concentrado em poucos clientes, em uma área do direito ou em um tipo de contrato?

Este projeto visa responder a essas perguntas com um modelo analítico completo, do dado bruto ao dashboard, pensado para **leitura em minutos por quem decide**, não por quem opera.

---

##  Objetivos

### Objetivo geral
Dar ao **sócio** e ao **CFO** visibilidade total sobre a saúde do contas a receber do escritório, separando o que é timing do que é risco real de perda.

### Objetivos específicos

| Perspectiva | Pergunta que o painel responde |
|---|---|
| **Sócio** | Quais áreas (Cível, Trabalhista, Tributário) e modalidades (Partido Fixo, Êxito) geram mais receita e mais exposição? |
| **Sócio** | Nossa carteira depende de poucos clientes? (análise de Pareto) |
| **CFO** | Qual a **lacuna de caixa** (faturado − pago) e a taxa de pendência? |
| **CFO** | Quanto da lacuna é inadimplência efetiva e quanto é fatura ainda dentro do prazo? |
| **CFO** | Qual a idade (aging) da inadimplência e a chance realista de recuperação? |
| **CFO** | Como a pendência evolui mês a mês? Está melhorando ou piorando? |
| **Ambos** | Quais clientes concentram a maior perda em reais e onde agir primeiro? |

---

##  Resumo executivo

> Base analisada: **jan/2024 a jun/2026** (data de emissão) · **9.915 faturas** · **950 clientes** · 3 áreas do direito · 2 modalidades de contrato.

| Indicador | Valor |
|---|---|
|  **Faturamento total** | **R$ 2,50 bi** |
|  **Total recebido** | **R$ 2,17 bi** |
|  **Lacuna (faturado − pago)** | **R$ 328,8 mi** |
|  **Taxa de pendência** | **13,1 %** |
|  **Ticket médio por fatura** | R$ 252,5 mil |

**A leitura que muda a conversa:** os 13,1 % de pendência são, na verdade, **duas coisas diferentes**.

| Composição da lacuna | Valor | % do faturado | % da lacuna |
|---|---|---|---|
|  Inadimplente (vencida e não paga) | R$ 170,6 mi | 6,8 % | 51,9 % |
|  Em aberto (emitida em mai–jun/2026, ainda a vencer) | R$ 158,2 mi | 6,3 % | 48,1 % |

Ou seja, **a inadimplência estrutural gira em torno de 7 %**, estável desde 2024. Quase metade da lacuna é timing, não perda.

---

##  Ferramentas utilizadas

| Ferramenta | Aplicação no projeto |
|---|---|
| **Python 3** | Geração de dados sintéticos através das bibliotecas Pandas e NumPy, além da simulação de regras de negócio financeiras. |
| **DBeaver** | Atuando como um SGBD e na criação do banco de dados relacional e validação das lógicas analíticas. |
| **SQL** | Construção de métricas, agrupamentos, manipulação de datas e lógicas condicionais. |
| **Power BI / DAX** | Modelagem de dados (*Star Schema*), criação de medidas e visualização de dados (Dashboard). |
| **Git & GitHub** | Versionamento de código e documentação. |

---

## 🏗️ Arquitetura do projeto

| Ferramenta / Linguagem | Função no Projeto |
| :--- | :--- |
| **Python 3**  | Geração de dados sintéticos através das bibliotecas Pandas e Numpy, além da simulação de regras de negócio financeiras. |
| **DBeaver** | Atuando como um SGDB e na criação do banco de dados relacional e validação das lógicas analíticas. |
| **SQL** | Construção de métricas, agrupamentos, manipulação de datas e lógicas condicionais. |
| **Power BI / DAX** | Modelagem de dados (*Star Schema*), criação de medidas e visualização de dados (Dashboard). |
| **Git & GitHub** | Versionamento de código e documentação. |


## 📁 Estrutura do repositório


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

##  Modelo de dados

Modelo em **Star Schema**, com uma tabela fato e duas dimensões.

<img width="632" height="579" alt="image" src="https://github.com/user-attachments/assets/a3c0327f-a3c5-4765-be14-49de8c00a235" />



### `fato_faturamento` (9.915 linhas, uma por fatura)

| Coluna | Tipo | Descrição |
|---|---|---|
| `id_faturamento` | texto | Identificador único da fatura (ex.: `FAT-10022`) |
| `id_cliente` | texto | Chave estrangeira para `dim_clientes` |
| `area_direito` | texto | Cível, Trabalhista ou Tributário |
| `modalidade_contrato` | texto | Partido Fixo ou Êxito |
| `data_emissao` | data | Data de emissão da fatura |
| `data_vencimento` | data | Vencimento (emissão + 30 dias) |
| `data_pagamento` | data | Data do pagamento (nula quando não pago) |
| `valor_faturado` | inteiro | Valor emitido (R$) |
| `valor_pago` | inteiro | Valor efetivamente recebido (R$) |
| `status_cobranca` | texto | Pago, Pago com Atraso, Em Aberto ou Inadimplente |

### `dim_clientes` (950 clientes)

| Coluna | Descrição |
|---|---|
| `id_cliente` | Chave primária |
| `nome_cliente` | Nome (anonimizado) |
| `porte_cliente` | Pequeno, Médio ou Grande |
| `segmento_atuacao` | Saúde, Construção Civil, Logística, Varejo, Tecnologia ou Financeiro |
| `data_inicio_relacionamento` | Início do relacionamento com o escritório |
| `status_cliente` | Ativo ou Cancelado |

### `calendario`
Tabela de datas com ano, trimestre, mês, `Mes_Ano` e dia da semana, usada nas análises de evolução temporal.

---


## 🧹 Limpeza, tratamento e validação dos dados

A qualidade do dado define a credibilidade do número que chega ao CFO. O tratamento seguiu três camadas.

### 1. Geração e regras de negócio (Python)
Os dados são **sintéticos**, produzidos com Pandas e NumPy, com regras financeiras simuladas para que o comportamento da carteira seja realista:

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
- Vencimento fixado em **30 dias após a emissão**.
- Faturas **Pagas** liquidadas em até 15 dias após o vencimento; **Pagas com Atraso** liquidadas entre 31 e 90 dias após o vencimento.
- Faturas **Em Aberto** e **Inadimplentes** têm `valor_pago = 0` e `data_pagamento` nula.
- Modalidades com perfis de valor distintos: Partido Fixo (de R$ 30 mil a R$ 360 mil) e Êxito (de R$ 150 mil a R$ 1,44 mi).
O principal desafio de qualidade de dados neste escopo foi o tratamento de faturas não pagas.
- Valores Ausentes (Nulls): Faturas inadimplentes não possuem data_pagamento. No ambiente relacional (SQL), isso foi tratado utilizando a função COALESCE para fixar uma data de corte e permitir o cálculo exato dos dias de atraso.
- Padronização: Tipagem rigorosa de datas (YYYY-MM-DD) e valores monetários (Float/Decimal) garantida desde a geração no Python até a carga no banco.
## 2. Análise exploratória de dados (EDA)
A etapa exploratória foi conduzida primariamente via SQL dentro do Dbeaver. O meu foco foi investigar anomalias de recebimento.
- Descoberta inicial: Observou-se rapidamente que, enquanto a emissão de faturas crescia de forma linear, o status "Em Aberto" se concentrava desproporcionalmente em processos Trabalhistas.
- Investigação de Prazos: Cruzando datas de vencimento e pagamento, o ciclo médio de contratos de Êxito demonstrou uma variação extrema em comparação aos contratos de Partido Fixo.
## 3. Criando o banco de dados e as consultas SQL no Dbeaver
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

### 4. Tipagem e carga (Power Query)
- Importação dos CSVs (UTF-8, delimitador vírgula) e promoção da primeira linha a cabeçalho.
- Conversão explícita de tipos: texto para IDs e categorias, **data** para as três colunas de data, **inteiro** para os valores monetários.

### 5. Validações de integridade

| Verificação | Resultado |
|---|---|
| Chaves duplicadas em `id_faturamento` e `id_cliente` |  Nenhuma |
| Integridade referencial (toda fatura tem cliente em `dim_clientes`) |  0 órfãs |
| Valores nulos nas colunas de negócio |  Nenhum |
| Nulos em `data_pagamento` |  1.313, exatamente as faturas Em Aberto (627) + Inadimplentes (686) |
| `valor_pago` maior que `valor_faturado` |  Nenhum caso |
| Consistência status × pagamento (Pago ⇒ pago = faturado; Em Aberto/Inadimplente ⇒ pago = 0) |  100 % consistente |
| Totais por área, modalidade e status somam ao total geral |  Fecham |
| Cobertura temporal (calendário cobre toda a janela de emissões) |  jan/2024 a jun/2026 |

---

##  Medidas DAX

| Medida | Lógica | Finalidade |
|---|---|---|
| `SomaFaturamento` | `SUM(fato_faturamento[valor_faturado])` | Total emitido |
| `SomaPagamento` | `SUM(fato_faturamento[valor_pago])` | Total recebido |
| `lacuna_diferenca` | `[SomaFaturamento] - [SomaPagamento]` | Dinheiro faturado e ainda não recebido |
| `taxa_percentual_pendencia` | `[lacuna_diferenca] / [SomaFaturamento]` | Peso da lacuna sobre o faturado |
| `TicketMedio` | `AVERAGE(fato_faturamento[valor_faturado])` | Valor médio por fatura |
| `Rank10_clientes` | `RANKX` sobre `nome_cliente` por faturamento | Posição do cliente no ranking |
| `Faturamento_Top10_CLIENTES` | `TOPN(10, clientes, [SomaFaturamento])` | Receita dos 10 maiores clientes |
| `Pct_Acumulado_Pareto` | Faturamento acumulado por ranking ÷ total | Curva de Pareto (concentração) |

```dax
Faturamento_Top10_CLIENTES =
CALCULATE (
    [SomaFaturamento],
    TOPN ( 10, ALLSELECTED ( dim_clientes[nome_cliente] ), [SomaFaturamento], DESC )
)
```

---

##  O dashboard

O relatório tem **2 páginas**, desenhadas para uma leitura do macro para o detalhe.

| Página | Foco | Principais visuais |
|---|---|---|
| **1. Visão executiva por área** | Faturado × pago × lacuna por área do direito | Matriz com taxa de pendência, combo faturado × pago, medidor de recebimento (pago vs. faturado), cartão de lacuna, status de cobrança por modalidade |
| **2. Clientes e evolução** | Quem são os maiores clientes e como o recebimento evolui | Cartões de faturamento total e Top 10, ranking de clientes, **curva de Pareto**, evolução mensal em área, comparativo por área |
| **3. Painel de KPIs** | Números-chave de uma olhada | Cartões de faturamento, pagamento, lacuna e taxa de pendência; combo por área; rosca da lacuna por modalidade |
| **4. Modalidade ao longo do tempo** | Evolução da lacuna por tipo de contrato | Área empilhada por modalidade e mês, Pareto de clientes, ranking de clientes |


> <img width="1303" height="729" alt="image" src="https://github.com/user-attachments/assets/be71e715-2abb-4b8b-8d1c-3ff372874b40" />

> <img width="1303" height="724" alt="image" src="https://github.com/user-attachments/assets/7818a9a9-e591-467d-92d5-b37e69e40bc4" />
---

##  Principais insights e conclusões

### 1. A "inadimplência de 13 %" é, na realidade, cerca de 7 %
A taxa de pendência de 13,1 % mistura dois fenômenos. **R$ 158,2 mi (48 % da lacuna) são faturas emitidas em maio e junho de 2026 que ainda estão dentro do prazo.** Considerando apenas as faturas já maduras (emitidas até abril/2026), a pendência cai para **7,3 %**.

| Ano de emissão | Taxa de pendência |
|---|---|
| 2024 | 7,7 % |
| 2025 | 6,9 % |
| jan–abr/2026 | 7,3 % |
| mai–jun/2026 | 95 % a 100 % (efeito de prazo, não de perda) |

 **Conclusão:** a inadimplência é estável. O pico visível nos últimos dois meses do gráfico de evolução é artefato de maturidade da carteira e não deve gerar alarme.

### 2. A dívida vencida está envelhecendo, e cada mês reduz a chance de recuperação
Das **686 faturas inadimplentes (R$ 170,6 mi)**, medindo o aging até 30/06/2026:

| Faixa de atraso | Valor | % |
|---|---|---|
| Até 90 dias | R$ 7,7 mi | 4,5 % |
| 91 a 180 dias | R$ 21,9 mi | 12,9 % |
| 181 a 365 dias | R$ 36,4 mi | 21,3 % |
| **Acima de 365 dias** | **R$ 104,6 mi** | **61,3 %** |

 **Conclusão:** **83 % da inadimplência tem mais de 180 dias** e 61 % passa de um ano. A régua de cobrança atual não está recuperando o que vence. Só R$ 7,7 mi estão na janela em que a cobrança costuma funcionar.

### 3. O problema é transversal: não está em uma área nem em um tipo de contrato
| Dimensão | Taxa de pendência |
|---|---|
| Cível | 13,2 % |
| Trabalhista | 12,9 % |
| Tributário | 13,3 % |
| Partido Fixo | 13,2 % |
| Êxito | 13,1 % |

 **Conclusão:** nenhuma área ou modalidade se destaca. Trocar a política de uma prática específica não resolve. O ponto de ação é o **processo de cobrança do escritório como um todo**.

### 4. O Êxito concentra o risco em reais
Contratos de Êxito são **64,4 % do faturamento**, com ticket médio de **R$ 559 mil**, contra R$ 127 mil do Partido Fixo (4,4 vezes maior). Embora a taxa de perda seja igual, **uma única fatura de Êxito inadimplente custa quatro vezes mais**. Êxito responde por R$ 211,1 mi da lacuna (64,2 %).

### 5. A carteira é pulverizada: baixo risco de concentração
| Faixa | Clientes | % da base |
|---|---|---|
| Para atingir **50 %** do faturamento | 125 | 13,2 % |
| Para atingir **80 %** do faturamento | 350 | 36,8 % |
| **Top 10 clientes** | 10 | **6,0 % do faturamento (R$ 149,6 mi)** |

 **Conclusão:** a curva de Pareto é bem mais "achatada" que o clássico 80/20. Perder um grande cliente não ameaça o escritório. Em contrapartida, a perda também é pulverizada: **434 clientes (46 %) têm ao menos uma fatura inadimplente**, e o maior saldo em aberto de um único cliente é de R$ 3,5 mi (≈ 1 % da lacuna). Por isso a solução é **processo e régua de cobrança**, não negociação caso a caso com poucos devedores.

### 6. Onde o risco é maior: segmento e porte
| Segmento | Pendência | Inadimplência |
|---|---|---|
| **Financeiro** | **16,1 %** | **10,0 %** |
| Tecnologia | 14,2 % | 8,1 % |
| Construção Civil | 13,4 % | 6,1 % |
| Logística | 13,0 % | 6,4 % |
| Saúde | 11,7 % | 5,4 % |
| Varejo | 11,1 % | 5,9 % |

| Porte | Peso no faturamento | Pendência | Inadimplência |
|---|---|---|---|
| Grande | 55,5 % | 12,7 % | 6,4 % |
| Médio | 30,6 % | 13,3 % | 7,0 % |
| Pequeno | 13,9 % | 14,4 % | 8,2 % |

 **Conclusão:** clientes do setor **Financeiro** inadimplem **quase o dobro** do segmento Saúde. Clientes **Pequenos** têm a pior taxa, mas **Grandes** concentram **R$ 176,5 mi (54 %) da lacuna em valor absoluto**.

### 7. O atraso "leve" também custa
- **88,1 %** das faturas pagas foram pontuais; **1.024 faturas (R$ 258,4 mi, 10,3 % do faturado)** foram pagas com atraso médio de **61 dias**.
- Prazo médio de recebimento, da emissão ao pagamento: **41 dias**, igual nas duas modalidades.
- Há um "vazio" no comportamento: quem atrasa, atrasa bastante (31 a 90 dias). Não existe pagamento com atraso curto, o que indica que o atraso é decisão do cliente, não falha operacional.

### 8. Clientes cancelados ainda deixam dinheiro na mesa
**148 clientes cancelados (15,6 % da base)** respondem por **R$ 58,6 mi da lacuna (17,8 %)**, dos quais R$ 30,6 mi são inadimplência pura. A recuperação desses valores é mais difícil por falta de relacionamento ativo.

---

##  Recomendações para a diretoria

| Prioridade | Ação | Base no dado |
|---|---|---|
|  **Alta** | Força-tarefa de cobrança para as faturas vencidas entre 91 e 365 dias (R$ 58,3 mi), onde ainda há chance real de recuperação. | 34 % da inadimplência está nessa faixa |
|  **Alta** | Provisionar (ou rever contabilmente) os R$ 104,6 mi com mais de 365 dias de atraso. | 61 % da inadimplência |
|  **Média** | Implantar régua de cobrança preventiva (lembrete antes do vencimento e contato em 1 a 30 dias de atraso). | Não há atraso curto: o cliente "pula" direto para 31+ dias |
|  **Média** | Exigir entrada, garantia ou parcelamento em honorários de Êxito de alto valor. | Ticket 4,4 vezes maior e 64 % da exposição |
|  **Média** | Análise de crédito reforçada para clientes do segmento Financeiro e de porte Pequeno. | 10,0 % e 8,2 % de inadimplência |
|  **Monitorar** | Acompanhar as R$ 158,2 mi "Em Aberto" na virada de prazo para confirmar se seguem o padrão histórico de cerca de 7 %. | Evita falso alarme ou falsa tranquilidade |
|  **Monitorar** | Tratar clientes cancelados com saldo devedor (R$ 30,6 mi inadimplentes) como carteira de recuperação dedicada. | 17,8 % da lacuna |

---

##  Limitações e próximos passos

**Limitações**
- Os dados são **sintéticos**: os padrões refletem as regras de negócio simuladas, e os achados demonstram a metodologia, não o comportamento de um escritório real.
- Não há **pagamento parcial**: cada fatura é quitada integralmente ou não é paga. Em um caso real, parcelamentos e descontos negociados exigiriam um modelo de pagamentos 1:N.
- A inadimplência não tem **reversão registrada** (renegociação, baixa contábil ou perda definitiva).
- O aging considera como data de corte **30/06/2026** (última emissão da base).

**Próximos passos**
-  Modelo de probabilidade de inadimplência (Scikit-learn) usando porte, segmento e histórico do cliente.
-  Projeção de fluxo de caixa a receber (faturas Em Aberto × padrão histórico de pagamento).
-  Tabela de pagamentos separada, para suportar parcelas e descontos.
-  Atualização automatizada da base e publicação no Power BI Service.

---

*Projeto de portfólio com dados fictícios. Nenhuma informação real de clientes ou de escritórios foi utilizada.*



# 👤 Sobre mim 
**Samyra Bentemmuller**

Analista de Dados / BI Specialist

LinkedIn: https://www.linkedin.com/in/samyra-bentemmuller

GitHub: https://github.com/samyraLB

E-mail: Samyrabentemmuller@gmail.com
