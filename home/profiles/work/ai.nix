{ ... }:

let
  newClaudeVersion = "2.1.92"; # Latest available as of 2026-04-04

  # Override claude-code to a newer version because 2.1.88 binary URLs are dead
  claudeCodeOverlay = final: prev: {
    claude-code = prev.claude-code.overrideAttrs (old: {
      version = newClaudeVersion;
      src = prev.fetchurl {
        url = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/${newClaudeVersion}/linux-x64/claude";
        # hash will be computed on first build with --impure, then fill in the correct value
        # For now use a placeholder - the build will fail and show the expected hash
        hash = "sha256-4iMkUUln/y1en5Hw7jfkZ1v4tt/sJ/r7GcslzFsj/K8=";
      };
    });
  };

in
{
  nixpkgs.overlays = [ claudeCodeOverlay ];
}
