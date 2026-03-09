import { useState } from 'react'
import { useAuth } from '../../hooks/useAuth.js'
import { useNavigate } from 'react-router-dom'

const Login = () => {
  const [email, setEmail] = useState('admin@example.com')
  const [password, setPassword] = useState('password')
  const [loading, setLoading] = useState(false)
  const { login } = useAuth()
  const navigate = useNavigate()

  const handleSubmit = async (e) => {
    e.preventDefault()
    setLoading(true)
    
    const result = await login(email, password)
    if (result.success) {
      navigate('/dashboard')
    }
    
    setLoading(false)
  }

  return (
    <div className="bg-white rounded-lg shadow-lg p-8">
      <div className="text-center mb-8">
        <h1 className="text-2xl font-bold text-gray-900">HRIS Admin</h1>
        <p className="text-gray-600 mt-2">Sign in to your account</p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-6">
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Email Address
          </label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
          />
        </div>

        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Password
          </label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            required
          />
        </div>

        <button
          type="submit"
          disabled={loading}
          className="w-full bg-blue-500 text-white py-2 px-4 rounded-lg hover:bg-blue-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {loading ? 'Signing in...' : 'Sign In'}
        </button>
      </form>

      <div className="mt-6 text-center text-sm text-gray-500">
        <p>Demo credentials:</p>
        <p>Email: admin@example.com</p>
        <p>Password: password</p>
      </div>
    </div>
  )
}

export default Login