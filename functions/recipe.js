const apiKeys = require("./api_keys");
const admin = require("firebase-admin");
const algoliasearch = require("algoliasearch");
const functions = require("firebase-functions");

const APP_ID = apiKeys.APP_ID;
const ADMIN_KEY = apiKeys.ADMIN_KEY;
const client = algoliasearch(APP_ID, ADMIN_KEY);
const index = client.initIndex("chef-book-recipes");

const increment = admin.firestore.FieldValue.increment(1);
const decrement = admin.firestore.FieldValue.increment(-1);

/**
 * Firestore trigger for (new recipe creation)
 * @returns {Promise}
 */
exports.onCreated = functions.firestore
  .document("recipes/{recipeId}")
  .onCreate((snapshot) => {
  const data = snapshot.data();
  const objectID = snapshot.id;
  const uid = data.createdBy;
  const cookbookId = data.cookbookId;

  const cookbookDocumentRef = admin
    .firestore()
    .collection("cookbooks")
    .doc(cookbookId);

  const userDocumentRef = admin
    .firestore()
    .collection("users")
    .doc(uid);

  const incrementUserRecipeCount = userDocumentRef
    .update({ recipeCount: increment }).then(() => {
      console.log("Incremented user recipe count");
  });

  const incrementCookbookRecipeCount = cookbookDocumentRef
    .update({ recipeCount: increment }).then(() => {
      console.log("Incremented cookbook recipe count");
  });

  const addRecipeToIndex = index
    .saveObject({ ...data, objectID })
    .then(() => {
      console.log("Added recipe to algolia index");
  });

  return Promise.all([
    addRecipeToIndex, 
    incrementUserRecipeCount, 
    incrementCookbookRecipeCount,
  ]);
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
  const data = snapshot.data();
  const objectID = snapshot.id;
  const uid = data.createdBy;
  const cookbookId = data.cookbookId;

  const cookbookDocumentRef = admin
    .firestore()
    .collection("cookbooks")
    .doc(cookbookId);

  const userDocumentRef = admin
    .firestore()
    .collection("users")
    .doc(uid);

  const decrementUserRecipeCount = userDocumentRef
  .update({ recipeCount: decrement }).then(() => {
    console.log("Decremented user recipe count");
  });

  const decrementCookbookRecipeCount = cookbookDocumentRef
    .update({ recipeCount: decrement }).then(() => {
      console.log("Decremented cookbook recipe count");
  });

  const removeRecipeFromIndex = index
    .deleteObject(objectID)
    .then(() => {
      console.log("Deleted recipe in algolia index");
  });

  return Promise.all([
    removeRecipeFromIndex, 
    decrementUserRecipeCount, 
    decrementCookbookRecipeCount,
  ]);
});