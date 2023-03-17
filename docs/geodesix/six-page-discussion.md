# Intro

## Nix

The summary of Nix from the
[official website](https://nixos.org/manual/nix/stable/introduction.html)
is worth quoting here:

>Nix is a _purely functional package manager_.  This means that it
treats packages like values in purely functional programming languages
such as Haskell — they are built by functions that don’t have
side-effects, and they never change after they have been built.  Nix
stores packages in the _Nix store_, usually the directory
`/nix/store`, where each package has its own unique subdirectory such
as

    /nix/store/b6gvzjyb2pg0kjfwrjmg1vfhh54ad73z-firefox-33.1/

>where `b6gvzjyb2pg0…` is a unique identifier for the package that
captures all its dependencies (it’s a cryptographic hash of the
package’s build dependency graph).  This enables many powerful
features.

Something worth noting is that the NixPkgs library is always treated
as a separate thing in Nix.

I'll take the liberty to skip some of the details of Nix store and instead
focus on the language of Nix, which is Nickel.

## Nickel

Once again, the intro from the official docs is fantastic and worth quoting:
>Nickel is a generic configuration language.

>Its purpose is to automate the generation of static configuration files - think
JSON, YAML, XML, or your favorite data representation language - that are then
fed to another system. It is designed to have a simple, well-understood core: it
is in essence JSON with functions.

>Nickel's salient traits are:

- **Lightweight**: Nickel is easy to embed. An interpreter should be simple to
    implement. The reference interpreter can be called from many programming
    languages.
- **Composable code**: the basic building blocks for computing are functions.
    They are first-class citizens, which can be passed around, called and
    composed.
- **Composable data**: the basic building blocks for data are records
    (called *objects* in JSON). In Nickel, records can be merged at will,
    including associated metadata (documentation, default values, type
    contracts, etc).
- **Typed, but only when it helps**: static types improve code quality, serve as
    documentation and eliminate bugs early. But application-specific
    self-contained code will always evaluate to the same value, so type errors
    will show up at runtime anyway. Some JSON is hard to type. There, types are
    only a burden. Whereas reusable code - that is, *functions* - is evaluated
    on potentially infinitely many different inputs, and is impossible to test
    exhaustively. There, types are precious. Nickel has types, but you get to
    choose when you want it or not, and it handles safely the interaction between
    the typed and the untyped world.
- **Design by contract**: complementary to the type system, contracts are
    a principled approach to checking assertions. The interpreter automatically
    inserts assertions at the boundary between typed and untyped code. Nickel
    lets users add arbitrary assertions of their own and easily understand why
    when assertions fail.

>The motto guiding Nickel's design is:
 Great defaults, design for extensibility

>There should be a standard, clear path for common things. There should be no
arbitrary restrictions that limit what you can do you the one day you need to go
beyond.

## Geodesic

Let's continue with the Geodesic introduction docs:
>Geodesic is the fastest way to get up and running with a rock solid, production grade cloud platform built entirely from Open Source technologies.

>It’s a swiss army knife for creating and building consistent platforms to be shared across a team environment.

>It easily versions staging environments in a repeatable manner that can be followed by any team member.

>It's a way of doing things that allows companies to collaborate on infrastructure (snowflakes) and radically reduce Total Cost of Ownership, along with a vibrant and active slack community.

>It provides a fully customizable framework for defining and building cloud infrastructures backed by AWS and powered by kubernetes. It couples best-of-breed technologies with engineering best-practices to equip organizations with the tooling that enables clusters to be spun up in record time without compromising security.

## Docker

Right now, the quickest way to get started with Geodesic is to use Docker. It makes sense
to briefly include what Docker's official website says about it an overview:

>Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications. By taking advantage of Docker’s methodologies for shipping, testing, and deploying code quickly, you can significantly reduce the delay between writing code and running it in production.

## Where does that place this repo?

The `cloud-nix` repo and `geodesix` are one way you might combine the technologies above
to best share their strengths and focus on the heart of what makes development
lower effort and more intuitive. While the solution I've picked doesn't apply Docker,
local tests showed that it works there too, but I'll discuss why Docker/containerization
may not be necessary.

The remainder of this document will be about how I've leveraged Nix as a hub to deliver
the environment of geodesic.

# Why "nixify" Geodesic?

Of the four technologies above, this repo only combines three for now:

Geodesic, a toolkit and a repeatable environment.
Nickel, a functional language for configuration.
Nix, a package manager built on content addressable storage.

You might already guess how these compliment each other.

## To Docker or not to Docker

The elephant in the room is not including the Docker layer that honestly could be included.
Let's dig into that decision first. First some points to get out of the way:

- Docker at its core focuses on a feature of Linux, "Containers". Windows and MacOS
  have features that approach the same functionality as containers, but either are not
  open source or are not as full featured. This means Docker relies on virtualization
  in non-Linux environments.
- MacOS is a common development environment. More often (and for the rest of this document)
  I'll refer to MacOS as `darwin`. The darwin development environment has shifted to a
  ARM architecture, which can complicate building environments for it.
- Windows has WSL, which provides a lot of the functionality of the Linux kernel to ELF
  binaries. This means that you can run Linux binaries on Windows, but the syscalls are
  ultimately just providing Windows primitives. So things like dbus and inotify (common
  facets of Linux) are problematic to rely on while developing on Windows.

Docker hasn't been a bad solution considering we've come from a world of Vagrant, Virtualbox,
and ssh. Those tools are still relevant, but Docker has made them much less common.

Why?

Containers give you consistency and portability. And with those, you have less fuss over
how to get code building consistently. This is where Geodesic leans heaviest on Docker.
We want to be sure that our infrastructure can be maintained for years to come. And we
don't want to worry about the environment we're building in. So why give this up? This
all sounds like I should have started -with- Docker and added Nix.

## The Nix Store and Profiles

Nix has been likened to tools like Ansible and SaltStack. The way it behaves, you
describe a set of packages (called derivations) and how they should be installed.
Let's summarize some of the effects of the functional, declarative nature of Nix:

- All packages in Nix are immutable. This means that you can't change the contents of
  a package after it's been built, which safeguards you from drift.
- Any given release is stored by a hash of its contents. That is, the path to a
  given binary/package will never change in Nix.
- Binaries in Nix are expected to only point to their dependencies and never break
  out of their store. So if a package uses glibc, the binaries will be linked to
  the hashed store paths of the precise version of glibc they were built with.
- Flakes are a feature of Nix that let you configure a set of code repositories
  as inputs. They effectively guarantee that version control reigns supreme on a
  package and express several outputs that demonstrate was a Flake repository supports.

## Is it practical?

Let's compare Docker to our Nix solution. I'll discuss the points above as they come
up while we do a few things in geodesix.

Let's assume you've just installed Nix. To run with Flake, you'll need to enable it
like so:
```bash
mkdir -p ~/.config/nix
echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
```

We'll discuss later why these are set in `experimental-features`. For now, suffice to
say that many stable facets of Nix are labeled 'experimental' because they set
opinions in motion. We'll be using Flakes from here on out, and many consider them
just a 'notion' of how to wield the Nix store.

Okay, Flakes are turned on. Now let's run the `geodesix` app:
```bash
nix run github:dudymas/cloud-nix#geodesix
```

That's it. If you just wanted geodesix, you should be greeted with a prompt. You
can run things like `atmos version` or, if you're in a repo that has an `atmos.yaml`,
why not try `atmos describe stack 

So what happened? This will download the `geodesix` derivation and run it. You'll notice
that I haven't mentioned much about environment. Similar to Docker, Nix's store will
manage looking up that GitHub repo, grabbing the latest copy, evaluating its dependencies,
and building it. Once the Flake app is built, it's put in the Nix store and all that Nix
has to do is execute it.

If you run the command again, it'll be nearly instant, similar to how quickly Docker will
run a container. For Docker, this comes from having a filesystem that can layer changes.
When you start a Docker container over again, Docker has little to no effort. When you
run inside a Container, the filesystem is a union of the layers that make up the image.
Any updates or changes that you make are cleanly removed and new containers will start
fresh. This gives rise to consistency.

Nix, however, doesn't need a layered filesystem. It has a content addressable store, and
the content never changes. For Nix, it just checks to see what the last commit was on
our Flake repo. If there's a store path for that commit, then it just runs. There's no
fear that anything has changed. It's all read-only.

In a way, this experience is similar to Docker. You don't have to worry about the environment.
But there are some interesting differences. With Docker, you have a list of images that
you have pulled tha represent a set of compressed layers. With Nix, you have a list of
generations that represent sets of immutable packages.

## How much effort is it?
- Learning enough of Nix to be effective
- Understanding enough of Nickel to extend
- Taking enough of Geodesic to keep things consistent

# Overview of geodesix derivation

## Flake structure - the outputs

I mentioned before that Flakes have several outputs. Let's try listing out what
the `cloud-nix` Flake has:
```bash
nix flake show github:dudymas/cloud-nix

github:dudymas/cloud-nix/aba59d684ba49e24762bb3a9510eb1ee3eae86a9
├───apps
│   ├───aarch64-darwin
│   │   ├───default: app
│   │   └───geodesix: app
│   ├───aarch64-linux
│   │   ├───default: app
│   │   └───geodesix: app
│   ├───x86_64-darwin
│   │   ├───default: app
│   │   └───geodesix: app
│   └───x86_64-linux
│       ├───default: app
│       └───geodesix: app
├───devShells
│   ├───aarch64-darwin
│   │   ├───default: development environment 'nix-shell'
│   │   ├───geodesix: development environment 'nix-shell'
│   │   └───project-templates: development environment 'nix-shell'
│   ├───aarch64-linux
│   │   ├───default: development environment 'nix-shell'
│   │   ├───geodesix: development environment 'nix-shell'
│   │   └───project-templates: development environment 'nix-shell'
│   ├───x86_64-darwin
│   │   ├───default: development environment 'nix-shell'
│   │   ├───geodesix: development environment 'nix-shell'
│   │   └───project-templates: development environment 'nix-shell'
│   └───x86_64-linux
│       ├───default: development environment 'nix-shell'
│       ├───geodesix: development environment 'nix-shell'
│       └───project-templates: development environment 'nix-shell'
└───templates
    ├───default: template: Geodesix template for adding nix to your infra repo
    └───geodesix: template: Geodesix template for adding nix to your infra repo
```

This lists three outputs: `apps`, `devShells`, and `templates`. Let's look at each:

- Apps
  - These are the derivations that are built and put in the Nix store. They are
    the things that you can run with `nix run`.
- DevShells
  - These are build environments you can use to kick the tires on new changes. They are
    the things that you can run with `nix develop`.
- Templates
  - These are the things that you can use to add static boilerplate. They are the things
  that you can run with `nix flake init`.

The design of Flakes is to allow you to have a single repo that can be used in many
common tasks of development: building, testing, and deploying. Let's say you wanted to
add a binary to geodesix.

First, you might want to just build the app with Nix and see how it plays within a
shared environment. That's what the `devShells` are for. You can run `nix develop` and
it will run a shell that doesn't mess with geodesix, but the shell itself can be manipulated
to include the new binary in its PATH. You do this in cloud-nix by first getting a name
of the known package:
```bash
nix-env -qaP '.*poetry'

nixpkgs.emacsPackages.poetry      emacs-poetry-20220915.801
nixpkgs.python310Packages.poetry  python3.10-poetry-1.2.2
nixpkgs.poetry                    python3.10-poetry-1.3.0
nixpkgs.python39Packages.poetry   python3.9-poetry-1.2.2
```

The output of this command should the package name on the left (which we'll want for code)
and the full derivation name on the right (which helps you know what versions you'll use).

Then, you can add it to the `devShells.geodesix` derivation:
```nix
  devShells.poetryShell = pkgs.mkShell {
    packages = [
      pkgs.poetry # becomes python3.10-poetry-1.3.0
      pkgs.geodesix
    ];
  };
```

Now, you can run `nix develop` and you'll have a shell that has the `poetry` binary.
Once you're satisfied with this, you can then update the derivation in
[packages](../../geodesix/packages/geodesic.nix). Let's go over how a derivation works
in Nix while we do it:

- `mkDerivation` is the function that creates a derivation. It takes a set of
  attributes that define what it takes to make an application.
- Derivations have a set of phases. Each phase moves a build along. The default phases
  assume a more traditional build process. This includes running git to fetch sources,
  running a configure script, and then running a makefile.
- All phases are just default attributes you can override. To change the install phase,
  you can just override the `installPhase` attribute.
- Attributes inside the derivation are available to all phases. So if you set a `hello`
  attribute, you can use it in the `installPhase` as `$hello`. They're just bash variables.
- Derivations resolve to their store path, which is just the hash of the derivation.
  So if you set an attribute `bash` to be the bashInteractive package, the var `$bash`
  is just the path to the bashInteractive package in the Nix store.
- mkDerivation will provide several helpers which let you rewrite binaries to only use
  dependencies from the derivation. If you aren't sure which ones to use, just enter
  the `nix develop` shell to try them out and test your changes on a build.

So armed with these points about derivations, let's update the derivation to include
the `poetry` binary. We'll start by adding the `poetry` binary to the derivation:
```nix
  bash = pkgs.bashInteractive;
  poetry = pkgs.poetry;
```

Then, we'll add the `poetry` binary to the derivation's bin directory:
```bash
cp $poetry/bin/poetry $out/bin/poetry
```

Remember, the poetry binary will be set to only point to its store path. Copying it
will effectively link our derivation to that one, and it will only ever point to the
-exact- version of poetry we built with. It won't change because now the hash of our
geodesix will include those store paths.

Now we can test if poetry is available by running `nix run`:
```bash
nix run . -- -c "poetry --version"
```

The geodesix app is a bash script that just sources a profile and adds the geodesix
bin directory to the PATH. By adding `-c "poetry --version"` to the end of the command,
we're telling that bash to execute the command `poetry --version` and then exit.

---

# A Word

This is a lot. I am going to stop the discussion here for the sake of time.
I can only imagine at this point you have tons of questions.

<!--
## Flake structure - the inputs


## What are Overlays?

## So why make shells and apps?

# Using geodesix

## Running the shell
- all the tools
- resetting your prompt (where did zsh go? why would I want to do that?)

## Running the app
- essential tools
- keep your prompt
- envrc/direnv

## Using templates to extend
- adding custom profile.d scripts
- changing binaries
- advanced config

# Reflection and potential future

## "Nix is a cult"
- [the ycombinator thread](https://news.ycombinator.com/item?id=31141377)
- Documentation. ???
- "I would hardly call this a cult, more of just an interest group with weird nerds in it."
- To rule with an iron ~fist~ opinion
- A dependence on systemd

## Will I keep using it?
- What has worked great
- What has been a pain

## Would I recommend it?
- Using the basics
- Extending
- Supporting

# Related effort

## Camlistore/Perkeep

## Warpforge

-->
