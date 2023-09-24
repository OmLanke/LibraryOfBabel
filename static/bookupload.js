var express = require("express");
var app = express();

app.listen(3000);

app.get("/home",(req,res)=>{
    res.sendFile("bookupload.html", { root: __dirname });

})