const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.profilePicChanged = functions.storage.object().onFinalize(async (object) => {
    const name = object.name.split('/')[1].split('.')[0];
    const metaData = object.mediaLink;
    console.log(`new profile Pic created: ${name}, ${metaData}`);
    // return Promise.resolve();
});