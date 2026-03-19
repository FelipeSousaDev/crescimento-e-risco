# 📊 Crescimento e Risco — Projeto End-to-End de Dados

![SQL Server](https://img.shields.io/badge/SQL_Server-T--SQL-CC2927?style=flat&logo=microsoftsqlserver&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.x-3776AB?style=flat&logo=python&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-ETL-150458?style=flat&logo=pandas&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-Dashboard-F2C811?style=flat&logo=powerbi&logoColor=black)

> Pipeline completo de dados simulando o fluxo real de uma empresa de varejo — da modelagem do banco até a entrega de dashboards executivos com insights acionáveis.

---

## 📌 Problema de Negócio

No cenário de operações de e-commerce, empresas perdem receita porque não conseguem cruzar dados de pagamento com o comportamento real do cliente. Este projeto responde três perguntas críticas:

- **Qual método de pagamento gera mais cancelamentos?**
- **Qual é o prejuízo financeiro real causado pelo churn?**
- **Como o crescimento de receita se comporta ao longo do tempo por região?**

---

## 🏗️ Arquitetura do Projeto

```
CSV (Kaggle/Olist)
      ↓
 Python ETL
 (Pandas + SQLAlchemy)
      ↓
 SQL Server
 (Tabelas + Views)
      ↓
 Power BI
 (Star Schema + DAX)
      ↓
 3 Dashboards Executivos
```

---

## 📁 Estrutura do Repositório

```
crescimento-e-risco/
│
├── 01_sql/
│   ├── SCRIPTS_CRIACAO_BD.sql       # DDL: criação das tabelas com constraints
│   └── VW_CHURN_PAGAMENTOS.sql      # View usada como base para análise de churn
│
├── 02_python/
│   ├── leitura_de_entidades.ipynb   # EDA inicial: entendimento do dataset
│   └── tratatamento_dados.ipynb     # ETL completo + análise de churn
│
├── 03_dashboard/
│   ├── dashboard.pbix               # Arquivo Power BI com os 3 dashboards
│   └── prints/
│       ├── executive_overview.png
│       ├── risk_analysis.png
│       └── growth_ltv.png
│
├── 04_docs/
│   ├── DIAGRAMA_BANCO_DADOS.pdf     # Diagrama entidade-relacionamento
│   └── plano_de_projeto_v1.pdf      # Documento de definição do projeto
│
└── README.md
```

---

## 🛠️ Stack Técnica

| Camada | Tecnologia | Uso |
|---|---|---|
| Banco de Dados | SQL Server · T-SQL | Modelagem relacional, constraints, views |
| Pipeline | Python · Pandas · SQLAlchemy | ETL, limpeza, ingestão e auditoria |
| Análise | Python · Matplotlib | Churn analysis, análise geográfica e temporal |
| BI | Power BI · DAX | Star Schema, KPIs, 3 dashboards executivos |

---

## 🗄️ Fase 1 — Modelagem do Banco de Dados (SQL)

Modelagem de 3 entidades com constraints estritas de integridade referencial:

```sql
CREATE TABLE PAGAMENTOS (
    id_pagamentos  INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    order_id       VARCHAR(50) NOT NULL,
    payment_type   VARCHAR(100),
    payment_value  DECIMAL(10, 2),
    CONSTRAINT FK_PAGAMENTOS_PEDIDOS FOREIGN KEY (order_id)
        REFERENCES PEDIDOS (order_id)
)
```

**Conceitos aplicados:** `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `IDENTITY`, `DECIMAL`, Views para desacoplamento da lógica de negócio.

---

## 🐍 Fase 2 — Pipeline ETL com Python

Ingestão dos dados com validação de integridade antes de qualquer INSERT:

```python
# Auditoria: filtra pagamentos sem pedido correspondente no banco
set_ids = set(lista_de_id['order_id'].astype(str).unique())
df_pagamentos = df_pagamentos[df_pagamentos['order_id'].isin(set_ids)]
print(f'Registros válidos para carga: {len(df_pagamentos)}')

# Ingestão via SQLAlchemy
df_pagamentos.to_sql('PAGAMENTOS', con=engine, if_exists='append', index=False)
```

**Conceitos aplicados:** conexão via `SQLAlchemy + pyodbc`, `pd.to_datetime()`, filtro de registros órfãos, auditoria pré-carga.

---

## 📈 Fase 3 — Análise de Churn e Risco

Análise realizada sobre a view `VW_CHURN_PAGAMENTOS`, cruzando status do pedido com método de pagamento e região:

```python
# Definição de churn: pedido não entregue
view['CHURN'] = view['STATUS_PEDIDO'] != 'delivered'

# Taxa de churn por método de pagamento
view.groupby('TIPO_PAGAMENTO')['CHURN'].mean() * 100
```

---

## 💡 Principais Insights

| Insight | Valor |
|---|---|
| Churn Rate geral | 2,26% |
| Recovery Rate | 97,73% |
| Receita total aprovada | R$ 8,70 Mi |
| Receita perdida por churn | R$ 246,79 Mil |
| % pedidos perdidos via cartão de crédito | **66,67%** |
| Crescimento de receita (2016→2018) | +20% a.a. |
| Redução do churn (2016→2018) | de ~18% para 2,26% |

> **O dado mais relevante:** enquanto a receita cresceu 20% ao ano, o churn caiu de 18% para 2,26% no mesmo período — evidência de maturação operacional da plataforma.

---

## 📊 Fase 4 — Dashboards Power BI

Três páginas com paleta de cores semântica: **azul = saudável / vermelho = risco**.

**Executive Overview**
KPIs com comparativo YoY · Receita por Estado · Receita x Churn Rate (eixo duplo)

![Visão Executiva](03_dashboard/prints/visao_executiva.png)

---

**Risk Analysis**
Pedidos perdidos por tipo de pagamento · Churn Rate por Estado · Evolução mensal do churn

![Análise de Risco](03_dashboard/prints/analise_de_risco.png)

---

**Growth & LTV**
MoM Growth · Ticket Médio · Gráfico de área mensal · Matriz Cohort com heatmap

![Crescimento](03_dashboard/prints/crescimento.png)

---

## ▶️ Como Executar

**Pré-requisitos:**
- SQL Server instalado e em execução
- Python 3.x
- ODBC Driver 17 for SQL Server

**1. Clone o repositório**
```bash
git clone https://github.com/FelipeSousaDev/crescimento-e-risco.git
```

**2. Instale as dependências Python**
```bash
pip install pandas sqlalchemy pyodbc matplotlib
```

**3. Baixe o dataset**

Acesse [Brazilian E-Commerce (Olist) no Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) e salve os CSVs em uma pasta `datasets/` na raiz do projeto.

**4. Execute o banco de dados**

Abra o SQL Server Management Studio e execute `01_sql/SCRIPTS_CRIACAO_BD.sql` seguido de `01_sql/VW_CHURN_PAGAMENTOS.sql`.

**5. Execute os notebooks**

Abra os notebooks em `02_python/` na ordem e configure a string de conexão com seus dados do SQL Server.

**6. Abra o dashboard**

Abra `03_dashboard/dashboard.pbix` no Power BI Desktop.

---

## 📄 Dataset

**Brazilian E-Commerce Public Dataset by Olist**  
Disponível em: [kaggle.com/datasets/olistbr/brazilian-ecommerce](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)  
~100.000 pedidos reais entre 2016 e 2018.

---

## 👤 Autor

**Felipe Sousa**  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-felipeb26-0077B5?style=flat&logo=linkedin)](https://www.linkedin.com/in/felipeb26/)
[![Gmail](https://img.shields.io/badge/Email-felipesousa.b1@gmail.com-D14836?style=flat&logo=gmail&logoColor=white)](mailto:felipesousa.b1@gmail.com)
