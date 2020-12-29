const admin = require("firebase-admin");
const functions = require("firebase-functions");

const increment = admin.firestore.FieldValue.increment(1);
const decrement = admin.firestore.FieldValue.increment(-1);

/**
 * Firestore trigger for (new recipe favourite creation)
 * @returns {Promise}
 */
exports.onCreated = functions.firestore
  .document("users/{uid}/favourites/{recipeId}")
  .onCreate(async (snapshot) => {
  const recipeId = snapshot.id;

  const recipeRef = admin
    .firestore()
    .collection("recipes")
    .doc(recipeId);

  return await recipeRef.update({ favouritesCount: increment })
    .then(() => {
    console.log("Decremented user recipe count")
  });
});

/**
 * Firestore trigger for (new recipe deletion)
 * @returns {Promise}
 */
exports.onDeleted = functions.firestore
  .document("users/{uid}/favourites/{recipeId}")
  .onDelete(async (snapshot) => {
  const recipeId = snapshot.id;

  const recipeRef = admin
    .firestore()
    .collection("recipes")
    .doc(recipeId);

  return await recipeRef.update({ favouritesCount: decrement })
    .then(() => {
    console.log("Decremented user recipe count")
  });
});