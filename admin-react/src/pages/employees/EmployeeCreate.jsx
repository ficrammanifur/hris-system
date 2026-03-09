import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useEmployees } from '../../hooks/useEmployees.js'
import EmployeeForm from '../../components/forms/EmployeeForm.jsx'

const EmployeeCreate = () => {
  const navigate = useNavigate()
  const { createEmployee } = useEmployees()
  const [loading, setLoading] = useState(false)

  const handleSubmit = async (data) => {
    setLoading(true)
    try {
      await createEmployee(data)
      navigate('/employees')
    } catch (error) {
      console.error('Failed to create employee:', error)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-2xl font-semibold text-gray-900">Add New Employee</h1>
      </div>

      <div className="bg-white rounded-lg shadow-sm p-6">
        <EmployeeForm
          onSubmit={handleSubmit}
          loading={loading}
          buttonText="Create Employee"
        />
      </div>
    </div>
  )
}

export default EmployeeCreate