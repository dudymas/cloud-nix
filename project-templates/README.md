# Wat

A simple Nix shell for working with cruft/cookiecutter.

# Why

Project generation honestly requires a lot of boilerplate.
Codifying that alone can be arduous and the configuration can be
tricky to get right.

This Nix package aims to provide consistent tooling for generating
projects from templates.

# How?

## Using direnv

You can add this to your `.envrc` file:

```bash
use flake github:dudymas/cloud-nix#project-templates
```

## Using Nix (no file changes needed!)

Just use the following command to enter the Nix shell:
```bash
nix develop github:dudymas/cloud-nix#project-templates
```
