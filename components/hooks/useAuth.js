import { useContext } from "react";
import { collectionContext } from "../../App";

const useAuth = () => {
    const { auth } = useContext(collectionContext);
    return auth;
}

export default useAuth;