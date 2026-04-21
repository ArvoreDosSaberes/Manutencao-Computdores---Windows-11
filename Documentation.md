![visitors](https://visitor-badge.laobi.icu/badge?page_id=ArvoreDosSaberes.Manutencao-Computdores---Windows-11)
[![License: CC BY-SA 4.0](https://img.shields.io/badge/License-CC_BY--SA_4.0-blue.svg)](https://creativecommons.org/licenses/by-sa/4.0/)
![Language: Portuguese](https://img.shields.io/badge/Language-Portuguese-brightgreen.svg)
![Python](https://img.shields.io/badge/Python-3.8%2B-blue)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-orange)
![Machine Learning](https://img.shields.io/badge/Machine%20Learning-Prática-green)
![Status](https://img.shields.io/badge/Status-Educa%C3%A7%C3%A3o-brightgreen)
![Repository Size](https://img.shields.io/github/repo-size/ArvoreDosSaberes/Manutencao-Computdores---Windows-11)
![Last Commit](https://img.shields.io/github/last-commit/ArvoreDosSaberes/Manutencao-Computdores---Windows-11)

<!-- Animated Header -->
<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:0f172a,50:1a56db,100:10b981&height=220&section=header&text=RISC-V%20Resilience&fontSize=42&fontColor=ffffff&animation=fadeIn&fontAlignY=35&desc=Pesquisa%20em%20Resili%C3%AAncia%20de%20Processadores%20RISC-V&descSize=18&descAlignY=55&descColor=94a3b8" width="100%" alt="RISC-V Resilience Header"/>
</p>

## Documentação Técnica do `RemoveWindowsAi.ps1`

## Suporte de Sistema

- **Versões suportadas**
  - O script foi projetado para Windows 10 e Windows 11 em builds estáveis recentes.

- **Edições recomendadas**
  - Os melhores resultados tendem a ocorrer em edições Pro, Enterprise, Education e Server.
  - Em edições Home, parte das remoções pode não ser completa.

- **Observação sobre Insider**
  - O script pode executar em builds Insider, mas novos componentes de IA introduzidos ali podem não estar cobertos até chegarem ao canal estável.

## Visão Técnica da Implementação

- **Objetivo**
  - O script usa técnicas avançadas em PowerShell para desativar, remover e evitar reinstalação de recursos de IA integrados ao Windows.

### Função `Run-Trusted`

- **Finalidade**
  - Executa comandos com privilégios elevados ligados ao `TrustedInstaller`, também conhecido como `Windows Module Installer`.

- **Uso prático**
  - Permite manipular arquivos, chaves e pacotes que normalmente ficam bloqueados por privilégios de sistema.

### Chaves de Registro e Políticas

- **Cobertura**
  - O script reúne chaves de desativação relacionadas a Copilot, Recall, Edge, Paint, Notepad e integrações correlatas.

- **Efeito esperado**
  - Algumas alterações são aplicadas via políticas, então certos painéis podem mostrar a mensagem `Some settings are managed by your organization`.

### Prevenção de Reinstalação de Pacotes de IA

- **Estratégia**
  - Instala um pacote de atualização customizado para sinalizar ao Windows que uma versão superior do componente já está presente.

- **Referência técnica**
  - A abordagem é inspirada em métodos usados por projetos como Atlas e ReviOS.

### Desativação no `IntegratedServicesRegionPolicySet`

- **Como funciona**
  - O script localiza políticas relacionadas a Copilot em `IntegratedServicesRegionPolicySet.json` e altera o estado padrão para desabilitado.

- **Contexto**
  - Esse arquivo também influencia disponibilidade regional, especialmente em cenários do EEA.

### Remoção de Pacotes Appx

- **Motivação**
  - Nem todos os pacotes podem ser removidos com `Remove-AppxPackage`, porque muitos são marcados como `Non-Removable`.

- **Técnicas utilizadas**
  - O script cria subprocessos temporários em `%TEMP%` e usa múltiplas abordagens:
    - `EndOfLife`
    - `Deprovisioned`
    - `Set-NonRemovableAppsPolicy`
    - remoção de entradas em `InboxApplications`

- **Objetivo**
  - Forçar remoção para usuários existentes, impedir reprovisionamento e reduzir reinstalações por update.

### Recall como Recurso Opcional

- **Tratamento**
  - Quando presente como optional feature, o Recall é desabilitado e removido até o estado `DisabledWithPayloadRemoved`.

### Pacotes Ocultos em CBS

- **Escopo**
  - O script procura pacotes relacionados a IA em `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages`.

- **Método**
  - Ajusta `Visibility` e remove subchaves como `Owners` e `Updates` para expor/remover pacotes antes ocultos ao fluxo padrão do DISM.

### Remoção de Arquivos e Pastas de IA

- **Limpeza aplicada**
  - O script remove instaladores residuais, artefatos de Copilot, DLLs ligadas a machine learning e outras sobras relacionadas.

### Desativação do Rewrite no Notepad

- **Abordagem dupla**
  - O script altera configurações persistidas do app e também aplica políticas, para aumentar a chance de a funcionalidade permanecer desativada.

### Remoção de Tarefas do Recall

- **Execução**
  - Um subscript temporário é usado para remover tarefas agendadas e entradas relacionadas ao Recall com privilégios altos.

### Instalação de Apps Clássicos

- **Capacidades**
  - Permite instalar ou restaurar variantes clássicas de `notepad`, `paint`, `photo viewer`, `snipping tool` e `photos legacy`.

- **Dependências locais**
  - A pasta `ClassicApps/` é utilizada quando disponível localmente na raiz do repositório.

## Recursos Relacionados

- **Script principal**
  - [`RemoveWindowsAi.ps1`](./RemoveWindowsAi.ps1)

- **Limpeza pós-update**
  - [`RemoveAI-UpdateCleanup.ps1`](./RemoveAI-UpdateCleanup.ps1)

- **Recursos adicionais**
  - [`OtherAIFeatures.md`](./OtherAIFeatures.md)

<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:10b981,50:1a56db,100:0f172a&height=120&section=footer" width="100%" alt="Footer"/>
</p>

---
**Resumo:** Documento técnico em português que descreve a arquitetura, técnicas e escopo de remoção de IA do script `RemoveWindowsAi.ps1`.
**Data de Criação:** 2026-04-21
**Autor:** Rapport GenerAtiva
**Versão:** 1.0
**Última Atualização:** 2026-04-21
**Atualizado por:** Rapport GenerAtiva
**Histórico de Alterações:**
- 2026-04-21 - Criado por Rapport GenerAtiva - Versão 1.0
- 2026-04-21 - Atualizado por Rapport GenerAtiva - Padronizado no template markdown do projeto e adaptado para a migração à raiz - Versão 1.0
