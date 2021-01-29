const admin = require("firebase-admin");
admin.initializeApp();

exports.user = require("./user");
exports.recipe = require("./recipe");
exports.social = require("./social");
exports.cookbook = require("./cookbook");
exports.favourite = require("./favourite");
