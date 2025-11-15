
import os

def create_placeholders():
    # List of all files to be created, derived from init.md
    file_list = [
        ".github/workflows/ci-advanced.yml",
        ".github/workflows/deploy-docs.yml",
        ".github/ISSUE_TEMPLATE/bug_report.md",
        ".github/ISSUE_TEMPLATE/feature_request.md",
        ".github/FUNDING.yml",
        ".github/dependabot.yml",
        ".github/template.yml",
        "docs/index.md",
        "docs/architecture/overview.md",
        "docs/architecture/implementation.md",
        "docs/architecture/security.md",
        "docs/architecture/performance.md",
        "docs/beginner/getting-started.md",
        "docs/beginner/installation.md",
        "docs/beginner/first-steps.md",
        "docs/advanced/configuration.md",
        "docs/advanced/performance.md",
        "docs/advanced/security.md",
        "docs/advanced/recovery.md",
        "docs/modules/base.md",
        "docs/modules/security.md",
        "docs/modules/storage.md",
        "docs/modules/containers.md",
        "docs/modules/monitoring.md",
        "docs/modules/services.md",
        "docs/profiles/minimal.md",
        "docs/profiles/webserver.md",
        "docs/profiles/container-host.md",
        "docs/profiles/database-server.md",
        "docs/profiles/full-stack.md",
        "docs/reference/api.md",
        "docs/reference/options.md",
        "docs/reference/commands.md",
        "docs/reference/troubleshooting.md",
        "docs/examples/simple-webserver.md",
        "docs/examples/production-stack.md",
        "docs/examples/ha-setup.md",
        "docs/contributing/development.md",
        "docs/contributing/testing.md",
        "docs/contributing/documentation.md",
        "docs/about/license.md",
        "docs/about/changelog.md",
        "docs/about/roadmap.md",
        "modules/base/00-hardware.nix",
        "modules/base/01-boot.nix",
        "modules/base/02-users.nix",
        "modules/security/01-luks.nix",
        "modules/security/02-firewall.nix",
        "modules/security/03-ssh.nix",
        "modules/security/04-hardening.nix",
        "modules/storage/01-zfs-pool.nix",
        "modules/storage/02-zfs-datasets.nix",
        "modules/storage/03-snapshots.nix",
        "modules/storage/04-backup.nix",
        "modules/containers/01-podman-base.nix",
        "modules/containers/02-podman-rootless.nix",
        "modules/containers/03-systemd-integration.nix",
        "modules/containers/04-registry.nix",
        "modules/monitoring/01-prometheus.nix",
        "modules/monitoring/02-grafana.nix",
        "modules/monitoring/03-alerting.nix",
        "modules/monitoring/04-logs.nix",
        "modules/services/web/nginx.nix",
        "modules/services/web/caddy.nix",
        "modules/services/web/acme.nix",
        "modules/services/database/postgresql.nix",
        "modules/services/database/mysql.nix",
        "modules/services/cache/redis.nix",
        "profiles/minimal.nix",
        "profiles/webserver.nix",
        "profiles/container-host.nix",
        "profiles/database-server.nix",
        "profiles/full-stack.nix",
        "templates/by-profile/minimal.template.nix",
        "templates/by-profile/webserver.template.nix",
        "templates/by-profile/container-host.template.nix",
        "templates/by-profile/database-server.template.nix",
        "templates/by-profile/full-stack.template.nix",
        "templates/by-use-case/simple-website.template.nix",
        "templates/by-use-case/api-server.template.nix",
        "templates/by-use-case/development.template.nix",
        "scripts/setup/quick-install.sh",
        "scripts/setup/interactive-config.sh",
        "scripts/maintenance/backup.sh",
        "scripts/maintenance/snapshot.sh",
        "scripts/maintenance/update.sh",
        "scripts/recovery/restore.sh",
        "scripts/recovery/recovery-mode.sh",
        "examples/simple-webserver.nix",
        "examples/monitoring-stack.nix",
        "examples/production-setup.nix",
        "benchmarks/zfs-performance.nix",
        "benchmarks/network-benchmark.nix",
        "benchmarks/container-benchmark.nix",
        ".gitignore",
        ".editorconfig",
        "CHANGELOG.md",
        "LICENSE",
        "CONTRIBUTING.md",
        "SECURITY.md",
        "QUALITY_METRICS.md",
        "mkdocs.yml",
        "flake.nix",
        "README.md"
    ]
    
    root_dir = 'nixos-hetzner-vps'
    created_count = 0

    for rel_path in file_list:
        full_path = os.path.join(root_dir, rel_path)

        if os.path.exists(full_path):
            continue

        parent_dir = os.path.dirname(full_path)
        if parent_dir and not os.path.exists(parent_dir):
            os.makedirs(parent_dir)

        file_name = os.path.basename(full_path)
        placeholder_content = f"# Placeholder for {file_name}"
        
        if file_name.endswith('.nix'):
            placeholder_content = f"{{ config, lib, pkgs, ... }}: {{\n  # Placeholder for {file_name}\n}}"

        try:
            with open(full_path, 'w', encoding='utf-8') as f:
                f.write(placeholder_content)
            print(f"Created placeholder: {full_path}")
            created_count += 1
        except Exception as e:
            print(f"Error creating file {full_path}: {e}")
            
    print(f"\nProcess complete. Created {created_count} new placeholder files.")

create_placeholders()
