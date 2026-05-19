"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SignInRoutes = void 0;
const express_1 = require("express");
const signin_controller_1 = require("./signin.controller");
exports.SignInRoutes = (0, express_1.Router)();
exports.SignInRoutes.post("/login", signin_controller_1.SignInController.login);
