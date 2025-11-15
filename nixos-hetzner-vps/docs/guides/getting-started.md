# Getting Started

Questa guida ti accompagnerà nel processo di deploy del tuo primo server NixOS su Hetzner Cloud utilizzando questo template.

## 1. Create a New Repository from this Template

- Clicca sul pulsante **"Use this template"** in cima alla pagina di GitHub.
- Assegna un nome al tuo nuovo repository e clicca su **"Create repository from template"**.

## 2. Clone Your New Repository

Clona il repository appena creato sulla tua macchina locale:

```bash
git clone https://github.com/{{ Owner }}/{{ Repository Name }}.git
cd {{ Repository Name }}
```

## 3. Create a Hetzner Cloud Server

1.  Accedi alla tua [console Hetzner Cloud](https://console.hetzner.cloud/).
2.  Crea un nuovo progetto, se non ne hai già uno.
3.  All'interno del progetto, clicca su **"Add Server"**.
4.  Scegli una location.
5.  Come **Image**, seleziona **Debian 12**.
6.  Come **Type**, scegli un'istanza (es. `CPX11` o `CX11` sono ottimi per iniziare).
7.  Aggiungi la tua chiave SSH. **Questo è fondamentale.**
8.  Assegna un nome al server (es. `nixos-server1`).
9.  Crea il server.

## 4. Enter Rescue Mode

Per installare NixOS, dobbiamo prima avviare il server in modalità di ripristino.

1.  Seleziona il server appena creato.
2.  Vai alla sezione **"Rescue"**.
3.  Seleziona **"Linux 64bit"** e monta la tua chiave SSH.
4.  Clicca su **"Enable Rescue"**. Sarà visualizzata una password di root. Copiala.
5.  Ora vai alla sezione **"Power"** e clicca su **"Power Cycle"** per riavviare il server in modalità rescue.

## 5. Install NixOS

Connettiti al server in modalità rescue via SSH (l'utente è `root`):

```bash
ssh root@<YOUR_SERVER_IP>
```

Una volta dentro, esegui il seguente comando. Questo installerà NixOS sul server utilizzando il profilo `hetzner-webserver` definito nel tuo flake.

```bash
nix --extra-experimental-features "nix-command flakes" run github:nix-community/nixos-anywhere -- \
  --flake github:{{ Owner }}/{{ Repository Name }}#hetzner-webserver \
  root@<YOUR_SERVER_IP>
```

> **Nota:** Il comando `nixos-anywhere` si occuperà di tutto: partizionamento del disco (tramite `disko`), installazione di NixOS e configurazione dell'utente e di SSH.

## 6. Reboot and Connect

Una volta completata l'installazione, esci dalla sessione SSH di rescue e riavvia il server dalla console di Hetzner (oppure digita `reboot` nel terminale di rescue).

Attendi qualche minuto, quindi connettiti al tuo nuovo server NixOS con l'utente configurato (di default `bmad`):

```bash
ssh bmad@<YOUR_SERVER_IP>
```

**Congratulazioni! Hai deployato con successo il tuo primo server NixOS dichiarativo!**
