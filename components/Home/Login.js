import React, { useEffect, useState } from 'react'
import bg from '../../images/bg-01.jpg'
import '../../css/main.css'
import '../../css/util.css'
import useAuth from '../hooks/useAuth'
import { useLocation, useNavigate } from 'react-router';
import { ThreeDots } from 'react-loader-spinner';

export const Login = () => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const { signInWithEmailPassword } = useAuth();
    const [loader, setLoader] = useState(false);
    const [, setErrorMessage] = useState('');
    const navigate = useNavigate();
    const location = useLocation();
    const handleSubmit = (e) => {
        setLoader(true)
        if (email && password) {
            signInWithEmailPassword(email, password, navigate, location, setLoader, setErrorMessage)
        }
        e.preventDefault()
    }

    useEffect(() => {
        if (localStorage.getItem('token')) {
            navigate('/')
        }
        // eslint-disable-next-line
    }, [window.location.pathname, navigate])
    return (
        <>
            <div className="limiter">
                <div className="container-login100" style={{
                    backgroundImage: `url(${bg})`
                }}>
                    <div className="wrap-login100 p-t-30 p-b-50">
                        <span className="login100-form-title p-b-41">
                            Admin Login
                        </span>
                        <form className="login100-form validate-form p-b-33 p-t-5" id="login_div" onSubmit={handleSubmit}>

                            <div className="wrap-input100 validate-input" data-validate="Enter username">
                                <input className="input100" type="text" value={email} onChange={({ target }) => setEmail(target.value)} name="email" placeholder="Admin email" id="email_fild" required />
                                <span className="focus-input100" data-placeholder="&#xe82a;"></span>
                            </div>

                            <div className="wrap-input100 validate-input" data-validate="Enter password">
                                <input className="input100" type="password" value={password} onChange={({ target }) => setPassword(target.value)} name="password" placeholder="Admin password" id="pass_fild" required />
                                <span className="focus-input100" data-placeholder="&#xe80f;"></span>
                            </div>

                            <div className="container-login100-form-btn m-t-32">
                                <button className="login100-form-btn" id="submitData" style={{
                                    cursor: loader ? 'not-allowed' : 'pointer'
                                }} >
                                    {
                                        loader ? <ThreeDots
                                            height={30}
                                            width={50}
                                            radius="9"
                                            color={'#fff'}
                                            ariaLabel="three-dots-loading"
                                            wrapperStyle={{
                                                display: 'flex',
                                                justifyContent: 'center',
                                            }}
                                            wrapperClassName="three-dots-loading"
                                            visible={true}
                                        /> : 'Login'
                                    }
                                </button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>


            <div id="dropDownSelect1"></div>
        </>
    )
}
