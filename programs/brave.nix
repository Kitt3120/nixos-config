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
      value = {
        toolbar_pin = "default_pinned";
      };
    }) pinnedExtensions
  );

  filterListIds = [
    "03F91310-9244-40FA-BCF6-DA31B832F34D"
    "0783DBFD-B5E0-4982-9B4A-711BDDB925B7"
    "1088D292-2369-4D40-9BDF-C7DC03C05966"
    "15B64333-BAF9-4B77-ADC8-935433CD6F4C"
    "1BE19EFD-9191-4560-878E-30ECA72B5B3C"
    "1C6D8556-3400-4358-B9AD-72689D7B2C46"
    "1ED1870B-997C-4BFE-AEBC-B67D679BAF3B"
    "1FEAF960-F377-11E8-8EB2-F2801F1B9FD1"
    "2D57ADED-3531-419A-9DED-7F8868BC1561"
    "2F3DCE16-A19A-493C-A88F-2E110FBD37D6"
    "3afa9d35-d837-45b5-b742-b3d0fe94e77c"
    "418D293D-72A8-4A28-8718-A1EE40A45AAF"
    "45B3ED40-C607-454F-A623-195FDD084637"
    "48796273-E783-431E-B864-44D3DCEA66DC"
    "49958da7-f532-4a84-a765-9501729b8e75"
    "4C07DB6B-6377-4347-836D-68702CF1494A"
    "4D715457-307C-4383-8873-73A2FD263F71"
    "4E8B1A63-DEBE-4B8B-AD78-3811C632B353"
    "564C3B75-8731-404C-AD7C-5683258BA0B0"
    "5c6a6c95-b60a-4695-9efb-539359022531"
    "61C6046C-B040-4CE4-8C8E-F3E8F316AA72"
    "658F092A-F377-11E8-8EB2-F2801F1B9FD1"
    "67E792D4-AE03-4D1A-9EDE-80E01C81F9B8"
    "690FF3B4-8B6B-4709-8505-FEC6643D7BD9"
    "6A0209AC-9869-4FD6-A9DF-039B4200D52C"
    "6C0F4C7F-969B-48A0-897A-14583015A587"
    "6b91e355-1421-4c03-9a30-911b4d0fb277"
    "78672887-A098-4D2C-B0CB-A3DEC4834DA7"
    "7911A1CB-304E-4CDB-ABB3-E2A94A37E4DD"
    "7BC951C6-B0B8-4223-97FC-3C22605734FC"
    "7CCB6921-7FDA-4A9B-B70A-12DD0A8F08EA"
    "7DC2AC80-5BBC-49B8-B473-A31A1145CAC1"
    "7f11b964-4f36-4e06-9d75-bd16381b9386"
    "80470EEC-970F-4F2C-BF6B-4810520C72E6"
    "84960ADD-1CC1-419F-81FC-9F116F5205CC"
    "85F65E06-D7DA-4144-B6A5-E1AA965D1E47"
    "8BEDBAA8-4FE2-4FEA-82F2-81B8124A4A74"
    "92AA0D3B-34AC-4657-9A5C-DBAD339AF8E2"
    "93123971-5AE6-47BA-93EA-BE1E4682E2B6"
    "9852EFC4-99E4-4F2D-A915-9C3196C7A1DE"
    "9D644676-4784-4982-B94D-C9AB19098D2A"
    "9E8EC586-4E17-4E5E-99D7-35172C4CEA74"
    "9F38E77A-64AA-4C5F-AF37-727CAE1266FF"
    "9FCEECEC-52B4-4487-8E57-8781E82C91D0"
    "A5E6EC21-F01F-4547-9F0A-1EE1C3F2AE8D"
    "AB1A661D-E946-4F29-B47F-CA3885F6A9F7"
    "AC023D22-AE88-4060-A978-4FEEEC4221693"
    "AD3E8454-F376-11E8-8EB2-F2801F1B9FD1"
    "AE657374-1851-4DC4-892B-9212B13B15A7"
    "BD308B90-D3BB-4041-9114-22E096B0BA77"
    "BF9234EB-4CB7-4CED-9FCB-F1FD31B0666C"
    "C3C2F394-D7BB-4BC2-9793-E0F13B2B5971"
    "CC98E4BA-9257-4386-A1BC-1BBF6980324F"
    "d579f370-6de3-4507-aa9a-cee4227e59f5"
    "E2FA7D98-0BD5-493E-8AF4-950604ADE9CB"
    "E71426E7-E898-401C-A195-177945415F38"
    "E99CBD02-FFD1-4651-9BDD-6A9ED7B87819"
    "EDEEE15A-6FA9-4FAC-8CA8-3565508EAAC3"
    "F61D6B7B-4110-4EA4-9C81-38FB4CE90AEC"
    "FB626316-6CC8-4447-884B-F5A37C29B0AE"
    "FD176DD1-F9A0-4469-B43E-B1764893DD5C"
  ];

  disabledFilterListIds = [
    "9E8EC586-4E17-4E5E-99D7-35172C4CEA74"
    "5c6a6c95-b60a-4695-9efb-539359022531"
    "2D57ADED-3531-419A-9DED-7F8868BC1561"
    "7f11b964-4f36-4e06-9d75-bd16381b9386"
    "d579f370-6de3-4507-aa9a-cee4227e59f5"
    "49958da7-f532-4a84-a765-9501729b8e75"
    "BD308B90-D3BB-4041-9114-22E096B0BA77"
    "3afa9d35-d837-45b5-b742-b3d0fe94e77c"
    "F61D6B7B-4110-4EA4-9C81-38FB4CE90AEC"
  ];

  filterListStates = builtins.listToAttrs (
    map (id: {
      name = id;
      value = !(builtins.elem id disabledFilterListIds);
    }) filterListIds
  );

  regionalFilters = builtins.mapAttrs (_: enabled: { inherit enabled; }) filterListStates;

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
    DefaultBraveHttpsUpgradeSetting = 2;
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

      containers.enabled = true;
      enable_media_router_on_restart = true;
      enable_window_closing_confirm = false;
      history.retention_days = -1;
      show_side_panel_button = true;
      tabs.hover_mode = 2;
      web_view_rounded_corners = false;
    };

    media_router.enable_media_router = true;
    omnibox.prevent_url_elisions = true;
    browser.show_home_button = true;
    extensions.pinned_extensions = pinnedExtensions;
    account_values.extensions.pinned_extensions = pinnedExtensions;

    toolbar = {
      pinned_actions = [
        "kActionNewIncognitoWindow"
        "kActionShowDownloads"
        "kActionCopyUrl"
        "kActionSendTabToSelf"
        "kActionDevTools"
        "kActionRouteMedia"
      ];
      pinned_chrome_labs_migration_complete = true;
      pinned_cast_migration_complete = true;
      tabs_from_other_devices_auto_pinned_migration = true;
      ttc_auto_pinned_migration = true;
    };
  };

  localState = {
    brave.widevine_opted_in = true;
    brave.allow_element_blocker_in_private_mode = true;
    brave.shields.adblock_only_mode_enabled = false;
    brave.shields.fb_embed_default = false;
    brave.shields.twitter_embed_default = true;
    brave.shields.linkedin_embed_default = false;
    brave.ad_block.regional_filters = regionalFilters;
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
