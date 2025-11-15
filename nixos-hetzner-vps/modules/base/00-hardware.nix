# Hardware detection and configuration
# This module is completely self-contained and can be used independently
{ config, lib, pkgs, ... }:

let
  # Hardware detection logic
  detectHardware = {
    # Hetzner-specific hardware detection
    hetzner = {
      isHetzner = lib.mkDefault (
        (builtins.tryEval (builtins.readFile "/sys/class/dmi/id/sys_vendor")).value or ""
      ).contains "Hetzner";

      # Detect server generation (AMD vs Intel)
      isAMD = lib.mkDefault (
        (builtins.tryEval (builtins.readFile "/proc/cpuinfo")).value or ""
      ).contains "AMD";

      # Detect storage type
      storageType = lib.mkDefault (
        if (lib.strings.hasInfix "nvme" (builtins.toString config.boot.initrd.availableKernelModules))
        then "nvme"
        else "sata"
      );
    };
  };

  # Performance optimizations based on hardware
  hardwareOptimizations = {
    kernelParams = lib.mkIf detectHardware.hetzner.isHetzner [
      "mitigations=off"           # Disable security mitigations for performance
      "intel_idle.max_cstate=1"   # Reduce CPU idle states for latency
      "processor.max_cstate=1"
    ] ++ lib.optionals detectHardware.hetzner.isAMD [
      "amd_pstate=passive"        # AMD power management
    ];

    # I/O scheduler optimizations
    ioScheduler = lib.mkIf (detectHardware.hetzner.storageType == "nvme") "none"
      (lib.mkIf (detectHardware.hetzner.storageType == "sata") "mq-deadline" "cfq");
  };

in {
  # This module can be imported anywhere without dependencies
  options.hardware = {
    enable = lib.mkEnableOption "Hardware detection and optimization";
    hetzner = {
      enable = lib.mkEnableOption "Hetzner-specific optimizations";
      generation = lib.mkOption {
        type = lib.types.enum [ "amd" "intel" "unknown" ];
        default = if detectHardware.hetzner.isAMD then "amd" else "intel";
        description = "Hetzner server generation";
      };
      storage = {
        type = lib.mkOption {
          type = lib.types.enum [ "nvme" "sata" "unknown" ];
          default = detectHardware.hetzner.storageType;
          description = "Storage type detection";
        };
        scheduler = lib.mkOption {
          type = lib.types.str;
          default = hardwareOptimizations.ioScheduler;
          description = "I/O scheduler for optimal performance";
        };
      };
    };
  };

  config = lib.mkIf config.hardware.enable {
    # Hardware-agnostic optimizations
    boot.kernelParams = hardwareOptimizations.kernelParams;

    # Hardware-specific optimizations
    boot.kernel.sysctl = lib.mkIf config.hardware.hetzner.enable {
      "vm.swappiness" = 10;
      "vm.dirty_ratio" = 15;
      "vm.dirty_background_ratio" = 5;
      "kernel.sched_migration_cost_ns" = 5000000;
    };

    # Device-specific configurations
    services.udev.extraRules = ''
      # Optimize NVMe devices
      KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="${hardwareOptimizations.ioScheduler}"
      KERNEL=="sd[a-z]", ATTR{queue/scheduler}="${hardwareOptimizations.ioScheduler}"
    '';

    # Documentation for users
    assertions = [
      {
        assertion = config.hardware.hetzner.enable -> detectHardware.hetzner.isHetzner;
        message = "Hetzner-specific optimizations enabled on non-Hetzner hardware. This may cause issues.";
      }
    ];

    # Self-documentation
    documentation = {
      description = ''
        Hardware detection and optimization module.

        Features:
        - Automatic hardware detection (Hetzner, AMD/Intel, NVMe/SATA)
        - Performance optimizations based on detected hardware
        - Security mitigations tuning for cloud environments
        - I/O scheduler optimization

        Usage:
        ```nix
        { config, pkgs, ... }: {
          hardware.enable = true;
          hardware.hetzner.enable = true;
        }
        ```
      '';
      examples = {
        "hetzner-amd" = {
          hardware.enable = true;
          hardware.hetzner = {
            enable = true;
            generation = "amd";
            storage.type = "nvme";
          };
        };
      };
    };
  };
}