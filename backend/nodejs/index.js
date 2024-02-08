const express = require("express");
const path = require("path");

const app = express();

app.engine("html", require("ejs").renderFile);
app.set("view engine", "html");
// Config onde está os assets
app.use("/public", express.static(path.join(__dirname, "public")));
// Config onde está as views
app.set("views", path.join(__dirname, "/views"));

app.get("/", (req, res) => {
  res.render("index", { nome: "Vittor" });
});

app.listen(5000, () => {
  console.log("Server rodando");
});
