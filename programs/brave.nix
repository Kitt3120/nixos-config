{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  extensions = [
    "aghdiknflpelpkepifoplhodcnfildao"
    "ajopnjidmegmdimjlfnijceegpefgped"
    "bgkmgpgeempochogfoddiobpbhdfgkdi"
    "blfpdedbdighagggfhgihcocfheicfjk"
    "cfidkbgamfhdgmedldkagjopnbobdmdn"
    "dmodoodhamgjfnfnokgflekfjgjagpna"
    "edafomjglmkfbiieocpflnhfdmikkhbo"
    "edibdbjcniadpccecjdfdjjppcpchdlm"
    "eimadpbcbfnmbkopoojfekhnkhdbieeh"
    "emffkefkbkpkgpdeeooapgaicgmcbolj"
    "gebbhagfogifgggkldgodflihgfeippi"
    "hkligngkgcpcolhcnkgccglchdafcnao"
    "iaiomicjabeggjcfkbimgmglanimpnae"
    "iidnbdjijdkbmajdffnidomddglmieko"
    "jcokkipkhhgiakinbnnplhkdbjbgcgpe"
    "ldpochfccmkkmhdbclfhpagapcfdljkj"
    "lmjnegcaeklhafolokijcfjliaokphfk"
    "mnjggcdmjocbbbhaepdhchncahnbgone"
    "neebplgakaahbhdphmkckjjcegoiijjo"
    "nngceckbapebfimnlniiiahkandclblb"
    "nomnklagbgmgghhjidfhnoelnjfndfpd"
  ];

  pinnedExtensions = [
    "nngceckbapebfimnlniiiahkandclblb"
    "bgkmgpgeempochogfoddiobpbhdfgkdi"
    "jcokkipkhhgiakinbnnplhkdbjbgcgpe"
    "ldpochfccmkkmhdbclfhpagapcfdljkj"
    "nomnklagbgmgghhjidfhnoelnjfndfpd"
    "eimadpbcbfnmbkopoojfekhnkhdbieeh"
    "iaiomicjabeggjcfkbimgmglanimpnae"
    "hkligngkgcpcolhcnkgccglchdafcnao"
    "lmjnegcaeklhafolokijcfjliaokphfk"
  ];

  extensionSettings = builtins.listToAttrs (
    map (id: {
      name = id;
      value.toolbar_pin = "default_pinned";
    }) pinnedExtensions
  );

  policies = {
    BraveAIChatEnabled = false;
    BraveRewardsDisabled = true;
    BraveWalletDisabled = true;
    BraveVPNDisabled = true;
    BraveNewsDisabled = true;
    BraveTalkDisabled = true;
    BraveP3AEnabled = false;
    BraveStatsPingEnabled = false;
    BraveWebDiscoveryEnabled = false;
    MetricsReportingEnabled = false;
    PasswordManagerEnabled = false;
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    BackgroundModeEnabled = false;
    ExtensionSettings = extensionSettings;
  };

  preferences = {
    brave = {
      new_tab_page = {
        background = {
          random = true;
          selected_value = "";
          type = "brave";
        };

        clock_format = "24";
        show_background_image = true;
        show_branded_background_image = false;
        show_brave_news = false;
        show_clock = true;
        show_rewards = false;
        show_together = false;
      };

      always_show_bookmark_bar_on_ntp = false;

      tabs = {
        vertical_tabs_enabled = false;
        vertical_tabs_expanded_state_per_window = false;
        vertical_tabs_show_scrollbar = false;
        vertical_tabs_show_title_on_window = false;
      };

      sidebar = {
        hidden_built_in_items = [
          7
          1
          2
          3
          4
        ];

        sidebar_items = [ ];
        sidebar_show_option = 3;
      };
    };

    browser.show_home_button = true;
    extensions.pinned_extensions = pinnedExtensions;
    account_values.extensions.pinned_extensions = pinnedExtensions;
  };

  localState = {
    brave.shields.adblock_only_mode_enabled = false;
  };
in
{
  environment.etc."brave/policies/managed/nixos.json".text = builtins.toJSON policies;

  home-manager.users = config.mapAllUsersToSet (user: {
    "${user}" = {
      programs.brave = {
        enable = true;
        extensions = extensions;
      };

      home.activation.bravePreferences = inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        brave_config_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/BraveSoftware/Brave-Browser"
        brave_profile_dir="$brave_config_dir/Default"
        brave_preferences="$brave_profile_dir/Preferences"
        brave_local_state="$brave_config_dir/Local State"

        if ${pkgs.procps}/bin/pgrep -u "$(${pkgs.coreutils}/bin/id -u)" -f '(^|/)(brave|brave-browser)( |$)' >/dev/null; then
          verboseEcho "Skipping Brave Preferences and Local State merge because Brave is running."
        else
          ${pkgs.coreutils}/bin/mkdir -p "$brave_profile_dir"

          merge_brave_json() {
            target="$1"
            managed_json="$2"
            temp_file="$(${pkgs.coreutils}/bin/mktemp "''${target}.tmp.XXXXXX")"
            if [ -f "$target" ]; then
              ${pkgs.jq}/bin/jq -s '.[0] * .[1]' "$target" "$managed_json" > "$temp_file"
            else
              ${pkgs.coreutils}/bin/printf '{}' | ${pkgs.jq}/bin/jq -s '.[0] * .[1]' - "$managed_json" > "$temp_file"
            fi
            ${pkgs.coreutils}/bin/mv "$temp_file" "$target"
          }

          preferences_json="$(${pkgs.coreutils}/bin/mktemp)"
          local_state_json="$(${pkgs.coreutils}/bin/mktemp)"
          trap '${pkgs.coreutils}/bin/rm -f "$preferences_json" "$local_state_json"' EXIT
          printf '%s\n' ${lib.escapeShellArg (builtins.toJSON preferences)} > "$preferences_json"
          printf '%s\n' ${lib.escapeShellArg (builtins.toJSON localState)} > "$local_state_json"
          merge_brave_json "$brave_preferences" "$preferences_json"
          merge_brave_json "$brave_local_state" "$local_state_json"
        fi
      '';
    };
  });
}
