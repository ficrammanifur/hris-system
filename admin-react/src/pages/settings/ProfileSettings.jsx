import { useState } from 'react'
import { useAuth } from '../../hooks/useAuth.js'
import { User, Mail, Phone, MapPin, Briefcase } from 'lucide-react'
import toast from 'react-hot-toast'

const ProfileSettings = () => {
  const { user } = useAuth()
  const [formData, setFormData] = useState({
    name: user?.name || '',
    phone: user?.phone || '',
    address: user?.address || ''
  })
  const [loading, setLoading] = useState(false)

  const handleSubmit = async (e) => {
    e.preventDefault()
    setLoading(true)
    // TODO: Implement profile update API
    setTimeout(() => {
      toast.success('Profile updated successfully')
      setLoading(false)
    }, 1000)
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold text-gray-900">Profile Settings</h1>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Profile Info */}
        <div className="lg:col-span-1">
          <div className="bg-white rounded-lg shadow-sm p-6">
            <div className="flex flex-col items-center">
              <div className="h-24 w-24 bg-blue-500 rounded-full flex items-center justify-center mb-4">
                <User className="h-12 w-12 text-white" />
              </div>
              <h2 className="text-xl font-semibold">{user?.name}</h2>
              <p className="text-gray-500">{user?.position}</p>
              <p className="text-sm text-gray-400 mt-1">Employee ID: {user?.employee_id}</p>

              <div className="w-full mt-6 space-y-3">
                <div className="flex items-center gap-3 text-gray-600">
                  <Mail className="h-4 w-4" />
                  <span className="text-sm">{user?.email}</span>
                </div>
                <div className="flex items-center gap-3 text-gray-600">
                  <Phone className="h-4 w-4" />
                  <span className="text-sm">{user?.phone || '-'}</span>
                </div>
                <div className="flex items-center gap-3 text-gray-600">
                  <Briefcase className="h-4 w-4" />
                  <span className="text-sm">{user?.department?.name}</span>
                </div>
                <div className="flex items-center gap-3 text-gray-600">
                  <MapPin className="h-4 w-4" />
                  <span className="text-sm">{user?.address || '-'}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Edit Form */}
        <div className="lg:col-span-2">
          <div className="bg-white rounded-lg shadow-sm p-6">
            <h2 className="text-lg font-semibold mb-6">Edit Profile</h2>
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Full Name
                </label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Phone
                </label>
                <input
                  type="text"
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Address
                </label>
                <textarea
                  value={formData.address}
                  onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                  rows="3"
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>

              <div className="flex justify-end">
                <button
                  type="submit"
                  disabled={loading}
                  className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 disabled:opacity-50"
                >
                  {loading ? 'Saving...' : 'Save Changes'}
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  )
}

export default ProfileSettings