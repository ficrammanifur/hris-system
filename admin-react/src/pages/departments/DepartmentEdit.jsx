import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import DepartmentForm from '../../components/forms/DepartmentForm.jsx'
import departmentsService from '../../services/departments.service.js'
import toast from 'react-hot-toast'

const DepartmentEdit = () => {
  const { id } = useParams()
  const navigate = useNavigate()
  const [department, setDepartment] = useState(null)
  const [loading, setLoading] = useState(true)
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    fetchDepartment()
  }, [id])

  const fetchDepartment = async () => {
    try {
      const response = await departmentsService.getById(id)
      setDepartment(response.data)
    } catch (error) {
      toast.error('Failed to fetch department')
      navigate('/departments')
    } finally {
      setLoading(false)
    }
  }

  const handleSubmit = async (data) => {
    setSubmitting(true)
    try {
      await departmentsService.update(id, data)
      toast.success('Department updated successfully')
      navigate('/departments')
    } catch (error) {
      toast.error(error.response?.data?.message || 'Failed to update department')
    } finally {
      setSubmitting(false)
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
      <h1 className="text-2xl font-semibold text-gray-900">Edit Department</h1>

      <div className="bg-white rounded-lg shadow-sm p-6">
        <DepartmentForm
          initialData={department}
          onSubmit={handleSubmit}
          loading={submitting}
          buttonText="Update Department"
        />
      </div>
    </div>
  )
}

export default DepartmentEdit