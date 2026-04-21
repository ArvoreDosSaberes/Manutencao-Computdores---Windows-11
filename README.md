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
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:0f172a,50:1a56db,100:10b981&height=220&section=header&text=Windows%2011&fontSize=42&fontColor=ffffff&animation=fadeIn&fontAlignY=35&desc=Manuten%C3%A7%C3%A3o%20de%20Computadores&descSize=18&descAlignY=55&descColor=94a3b8" width="100%" alt="Windows 11 Header"/>
</p>

## Visão Geral

Este repositório contém três ferramentas em PowerShell para diagnosticar lentidão no Windows 11, aplicar otimizações práticas e remover recursos de IA introduzidos nas versões mais recentes do sistema.

## Ferramentas Disponíveis

### `diagnostico-windows11.ps1`

Gera um relatório textual com informações úteis para análise de desempenho.

O script coleta:

- **Resumo do sistema**
  - Nome do computador
  - Versão do Windows
  - Build
  - Tempo ligado
  - RAM total e livre

- **Espaço em disco**
  - Tamanho total
  - Espaço livre
  - Percentual livre

- **Processos mais pesados**
  - Top por CPU
  - Top por memória

- **Itens de inicialização automática**
  - Aplicativos configurados para iniciar com o Windows

- **Serviços e processos relevantes**
  - Serviços em execução
  - Aplicativos comuns de fundo
  - Itens relacionados a IA, Widgets, Teams, Xbox e similares

### `otimizacao-windows11.ps1`

Aplica ações de redução de carga no sistema para melhorar a responsividade do Windows 11.

O script pode:

- **Encerrar processos em segundo plano**
  - `WidgetBoard`
  - `WidgetService`
  - `ms-teams`
  - `AnyDesk`
  - `SyncTrayzor`
  - `syncthing`
  - `OneDrive`
  - `OpenVPNConnect`
  - `Discord`

- **Desativar inicialização automática**
  - Entradas no Registro
  - Atalhos nas pastas de inicialização

- **Ajustar serviços opcionais**
  - Serviços do OpenVPN identificados no sistema

- **Remover componentes opcionais do Windows**
  - `MicrosoftWindows.Client.WebExperience`
  - `Microsoft.WidgetsPlatformRuntime`
  - `MSTeams`
  - `Microsoft.YourPhone`
  - componentes `Xbox`

- **Desativar tarefas agendadas relacionadas a Widgets/Feeds**

### `RemoveWindowsAi.ps1`

Remove, desativa e oculta componentes de IA do Windows 11, com suporte a execução interativa e não interativa.

O script pode:

- **Desativar chaves de Registro e políticas**
  - Copilot
  - Recall
  - Rewrite do Notepad
  - integrações de IA em Edge, Paint e componentes relacionados

- **Remover pacotes Appx e componentes protegidos**
  - pacotes `Copilot`
  - componentes `CoreAI`
  - `WindowsWorkload.*`
  - tarefas e artefatos relacionados ao Recall

- **Instalar apps clássicos opcionais**
  - `photoviewer`
  - `mspaint`
  - `snippingtool`
  - `notepad`
  - `photoslegacy`

- **Manter limpeza após updates**
  - usa `RemoveAI-UpdateCleanup.ps1`
  - consome `RemoveWindowsAIPackage/`
  - utiliza `ClassicApps/` quando disponível localmente

## Pré-Requisitos

Antes de usar os scripts, verifique os seguintes pontos:

- **PowerShell disponível**
  - O Windows 11 já inclui PowerShell por padrão.
  - Para `RemoveWindowsAi.ps1`, use preferencialmente o Windows PowerShell 5.1.

- **Permissões adequadas**
  - O script de diagnóstico pode ser executado em sessão comum.
  - O script de otimização funciona melhor com PowerShell aberto como administrador.
  - O script `RemoveWindowsAi.ps1` deve ser executado como administrador.

- **Política de execução**
  - Caso necessário, execute usando `-ExecutionPolicy Bypass` apenas para a sessão do comando.

```text
.
├── diagnostico-windows11.ps1
├── Documentation.md
├── OtherAIFeatures.md
├── ClassicApps\
├── RemoveAI-UpdateCleanup.ps1
├── RemoveWindowsAi.ps1
├── RemoveWindowsAIPackage\
├── otimizacao-windows11.ps1
└── README.md
```

## Como Executar o Diagnóstico

### Passo 1: abrir o PowerShell

Abra o PowerShell na pasta do projeto.

### Passo 2: executar o script

```powershell
powershell -ExecutionPolicy Bypass -File .\diagnostico-windows11.ps1
```

### Passo 3: analisar o relatório gerado

Por padrão, o script cria o arquivo:

```text
.\relatorio-diagnostico-windows11.txt
```

### Passo 4: gerar o relatório em outro local

Você também pode informar um caminho customizado:

```powershell
powershell -ExecutionPolicy Bypass -File .\diagnostico-windows11.ps1 -ReportPath ".\saida\relatorio.txt"
```

## Como Executar a Otimização

### Execução padrão

Para aplicar a otimização completa:

```powershell
powershell -ExecutionPolicy Bypass -File .\otimizacao-windows11.ps1
```

### O que acontece nessa execução

- **Processos são encerrados**
- **Inicializações automáticas são removidas**
- **Tarefas de Widgets são desativadas**
- **Pacotes opcionais são removidos**

### Reinicialização recomendada

Após executar a otimização, reinicie o Windows para aplicar totalmente as alterações.

## Parâmetros do Script de Otimização

O script aceita `switches` para controlar o comportamento.

### `-StopBackgroundApps`

Encerra aplicativos selecionados em segundo plano.

### `-DisableStartupEntries`

Remove entradas de inicialização automática no Registro e em atalhos da pasta de Startup.

### `-RemoveConsumerPackages`

Remove Widgets, Teams, Seu Telefone e componentes Xbox identificados no script.

### `-DisableWidgetsTasks`

Desativa tarefas agendadas relacionadas a Feeds e Widgets.

## Exemplos de Uso

### Executar apenas o diagnóstico

```powershell
powershell -ExecutionPolicy Bypass -File .\diagnostico-windows11.ps1
```

### Executar otimização completa

```powershell
powershell -ExecutionPolicy Bypass -File .\otimizacao-windows11.ps1
```

### Executar remoção de IA com interface

```powershell
powershell -ExecutionPolicy Bypass -File .\RemoveWindowsAi.ps1
```

### Executar remoção de IA em modo não interativo

```powershell
powershell -ExecutionPolicy Bypass -File .\RemoveWindowsAi.ps1 -nonInteractive -AllOptions
```

### Instalar apps clássicos pelo script de remoção de IA

```powershell
powershell -ExecutionPolicy Bypass -File .\RemoveWindowsAi.ps1 -nonInteractive -InstallClassicApps photoviewer,mspaint,snippingtool,notepad
```

### Executar com parâmetros explícitos

```powershell
powershell -ExecutionPolicy Bypass -File .\otimizacao-windows11.ps1 -StopBackgroundApps -DisableStartupEntries -RemoveConsumerPackages -DisableWidgetsTasks
```

## Documentação da Remoção de IA

 - **Guia técnico**
   - [`Documentation.md`](./Documentation.md)

 - **Recursos adicionais não removíveis por script**
   - [`OtherAIFeatures.md`](./OtherAIFeatures.md)

## Interpretação do Relatório

Ao abrir o arquivo de diagnóstico, dê atenção especial aos seguintes blocos:

- **Top processos por CPU**
  - Identifica programas consumindo processamento por tempo acumulado.

- **Top processos por memória**
  - Mostra quais aplicativos ocupam mais RAM.

- **Inicialização automática**
  - Ajuda a localizar programas que deixam o boot mais lento.

- **Processos de background relevantes**
  - Destaca software de sincronização, acesso remoto, widgets e integrações extras.

- **Pacotes Appx consumer e extras**
  - Mostra componentes opcionais do Windows que podem ser removidos.

## Cuidados Antes de Otimizar

- **Verifique o impacto no seu fluxo**
  - `AnyDesk`, `OneDrive`, `OpenVPN` e `SyncTrayzor` podem ser necessários no seu uso diário.

- **Evite executar durante trabalho remoto ativo**
  - Encerrar `AnyDesk` ou VPN pode interromper conexões em andamento.

- **Use conta com privilégios adequados**
  - Remoção de pacotes e alteração de serviços pode exigir privilégios administrativos.

- **Faça primeiro o diagnóstico**
  - O fluxo recomendado é diagnosticar, revisar e só depois otimizar.

## Fluxo Recomendado de Uso

1. Execute `diagnostico-windows11.ps1`.
2. Revise o relatório gerado.
3. Identifique softwares realmente desnecessários no seu cenário.
4. Execute `otimizacao-windows11.ps1`.
5. Reinicie o computador.
6. Gere novo relatório para comparar o antes e depois.

## Solução de Problemas

### O script não executa

Use:

```powershell
powershell -ExecutionPolicy Bypass -File .\diagnostico-windows11.ps1
```

ou:

```powershell
powershell -ExecutionPolicy Bypass -File .\otimizacao-windows11.ps1
```

### O relatório não aparece

 - **Verifique a pasta atual**
   - O relatório é salvo no diretório de execução, salvo quando `-ReportPath` for informado.

### Nem tudo foi removido

 - **Alguns componentes dependem de privilégio elevado**
   - Reexecute o PowerShell como administrador.

### O computador continua lento

 - **Revise processos do IDE, sincronização e antivírus**
   - Em muitos cenários, a lentidão está em aplicações abertas e não no Windows em si.

## Melhorias Futuras Sugeridas

- **Adicionar exportação em CSV ou JSON**
- **Criar ponto de restauração antes da otimização**
- **Separar modos leve e agressivo de limpeza**
- **Registrar logs detalhados por etapa**

<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=0:10b981,50:1a56db,100:0f172a&height=120&section=footer" width="100%" alt="Footer"/>
</p>

---
 
**Resumo:** Guia principal em português para uso dos scripts de diagnóstico, otimização e remoção de recursos de IA no Windows 11 presentes neste repositório.
**Data de Criação:** 2026-04-21
**Autor:** Rapport GenerAtiva
**Versão:** 1.2
**Última Atualização:** 2026-04-21
**Atualizado por:** Rapport GenerAtiva
**Histórico de Alterações:**
- 2026-04-21 - Criado por Rapport GenerAtiva - Versão 1.0
- 2026-04-21 - Atualizado por Rapport GenerAtiva - Adicionado tutorial completo de uso das ferramentas PowerShell - Versão 1.0
- 2026-04-21 - Atualizado por Rapport GenerAtiva - Ajustado o header para o projeto Windows 11 com subtítulo Manutenção de Computadores - Versão 1.1
- 2026-04-21 - Atualizado por Rapport GenerAtiva - Integrada a ferramenta RemoveWindowsAi na documentação principal e na estrutura do repositório - Versão 1.2
