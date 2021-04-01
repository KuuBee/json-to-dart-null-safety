const withPlugins = require("next-compose-plugins");
const withTM = require("next-transpile-modules");
const withBundleAnalyzer = require("@next/bundle-analyzer")({
  enabled: process.env.ANALYZE === "true"
});
module.exports = withPlugins(
  [withTM(["@material-ui/core", "@material-ui/icons"]), withBundleAnalyzer],
  {
    /* config options here */
    transpileModules: ["@material-ui/core", "@material-ui/icons"],
    env: {
      basePath: "/jsontodart"
    },
    basePath: "/jsontodart"
  }
);
