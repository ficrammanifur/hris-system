import { Outlet } from 'react-router-dom'
import { useEffect } from 'react'
import { useAuth } from '../hooks/useAuth.js'
import { useNavigate } from 'react-router-dom'

const AuthLayout = () => {
  const { user } = useAuth()
  const navigate = useNavigate()

  useEffect(() => {
    if (user) {
      navigate('/dashboard')
    }
  }, [user, navigate])

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="max-w-md w-full">
        <Outlet />
      </div>
    </div>
  )
}

export default AuthLayout