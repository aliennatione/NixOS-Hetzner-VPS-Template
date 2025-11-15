# Diario di Sviluppo - Progetto NixOS Hetzner VPS

Questo documento traccia la cronologia delle decisioni e delle attività di sviluppo per il progetto, fornendo un contesto più ampio rispetto ai singoli messaggi di commit di Git.

... (contenuto precedente omesso per brevità) ...

**Risultato:** Con il profilo `minimal` in posizione, il `flake.nix` può ora esporre una configurazione NixOS funzionante e installabile (`nixosConfigurations.hetzner-minimal`) che rappresenta la base di partenza più semplice possibile per un server Hetzner. Questo completa il primo livello funzionale del sistema.

## Fase 7: Partizionamento Dichiarativo con Disko

**Obiettivo:** Definire uno schema di partizionamento del disco riproducibile e dichiarativo per i server Hetzner Cloud utilizzando la libreria `disko`.

**Contesto:** La gestione manuale delle partizioni è un processo prono a errori e non allineato con i principi di IaC (Infrastructure as Code). `disko` è uno strumento per NixOS che permette di definire layout di dischi in modo dichiarativo, integrandoli direttamente nella configurazione di sistema.

**Implementazione Tecnica:**

*   È stato creato il file `modules/disko/disko.nix` per ospitare la configurazione.
*   La configurazione si rivolge al disco primario tipico delle VM Hetzner Cloud, identificato come `/dev/sda`.
*   È stato definito un layout GPT (GUID Partition Table) standard con due partizioni:
    1.  **Partizione di Boot (`/boot`):**
        *   Dimensione: `512M`.
        *   Tipo: `EF00` (EFI System Partition).
        *   Filesystem: `vfat`, montata in `/boot`.
        *   Scopo: Necessaria per l'avvio su sistemi basati su UEFI.
    2.  **Partizione di Root (`/`):**
        *   Dimensione: `100%` (utilizza tutto lo spazio rimanente sul disco).
        *   Filesystem: `ext4`, montata in `/`.
        *   Scopo: Contiene il sistema operativo NixOS e tutti i dati dell'utente.

**Integrazione:**

*   Il modulo `disko.nix` è stato importato direttamente nel `core.nix`. Questo garantisce che qualsiasi profilo che erediti da `core.nix` includerà automaticamente questa configurazione di partizionamento.
*   L'utente può ora installare NixOS su un nuovo server Hetzner eseguendo un singolo comando che utilizza `disko` per preparare i dischi prima dell'installazione, rendendo l'intero processo di bootstrap completamente automatizzato.

**Risultato:** Il processo di installazione del sistema operativo è ora quasi completamente automatizzato. La configurazione del disco, un passaggio critico e complesso, è stata codificata in modo dichiarativo, aumentando l'affidabilità e la riproducibilità del setup iniziale del server.
