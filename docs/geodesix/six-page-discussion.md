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

# Why nixify geodesic?

Geodesic, a toolkit and a repeatable environment.
Nickel, a functional language for configuration.
Nix, a package manager built on content addressable storage.

You might already guess why I felt nix would be a nice way to improve geodesic.

## What has vanilla Geodesic struggled with?

In the end, we want to continue to make software that excels in its purpose,
while standing on software that was intended to support it.

To that end, Geodesic has been great for its purpose. But I would like to reflect
on how the software that supports it has created some challenges.

- Docker at its core focuses on a feature of linux kernels. Neither Windows nor MacOS
  directly support Docker because they simply don't run the Linux host operating system.
- MacOS
- Windows
- Git
- VPCs and CI/CD

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
