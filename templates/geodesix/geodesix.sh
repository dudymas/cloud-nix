#!/bin/bash

bash=${bash?Please run this after activating a nix shell}
geodesic=${geodesic?Please run this after activating a nix shell}
# note, this script expects to be run after initializing a dev shell
exec "$bash/bin/bash" --init-file "$geodesic/etc/profile"
