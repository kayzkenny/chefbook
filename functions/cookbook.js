const admin = require("firebase-admin");
const functions = require("firebase-functions");

const increment = admin.firestore.FieldValue.increment(1);
const decrement = admin.firestore.FieldValue.increment(-1);

/**
 * Firestore trigger for (create cookbook)
 * @returns {Promise}
 */
exports.onCreated = functions.firestore
    .document("cookbooks/{cookbookId}")
    .onCreate((snapshot) => {
    const data = snapshot.data();
    const uid = data.createdBy;
    
    const userRef = admin
        .firestore()
        .collection("users")
        .doc(uid);

    return incrementUserCookbookCount = userRef
        .update({ cookbookCount: increment }).then(() => {
        console.log("Incremented user cookbook count");
    });
});

/**
 * Firestore trigger for (delete cookbook)
 * @returns {Promise}
 */
exports.onDeleted = functions.firestore
    .document("cookbooks/{cookbookId}")
    .onDelete(async (snapshot) => {
    const data = snapshot.data();
    const uid = data.createdBy;
    const cookbookId = data.cookbookId;
    const recipesToDelete = [];

    const recipesRef = admin
        .firestore()
        .collection("recipes");

    const userRef = admin
        .firestore()
        .collection("users")
        .doc(uid);

    const recipesSnapshot = await recipesRef
        .where('cookbookId', '==', cookbookId).get();

    const decrementUserCookbookCount = userRef
        .update({ cookbookCount: decrement }).then(() => {
        console.log("Decremented user cookbook count");
    });

    if (recipesSnapshot.docs.length > 0) {
        recipesSnapshot.docs.forEach(doc => {
            var recipeId = doc.id;
            recipesToDelete.push(recipesRef.doc(recipeId).delete());
        });

        return Promise.all([...recipesToDelete, decrementUserCookbookCount])
            .then(() => {
            console.log("Successfully deleted recipes");
        });
    }

    return Promise.resolve().then(() => {
        console.log("No recipes to delete...");
    });        
});