{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.firefox.policies = {
    AppAutoUpdate = false;
    BackgroundAppUpdate = false;

    DisableFirefoxStudies = true;
    DisableFirefoxScreenshots = true;
    DisableForgetButton = true;
    DisableMasterPasswordCreation = true;
    DisableProfileImport = true;
    DisableProfileRefresh = true;
    DisableSetDesktopBackground = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DisableFormHistory = true;
    DisablePasswordReveal = true;

    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };

    DontCheckDefaultBrowser = true;
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";
    OfferToSaveLogins = false;
  };

  programs.firefox.preferences = {
    "browser.download.open_pdf_attachments_inline" = true;

    # STARTUP

    # set startup page
    "browser.startup.page" = 1;
    "browser.startup.homepage" = "about:home";
    # set NEWTAB page
    "browser.newtabpage.enabled" = false;
    # disable sponsored content on Firefox Home (Activity Stream)
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    # clear default topsites
    "browser.newtabpage.activity-stream.default.sites" = "";

    # GEOLOCATION

    # use Mozilla geolocation service instead of Google if permission is granted
    # Optionally enable logging to the console (defaults to false)
    "geo.provider.network.url" =
      "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
    # disable using the OS's geolocation service
    "geo.provider.ms-windows-location" = false;
    "geo.provider.use_corelocation" = false;
    "geo.provider.use_gpsd" = false;
    "geo.provider.use_geoclue" = false;

    # QUIETER FOX

    # RECOMMENDATIONS
    # disable recommendation pane in about:addons (uses Google Analytics)
    "extensions.getAddons.showPane" = false;
    # disable recommendations in about:addons' Extensions and Themes panes
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    # disable personalized Extension Recommendations in about:addons and AMO
    "browser.discovery.enabled" = false;
    # disable shopping experience
    "browser.shopping.experience2023.enabled" = false;
    # TELEMETRY
    # disable new data submission
    "datareporting.policy.dataSubmissionEnabled" = false;
    # disable Health Reports
    "datareporting.healthreport.uploadEnabled" = false;
    # disable telemetry
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    # disable Telemetry Coverage
    "toolkit.telemetry.coverage.opt-out" = true;
    "toolkit.coverage.opt-out" = true;
    "toolkit.coverage.endpoint.base" = "";
    # disable Firefox Home (Activity Stream) telemetry
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    # STUDIES
    "app.shield.optoutstudies.enabled" = false;
    # disable Normandy/Shield
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";
    # CRASH REPORTS
    # disable Crash Reports
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;
    # enforce no submission of backlogged Crash Reports
    "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
    # OTHER
    # disable Captive Portal detection
    "captivedetect.canonicalURL" = "";
    "network.captive-portal-service.enabled" = false;
    # disable Network Connectivity checks
    "network.connectivity-service.enabled" = false;

    # SAFE BROWSING (SB)

    # disable SB checks for downloads (remote)
    "browser.safebrowsing.downloads.remote.enabled" = false;

    # BLOCK IMPLICIT OUTBOUND [not explicitly asked for - e.g. clicked on]

    # disable link prefetching
    "network.prefetch-next" = false;
    # disable DNS prefetching
    "network.dns.disablePrefetch" = true;
    # disable predictor / prefetching
    "network.predictor.enabled" = false;
    "network.predictor.enable-prefetch" = false;
    # disable link-mouseover opening connection to linked server
    "network.http.speculative-parallel-limit" = 0;
    # disable mousedown speculative connections on bookmarks and history
    "browser.places.speculativeConnect.enabled" = false;

    # DNS / DoH / PROXY / SOCKS

    # set the proxy server to do any DNS lookups when using SOCKS
    "network.proxy.socks_remote_dns" = true;
    # disable using UNC (Uniform Naming Convention) paths
    "network.file.disable_unc_paths" = true;
    # disable GIO as a potential proxy bypass vector
    "network.gio.supported-protocols" = "";
    # enable DNS-over-HTTPS (DoH)
    "network.trr.mode" = 3;
    # set DoH provider
    # user_pref("network.trr.uri", "https://example.dns");
    # user_pref("network.trr.custom_uri", "https://example.dns");

    # LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS

    # disable location bar making speculative connections
    "browser.urlbar.speculativeConnect.enabled" = false;
    # disable location bar contextual suggestions
    "browser.urlbar.quicksuggest.enabled" = false;
    "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    # disable live search suggestions
    "browser.search.suggest.enabled" = false;
    "browser.urlbar.suggest.searches" = false;
    # disable urlbar trending search suggestions
    "browser.urlbar.trending.featureGate" = false;
    # disable urlbar suggestions
    "browser.urlbar.addons.featureGate" = false;
    "browser.urlbar.mdn.featureGate" = false;
    "browser.urlbar.pocket.featureGate" = false;
    "browser.urlbar.weather.featureGate" = false;
    "browser.urlbar.yelp.featureGate" = false;
    # disable search and form history
    "browser.formfill.enable" = false;

    # PASSWORDS

    # disable auto-filling username & password form fields
    "signon.autofillForms" = false;
    # disable formless login capture for Password Manager
    "signon.formlessCapture.enabled" = false;
    # limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources
    "network.auth.subresource-http-auth-allow" = 1;

    # DISK AVOIDANCE

    # disable disk cache
    "browser.cache.disk.enable" = false;
    # disable media cache from writing to disk in Private Browsing
    "browser.privatebrowsing.forceMediaMemoryCache" = true;
    "media.memory_cache_max_size" = 65536;
    # disable storing extra session data [SETUP-CHROME]
    "browser.sessionstore.privacy_level" = 2;

    # HTTPS (SSL/TLS / OCSP / CERTS / HPKP)

    # SSL (Secure Sockets Layer) / TLS (Transport Layer Security)
    # require safe negotiation
    "security.ssl.require_safe_negotiation" = true;
    # disable TLS1.3 0-RTT (round-trip time)
    "security.tls.enable_0rtt_data" = false;
    # OCSP (Online Certificate Status Protocol)
    # enforce OCSP fetching to confirm current validity of certificates
    "security.OCSP.enabled" = 1;
    # set OCSP fetch failures (non-stapled, see 1211) to hard-fail
    "security.OCSP.require" = true;
    # CERTS / HPKP (HTTP Public Key Pinning)
    # enable strict PKP (Public Key Pinning)
    "security.cert_pinning.enforcement_level" = 2;
    # enable CRLite
    "security.remote_settings.crlite_filters.enabled" = true;
    "security.pki.crlite_mode" = 2;
    # MIXED CONTENT
    # enable HTTPS-Only mode in all windows
    "dom.security.https_only_mode" = true;
    # disable HTTP background requests
    "dom.security.https_only_mode_send_http_background_request" = false;
    # UI (User Interface)
    # display warning on the padlock for "broken security" (if 1201 is false)
    "security.ssl.treat_unsafe_negotiation_as_broken" = true;
    # display advanced information on Insecure Connection warning pages
    "browser.xul.error_pages.expert_bad_cert" = true;

    # REFERERS

    # control the amount of cross-origin information to send
    "network.http.referer.XOriginTrimmingPolicy" = 2;

    # CONTAINERS

    # enable Container Tabs and its UI setting
    "privacy.userContext.enabled" = true;
    "privacy.userContext.ui.enabled" = true;
    # set behavior on "+ Tab" button to display container menu on left click
    # user_pref("privacy.userContext.newTabContainerOnLeftClick.enabled", true);
    # set external links to open in site-specific containers
    # user_pref("browser.link.force_default_user_context_id_for_external_opens", true);

    # PLUGINS / MEDIA / WEBRTC

    "media.peerconnection.enabled" = false;
    # force WebRTC inside the proxy
    # "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
    # force a single network interface for ICE candidates generation
    # "media.peerconnection.ice.default_address_only" = true;

    # DOM (DOCUMENT OBJECT MODEL)

    # prevent scripts from moving and resizing open windows
    "dom.disable_window_move_resize" = true;

    # MISCELLANEOUS

    # disable warning for about:config
    "browser.aboutConfig.showWarning" = false;
    # disable UITour backend so there is no chance that a remote page can use it
    "browser.uitour.enabled" = false;
    # reset remote debugging to disabled
    "devtools.debugger.remote-enabled" = false;
    # remove special permissions for certain mozilla domains
    "permissions.manager.defaultsUrl" = "";
    # remove webchannel whitelist
    "webchannel.allowObject.urlWhitelist" = "";
    # enforce PDFJS, disable PDFJS scripting
    "pdfjs.disabled" = false;
    "pdfjs.enableScripting" = false;
    # DOWNLOADS
    # disable adding downloads to the system's "recent documents" list
    "browser.download.manager.addToRecentDocs" = false;
    # enable user interaction for security by always asking how to handle new mimetypes
    "browser.download.always_ask_before_handling_new_types" = true;
    # EXTENSIONS
    # limit allowed extension directories
    "extensions.enabledScopes" = 5;
    # disable bypassing 3rd party extension install prompts
    "extensions.postDownloadThirdPartyPrompt" = false;

    # ETP (ENHANCED TRACKING PROTECTION)

    # enable ETP Strict Mode
    "browser.contentblocking.category" = "strict";

    # SHUTDOWN & SANITIZING

    # enable Firefox to clear items on shutdown
    "privacy.sanitize.sanitizeOnShutdown" = true;
    # SANITIZE ON SHUTDOWN: IGNORES "ALLOW" SITE EXCEPTIONS
    # set/enforce what items to clear on shutdown
    "privacy.clearOnShutdown.cache" = true;
    "privacy.clearOnShutdown.downloads" = true;
    "privacy.clearOnShutdown.formdata" = true;
    "privacy.clearOnShutdown.history" = true;
    "privacy.clearOnShutdown_v2.cache" = true;
    "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
    # SANITIZE ON SHUTDOWN: RESPECTS "ALLOW" SITE EXCEPTIONS FF103+
    # set "Cookies" and "Site Data" to clear on shutdown
    "privacy.clearOnShutdown.cookies" = true;
    "privacy.clearOnShutdown.offlineApps" = true;
    "privacy.clearOnShutdown.sessions" = true;
    "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
    # SANITIZE SITE DATA: IGNORES "ALLOW" SITE EXCEPTIONS
    # set manual "Clear Data" items
    "privacy.clearSiteData.cache" = true;
    "privacy.clearSiteData.cookiesAndStorage" = false;
    "privacy.clearSiteData.historyFormDataAndDownloads" = true;
    # SANITIZE HISTORY: IGNORES "ALLOW" SITE EXCEPTIONS
    # set manual "Clear History" items, also via Ctrl-Shift-Del
    "privacy.cpd.cache" = true;
    "privacy.cpd.formdata" = true;
    "privacy.cpd.history" = true;
    "privacy.cpd.cookies" = false;
    "privacy.cpd.sessions" = true;
    "privacy.cpd.offlineApps" = false;
    "privacy.clearHistory.cache" = true;
    "privacy.clearHistory.historyFormDataAndDownloads" = true;
    "privacy.clearHistory.cookiesAndStorage" = false;
    # SANITIZE MANUAL: TIMERANGE
    # set "Time range to clear" for "Clear Data" (2820) and "Clear History" (2830)
    "privacy.sanitize.timeSpan" = 0;
  };
}
