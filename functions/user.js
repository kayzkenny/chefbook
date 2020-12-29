const admin = require("firebase-admin");
const functions = require("firebase-functions");

const increment = admin.firestore.FieldValue.increment(1);
const decrement = admin.firestore.FieldValue.increment(-1);

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

/**
 * Firestore trigger for (create follower object)
 * @returns {Promise}
 */
exports.onCreated = functions.firestore
  .document("users/{uid}/following/{followerId}")
  .onCreate((snapshot) => {
  const data = snapshot.data();
  const followerId = snapshot.id;
  const addedBy = data.addedBy; // kenny uid

  // user who followed taiwo (kenny)
  const userWhoFollowedRef = admin
    .firestore()
    .collection("users")
    .doc(addedBy);

  // user who followed (taiwo's uid)
  const followedRef = admin
    .firestore()
    .collection("users")
    .doc(followerId);

  // users kenny is following
  const followingRef = admin
    .firestore()
    .collection("users")
    .doc(addedBy)
    .collection("following")
    .doc(followerId);

  // Kenny’s user data get added taiwo’s followers collection
  const addToUserFollowing = followingRef
    .set(data).then(() => {
      console.log("Add user to following collecion");
  });

  // Taiwo’s followerCount get incremented
  const incrementFollowerCount = followedRef
    .update({ followerCount: increment }).then(() => {
      console.log("Incremented user follower count");
  });

  // Kenny’s followingCount get incremented
  const incrementFollowingCount = userWhoFollowedRef
    .update({ followerCount: increment }).then(() => {
      console.log("Incremented user follower count");
  });

  return Promise.all([
    addToUserFollowing,
    incrementFollowerCount,
    incrementFollowingCount,
  ]);
});

/**
 * Firestore trigger for (delete follower object)
 * @returns {Promise}
 */
exports.onDeleted = functions.firestore
  .document("users/{uid}/following/{followerId}")
  .onCreate((snapshot) => {
  const data = snapshot.data();
  const followerId = snapshot.id;
  const addedBy = data.addedBy; // kenny uid

  // user who followed taiwo (kenny)
  const userWhoFollowedRef = admin
    .firestore()
    .collection("users")
    .doc(addedBy);

  // user who followed (taiwo's uid)
  const followedRef = admin
    .firestore()
    .collection("users")
    .doc(followerId);

  // users kenny is following
  const followingRef = admin
    .firestore()
    .collection("users")
    .doc(addedBy)
    .collection("following")
    .doc(followerId);

  // Taiwo’s user data gets removed to kenny’s following collection
  const removeFromUserFollowing = followingRef
    .delete().then(() => {
      console.log("Remove user from following collecion");
  });

  // Taiwo’s followerCount get decremented
  const decrementFollowerCount = followedRef
    .update({ followerCount: decrement }).then(() => {
      console.log("Incremented user follower count");
  });

  // Kenny’s followingCount get incremented
  const decrementFollowingCount = userWhoFollowedRef
    .update({ followerCount: decrement }).then(() => {
      console.log("Incremented user follower count");
  });

  return Promise.all([
    removeFromUserFollowing,
    decrementFollowerCount,
    decrementFollowingCount,
  ]);
});