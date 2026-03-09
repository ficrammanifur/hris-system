import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import departmentsService from '../../services/departments.service.js'

const EmployeeForm = ({ initialData = {}, onSubmit, loading, buttonText }) => {
  const navigate = useNavigate()
  const [departments, setDepartments] = useState([])
  const [formData, setFormData] = useState({
    name: initialData.name || '',
    email: initialData.email || '',
    employee_id: initialData.employee_id || '',
    department_id: initialData.department_id || '',
    position: initialData.position || '',
    join_date: initialData.join_date || '',
    phone: initialData.phone || '',
    address: initialData.address || '',
    status: initialData.status || 'active',
    password: initialData.password || ''
  })

  useEffect(() => {
    fetchDepartments()
  }, [])

  const fetchDepartments = async () => {
    try {
      const response = await departmentsService.getAll()
      setDepartments(response.data)
    } catch (error) {
      console.error('Failed to fetch departments:', error)
    }
  }

  const handleChange = (e) => {
    const { name, value } = e.target
    setFormData(prev => ({ ...prev, [name]: value }))
  }

  const handleSubmit = (e) => {
    e.preventDefault()
    onSubmit(formData)
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Name */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Full Name *
          </label>
          <input
            type="text"
            name="name"
            value={formData.name}
            onChange={handleChange}
            required
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        {/* Email */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Email *
          </label>
          <input
            type="email"
            name="email"
            value={formData.email}
            onChange={handleChange}
            required
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        {/* Employee ID */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Employee ID *
          </label>
          <input
            type="text"
            name="employee_id"
            value={formData.employee_id}
            onChange={handleChange}
            required
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        {/* Department */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Department *
          </label>
          <select
            name="department_id"
            value={formData.department_id}
            onChange={handleChange}
            required
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Select Department</option>
            {departments.map(dept => (
              <option key={dept.id} value={dept.id}>{dept.name}</option>
            ))}
          </select>
        </div>

        {/* Position */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Position *
          </label>
          <input
            type="text"
            name="position"
            value={formData.position}
            onChange={handleChange}
            required
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        {/* Join Date */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Join Date *
          </label>
          <input
            type="date"
            name="join_date"
            value={formData.join_date}
            onChange={handleChange}
            required
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        {/* Phone */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Phone
          </label>
          <input
            type="text"
            name="phone"
            value={formData.phone}
            onChange={handleChange}
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        {/* Status */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Status
          </label>
          <select
            name="status"
            value={formData.status}
            onChange={handleChange}
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          >
            <option value="active">Active</option>
            <option value="inactive">Inactive</option>
          </select>
        </div>

        {/* Password (only for create) */}
        {!initialData.id && (
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Password *
            </label>
            <input
              type="password"
              name="password"
              value={formData.password}
              onChange={handleChange}
              required={!initialData.id}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
        )}

        {/* Address - Full width */}
        <div className="md:col-span-2">
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Address
          </label>
          <textarea
            name="address"
            value={formData.address}
            onChange={handleChange}
            rows="3"
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>
      </div>

      {/* Form Actions */}
      <div className="flex justify-end gap-4">
        <button
          type="button"
          onClick={() => navigate('/employees')}
          className="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50"
        >
          Cancel
        </button>
        <button
          type="submit"
          disabled={loading}
          className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 disabled:opacity-50"
        >
          {loading ? 'Processing...' : buttonText}
        </button>
      </div>
    </form>
  )
}

export default EmployeeForm