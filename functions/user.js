const admin = require("firebase-admin");
const functions = require("firebase-functions");

/**
 * Auth trigger for (new user sign up)
 * @returns {Promise}
 */
exports.onCreated = functions.auth.user().onCreate(async (user) => {
    const doc = admin.firestore().collection("users").doc(user.uid);
    return doc.set({
      email: user.email,
    }).then(() => {
      console.log("User created successfully");
    });
});

/**
 * Auth trigger for (new user deletion)
 * @returns {Promise}
 */
exports.onDeleted = functions.auth.user().onDelete(async (user) => {
    const doc = admin.firestore().collection("users").doc(user.uid);
    return doc.delete().then(() => {
      console.log("User deleted successfully");
    });
  });