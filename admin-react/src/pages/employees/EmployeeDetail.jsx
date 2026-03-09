import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { ArrowLeft, Mail, Phone, Calendar, MapPin, Briefcase, Building2, BadgeCheck } from 'lucide-react'
import { useEmployees } from '../../hooks/useEmployees.js'
import toast from 'react-hot-toast'

const EmployeeDetail = () => {
  const { id } = useParams()
  const navigate = useNavigate()
  const { getEmployee, loading } = useEmployees()
  const [employee, setEmployee] = useState(null)

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

  if (loading || !employee) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
      </div>
    )
  }

  const InfoItem = ({ icon: Icon, label, value }) => (
    <div className="flex items-start gap-3 p-4 bg-gray-50 rounded-lg">
      <div className="text-blue-500">
        <Icon className="h-5 w-5" />
      </div>
      <div>
        <p className="text-sm text-gray-500">{label}</p>
        <p className="font-medium text-gray-900">{value || '-'}</p>
      </div>
    </div>
  )

  return (
    <div className="space-y-6">
      <div className="flex items-center gap-4">
        <button
          onClick={() => navigate('/employees')}
          className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
        >
          <ArrowLeft className="h-5 w-5" />
        </button>
        <h1 className="text-2xl font-semibold text-gray-900">Employee Details</h1>
      </div>

      <div className="bg-white rounded-lg shadow-sm overflow-hidden">
        {/* Header */}
        <div className="bg-gradient-to-r from-blue-500 to-blue-600 px-6 py-8">
          <div className="flex items-center gap-4">
            <div className="h-20 w-20 bg-white rounded-full flex items-center justify-center">
              <span className="text-2xl font-bold text-blue-500">
                {employee.name?.charAt(0)}
              </span>
            </div>
            <div className="text-white">
              <h2 className="text-2xl font-semibold">{employee.name}</h2>
              <p className="text-blue-100">{employee.position}</p>
              <div className="flex items-center gap-2 mt-1">
                <BadgeCheck className="h-4 w-4" />
                <span className="text-sm">Employee ID: {employee.employee_id}</span>
              </div>
            </div>
          </div>
        </div>

        {/* Info Grid */}
        <div className="p-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <InfoItem
              icon={Mail}
              label="Email"
              value={employee.email}
            />
            <InfoItem
              icon={Phone}
              label="Phone"
              value={employee.phone}
            />
            <InfoItem
              icon={Briefcase}
              label="Position"
              value={employee.position}
            />
            <InfoItem
              icon={Building2}
              label="Department"
              value={employee.department?.name}
            />
            <InfoItem
              icon={Calendar}
              label="Join Date"
              value={new Date(employee.join_date).toLocaleDateString('id-ID', {
                day: 'numeric',
                month: 'long',
                year: 'numeric'
              })}
            />
            <InfoItem
              icon={MapPin}
              label="Address"
              value={employee.address}
            />
          </div>

          {/* Status */}
          <div className="mt-6 pt-6 border-t">
            <div className="flex items-center justify-between">
              <span className="text-sm font-medium text-gray-500">Status</span>
              <span className={`px-3 py-1 rounded-full text-sm font-semibold ${
                employee.status === 'active'
                  ? 'bg-green-100 text-green-800'
                  : 'bg-red-100 text-red-800'
              }`}>
                {employee.status?.toUpperCase()}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default EmployeeDetail