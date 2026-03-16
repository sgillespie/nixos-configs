# Default recipe to show available targets
default:
    @just --list

# Deploy to any host (sean-nixos, sean-work, sean-pi, sean-pi-public)
deploy HOST:
    just deploy-{{HOST}}

deploy-local:
    nixos-rebuild switch --flake . --sudo

# Deploy to local desktop (sean-nixos)
deploy-sean-nixos:
    nixos-rebuild switch --flake .#sean-nixos --sudo

# Deploy to local work machine (sean-work)
deploy-sean-work:
    nixos-rebuild switch --flake .#sean-work --sudo

# Deploy to Raspberry Pi via colmena
deploy-sean-pi:
    colmena apply --on sean-pi

# Deploy to Raspberry Pi Public via SSH (with remote build)
deploy-sean-pi-public:
    nixos-rebuild switch --flake .#sean-pi-public --target-host pi-public.home --build-host pi-public.home --use-remote-sudo

# Build only (no switch) for testing
build HOST:
    just build-{{HOST}}

build-local:
    nixos-rebuild build --flake .

# Build for local desktop (sean-nixos)
build-sean-nixos:
    nixos-rebuild build --flake .#sean-nixos

# Build for local work machine (sean-work)
build-sean-work:
    nixos-rebuild build --flake .#sean-work

# Build for Raspberry Pi
build-sean-pi:
    nixos-rebuild build --flake .#sean-pi

# Build for Raspberry Pi Public (with remote build)
build-sean-pi-public:
    nixos-rebuild build --flake .#sean-pi-public --target-host pi-public.home --build-host pi-public.home

# Update flake.lock
update:
    nix flake update

# Format all Nix files
fmt:
    nix fmt

# Check flake evaluation
check:
    nix flake check
