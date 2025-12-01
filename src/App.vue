<script setup>
import { initializeApp } from "firebase/app";
import {getAuth, GoogleAuthProvider, signInWithRedirect, getRedirectResult} from "firebase/auth";
import { onMounted } from "vue";
const firebaseConfig = {
  apiKey: "AIzaSyApeT_XVx-zKvIXi3t6R3oYCzkdSYybB20",
  authDomain: "bellaalbum.firebaseapp.com",
  projectId: "bellaalbum",
  storageBucket: "bellaalbum.firebasestorage.app",
  messagingSenderId: "368926442874",
  appId: "1:368926442874:web:1bf3d3995f46dc0780c2c3",
  measurementId: "G-E7HKY693WX"
};
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
async function onLogin(){
  const provider = new GoogleAuthProvider();
  try {
    signInWithRedirect(auth, provider);
  } catch (error) {
    console.error('Error during sign-in:', error);
  }
}
onMounted(async ()=>{
  try {
    const result = await getRedirectResult(auth);
    if (result?.user) {
      console.log('User signed in:', result.user);
    } else {
      console.log('No redirect result available.');
    }
  } catch (error) {
    console.error('Error getting redirect result:', error);
  }
});
</script>

<template>
  <button @click="onLogin">Login</button>
</template>

<style scoped></style>
