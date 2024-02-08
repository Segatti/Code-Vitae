const http = require("http");
const fs = require("fs");
const read = require("readline");

// const hostname = "127.0.0.1";
// const port = 3000;
// const server = http.createServer((req, res) => {
//   res.statusCode = 200;
//   res.setHeader("Content-Type", "text/plain");
//   res.end("Hello World!");
// });

// server.listen(port, hostname, () => {
//   console.log("Servidor rodando!");
// });

const rl = read.createInterface({
  input: process.stdin,
  output: process.stdout,
});

rl.question("Qual seu nome? ", (value) => {
  console.log("Seu nome é " + value);
});

rl.on("close", () => {
  console.log("adeus!");
  process.exit(0);
});
