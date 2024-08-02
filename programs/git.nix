{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    prompt.enable = true;
    config = {
      core = {
        autocrlf = "input";
        editor = "nano";
        untrackedCache = true;
        fsmonitor = true;
      };

      init.defaultBranch = "main";
      gpg.format = "ssh";
      commit.gpgsign = true;
      tag.gpgsign = true;
      rerere.enabled = true;
      column.ui = "auto";
      fetch.writeCommitGraph = true;

      alias = {
        as = "!git add . && git status";
        ds = "diff --staged";
        ads = "!git add . && git diff --staged";
        bvs = "!git branch -v --sort=committerdate";
        bvas = "!git branch -va --sort=committerdate";
        rebaseFromMain = "!git stash && git checkout main && git fetch --all -p && git pull && git checkout - && git rebase main && git stash pop";
        rebaseFromMaster = "!git stash && git checkout master && git fetch --all -p && git pull && git checkout - && git rebase master && git stash pop";
      };
    };
  };
}