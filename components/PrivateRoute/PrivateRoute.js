import React from "react";
import { Navigate } from 'react-router-dom';
const PrivateRoute = ({ children }) => {
    const token = localStorage.getItem('token')
    function parseJwt() {
        var base64Url = token.split('.')[1];
        var base64 = base64Url?.replace(/-/g, '+').replace(/_/g, '/');
        var jsonPayload = decodeURIComponent(window.atob(base64).split('').map(function (c) {
            return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
        }).join(''));

        return JSON.parse(jsonPayload);
    }

    if(!token) {
        return <Navigate to='/login' />
    }
    else if (parseJwt()?.email === process.env.REACT_APP_ADMIN_EMAIL) {
        console.log('Hello');
        return children
    } else {
        <Navigate to='/login' />
    }

};
export default PrivateRoute;