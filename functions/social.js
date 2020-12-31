const admin = require("firebase-admin");
const functions = require("firebase-functions");

const increment = admin.firestore.FieldValue.increment(1);
const decrement = admin.firestore.FieldValue.increment(-1);
const arrayRemove = admin.firestore.FieldValue.arrayRemove;

// /**
//  * Firestore trigger for (create follower object)
//  * @returns {Promise}
//  */
// exports.onCreated = functions.firestore
//   .document("users/{uid}/following/{followerId}")
//   .onCreate((snapshot) => {
//   const data = snapshot.data();
//   const followerId = snapshot.id;
//   const addedBy = data.addedBy; // kenny uid

//   // user who followed taiwo (kenny)
//   const userWhoFollowedRef = admin
//     .firestore()
//     .collection("users")
//     .doc(addedBy);

//   // user who followed (taiwo's uid)
//   const followedRef = admin
//     .firestore()
//     .collection("users")
//     .doc(followerId);

//   // users kenny is following
//   const followingRef = admin
//     .firestore()
//     .collection("users")
//     .doc(addedBy)
//     .collection("following")
//     .doc(followerId);

//   // Kenny’s user data get added taiwo’s followers collection
//   const addToUserFollowing = followingRef
//     .set(data).then(() => {
//       console.log("Add user to following collecion");
//   });

//   // Taiwo’s followerCount get incremented
//   const incrementFollowerCount = followedRef
//     .update({ followerCount: increment }).then(() => {
//       console.log("Incremented user follower count");
//   });

//   // Kenny’s followingCount get incremented
//   const incrementFollowingCount = userWhoFollowedRef
//     .update({ followingCount: increment }).then(() => {
//       console.log("Incremented user following count");
//   });

//   return Promise.all([
//     addToUserFollowing,
//     incrementFollowerCount,
//     incrementFollowingCount,
//   ]);
// });

// /**
//  * Firestore trigger for (delete follower object)
//  * @returns {Promise}
//  */
// exports.onDeleted = functions.firestore
//   .document("users/{uid}/following/{followerId}")
//   .onDelete((snapshot) => {
//   const data = snapshot.data();
//   const followerId = snapshot.id;
//   const addedBy = data.addedBy; // kenny uid

//   // user who followed taiwo (kenny)
//   const userWhoFollowedRef = admin
//     .firestore()
//     .collection("users")
//     .doc(addedBy);

//   // user who followed (taiwo's uid)
//   const followedRef = admin
//     .firestore()
//     .collection("users")
//     .doc(followerId);

//   // users kenny is following
//   const followingRef = admin
//     .firestore()
//     .collection("users")
//     .doc(addedBy)
//     .collection("following")
//     .doc(followerId);

//   // Taiwo’s user data gets removed to kenny’s following collection
//   const removeFromUserFollowing = followingRef
//     .delete().then(() => {
//       console.log("Remove user from following collecion");
//   });

//   // Taiwo’s followerCount get decremented
//   const decrementFollowerCount = followedRef
//     .update({ followerCount: decrement }).then(() => {
//       console.log("Incremented user follower count");
//   });

//   // Kenny’s followingCount get incremented
//   const decrementFollowingCount = userWhoFollowedRef
//     .update({ followingCount: decrement }).then(() => {
//       console.log("Incremented user following count");
//   });

//   return Promise.all([
//     removeFromUserFollowing,
//     decrementFollowerCount,
//     decrementFollowingCount,
//   ]);
// });

/**
 * Triggers when a user gets a new follower and sends a notification.
 *
 * Followers add a flag to `/followers/{followedUid}/users/{followerUid}`.
 * Users save their device notification tokens to 
 * `/users/{followedUid}/notificationTokens/{notificationToken}`.
 */

exports.onUnfollow = functions.firestore
  .document("/followers/{followedUid}/users/{followerUid}")
  .onDelete(async (snapshot, context) => {
  const followerUid = context.params.followerUid; // kenny
  const followedUid = context.params.followedUid; // taiwo

  const followerRef = admin.firestore().collection("users").doc(followerUid);
  const followedRef = admin.firestore().collection("users").doc(followedUid);
  // If un-follow we exit the function.
  // kenny unfollows taiwo
  console.log('User ', followerUid, 'un-followed user', followedUid);

  const followingRef = admin
    .firestore()
    .collection("following")
    .doc(followerUid)
    .collection("users")
    .doc(followedUid);

  // Taiwo’s user data gets removed to kenny’s following collection
  const removeFromUserFollowing = followingRef
    .delete()
    .then(() => console.log("Remove user from following collecion"));

  // Taiwo’s followerCount get decremented
  const decrementFollowerCountPromise = followerRef
    .update({ followerCount: decrement })
    .then(() => console.log("Decremented user follower count"));
  // Kenny’s followingCount get decremented
  const decrementFollowingCountPromise = followedRef
    .update({ followingCount: decrement })
    .then(() => console.log("Decremented user following count"));

  return Promise.all([
    removeFromUserFollowing,
    decrementFollowerCountPromise,
    decrementFollowingCountPromise,
  ]);
}); 

exports.onFollow = functions.firestore
  .document("/followers/{followedUid}/users/{followerUid}")
  .onCreate(async (snapshot, context) => {
  const data = snapshot.data();
  // kenny follows taiwo
  const followerUid = context.params.followerUid; // kenny
  const followedUid = context.params.followedUid; // taiwo

  const followerRef = admin.firestore().collection("users").doc(followerUid);
  const followedRef = admin.firestore().collection("users").doc(followedUid);
  // kenny follows taiwo
  console.log('We have a new follower UID:', followerUid, 'for user:', followedUid);

  const followingRef = admin
    .firestore()
    .collection("following")
    .doc(followerUid)
    .collection("users")
    .doc(followedUid);

  // Kenny’s user data get added taiwo’s followers collection
  const addToUserFollowing = followingRef
    .set(data)
    .then(() => console.log("Add user to following collecion"));

  // Taiwo’s followerCount get incremented
  const incrementFollowerCountPromise = followerRef
    .update({ followerCount: increment })
    .then(() => console.log("Incremented user follower count"));
  // Kenny’s followingCount get incremented
  const incrementFollowingCountPromise = followedRef
    .update({ followingCount: increment })
    .then(() => console.log("Incremented user following count"));

  await Promise.all([
    addToUserFollowing,
    incrementFollowerCountPromise,
    incrementFollowingCountPromise,
  ]);

  // Get the follower profile.
  const followedProfile = await followedRef.get();

  // The array containing all the user's tokens.
  let tokens = followedProfile.notificationTokens;

  // Check if there are any device tokens.
  if (!tokens || tokens.length == 0) {
    return console.log('There are no notification tokens to send to.');
  }
  console.log('There are', tokens.length, 'tokens to send notifications to.');
  console.log('Fetched follower profile', follower.firstName);

  // Notification details.
  const payload = {
    notification: {
      title: 'You have a new follower!',
      body: `${follower.firstName} is now following you.`,
      icon: follower.avatar
    }
  };

  // Send notifications to all tokens.
  const response = await admin.messaging().sendToDevice(tokens, payload);
  // For each message check if there was an error.
  const tokensToRemove = [];
  response.results.forEach((result, index) => {
    const error = result.error;
    if (error) {
      console.error('Failure sending notification to', tokens[index], error);
      // Cleanup the tokens who are not registered anymore.
      if (error.code === 'messaging/invalid-registration-token' ||
          error.code === 'messaging/registration-token-not-registered') {
        tokensToRemove.push(
          // followedRef.collection("notificationTokens").doc(tokens[index]).delete()
          followedRef.update({notificationTokens: arrayRemove(tokens[index])})
        );
      }
    }
  });
  return Promise.all(tokensToRemove);
});