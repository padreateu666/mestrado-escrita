# CLAUDE.md — Contexto: Revisão Bibliográfica da Dissertação de Mestrado

> Coloque este arquivo na raiz do projeto LaTeX. O Claude Code o lê automaticamente
> no início de cada sessão. Ele resume decisões já tomadas em conversa anterior
> (claude.ai, jul/2026).

## Quem sou e o que é o projeto

Mestrando em Engenharia Mecânica (Brasil). Dissertação sobre um
método híbrido de simulação de escoamentos com filme fino de parede.
Este repositório contém a dissertação em LaTeX. Idioma da dissertação: português.
Preferência de estilo: sem travessões (em dashes); texto denso, mecanístico,
citável; sem tom motivacional.

## O método (resumo preciso — usar esta descrição, não inventar variações)

- Problema: simular escoamento com filme fino de parede é caro com bifásico
  direto (VOF) pela disparidade de escalas filme × duto; modelos reduzidos
  (teoria da lubrificação / EWF comercial) são baratos mas imprecisos.
- Proposta: método zonal/híbrido que se posiciona ENTRE os dois polos.
- Arquitetura: aproveita a hierarquia de níveis do multigrid (código do
  laboratório) para acoplar DUAS simulações:
  - Core flow: single-phase, resolvido nos níveis inferiores com o solver
    clássico e V-cycle normal. O core NÃO enxerga o filme diretamente.
  - Filme: resolvido com VOF nos níveis mais finos (sub-hierarquia desacoplada
    do V-cycle, com níveis intermediários de interpolação). O refino não cobre
    o domínio todo, apenas a banda parede-filme-coreflow.
- Acoplamento bidirecional e FRACO (explícito): core→filme por interpolação de
  condições de contorno dos níveis inferiores; filme→core por condição de
  contorno na parede (o core "sente" o filme via BC de parede).
- Passos de tempo distintos para filme e core (sub-ciclagem / multi-rate),
  para economizar CPU. Acoplamento forte foi descartado: a precisão obtida
  não justifica o custo.
- Status: funcionando em 2D cartesiano bifásico; validado contra VOF puro e
  solução analítica; estudo comparativo de várias BCs de parede já feito.
- AMR existe no código mas NÃO está em uso no método atual. Immersed boundary.


## Estrutura da revisão (5 seções — JÁ DECIDIDA)

Metodologia, resultados etc. ficam FORA da revisão. O esquema específico do
método, implementação do multigrid, setup do estudo de BCs, casos de validação
e solução analítica vão para o capítulo de Metodologia.

1. **O problema: escoamento com filme fino e o desafio multiescala** 
   - Escopo DELIMITADO PELO PROBLEMA, não pela palavra-chave "thin film":
    Me refiro aos escoamentos com diferenças de escala entre o filme e o domínio, sendo exemplos clássicos disto os citados nos artigos seminais. Não me refiro a colóides, espumas, filmes de surfactante, filmes de evaporação, filmes de microfluídica etc. (fora do escopo). A revisão deve ser centrada no problema físico e na dificuldade numérica de resolvê-lo.
2. **Captura de interface — polo de alta fidelidade (VOF)** 
   - VOF como foco; menção breve a Level Set; problema do filme subgrid.
3. **Modelos reduzidos de filme — polo barato (lubrificação/EWF)** 
   - Reynolds → lubrificação → wall-film/EWF com acoplamento por termo-fonte;
     hipóteses limitantes.
4. **Abordagens híbridas, zonais e multiescala**
   - Linhagem multiescala Tryggvason (filme reduzido via BC de parede) +
     família zonal/multifield/all-regime. É onde o método se posiciona.
5. **Acoplamento entre modelos e condições de contorno** 
   - Fraco vs. forte, DD heterogênea, multi-rate; BC de parede como mecanismo.
   - Fundamenta as 3 escolhas: acoplamento fraco, multi-rate, comunicação por BC.


## Referências já verificadas (com DOI — NUNCA inventar referência nova;
## toda referência adicional deve ser verificada via busca antes de citar)

Seminais / revisões de física do filme (Seção 1):
- Oron, Davis & Bankoff (1997), Rev. Mod. Phys. 69:931 — 10.1103/RevModPhys.69.931
- Craster & Matar (2009), Rev. Mod. Phys. 81:1131 — 10.1103/RevModPhys.81.1131
  (Nessa sub-área, essas duas RMP seguem sendo o padrão; não há substituta recente.)

Aplicação anular / multiescala (Seção 1):
- "Dynamics of gas–liquid annular flow: from wall-film instability to
  fragmentation", J. Fluid Mech. (2025)
- "Thin liquid film method for analyzing gas–liquid annular flow in
  nonstraight pipe components", Nucl. Eng. Des. (2024)
- Wang et al. (2025), Phys. Fluids 37:071302 — 10.1063/5.0275856 (survey
  multiescala; contexto de metais líquidos, útil pelo panorama de métodos)

VOF e filme subgrid (Seção 2):
- Hirt & Nichols (1981) — seminal do VOF
- Han & Desjardins (2024) — filme subgrid em VOF — arXiv:2405.12441
- Reconstrução de dois planos p/ estruturas finas (2024) — arXiv:2403.10729

Lubrificação / wall-film (Seção 3):
- Reynolds (1886) — seminal da lubrificação
- O'Rourke & Amsden; Bai & Gosman (wall-film) — DOIs AINDA NÃO CONFIRMADOS,
  verificar antes de citar.

Híbridos/zonais/multiescala (Seção 4):
- Thomas, Esmaeeli & Tryggvason (2010), Int. J. Multiphase Flow 36(1):71–77 —
  ANCESTRAL DIRETO do método (filme reduzido → BC de parede; front-tracking).
  Diferença central: eles usam modelo semi-analítico p/ o filme; aqui o filme
  é RESOLVIDO com VOF em banda refinada.
- Aboulhasanzadeh et al. (2013), Chem. Eng. Sci. 101:165–174 —
  10.1016/j.ces.2013.06.020 (embedded analytical description)
- Panda et al. (2020), Chem. Eng. Sci. 227:115900 — 10.1016/j.ces.2020.115900
  (múltiplas resoluções p/ camada-limite em interfaces)
- Família zonal/multifield a puxar DOIs: Černe & Tiselj; Yan & Che;
  Hänsch/Lucas (multifield all-morphologies); AIAD/Höhne; zonal grid method.
  DOIs NÃO CONFIRMADOS — verificar antes de citar.
- Theodorakakos & Bergeles (2004), Int. J. Numer. Methods Fluids — AMR na
  interface VOF (citar como componente, não como rival)
- Lee, Thompson & Gaskell (2007), Computers & Fluids 36(5):838–855 —
  10.1016/j.compfluid.2006.08.006 (multigrid adaptativo p/ filme fino;
  ATENÇÃO: volume 36, não 37)
- Linhagem Gerris/Basilisk (Popinet) — octree = AMR = multigrid; conferir
  anos exatos (2003, 2009) antes de citar.

Acoplamento / DD heterogênea (Seção 5):
- Seus et al. (2023), Numer. Methods Partial Differ. Equ. — 10.1002/num.22906
  (modelagem bifásica híbrida via decomposição de domínio; a abstração geral
  da qual o método é instância)
- Linhagem DD heterogênea de FSI — dá lastro ao acoplamento fraco + passos de
  tempo distintos.


## Estado atual e próximos passos

- [x] Estrutura das 5 seções definida
- [x] Referências-âncora identificadas (DOIs acima)
- [x] Seção 1: seminais encontrados pelo usuário de forma independente
      (Oron; Craster & Matar) — método de busca validado
- [ ] Seção 1: podar fora-de-escopo dos achados; rodar busca específica da
      aplicação (gas-liquid annular flow liquid film; liquid film core flow
      pipe); escrever
- [ ] Seções 2–5: revisar e escrever, nesta ordem de prioridade de
      profundidade: 4 > 5 > 2 ≈ 3
- [ ] Confirmar DOIs pendentes (wall-film: O'Rourke & Amsden, Bai & Gosman;
      família multifield: Černe & Tiselj, Yan & Che, Hänsch, AIAD, zonal grid
      method; Popinet/Gerris)

## Regras para o Claude Code neste projeto

1. NUNCA inventar referência, DOI, ano ou nome de autor. Se não estiver na
   lista acima ou verificado em busca na sessão, marcar como [VERIFICAR].
2. Não reintroduzir literatura coloidal/espuma na Seção 1.
3. Texto em português, sem travessões, denso e mecanístico.
4. O código do solver pode estar neste workspace ou em repositório separado
   (org petrobrasbr) — se a tarefa envolver o código, pedir o caminho antes
   de assumir.
5. Ao escrever LaTeX, manter as citações em BibTeX; criar/atualizar o .bib
   com as referências confirmadas acima.
