import { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import { Plus, Edit, Trash2, Building2, Users } from 'lucide-react'
import departmentsService from '../../services/departments.service.js'
import toast from 'react-hot-toast'

const DepartmentList = () => {
  const [departments, setDepartments] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchDepartments()
  }, [])

  const fetchDepartments = async () => {
    try {
      const response = await departmentsService.getAll()
      setDepartments(response.data)
    } catch (error) {
      toast.error('Failed to fetch departments')
    } finally {
      setLoading(false)
    }
  }

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this department?')) return

    try {
      await departmentsService.delete(id)
      toast.success('Department deleted successfully')
      fetchDepartments()
    } catch (error) {
      toast.error(error.response?.data?.message || 'Failed to delete department')
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-2xl font-semibold text-gray-900">Departments</h1>
        <Link
          to="/departments/create"
          className="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 flex items-center gap-2"
        >
          <Plus className="h-5 w-5" />
          Add Department
        </Link>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {departments.map((dept) => (
          <div key={dept.id} className="bg-white rounded-lg shadow-sm p-6">
            <div className="flex items-start justify-between">
              <div className="flex items-center gap-3">
                <div className="bg-blue-100 p-3 rounded-lg">
                  <Building2 className="h-6 w-6 text-blue-600" />
                </div>
                <div>
                  <h3 className="font-semibold text-gray-900">{dept.name}</h3>
                  <p className="text-sm text-gray-500">Code: {dept.code}</p>
                </div>
              </div>
              <div className="flex gap-2">
                <Link
                  to={`/departments/${dept.id}/edit`}
                  className="text-yellow-600 hover:text-yellow-900"
                >
                  <Edit className="h-5 w-5" />
                </Link>
                <button
                  onClick={() => handleDelete(dept.id)}
                  className="text-red-600 hover:text-red-900"
                >
                  <Trash2 className="h-5 w-5" />
                </button>
              </div>
            </div>

            {dept.description && (
              <p className="mt-4 text-sm text-gray-600">{dept.description}</p>
            )}

            <div className="mt-4 pt-4 border-t flex items-center gap-2">
              <Users className="h-4 w-4 text-gray-400" />
              <span className="text-sm text-gray-600">
                {dept.users_count} {dept.users_count === 1 ? 'Employee' : 'Employees'}
              </span>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}

export default DepartmentList