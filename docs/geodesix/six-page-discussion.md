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

Let's finish off with the Geodesic introduction docs:
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

## The Nix Store


## Is it practical?
flakes
extending
common workflows

## How much effort is it?
- Learning enough of Nix to be effective
- Understanding enough of Nickel to extend
- Taking enough of Geodesic to keep things consistent

# Overview of geodesix derivation

## Flake structure
- What are the packages?
- Overlays?
- Shells vs. Apps

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

## Would I recommend it?

# Related effort and artifacts
## Camlistore/Perkeep
## Warpforge
