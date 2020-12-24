const admin = require("firebase-admin");
admin.initializeApp();

exports.user = require("./user");
exports.recipe = require("./recipe");
exports.cookbook = require("./cookbook");
