import React from 'react'
import { ThreeDots } from 'react-loader-spinner';
import './ThreeDotLoader.css'
export const ThreeDotLoader = ({ width = 50, height = 30, color = '#fff' }) => {
    return (
        <div className='three-dots-loading'>
            <ThreeDots
                height={height}
                width={width}
                radius="9"
                color={color}
                ariaLabel="three-dots-loading"
                wrapperStyle={{
                    display: 'flex',
                    justifyContent: 'center',
                }}
                wrapperClassName="three-dots-loading"
                visible={true}
            />
        </div>

    )
}
