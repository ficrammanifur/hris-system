import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { useEmployees } from '../../hooks/useEmployees.js'
import EmployeeForm from '../../components/forms/EmployeeForm.jsx'
import toast from 'react-hot-toast'

const EmployeeEdit = () => {
  const { id } = useParams()
  const navigate = useNavigate()
  const { getEmployee, updateEmployee, loading } = useEmployees()
  const [employee, setEmployee] = useState(null)
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    fetchEmployee()
  }, [id])

  const fetchEmployee = async () => {
    try {
      const data = await getEmployee(id)
      setEmployee(data)
    } catch (error) {
      toast.error('Failed to fetch employee details')
      navigate('/employees')
    }
  }

  const handleSubmit = async (data) => {
    setSubmitting(true)
    try {
      await updateEmployee(id, data)
      toast.success('Employee updated successfully')
      navigate('/employees')
    } catch (error) {
      console.error('Failed to update employee:', error)
    } finally {
      setSubmitting(false)
    }
  }

  if (loading || !employee) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-2xl font-semibold text-gray-900">Edit Employee</h1>
      </div>

      <div className="bg-white rounded-lg shadow-sm p-6">
        <EmployeeForm
          initialData={employee}
          onSubmit={handleSubmit}
          loading={submitting}
          buttonText="Update Employee"
        />
      </div>
    </div>
  )
}

export default EmployeeEdit