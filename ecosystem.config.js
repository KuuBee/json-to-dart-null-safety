module.exports = {
  apps: [
    {
      name: "json-to-dart",
      script: "npm",
      args: "start",
      watch: false,
      error_file: "/root/.pm2/logs/json-to-dart.error.log",
      out_file: "/root/.pm2/logs/json-to-dart.out.log"
    }
  ]
};
