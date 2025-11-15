# About the Project

## Project Philosophy

L'obiettivo di questo template è semplice: rendere il deploy di un server VPS un'operazione **prevedibile, dichiarativa e componibile**.

*   **Dichiarativo:** La configurazione del server è interamente definita come codice. Nessun passo manuale, nessuna "configuration drift". Lo stato del server rispecchia esattamente ciò che è definito nel repository Git.

*   **Componibile:** Invece di un'unica configurazione monolitica, il sistema è costruito su **profili** impilabili. Si parte da un sistema `minimal` e si aggiungono solo le funzionalità necessarie (es. `webserver`). Questo approccio favorisce il riutilizzo e la manutenibilità.

*   **Riproducibile:** Grazie a Nix e ai Flakes, lo stesso `flake.nix` produrrà **esattamente lo stesso ambiente software**, con le stesse versioni dei pacchetti e delle dipendenze, oggi o tra un anno. Questo elimina la sindrome del "funziona sulla mia macchina".

## Why NixOS on Hetzner?

*   **Hetzner Cloud** offre un eccellente rapporto prezzo/prestazioni per i server VPS.
*   **NixOS** è il sistema operativo dichiarativo per eccellenza, che porta la riproducibilità a livello di intero sistema operativo.

La combinazione di questi due elementi permette di creare infrastrutture cloud potenti, economiche e, soprattutto, manutenibili nel tempo con uno sforzo minimo.
