import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import '../../css/main.css';
import '../../css/util.css';
import logoSvg from '../../images/logo.svg';
import useAuth from '../hooks/useAuth';
import { getFirestore, doc, getDocs, collection, updateDoc } from '@firebase/firestore'
import { initializeApp } from "firebase/app";
import firebaseConfig from '../Firebase/firebase.config';
import { ThreeDotLoader } from '../ThreeDotLoader/ThreeDotLoader';
// import { toast } from "react-toastify";
// import { ToastContainer, toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
export const Delay = () => {
    const navigate = useNavigate();
    const { logOut } = useAuth();

    const [stationList, setStationList] = React.useState([]);
    const [station, setStation] = React.useState('Bus_1');
    const [timeSchedule, setTimeSchedule] = React.useState(false);
    const [loading, setLoading] = React.useState(false);
    const app = initializeApp(firebaseConfig);
    const db = getFirestore(app);

    React.useEffect(() => {
        getDocsData();
        // eslint-disable-next-line
    }, []);

    const getDocsData = async () => {
        const colRef = collection(db, "Bus_Station");
        const docsSnap = await getDocs(colRef);
        const dockData = docsSnap.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        setStationList(dockData);
    }

    const updateFireStoreData = async (e) => {
        e.preventDefault()
        setLoading(true);
        const docRef = doc(db, "Bus_Station", station);
        await updateDoc(docRef, {
            OnTime: timeSchedule === 'true' ? true : false
        }).then(() => {
            setLoading(false);
            // toast.success('Updated successfully.', {
            //     position: toast.POSITION.BOTTOM_LEFT,
            // });
            alert('Updated successfully.');
            setTimeSchedule(false);
            setStation('');
        })
            .catch((error) => {
                console.error("Error updating document: ", error);
            });
    }
    return (
        <>
            <div>

                <section className="header_req">`
                    <nav>
                        <Link to="/"><img id="logo" src={logoSvg} alt="" /></Link>
                        <div className="nav-links" id="logout_div">
                            <ul>
                                <li><Link to="/">Home</Link></li>
                                <li>{
                                    // eslint-disable-next-line
                                    <a href="#" onClick={() => logOut(navigate)}>Log Out</a>}</li>
                            </ul>
                        </div>
                    </nav>
                </section>
                <main>

                    <div className="Add_form">
                        <h1>Announce Delay</h1>
                        <form onSubmit={updateFireStoreData}>
                            <div className="section"><span className="num">1</span>
                            List Of Bus Stations
                            </div>
                            <div className="inner-wrap">
                                <select name="" id="" required onClick={({ target }) => setStation(target.value)} >
                                    <option value="" disabled >Select your option</option>
                                    {
                                        stationList.map((station, index) => (<option key={index} value={station.id} >
                                            {station.Name} {station.Number}</option>))
                                    }
                                </select>
                            </div>

                            <div className="section"><span className="num">2</span>Status</div>

                            <div className="inner-wrap">
                                <select name="services" id="services" required onClick={({ target }) => setTimeSchedule(target.value)} >
                                    <option value="" disabled >
                                        Select your option
                                    </option>
                                    <option value="true">On time</option>
                                    <option value="false">Delayed</option>
                                </select>
                            </div>

                            <div className="button-section" style={{
                                cursor: loading ? 'not-allowed' : 'pointer'
                            }}>
                                <br />
                                {
                                    loading ? <ThreeDotLoader /> : <input type="submit" value="Announce" />
                                }

                                <br />
                            </div>
                        </form>
                    </div>
                    <br /> <br /> <br /><br /><br />


                </main>
            </div >
        </>
    )
}
