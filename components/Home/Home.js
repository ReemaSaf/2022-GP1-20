import React from 'react'
import logsvg from '../../images/logo.svg';
import '../../css/main.css'
import { Link, useNavigate } from 'react-router-dom';
import useAuth from '../hooks/useAuth';
export const Home = () => {
    const navigate = useNavigate();
    const { logOut } = useAuth()
    return (
        <div>

            <section className="header_req">`
                <nav>
                    <Link href="/"><img id="logo" src={logsvg} alt="" /></Link>
                    <div className="nav-links" id="logout_div">
                        <ul>
                            <li id="logout_btn">{
                                // eslint-disable-next-line
                                <a href="#" onClick={() => logOut(navigate)}>Log Out</a>}</li>
                        </ul>
                    </div>
                </nav>
            </section>

            <main>
                <div className="ro">
                    <div className="main-col">
                        <br />
                        <Link to="/delay" className="login100-form-btn">Announce A Delay </Link>
                        <br />
                    </div>

                    <div className="main-col">
                        <br />
                        <Link to="/availavility" className="login100-form-btn">Update Availability</Link>
                        <br />
                    </div>
                    <br /><br /><br /><br />
                </div>
            </main>


        </div>
    )
}
