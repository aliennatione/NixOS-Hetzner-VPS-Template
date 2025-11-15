# Diario di Sviluppo - Progetto NixOS Hetzner VPS

Questo documento traccia la cronologia delle decisioni e delle attività di sviluppo per il progetto, fornendo un contesto più ampio rispetto ai singoli messaggi di commit di Git.

... (contenuto precedente omesso per brevità) ...

**Risultato:** Il processo di installazione del sistema operativo è ora quasi completamente automatizzato. La configurazione del disco, un passaggio critico e complesso, è stata codificata in modo dichiarativo, aumentando l'affidabilità e la riproducibilità del setup iniziale del server.

## Fase 8: Creazione del Profilo `webserver.nix`

**Obiettivo:** Creare un profilo specializzato per un server web, basato sul profilo `minimal` e includendo Nginx con le relative configurazioni di firewall.

**Logica di Composizione:**

Questo profilo dimostra la potenza della composizione nell'architettura NixOS del progetto:

1.  **Importazione di `minimal.nix`:** Il profilo `webserver.nix` importa `profiles/minimal.nix`.
2.  **Ereditarietà Implicita:** Importando `minimal.nix`, eredita transitivamente tutte le configurazioni definite in `modules/nixos/core.nix`, tra cui:
    *   Configurazione di base del sistema (utenti, SSH, localizzazione).
    *   Firewall con porta 22 aperta.
    *   Configurazione del partizionamento del disco tramite `disko`.

**Funzionalità Aggiunte:**

Partendo da questa solida base, il profilo `webserver` aggiunge due elementi specifici:

1.  **Abilitazione del Servizio Nginx:** La riga `services.nginx.enable = true;` attiva e configura il demone Nginx, pronto a servire contenuti web.
2.  **Configurazione del Firewall:** Vengono aperte le porte standard per il traffico web:
    *   Porta `80` (HTTP).
    *   Porta `443` (HTTPS).
    *   NixOS gestisce in modo intelligente l'unione di queste porte con la porta `22` (SSH) già definita in `core.nix`, risultando in un set di regole del firewall finale che permette il traffico su `[22, 80, 443]`.

**Risultato:**

È stato creato un profilo riutilizzabile e specifico per lo scopo. Un utente può ora deployare un server web semplicemente selezionando il profilo `webserver` nel proprio `flake.nix`. Questo astrae tutta la complessità della configurazione di base, del partizionamento e delle regole del firewall, permettendo all'utente di concentrarsi sulla configurazione specifica della propria applicazione web all'interno di Nginx.
