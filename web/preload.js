const firebaseSdkVersion = "12.12.0";
window.flutterfire_web_sdk_version = firebaseSdkVersion;

function seedPhase7LighthousePreferences() {
  const params = new URLSearchParams(window.location.search);
  if (params.get("jpstudy_qa") !== "phase7_lighthouse") return;

  const value = (item) => JSON.stringify(item);
  const preferences = {
    "flutter.onboarding.completed": value(true),
    "flutter.onboarding.level": value("n5"),
    "flutter.onboarding.goal": value("jlpt"),
    "flutter.app.locale": value("vi"),
    "flutter.analytics.consent": value(false),
    "flutter.foundations.softSuggest.grammar.shown": value(true),
    "flutter.foundations.softSuggest.vocab.shown": value(true),
    "flutter.foundations.softSuggest.kanji.shown": value(true),
  };

  for (const [key, storedValue] of Object.entries(preferences)) {
    window.localStorage.setItem(key, storedValue);
  }
}

async function preloadFirebaseSdk() {
  const base = `https://www.gstatic.com/firebasejs/${firebaseSdkVersion}`;
  const [
    firebaseCore,
    firebaseAuth,
    firebaseStorage,
    firebaseAnalytics,
    firebaseAppCheck,
  ] =
    await Promise.all([
      import(`${base}/firebase-app.js`),
      import(`${base}/firebase-auth.js`),
      import(`${base}/firebase-storage.js`),
      import(`${base}/firebase-analytics.js`),
      import(`${base}/firebase-app-check.js`),
    ]);

  window.firebase_core = firebaseCore;
  window.firebase_auth = firebaseAuth;
  window.firebase_storage = firebaseStorage;
  window.firebase_analytics = firebaseAnalytics;
  window.firebase_app_check = firebaseAppCheck;
}

function setAccessibleViewport() {
  let viewport = document.querySelector('meta[name="viewport"]');
  if (!viewport) {
    viewport = document.createElement("meta");
    viewport.name = "viewport";
    document.head.appendChild(viewport);
  }
  viewport.content = "width=device-width, initial-scale=1.0";
}

window.setAccessibleViewport = setAccessibleViewport;

function wireA11yNavigation() {
  document.querySelectorAll(".jpstudy-a11y-nav [data-route]").forEach((item) => {
    item.addEventListener("click", () => {
      window.location.hash = item.getAttribute("data-route") || "/";
    });
  });

  window.addEventListener("pointerup", (event) => {
    if (window.innerWidth < 900 || event.clientX > 190) return;
    const routes = [
      [225, 295, "/kanji"],
      [305, 375, "/foundations"],
      [385, 455, "/vocab"],
      [465, 535, "/grammar"],
      [545, 615, "/"],
      [625, 695, "/memory"],
      [705, 775, "/active"],
    ];
    const match = routes.find(([top, bottom]) => event.clientY >= top && event.clientY <= bottom);
    if (match) window.location.hash = match[2];
  }, { passive: true });
}

function loadFlutterBootstrap() {
  setAccessibleViewport();
  wireA11yNavigation();
  const script = document.createElement("script");
  script.src = "flutter_bootstrap.js";
  script.async = true;
  document.body.appendChild(script);
}

function scheduleFirebaseSdkPreload() {
  const run = () => {
    preloadFirebaseSdk().catch((error) => {
      console.warn(
        "Firebase SDK preload failed; cloud features may be unavailable.",
        error,
      );
    });
  };

  window.setTimeout(run, 30000);
}

seedPhase7LighthousePreferences();
loadFlutterBootstrap();
scheduleFirebaseSdkPreload();
