{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ nextcloud-client ];

  home-manager.users = config.mapAllUsersToSet (user: {
    "${user}".home.file.".config/Nextcloud/sync-exclude.lst".text = ''
      # This file contains fixed global exclude patterns

      *~
      ~$*
      .~lock.*
      ~*.tmp
      ]*.~*
      ]Icon\r*
      ].DS_Store
      ].ds_store
      *.textClipping
      ._*
      ]Thumbs.db
      ]photothumb.db
      System Volume Information

      .*.sw?
      .*.*sw?

      ].TemporaryItems
      ].Trashes
      ].DocumentRevisions-V100
      ].Trash-*
      .fseventd
      .apdisk
      .Spotlight-V100

      .directory

      *.part
      *.filepart
      *.crdownload

      *.kate-swp
      *.gnucash.tmp-*

      .synkron.*
      .sync.ffs_db
      .symform
      .symform-store
      .fuse_hidden*
      *.unison
      .nfs*

      # (default) metadata files created by Syncthing
      .stfolder
      .stignore
      .stversions

      My Saved Places.

      \#*#

      *.sb-*

      # Compile output
      target
    '';
  });
}
