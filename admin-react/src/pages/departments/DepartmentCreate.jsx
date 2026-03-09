import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import DepartmentForm from '../../components/forms/DepartmentForm.jsx'
import departmentsService from '../../services/departments.service.js'
import toast from 'react-hot-toast'

const DepartmentCreate = () => {
  const navigate = useNavigate()
  const [loading, setLoading] = useState(false)

  const handleSubmit = async (data) => {
    setLoading(true)
    try {
      await departmentsService.create(data)
      toast.success('Department created successfully')
      navigate('/departments')
    } catch (error) {
      toast.error(error.response?.data?.message || 'Failed to create department')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold text-gray-900">Add New Department</h1>

      <div className="bg-white rounded-lg shadow-sm p-6">
        <DepartmentForm
          onSubmit={handleSubmit}
          loading={loading}
          buttonText="Create Department"
        />
      </div>
    </div>
  )
}

export default DepartmentCreate