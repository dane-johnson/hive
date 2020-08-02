#!/usr/bin/lua
fennel = require('fennel')
local source = io.open("src/main.fnl", "r"):read("a")
fennel.path = fennel.path .. ";./src/?.fnl"
print(fennel.compileString(source))
