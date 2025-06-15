{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "libtelio";
  version = "5.1.9";

  src = fetchFromGitHub {
    owner = "NordSecurity";
    repo = "libtelio";
    rev = "v${version}";
    hash = "sha256-2/3JN+o+7KpOChsOkYxsD8FXsQFtkCQut11vgIaYs+o=";
  };

  # TODO: temporarily disable tests
  dontCargoCheck = true;

  cargoLock = {
    # fix the lockfile
    # 1. it specifies system-configuration and system-configuration-sys twice, as described in the bug
    #    https://github.com/NixOS/nixpkgs/issues/183344
    # 2. add rustls-webpki@0.102 explicitly to fix compilation issue
    #    https://github.com/MystenLabs/sui/issues/21509#issuecomment-2729655321
    lockFile = ./Cargo.lock;
    outputHashes = {
      "boringtun-0.6.0" = "sha256-NYSyJhM8h3sRhdlfSyjLq4tqhLToiEwGyxb8rdGA5zM=";
      "dispatch-0.2.0" = "sha256-nX1+sfLI3H8xz95d04JeO5QY+8BRpitWKKUeGWfVrdI=";
      "hickory-proto-0.24.0" = "sha256-L4FHJPkUuNegEpC/JVf0Ssp7TWq6bI+eQA+DHyae2O0=";
      "nat-detect-0.1.7" = "sha256-XmWpsOVTH3RaVTYuH3jbIh9iOVmBoEVuzPIspeUhsDY=";
      "system-configuration-0.5.1" = "sha256-0TnVVM2rpzjaeNJPV0AcJrXge6YaBxWO6SmHpSIFwBI=";
      "uniffi-0.3.1+v0.25.0" = "sha256-7+wiFetSaSheRUrbbMUH3ZM8jWOy3o8mpO/csU5oMbA=";
      "wireguard-nt-1.0.0" = "sha256-i00ug3DbYikADzP22/okssDNeLbsjZjVWfK+UsbaKvM=";
    };
  };

  # it tries to write to lock file during the build, so need to copy the file explicitly
  postPatch = ''
    cp -f ${./Cargo.lock} Cargo.lock
  '';

  # https://github.com/NordSecurity/libtelio/tree/${src.rev}?tab=readme-ov-file#build
  env.VERSION = version;
  env.BYPASS_LLT_SECRETS = 1;

  meta = with lib; {
    description = "A library providing networking utilities for NordVPN VPN and meshnet functionality";
    homepage = "https://github.com/NordSecurity/libtelio";
    changelog = "https://github.com/NordSecurity/libtelio/blob/${src.rev}/changelog.md";
    license = licenses.gpl3Only;
  };
}

