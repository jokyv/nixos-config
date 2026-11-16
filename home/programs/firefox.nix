{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    #   bitwarden
    #   darkreader
    #   ublock-origin
    #   privacy-badger
    #   self-destructing-cookies
    # ];

    # sets the "jokyv" profile as the default profile for Firefox
    # profiles.jokyv = {
    # isDefault = true;

    profiles.default = {
      id = 0;
      isDefault = true;
      # name = "default";
      # path = "fxoyb0f2.default";
      # extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
      #   ublock-origin
      #   1
      #   password
      #   auto-tab-discard # increase browser speed and reduce memory when too many open tabs

      #   #   # bitwarden
      #   #   # vimium # navigate like vim
      #   #   # sidebery # vertical tabs tree and bookmarks
      # ];

      search = {
        force = true;
        default = "google";
        privateDefault = "google";
      };

      userChrome = ''
        #TabsToolbar, #nav-bar, #PersonalToolbar {
          padding-block: 3px !important;
        }
      '';

      settings = {
        # Keep Firefox page fonts independent of the larger desktop font size.
        "font.size.variable.x-western" = lib.mkForce 16;
        "font.size.monospace.x-western" = lib.mkForce 13;

        # General settings
        "browser.startup.homepage" = "about:home";
        "browser.startup.page" = 1;
        "browser.newtabpage.enabled" = true;
        "browser.newtabpage.activity-stream.showSearch" = true;
        "browser.newtabpage.activity-stream.feeds.topsites" = true;
        "browser.newtabpage.activity-stream.topSitesRows" = 2;
        "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.tabs.closeWindowWithLastTab" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
        "browser.sessionstore.enabled" = true;
        "browser.sessionstore.resume_from_crash" = true;
        "browser.sessionstore.resume_session_once" = false;

        # Privacy and security settings
        "privacy.trackingprotection.enabled" = true;
        "network.cookie.cookieBehavior" = 1; # 0=allow all, 1=allow from originating site, 2=no cookies
        "network.http.referer.hideOnionUrl" = true;
        "network.http.referer.spoofSource" = true;
        "network.http.referer.XOriginPolicy" = 2; # 0=send, 1=send if origin matches, 2=send only on same origin
        "network.http.referer.XOriginTrimmingPolicy" = 2; # 0=send full URL, 1=send origin only, 2=trim path
        "browser.search.suggest.enabled" = false;
        "browser.search.suggest.enabled.private" = false;
        "browser.urlbar.suggest.addons" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.pocket" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.topsites" = false;

        # Performance settings
        "browser.tabs.remote.autostart" = true;
        "browser.tabs.remote.autostart.2" = true;
        "dom.ipc.processCount" = 8;
        "layers.acceleration.disabled" = false;
        "media.ffmpeg.low-latency.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-vpx.enabled" = true;
      };
    };
  };
}

# "browser.newtabpage.pinned" = [
#   {
#     title = "youtube";
#     url = "https://www.youtube.com/";
#   }
#   {
#     title = "scientiac";
#     url = "https://scientiac.space/";
#   }
#   {
#     title = "messenger";
#     url = "https://www.messenger.com/";
#   }
#   {
#     title = "search.nixos";
#     url = "https://search.nixos.org/";
#   }
#   {
#     title = "fosstodon";
#     url = "https://fosstodon.org/";
#   }
#   {
#     title = "gitlab";
#     url = "http://www.gitlab.com/";
#   }
#   {
#     title = "github";
#     url = "https://www.github.com/";
#   }
#   {
#     title = "chatgpt";
#     url = "https://chatgpt.com/";
