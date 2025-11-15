# Web server optimized profile
{ config, lib, pkgs, ... }:

{
  imports = [
    # Base system
    ../modules/base/00-hardware.nix
    ../modules/base/01-boot.nix
    ../modules/base/02-users.nix
    
    # Security
    ../modules/security/01-luks.nix
    ../modules/security/02-firewall.nix
    ../modules/security/03-ssh.nix
    
    # Storage
    ../modules/storage/01-zfs-pool.nix
    ../modules/storage/02-zfs-datasets.nix
    ../modules/storage/03-snapshots.nix
    
    # Containers
    ../modules/containers/01-podman-base.nix
    ../modules/containers/02-podman-rootless.nix
    
    # Monitoring
    ../modules/monitoring/01-prometheus.nix
    ../modules/monitoring/02-grafana.nix
    
    # Web services
    ../modules/services/web/nginx.nix
    ../modules/services/web/caddy.nix
    ../modules/services/web/acme.nix
  ];

  # Profile-specific configuration
  config = {
    # Hardware optimizations for web workloads
    hardware = {
      enable = true;
      hetzner.enable = true;
    };

    # Security configuration
    security = {
      luks.enable = true;
      luks.devices.cryptroot = {
        device = "/dev/sda2";
        # Web servers can use slightly less secure but faster settings
        cipher = "aes-xts-plain64";
        keySize = 256;
      };

      firewall.allowedTCPPorts = [ 22 80 443 ];
      ssh.enable = true;
    };

    # Storage configuration
    storage.zfs = {
      pools.rpool = {
        devices = [ "/dev/mapper/cryptroot" ];
        type = "single";
        workload = "vps";
        compression = "lz4";
      };

      datasets = {
        "rpool/www" = {
          mountpoint = "/var/www";
          quota = "10G";
        };
        
        "rpool/ssl" = {
          mountpoint = "/var/lib/acme";
          quota = "1G";
          # SSL certificates need special permissions
          extraFlags = [ "exec=off" "setuid=off" ];
        };
      };

      snapshots.enable = true;
      snapshots.policy = {
        frequent = 4;   # Every 15 minutes
        hourly = 6;     # Every 2 hours  
        daily = 7;      # Daily for a week
        weekly = 4;     # Weekly for a month
      };
    };

    # Web server configuration
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      
      # Security headers
      appendConfig = ''
        add_header X-Content-Type-Options nosniff;
        add_header X-Frame-Options SAMEORIGIN;
        add_header X-XSS-Protection "1; mode=block";
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
      '';
    };

    # ACME certificate management
    security.acme = {
      acceptTerms = true;
      defaults.email = "admin@localhost";
      defaults.enableHttpChallenge = true;
    };

    # Monitoring for web servers
    services.prometheus = {
      enable = true;
      exporters.nginx = {
        enable = true;
        port = 9113;
      };
    };

    services.grafana = {
      enable = true;
      settings.server = {
        http_port = 3000;
        domain = "localhost";
      };
    };

    # Web server specific packages
    environment.systemPackages = with pkgs; [
      nginx
      caddy
      certbot
      httpie
      siege  # Load testing
      webproc  # Process monitoring
    ];

    documentation = {
      description = ''
        Web Server Profile
        
        Optimized configuration for hosting websites and web applications.
        
        Features:
        - Nginx and Caddy web servers
        - Automatic SSL certificates (ACME/Let's Encrypt)
        - Web-optimized ZFS settings (LZ4 compression, frequent snapshots)
        - Built-in monitoring (Prometheus + Grafana)
        - Security-hardened (firewall, SSH, HTTP headers)
        
        Performance Characteristics:
        - Optimized for high-concurrency web requests
        - Fast SSL termination
        - Efficient static file serving
        - Automatic certificate renewal
        
        Use Cases:
        - Personal websites and blogs
        - Web applications and APIs
        - Static site hosting
        - Reverse proxy setups
      '';
      
      examples = {
        "simple-blog" = {
          services.nginx.virtualHosts."blog.example.com" = {
            forceSSL = true;
            enableACME = true;
            locations."/" = {
              root = "/var/www/blog";
            };
          };
        };
        
        "api-gateway" = {
          services.nginx.virtualHosts."api.example.com" = {
            forceSSL = true;
            enableACME = true;
            locations."/api/" = {
              proxyPass = "http://localhost:3000";
              proxyWebsockets = true;
            };
          };
        };
      };
    };
  };
}