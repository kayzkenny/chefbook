const admin = require("firebase-admin");
const functions = require("firebase-functions");

const increment = admin.firestore.FieldValue.increment(1);
const decrement = admin.firestore.FieldValue.increment(-1);
const arrayRemove = admin.firestore.FieldValue.arrayRemove;

exports.onUnfollow = functions.firestore
  .document("/following/{followerUid}/users/{followedUid}")
  .onDelete(async (snapshot, context) => {
  const followerUid = context.params.followerUid; // kenny
  const followedUid = context.params.followedUid; // taiwo

  const followerRef = admin.firestore().collection("users").doc(followerUid);
  const followedRef = admin.firestore().collection("users").doc(followedUid);
  // kenny unfollows taiwo
  console.log('User ', followerUid, 'un-followed user', followedUid);

  const followersRef = admin
    .firestore()
    .collection("followers")
    .doc(followedUid)
    .collection("users")
    .doc(followerUid);

  // Taiwo’s user data gets removed to kenny’s following collection
  const removeFromUserFollowers = followersRef
    .delete()
    .then(() => console.log("Remove user from following collecion"));

  // Taiwo’s followerCount get decremented
  const decrementFollowerCountPromise = followedRef
    .update({ followerCount: decrement })
    .then(() => console.log("Decremented user follower count"));
  // Kenny’s followingCount get decremented
  const decrementFollowingCountPromise = followerRef
    .update({ followingCount: decrement })
    .then(() => console.log("Decremented user following count"));

  return Promise.all([
    removeFromUserFollowers,
    decrementFollowerCountPromise,
    decrementFollowingCountPromise,
  ]);
}); 

exports.onFollow = functions.firestore
  .document("/following/{followerUid}/users/{followedUid}")
  .onCreate(async (snapshot, context) => {
  // kenny follows taiwo
  const followerUid = context.params.followerUid; // kenny
  const followedUid = context.params.followedUid; // taiwo

  const followerRef = admin.firestore().collection("users").doc(followerUid);
  const followedRef = admin.firestore().collection("users").doc(followedUid);
  // kenny follows taiwo
  console.log('We have a new follower UID:', followerUid, 'for user:', followedUid);

  const followerSnapshot = await followerRef.get(); // get kenny's userdata

  const followersRef = admin
    .firestore()
    .collection("followers")
    .doc(followedUid)
    .collection("users")
    .doc(followerUid);

  // Kenny’s user data get added taiwo’s followers collection
  const addToUserFollowers = followersRef
    .set(followerSnapshot.data())
    .then(() => console.log("Add user to followers collecion"));

  // Taiwo’s followerCount get incremented
  const incrementFollowerCountPromise = followedRef
    .update({ followerCount: increment })
    .then(() => console.log("Incremented user follower count"));
  // Kenny’s followingCount get incremented
  const incrementFollowingCountPromise = followerRef
    .update({ followingCount: increment })
    .then(() => console.log("Incremented user following count"));

  await Promise.all([
    addToUserFollowers,
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