# Wat

Geodesix - Nix-ified variant of [Geodesic](https://github.com/cloudposse/geodesic) -
a Docker-based shell for working with AWS and Kubernetes.

# Why

Geodesic at its heart intends to be a workspace for maintaining infra.
Nix at its heart intends to be a toolkit for building software and dev environments.

Together, they bring a workspace that is isolated, reproducible, and fast.

# How?

This package provides a shell that provides scripts from Geodesic, but with locally
built tools and libraries from Nix.

When you run this shell, it does not immediately put you in geodesix. Instead it just
provides the tooling by default and not the Geodesic shell scripts.

To try out geodesix, you just need to find a directory that has a working Geodesic build.
Once there, you'll want to use Nix to either call the shell directly,
or use direnv to automatically enter the shell.

## Using direnv

If you didn't already make an `.envrc`, there's already a Nix template for
this if you want a quick start.
```bash
nix flake init --template github:dudymas/cloud-nix#geodesix
chmod +x geodesix.sh
```

Next, edit the `.envrc` and set your GEODESIC_NAMESPACE to the atmos namespace you want.

Once your Nix shell is up and running with direnv, you can enter the geodesix shell with:

```bash
./geodesix.sh
```

## Using Nix (no file changes needed!)

Just use the following command to enter the Nix shell:
```bash
nix develop github:dudymas/cloud-nix#geodesix
```

Since this method does not add any files or scripts, you'll need to manually enter
the geodesix shell with:
```bash
export GEODESIC_NAMESPACE=__your_namespace__
$bash/bin/bash --init-file $geodesic/etc/profile
```

## How come you want to call it with env vars?

I don't like having too much magic in how my shells launch.
It's up to you to alias the command or create a wrapper function/script.

# Customizing

Most [geodesix env vars](profile.d/00_geodesix.sh) can be overridden
and you'll want to observe any defaults that don't make sense in your environment.

# TODO:
- Describe how to overlay your own profile and scripts.
- Describe how to overlay custom app versions and builds.
- Support using nix containers.
- Add commands in addition to the shell for quicker drop-in/drop-out use.
