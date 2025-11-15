# 🚀 NixOS Hetzner VPS Template

[![NixOS](https://img.shields.io/badge/NixOS-24.05-blue?logo=nixos&logoColor=white)](https://nixos.org)
[![CI](https://github.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>/actions/workflows/ci.yml/badge.svg)](https://github.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>/actions/workflows/ci.yml)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Documentation](https://img.shields.io/badge/docs-mkdocs-blue.svg)](https://<YOUR_GITHUB_USERNAME>.github.io/<YOUR_REPO_NAME>/)

**Un template di repository enterprise-grade per il deploy di server NixOS riproducibili su Hetzner Cloud, basato su un\'architettura a profili componibili.**

Questo progetto non è solo un insieme di file di configurazione, ma un framework completo progettato per portare i principi di Infrastructure as Code (IaC) e la riproducibilità di NixOS nel mondo del cloud hosting, con un focus specifico su Hetzner.

---

## ✨ Filosofia del Progetto

L\'obiettivo è semplice: rendere il deploy di un server VPS un\'operazione **prevedibile, dichiarativa e componibile**.

*   **Dichiarativo:** La configurazione del server è interamente definita come codice. Nessun passo manuale, nessuna "configuration drift".
*   **Componibile:** Invece di un monolite, il sistema è costruito su **profili** impilabili. Parti da un sistema `minimal` e aggiungi solo ciò di cui hai bisogno (es. `webserver`).
*   **Riproducibile:** Grazie a Nix e Flakes, lo stesso `flake.nix` produrrà **esattamente lo stesso ambiente software**, oggi o tra un anno.

## 🔥 Funzionalità Principali

*   **Architettura a Profili:**
    *   `minimal`: Una base sicura e ultra-leggera con solo l\'essenziale (SSH, utente, firewall).
    *   `webserver`: Estende `minimal` con Nginx e le porte firewall aperte per HTTP/HTTPS.
    *   *...facilmente estensibile con i tuoi profili!*
*   **Partizionamento Dichiarativo:** Il layout del disco è codificato tramite `disko`, eliminando la necessità di partizionamento manuale durante l\'installazione.
*   **Continuous Integration:** Un workflow di GitHub Actions è preconfigurato per verificare la formattazione e la correttezza del codice Nix ad ogni commit.
*   **Basato su Flakes:** Sfrutta la potenza dei Flakes per una gestione delle dipendenze ermetica e riproducibile.
*   **Integrazione con Hetzner Cloud:** Include i moduli hardware specifici per le VM Hetzner.
*   **Development Shell:** Fornisce una `devShell` con tutti gli strumenti necessari per lavorare sul progetto.

## 🚀 Come Iniziare

### 1. Utilizza questo Template

Clicca su "**Use this template**" in cima alla pagina di GitHub per creare un nuovo repository basato su questo modello.

### 2. Clona il tuo Repository

```bash
git clone https://github.com/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>.git
cd <YOUR_REPO_NAME>
```

### 3. Personalizza la Configurazione (Opzionale)

Apri `flake.nix` e scegli il profilo che desideri deployare. Di default, sono disponibili:

*   `nixosConfigurations.hetzner-minimal`
*   `nixosConfigurations.hetzner-webserver`

Puoi facilmente creare un nuovo profilo in `profiles/` e aggiungerlo al `flake.nix`.

### 4. Installa NixOS sul tuo Server Hetzner

Una volta creato un nuovo server (consigliato `cx11`) ed entrato nella rescue mode:

```bash
# Esegui lo script di installazione puntando al tuo repository
nix --extra-experimental-features "nix-command flakes" run github:nix-community/nixos-anywhere -- \
  --flake .#hetzner-webserver \
  root@<YOUR_SERVER_IP>
```

Questo comando farà tutto: partizionerà il disco, installerà NixOS con il profilo scelto e configurerà SSH.

---

## 📚 Documentazione

La documentazione completa, inclusi i dettagli sull\'architettura, le guide per la creazione di nuovi profili e le best practice, è disponibile [**qui**](https://<YOUR_GITHUB_USERNAME>.github.io/<YOUR_REPO_NAME>/).

## 🤝 Contributing

I contributi sono benvenuti! Consulta la documentazione per le linee guida su come contribuire al progetto.
