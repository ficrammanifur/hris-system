import { useState, useEffect } from 'react'
import { Calendar, Briefcase, Clock, AlertCircle } from 'lucide-react'
import leavesService from '../../services/leaves.service.js'
import employeesService from '../../services/employees.service.js'
import toast from 'react-hot-toast'

const LeaveBalance = () => {
  const [employees, setEmployees] = useState([])
  const [selectedEmployee, setSelectedEmployee] = useState(null)
  const [balance, setBalance] = useState(null)
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchEmployees()
  }, [])

  const fetchEmployees = async () => {
    try {
      const response = await employeesService.getAll()
      setEmployees(response.data)
    } catch (error) {
      toast.error('Failed to fetch employees')
    }
  }

  const fetchBalance = async () => {
    if (!selectedEmployee) {
      toast.error('Please select an employee')
      return
    }

    setLoading(true)
    try {
      const response = await leavesService.getBalance(selectedEmployee)
      setBalance(response.data)
    } catch (error) {
      toast.error('Failed to fetch leave balance')
    } finally {
      setLoading(false)
    }
  }

  const StatCard = ({ title, value, icon: Icon, color, total }) => (
    <div className="bg-white rounded-lg shadow-sm p-6">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-600">{title}</p>
          <p className="text-3xl font-semibold mt-1">{value}</p>
          {total && <p className="text-xs text-gray-500 mt-1">of {total} total</p>}
        </div>
        <div className={`${color} p-3 rounded-lg`}>
          <Icon className="h-6 w-6 text-white" />
        </div>
      </div>
    </div>
  )

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold text-gray-900">Leave Balance</h1>

      {/* Employee Selection */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Select Employee
            </label>
            <select
              value={selectedEmployee || ''}
              onChange={(e) => setSelectedEmployee(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">Choose employee...</option>
              {employees.map(emp => (
                <option key={emp.id} value={emp.id}>{emp.name}</option>
              ))}
            </select>
          </div>
          <div className="flex items-end">
            <button
              onClick={fetchBalance}
              disabled={loading}
              className="bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 disabled:opacity-50"
            >
              {loading ? 'Loading...' : 'Check Balance'}
            </button>
          </div>
        </div>
      </div>

      {/* Balance Cards */}
      {balance && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <StatCard
            title="Total Leave"
            value={balance.total}
            icon={Calendar}
            color="bg-blue-500"
          />
          <StatCard
            title="Taken"
            value={balance.taken}
            icon={Briefcase}
            color="bg-yellow-500"
            total={balance.total}
          />
          <StatCard
            title="Pending"
            value={balance.pending}
            icon={Clock}
            color="bg-orange-500"
          />
          <StatCard
            title="Remaining"
            value={balance.remaining}
            icon={AlertCircle}
            color="bg-green-500"
            total={balance.total}
          />
        </div>
      )}
    </div>
  )
}

export default LeaveBalance