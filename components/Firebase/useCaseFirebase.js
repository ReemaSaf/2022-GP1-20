import { useState, useEffect } from 'react';
import { getAuth, signInWithEmailAndPassword, onAuthStateChanged, getIdToken, signOut } from "firebase/auth";
import initializeAuth from "./firebase.init";

initializeAuth();

const useCaseFirebase = () => {
    const [user, setUser] = useState({});
    const auth = getAuth();
    const [reload, setReload] = useState(false);

    const logOut = (navigate) => {
        signOut(auth)
            .then(() => {
                // setUser({});
                localStorage.removeItem('token');
                navigate('/login');
            })
            .catch((error) => {
                console.log(error.message);
            })
    }


    const signInWithEmailPassword = (
        email,
        password,
        navigate,
        location,
        setLoader
    ) => {

        signInWithEmailAndPassword(auth, email, password)
            .then((res) => {
                const newUser = { ...user };
                newUser.email = email;
                newUser.password = password;
                setReload(true);
                setLoader(false)
                const redirect = location?.state?.from || "/";
                if (res.user.email === process.env.REACT_APP_ADMIN_EMAIL) {
                    localStorage.setItem('token', res.user.accessToken);
                    navigate(redirect);
                } else {
                    alert("Sorry you don't have access the system.");
                    navigate('/login');
                }
                


            })

            .catch((error) => {
                setLoader(false)
                alert('Sorry! Your password or email does not match.')
            })
    };
    useEffect(() => {
        const unsubscribe = onAuthStateChanged(auth, (user) => {
            if (user?.emailVerified) {
                getIdToken(user)
                    .then(idToken => localStorage.setItem('cashew-token', idToken));
                setUser(user);
            }
            else {
                setUser({});
            }
        });
        setReload(false);
        return () => unsubscribe;
    }, [reload, auth])

    return {
        user,
        signInWithEmailPassword,
        logOut
    }
}


export default useCaseFirebase;