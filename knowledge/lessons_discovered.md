# Lessons Discovered — DiD Reanalysis Project
## Lições extraídas de 56 reanálises

Gerado a partir dos resultados consolidados, failure_patterns.md e relatórios individuais.
Última atualização: 2026-04-02

---

## 0. CONTROLS — Como covariáveis afetam magnitude, pré-tendências e viabilidade dos estimadores

### 0.1 Propensity score e overfitting com controles categóricos de alta dimensão
**Artigos**: ID 241 (Lawler), ID 25 (Buchmueller), ID 44 (Bosch/Campos-Vazquez), ID 91 (Evans/Harris/Kessler), ID 271 (Slusky)
**Patterns**: 42

Quando o CS-DID usa dummies geográficas (e.g., estado) na `xformla`, o modelo de propensity score pode separar perfeitamente tratamento e controle se algum estado tiver menos de ~5 unidades tratadas. Três modos de falha: ATT zerado, atenuação de 47–83%, ou falha numérica. Em 8 artigos testados, adicionar dummies estaduais matou o efeito em 3 casos e atenuou fortemente em 2.

**Lição**: Estimadores baseados em IPW (CS-DID) absorvem covariáveis de forma fundamentalmente diferente de estimadores de efeitos fixos (TWFE). Pesquisadores que mecanicamente adicionam os mesmos controles a ambos podem produzir divergências que refletem artefatos de especificação, não heterogeneidade real.

### 0.2 Protocolo graduado para diagnóstico de overfitting vs. confundimento genuíno
**Artigos**: ID 25 (Buchmueller), ID 241 (Lawler), ID 271 (Slusky)
**Patterns**: 42

A comparação simples "com controles" vs. "sem controles" é ambígua. O protocolo graduado (baseline → +região → +estado(amostra completa) → +estado(overlap ≥ 5 tratados E ≥ 5 controles por estado)) separa overfitting de confundidores geográficos genuínos. Se a estimativa com restrição de overlap recupera o baseline, a atenuação era puro overfitting.

**Lição**: Divergências entre TWFE e CS-DID em especificações com covariáveis geográficas devem ser investigadas com testes de overlap antes de serem interpretadas como evidência de viés.

### 0.3 Controles com interação de tratamento são colineares com dummies de event study
**Artigos**: ID 79 (Carpenter/Lawler), ID 133 (Hoynes)
**Patterns**: 20

Quando o artigo original usa controles do tipo `treated * post * year` na especificação estática, esses são quase colineares com os indicadores de tempo relativo `i(rel_time)` no event study. Isso causa dropout de coeficientes e padrões distorcidos. Solução: definir conjuntos separados de controles para especificações estáticas (`twfe_controls`) e dinâmicas (`twfe_es_controls`).

**Lição**: A especificação de controles deve ser adaptada ao tipo de estimação (estática vs. dinâmica), não transportada automaticamente.

### 0.4 Artigos com covariáveis têm concordância de sinal ligeiramente maior, mas perdem significância com mais frequência
**Artigos**: Amostra completa (33 com covariáveis, 23 sem)

Concordância de sinal TWFE vs. CS-NT: 92% com covariáveis, 86% sem. Porém, transição sig→insig: 24% com covariáveis vs. 18% sem. Artigos com covariáveis são mais frequentemente RCS (14/33 vs. 3/23) e escalonados (19/33 vs. 12/23).

**Lição**: Covariáveis não necessariamente protegem contra divergência entre estimadores; o canal é mais complexo e depende da estrutura dos dados e do tipo de adoção.

---

## 1. STATIC EFFECTS — Sinal, magnitude e significância entre TWFE e estimadores modernos

### 1.1 Concordância de sinal é a norma, mas não é universal
**Artigos**: Amostra completa (56 artigos, 50 com TWFE + CS-NT)

TWFE vs. CS-NT: 45/50 (90%) concordam no sinal. Cinco reversões: ID 125 (Levine, McKnight & Heep), ID 234 (Myers), ID 281 (Steffens/Pereda), ID 380 (Kuziemko/Meckel/Rossin-Slater), ID 437 (Hausman). TWFE vs. CS-NYT: 25/31 (80,6%) concordam, 6 reversões (19,4%). A taxa de reversão é substancialmente maior com not-yet-treated.

**Lição**: A maioria dos resultados TWFE sobrevive à mudança para estimadores modernos em sinal, mas ~10% revertem — taxa alta o suficiente para justificar reanálise sistemática.

### 1.2 Mudanças de magnitude seguem padrões previsíveis por tipo de desenho
**Artigos**: Amostra completa

Mediana da mudança relativa (CS-NT vs. TWFE): −5,5%. Média: +15,7%. Desvio padrão: 2,02. 26% dos artigos mudam mais de 50% em magnitude; 14% mudam mais de 100%.

Padrões por desenho:
- **Adoção única**: TWFE e CS-DID quase idênticos (e.g., ID 133 Hoynes: −0,387 vs. −0,403; ID 68 Tanaka: 0,522 vs. 0,522).
- **Escalonada**: CS-DID tipicamente 15–40% maior que TWFE (e.g., ID 9 Dranove: −0,176 vs. −0,208; ID 347 Courtemanche: −0,174 vs. −0,448, aumento de 157%).

**Lição**: Em desenhos de adoção única, TWFE e CS-DID convergem por construção. A divergência substantiva concentra-se em desenhos escalonados, onde a contaminação por pesos negativos (Goodman-Bacon 2021) atenua o TWFE em direção a zero.

### 1.3 Mudanças de significância concentram-se em três cenários
**Artigos**: 50 com TWFE + CS-NT

Transições de significância (p < 0,05):
- Sig→Sig: 25 (50%)
- Sig→Insig: 12 (24%)
- Insig→Sig: 2 (4%)
- Insig→Insig: 11 (22%)

Para CS-NYT, Sig→Insig sobe para 29%.

Três cenários típicos:
(a) **Efeito real, TWFE atenuado**: CS recupera significância (e.g., ID 253 Bancalari).
(b) **Efeito marginal**: ambos estimadores oscilam em torno do limiar (e.g., ID 234 Myers, ID 281 Steffens).
(c) **CS infla erro-padrão via variância de coortes pequenas**: TWFE significante, CS não, por SE quase duplicado (e.g., ID 65 Akosa Antwi et al., ID 147 Greenstone).

**Lição**: Perda de significância é o canal mais frequente de divergência (24%), não reversão de sinal (10%). Um quarto dos artigos perde significância ao passar para CS-DID.

### 1.4 CS-NT e CS-NYT raramente discordam entre si
**Artigos**: 25 com ambos (NT e NYT)

Discordância de sinal: 0/25 (0%). Discordância de significância: 2/25 (8%) — IDs 253 (Bancalari) e 262 (Anderson/Charles/Rees).

**Lição**: A escolha do grupo de comparação (never-treated vs. not-yet-treated) raramente altera a conclusão qualitativa. Quando altera, sinaliza fragilidade do desenho, não do estimador.

---

## 2. DYNAMIC EFFECTS — Timing, persistência e padrões de event study

### 2.1 R e Stata estimam parâmetros diferentes no CS-DID dinâmico
**Artigos**: Todos com event study
**Patterns**: 24

R (`aggte(type="dynamic")`) estima efeitos marginais (período a período, usando t−1 como referência implícita pós-tratamento). Stata (`csdid2 ... long2`) estima efeitos cumulativos (todos relativos a g−1). Magnitudes pós-tratamento divergem por construção. Placebos pré-tratamento convergem apenas com `base_period="universal"` no R.

**Lição**: A divergência entre R e Stata no CS-DID dinâmico é uma diferença de parâmetro, não um bug. Comparações cross-platform de event studies exigem cuidado com a definição do período base.

### 2.2 Pré-tendências visíveis em TWFE podem desaparecer em CS-DID (e vice-versa)
**Artigos**: ID 9 (Dranove), ID 79 (Carpenter/Lawler)

Porque TWFE e CS-DID ponderam células coorte×tempo de forma diferente, uma pré-tendência visível em um estimador pode estar ausente no outro. A comparação graduada (TWFE, CS-NT, CS-NYT, SA, Gardner) oferece um retrato mais completo.

**Lição**: Nenhum estimador isolado é diagnóstico definitivo de pré-tendências. A comparação multi-estimador é ferramenta primária de diagnóstico.

### 2.3 Gardner (did2s) mostra apenas períodos pós-tratamento no R
**Artigos**: Todos com event study via did2s
**Patterns**: 3, 19

O pacote `didimputation` no R silenciosamente elimina horizontes negativos. Avaliação de pré-tendência deve vir de TWFE, CS ou SA. Limitação do pacote, não do método.

**Lição**: Não usar Gardner como único diagnóstico de pré-tendências.

### 2.4 Sun-Abraham requer cuidado na extração de SEs e aplicabilidade
**Artigos**: Todos escalonados com event study
**Patterns**: 1, 4

SA requer 2+ coortes de tratamento. Extração de SEs deve usar `iplot()`, não `coef()/vcov()`, que infla SEs em 5–18×. SA é instável quando a última coorte tratada é muito pequena (explosão de variância).

**Lição**: SA é complementar, não substituto do CS-DID dinâmico. Sua utilidade é confirmar padrões, não ser diagnóstico principal.

---

## 3. R vs STATA — Variação de implementação vs. variação substantiva

### 3.1 O default de base_period difere e importa enormemente
**Artigos**: ID 79 (Carpenter/Lawler), ID 80 (Marcus/Siedler/Ziebarth)
**Patterns**: 24, 26

R (`did`) usa `base_period="varying"` por default. Stata (`csdid2`) usa período base universal. Essa diferença de default produz placebos pré-tratamento com sinais opostos. O projeto padronizou `base_period="universal"` sempre.

**Lição**: Defaults de software devem ser explicitados e padronizados. Divergências aparentes entre R e Stata frequentemente desaparecem quando os defaults são alinhados.

### 3.2 R reclassifica silenciosamente unidades tratadas tarde como never-treated
**Artigos**: ID 79 (Carpenter/Lawler)
**Patterns**: 25

Quando unidades são tratadas após o fim da janela de dados, `att_gt` com `control_group="nevertreated"` absorve-as no grupo NT (porque `gvar > max(year)` é convertido a Inf). Stata não faz isso. Isso produziu discrepância de 37% no ATT (0,096 vs. 0,153) até ser identificado.

**Lição**: Falhas silenciosas dominam. Essa reclassificação não gera nenhuma mensagem de erro ou warning.

### 3.3 Codificação temporal do Stata requer decodificação manual
**Artigos**: Múltiplos
**Patterns**: 7, 12

Stata armazena semestres e meses como inteiros com codificação de época (e.g., semestre: `(year-1960)*2 + (h-1)`; mensal: `month_int %% 12 + 1`). Usar `as.Date()` do R nesses inteiros silenciosamente produz datas erradas.

**Lição**: Toda variável temporal de Stata deve ser decodificada com a fórmula correta antes de uso no R.

### 3.4 Variáveis criadas por `xi:` do Stata não existem nos dados brutos
**Artigos**: Múltiplos
**Patterns**: 16

Indicadores criados pelo prefixo `xi:` do Stata (e.g., `_Ieduc_cat_2`) não são armazenados no `.dta`. R deve usar a variável categórica base e deixar `feols()` expandir nativamente.

**Lição**: Nunca buscar variáveis com prefixo `_I` nos dados; reconstruir a partir da variável original.

### 3.5 Estrutura de FE do template pode divergir de OLS original
**Artigos**: ID 68 (Tanaka)
**Patterns**: 17

Quando o artigo original usa OLS simples com interação DiD pré-construída (`dd = treated * post`), os FEs bidirecionais obrigatórios do template produzem ~10% de divergência. Diferença estrutural documentada, não falha.

**Lição**: Divergências pequenas (~10%) entre TWFE replicado e original não indicam erro quando a estrutura de FE difere.

---

## 4. RCS vs PANEL — Efeitos da estrutura dos dados sobre viabilidade e resultados

### 4.1 CS-DID funciona em RCS via panel=FALSE, mas exige row_id sintético
**Artigos**: Todos RCS (18 artigos)
**Patterns**: 8

Configurar `panel=FALSE` e `idname="row_id"` (ID único por observação) ativa o estimador de cross-sections repetidas. Não requer agregação. Porém, tempo de computação escala com o número de períodos — além de ~60, CS-DID pode causar segfault.

**Lição**: RCS funciona no CS-DID, mas com custo computacional significativo e risco de instabilidade em amostras grandes.

### 4.2 BJS (did_imputation) não lida com dados individuais de RCS
**Artigos**: Múltiplos RCS
**Patterns**: 4, 22, 23

BJS requer combinações únicas (unidade, tempo). Dados individuais de survey violam isso. Pré-agregação ao nível unidade×tempo é possível, mas perde FEs individuais (idade, demografia) e é apenas aproximação.

**Lição**: BJS é inaplicável a RCS individual. Gardner (did2s) é o substituto operacional.

### 4.3 Gardner (did2s) funciona universalmente em qualquer estrutura de dados
**Artigos**: Todos (56 artigos)

Gardner opera diretamente em dados individuais, painel ou RCS, sem agregação. Substitui BJS como estimador de imputação para configurações RCS.

**Lição**: Gardner é o estimador robusto mais flexível do toolkit — funciona em todos os 56 desenhos da amostra.

### 4.4 Artigos RCS mostram gaps maiores entre TWFE e CS-DID
**Artigos**: 18 RCS vs. 38 painel

Artigos RCS tendem a apresentar diferenças proporcionais maiores entre TWFE e CS-DID. Provavelmente reflete o ruído adicional de não rastrear indivíduos ao longo do tempo, amplificando a sensibilidade de diferentes estimadores a ponderação e composição do grupo de controle.

**Lição**: Resultados de RCS merecem mais cautela na interpretação de divergências entre estimadores.

### 4.5 gvar_CS deve ser numeric, não integer, para sobreviver a conversão interna a Inf
**Artigos**: ID 305 (Sood), ID 359 (Fletcher/Frisvold/Tefft), ID 338 (Cotti/Nesson/Tefft)
**Patterns**: 43

O tipo integer do R não representa Inf. Quando gvar_CS é armazenado como integer, a conversão interna do pacote `did` de 0 para Inf produz NA silenciosamente, levando a resultados errados ou reversões de sinal.

**Lição**: Sempre converter gvar_CS para `as.numeric()` antes de passar ao `att_gt()`.

---

## Insight transversal

A lição mais importante e generalizável é que **falhas silenciosas dominam**. Dos 43 patterns documentados, a maioria não produz mensagem de erro — silenciosamente retorna estimativas erradas. Reversões de sinal (Pattern 43), contaminação de grupo de controle (Pattern 25), overfitting de propensity score (Pattern 42) e defaults de período base (Patterns 24/26) operam sem warnings. Isso torna a comparação multi-estimador (TWFE + CS-NT + CS-NYT + SA + Gardner) não apenas exercício de robustez, mas **ferramenta diagnóstica primária**: a discordância entre estimadores é frequentemente o primeiro sinal de que algo deu errado no pipeline.

---

## Índice reverso (artigo → lições)

| ID | Autor | Lições |
|----|-------|--------|
| 9 | Dranove | 1.2, 2.2 |
| 25 | Buchmueller | 0.1, 0.2 |
| 44 | Bosch/Campos-Vazquez | 0.1, 1.1 |
| 65 | Akosa Antwi et al. | 1.1, 1.3 |
| 68 | Tanaka | 1.2, 3.5 |
| 79 | Carpenter/Lawler | 0.3, 2.1, 3.1, 3.2 |
| 80 | Marcus/Siedler/Ziebarth | 3.1 |
| 91 | Evans/Harris/Kessler | 0.1 |
| 125 | Levine et al. | 1.1 |
| 133 | Hoynes | 0.3, 1.2 |
| 147 | Greenstone | 1.3 |
| 210 | Li | 1.1 |
| 234 | Myers | 1.1, 1.3 |
| 241 | Lawler | 0.1, 0.2 |
| 253 | Bancalari | 1.3, 1.4 |
| 262 | Anderson/Charles/Rees | 1.4 |
| 271 | Slusky | 0.1, 0.2 |
| 281 | Steffens/Pereda | 1.1, 1.3 |
| 305 | Sood | 4.5 |
| 338 | Cotti/Nesson/Tefft | 4.5 |
| 347 | Courtemanche | 1.2 |
| 359 | Fletcher/Frisvold/Tefft | 4.5 |
| 380 | Kuziemko/Meckel/Rossin-Slater | 1.1 |
| 437 | Hausman | 1.1 |
