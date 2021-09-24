importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.15.5/firebase-messaging.js");

//Using singleton breaks instantiating messaging()
// App firebase = FirebaseWeb.instance.app;


firebase.initializeApp({
	apiKey: "AIzaSyBGGLqULQwvMosxKFqVjfFrrhVieas6fTk",
	authDomain: "flutter-web-rebuild-issue.firebaseapp.com",
	projectId: "flutter-web-rebuild-issue",
	storageBucket: "flutter-web-rebuild-issue.appspot.com",
	messagingSenderId: "828518094230",
	appId: "1:828518094230:web:5eac05b82491a1a698b9b7",
	measurementId: "G-T6F53ZLSDF"
});

const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});