# Architecture Overview

Questo template adotta un'architettura a strati, progettata per la massima componibilità e manutenibilità. I componenti principali sono:

1.  **Flake (`flake.nix`)**: Il punto di ingresso del progetto.
2.  **Profiles**: Unità di configurazione impilabili.
3.  **Modules**: Configurazioni atomiche riutilizzabili.
4.  **Disko**: Configurazione dichiarativa del partizionamento del disco.

---

## 1. The Flake (`flake.nix`)

Il `flake.nix` è il cuore del sistema. Le sue responsabilità principali sono:

*   **Input Management**: Definisce tutte le dipendenze esterne del progetto, come `nixpkgs`, `nixos-hardware`, `disko`, ecc. Questo garantisce la riproducibilità, bloccando le versioni di ogni dipendenza nel file `flake.lock`.
*   **Output Definition**: Espone gli output principali del progetto, tra cui:
    *   `nixosConfigurations`: Le configurazioni complete del sistema operativo che possono essere deployate. Ogni configurazione è una combinazione di un profilo di base e moduli aggiuntivi.
    *   `devShells`: L'ambiente di sviluppo, che include tutti i pacchetti necessari per lavorare su questo progetto (es. `nixpkgs-fmt`, `statix`, ecc.).

```nix
# flake.nix (simplified)
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    # ... altre dipendenze
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      # Configurazione 1: Solo il minimo indispensabile
      hetzner-minimal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # Passa gli input ai moduli
        modules = [
          ./profiles/minimal.nix # Profilo di base
          inputs.disko.nixosModules.disko # Modulo per il partizionamento
          ./modules/hetzner/disko-config.nix # Config specifica per Disko
        ];
      };

      # Configurazione 2: Base + Webserver
      hetzner-webserver = nixpkgs.lib.nixosSystem {
        # ...
        modules = [
          ./profiles/webserver.nix # Profilo che include "minimal" e aggiunge Nginx
          # ... altri moduli
        ];
      };
    };
  };
}
```

---

## 2. Profiles

I profili sono il componente chiave dell'architettura componibile. Un profilo è semplicemente un modulo Nix che raggruppa altri moduli e configurazioni per definire una funzionalità di alto livello.

*   **Localizzazione**: `profiles/`
*   **Esempio**: `profiles/webserver.nix`

```nix
# profiles/webserver.nix
{
  imports = [
    ./minimal.nix # Importa e applica prima il profilo di base
    ../modules/networking/nginx.nix # Aggiunge il modulo Nginx
  ];

  # Aggiunge opzioni di configurazione specifiche per questo profilo
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
```

Questo approccio permette di "impilare" le configurazioni:

- `hetzner-minimal` usa `profiles/minimal.nix`.
- `hetzner-webserver` usa `profiles/webserver.nix`, che a sua volta include `profiles/minimal.nix`, ereditandone tutte le impostazioni.

---

## 3. Modules

I moduli contengono la configurazione effettiva per un singolo servizio o una singola funzionalità (es. Nginx, SSH, un utente specifico).

*   **Localizzazione**: `modules/`
*   **Esempio**: `modules/networking/nginx.nix`

```nix
# modules/networking/nginx.nix
{
  # Abilita il servizio Nginx
  services.nginx = {
    enable = true;
    # ... altre configurazioni di Nginx
  };
}
```

Separare i moduli in questo modo li rende **atomici e riutilizzabili** in diversi profili o configurazioni.

---

## 4. Disko

Il partizionamento del disco è un'operazione notoriamente manuale e soggetta a errori. `disko` risolve questo problema permettendo di definirlo in modo dichiarativo.

*   **Localizzazione**: `modules/hetzner/disko-config.nix`

Questo file definisce il layout del disco che `nixos-anywhere` applicherà prima dell'installazione.

```nix
# modules/hetzner/disko-config.nix
{
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = "/dev/sda"; # o vda, a seconda dell'hypervisor di Hetzner
        content = {
          type = "gpt";
          partitions = {
            # ... definizione di partizioni ESP, root, ecc.
          };
        };
      };
    };
  };
}
```

L'integrazione tra `disko` e `nixos-anywhere` è ciò che permette una vera installazione "zero-touch" del sistema operativo.
