"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.signupRouter = void 0;
const express_1 = require("express");
const signup_controller_1 = require("./signup.controller");
exports.signupRouter = (0, express_1.Router)();
exports.signupRouter.post("/register", signup_controller_1.SignupController.register);
