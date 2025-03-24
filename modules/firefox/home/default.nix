{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  inherit (builtins) readFile;
  cfg = config.custom.firefox;
in {
  options.custom.firefox = {enable = mkEnableOption "firefox";};

  config = mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = mkDefault {
      "text/html" = ["firefox.desktop"];
      "text/xml" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
    };

    programs.firefox = {
      enable = mkDefault true;
      package = mkDefault pkgs.firefox-bin;
      profiles.smj = {
        name = mkDefault "smj";
        isDefault = mkDefault true;
        search = {
          default = mkDefault "ddg";
          order = mkDefault ["ddg"];
          force = mkDefault true;
        };
        userChrome = mkDefault (readFile ./userChrome.css);
        userContent = mkDefault (readFile ./userContent.css);
        settings = {
          "middlemouse.paste" = mkDefault false;
          # BetterFox
          "content.notify.interval" = mkDefault 100000;
          "gfx.canvas.accelerated.cache-items" = mkDefault 4096;
          "gfx.canvas.accelerated.cache-size" = mkDefault 512;
          "gfx.content.skia-font-cache-size" = mkDefault 20;
          "browser.cache.jsbc_compression_level" = mkDefault 3;
          "media.memory_cache_max_size" = mkDefault 65536;
          "media.cache_readahead_limit" = mkDefault 7200;
          "media.cache_resume_threshold" = mkDefault 3600;
          "image.mem.decode_bytes_at_a_time" = mkDefault 32768;
          "network.http.max-connections" = mkDefault 1800;
          "network.http.max-persistent-connections-per-server" = mkDefault 10;
          "network.http.max-urgent-start-excessive-connections-per-host" = mkDefault 5;
          "network.http.pacing.requests.enabled" = mkDefault false;
          "network.dnsCacheExpiration" = mkDefault 3600;
          "network.ssl_tokens_cache_capacity" = mkDefault 10240;
          "network.dns.disablePrefetch" = mkDefault true;
          "network.dns.disablePrefetchFromHTTPS" = mkDefault true;
          "network.prefetch-next" = mkDefault false;
          "network.predictor.enabled" = mkDefault false;
          "network.predictor.enable-prefetch" = mkDefault false;
          "layout.css.grid-template-masonry-value.enabled" = mkDefault true;
          "dom.enable_web_task_scheduling" = mkDefault true;
          "browser.contentblocking.category" = mkDefault "strict";
          "urlclassifier.trackingSkipURLs" = mkDefault "*.reddit.com, *.twitter.com, *.twimg.com, *.tiktok.com";
          "urlclassifier.features.socialtracking.skipURLs" = mkDefault "*.instagram.com, *.twitter.com, *.twimg.com";
          "browser.download.start_downloads_in_tmp_dir" = mkDefault true;
          "browser.helperApps.deleteTempFileOnExit" = mkDefault true;
          "browser.uitour.enabled" = mkDefault false;
          "privacy.globalprivacycontrol.enabled" = mkDefault true;
          "security.OCSP.enabled" = mkDefault 0;
          "security.remote_settings.crlite_filters.enabled" = mkDefault true;
          "security.pki.crlite_mode" = mkDefault 2;
          "security.ssl.treat_unsafe_negotiation_as_broken" = mkDefault true;
          "browser.xul.error_pages.expert_bad_cert" = mkDefault true;
          "security.tls.enable_0rtt_data" = mkDefault false;
          "browser.privatebrowsing.forceMediaMemoryCache" = mkDefault true;
          "browser.sessionstore.interval" = mkDefault 60000;
          "privacy.history.custom" = mkDefault true;
          "browser.urlbar.trimHttps" = mkDefault true;
          "browser.urlbar.untrimOnUserInteraction.featureGate" = mkDefault true;
          "browser.search.separatePrivateDefault.ui.enabled" = mkDefault true;
          "browser.urlbar.update2.engineAliasRefresh" = mkDefault true;
          "browser.search.suggest.enabled" = mkDefault false;
          "browser.urlbar.quicksuggest.enabled" = mkDefault false;
          "browser.urlbar.groupLabels.enabled" = mkDefault false;
          "browser.formfill.enable" = mkDefault false;
          "security.insecure_connection_text.enabled" = mkDefault true;
          "security.insecure_connection_text.pbmode.enabled" = mkDefault true;
          "network.IDN_show_punycode" = mkDefault true;
          "dom.security.https_first" = mkDefault true;
          "signon.formlessCapture.enabled" = mkDefault false;
          "signon.privateBrowsingCapture.enabled" = mkDefault false;
          "network.auth.subresource-http-auth-allow" = mkDefault 1;
          "editor.truncate_user_pastes" = mkDefault false;
          "security.mixed_content.block_display_content" = mkDefault true;
          "pdfjs.enableScripting" = mkDefault false;
          "extensions.enabledScopes" = mkDefault 5;
          "network.http.referer.XOriginTrimmingPolicy" = mkDefault 2;
          "privacy.userContext.ui.enabled" = mkDefault true;
          "browser.safebrowsing.downloads.remote.enabled" = mkDefault false;
          "permissions.default.desktop-notification" = mkDefault 2;
          "permissions.default.geo" = mkDefault 2;
          "permissions.manager.defaultsUrl" = mkDefault "";
          "webchannel.allowObject.urlWhitelist" = mkDefault "";
          "datareporting.policy.dataSubmissionEnabled" = mkDefault false;
          "datareporting.healthreport.uploadEnabled" = mkDefault false;
          "toolkit.telemetry.unified" = mkDefault false;
          "toolkit.telemetry.enabled" = mkDefault false;
          "toolkit.telemetry.server" = mkDefault "data:,";
          "toolkit.telemetry.archive.enabled" = mkDefault false;
          "toolkit.telemetry.newProfilePing.enabled" = mkDefault false;
          "toolkit.telemetry.shutdownPingSender.enabled" = mkDefault false;
          "toolkit.telemetry.updatePing.enabled" = mkDefault false;
          "toolkit.telemetry.bhrPing.enabled" = mkDefault false;
          "toolkit.telemetry.firstShutdownPing.enabled" = mkDefault false;
          "toolkit.telemetry.coverage.opt-out" = mkDefault true;
          "toolkit.coverage.opt-out" = mkDefault true;
          "toolkit.coverage.endpoint.base" = mkDefault "";
          "browser.newtabpage.activity-stream.feeds.telemetry" = mkDefault false;
          "browser.newtabpage.activity-stream.telemetry" = mkDefault false;
          "app.shield.optoutstudies.enabled" = mkDefault false;
          "app.normandy.enabled" = mkDefault false;
          "app.normandy.api_url" = mkDefault "";
          "breakpad.reportURL" = mkDefault "";
          "browser.tabs.crashReporting.sendReport" = mkDefault false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = mkDefault false;
          "captivedetect.canonicalURL" = mkDefault "";
          "network.captive-portal-service.enabled" = mkDefault false;
          "network.connectivity-service.enabled" = mkDefault false;
          "browser.privatebrowsing.vpnpromourl" = mkDefault "";
          "extensions.getAddons.showPane" = mkDefault false;
          "extensions.htmlaboutaddons.recommendations.enabled" = mkDefault false;
          "browser.discovery.enabled" = mkDefault false;
          "browser.shell.checkDefaultBrowser" = mkDefault false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = mkDefault false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = mkDefault false;
          "browser.preferences.moreFromMozilla" = mkDefault false;
          "browser.aboutConfig.showWarning" = mkDefault false;
          "browser.aboutwelcome.enabled" = mkDefault false;
          "browser.profiles.enabled" = mkDefault true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = mkDefault true;
          "browser.compactmode.show" = mkDefault true;
          "browser.privateWindowSeparation.enabled" = mkDefault false;
          "browser.newtabpage.activity-stream.newtabWallpapers.v2.enabled" = mkDefault true;
          "cookiebanners.service.mode" = mkDefault 1;
          "cookiebanners.service.mode.privateBrowsing" = mkDefault 1;
          "full-screen-api.transition-duration.enter" = mkDefault "0 0";
          "full-screen-api.transition-duration.leave" = mkDefault "0 0";
          "full-screen-api.warning.timeout" = mkDefault 0;
          "browser.urlbar.suggest.calculator" = mkDefault true;
          "browser.urlbar.unitConversion.enabled" = mkDefault true;
          "browser.urlbar.trending.featureGate" = mkDefault false;
          "browser.newtabpage.activity-stream.feeds.topsites" = mkDefault false;
          "browser.newtabpage.activity-stream.showWeather" = mkDefault false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = mkDefault false;
          "extensions.pocket.enabled" = mkDefault false;
          "browser.download.manager.addToRecentDocs" = mkDefault false;
          "browser.download.open_pdf_attachments_inline" = mkDefault true;
          "browser.bookmarks.openInTabClosesMenu" = mkDefault false;
          "browser.menu.showViewImageInfo" = mkDefault true;
          "findbar.highlightAll" = mkDefault true;
          "layout.word_select.eat_space_to_next_word" = mkDefault false;
          "extensions.autoDisableScopes" = mkDefault 0;
          # SmoothFox
          "apz.overscroll.enabled" = mkDefault true;
          "general.smoothScroll" = mkDefault true;
          "mousewheel.default.delta_multiplier_y" = mkDefault 275;
        };
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            bitwarden
            darkreader
            sponsorblock
            sidebery
            tridactyl
            enhancer-for-youtube
          ];
        };
      };
    };
  };
}
