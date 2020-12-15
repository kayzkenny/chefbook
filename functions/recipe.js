const apiKeys = require("./api_keys");
const admin = require("firebase-admin");
const algoliasearch = require("algoliasearch");
const functions = require("firebase-functions");
// Initialize Algolia Client
const APP_ID = apiKeys.APP_ID;
const ADMIN_KEY = apiKeys.ADMIN_KEY;
const client = algoliasearch(APP_ID, ADMIN_KEY);
const index = client.initIndex("chef-book-recipes");

/**
 * Firestore trigger for (new recipe creation)
 * @returns {Promise}
 */
exports.onCreated = functions.firestore
  .document("recipes/{recipeId}")
  .onCreate((snapshot) => {
    const data = snapshot.data();
    const objectID = snapshot.id;

  return index
    .saveObject({ ...data, objectID })
    .then(() => {
      console.log("Added recipe to algolia index");
    });
});

/**
 * Firestore trigger for (update recipe object)
 * @returns {Promise}
 */
exports.onUpdated = functions.firestore
  .document("recipes/{recipeId}")
  .onUpdate((change) => {
    const newData = change.after.data();
    const objectID = change.after.id;

  return index.saveObject({ ...newData, objectID }).then(() => {
    console.log("Updated recipe in algolia index");
  });
});

/**
 * Firestore trigger for (delete recipe object)
 * @returns {Promise}
 */
exports.onDeleted = functions.firestore
  .document("recipes/{recipeId}")
  .onDelete((snapshot) => {
    const objectID = snapshot.id;

  return index.deleteObject(objectID).then(() => {
    console.log("Deleted recipe in algolia index");
  });
});