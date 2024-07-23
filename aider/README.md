# Wat

aider is an AI chatbot that helps you with your projects on the cli.
This is the Nix package for injecting aider into your project.

# Why

aider only needs an api key to work, and this makes it easy to drop in to any project.

# How?

## Using direnv

You can add this to your `.envrc` file:

```bash
use flake github:dudymas/cloud-nix#aider
```

## Using Nix (no file changes needed!)

Just use the following command to enter the Nix shell:
```bash
nix develop github:dudymas/cloud-nix#aider
```
