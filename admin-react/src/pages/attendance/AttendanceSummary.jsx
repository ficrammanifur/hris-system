import { useState, useEffect } from 'react'
import { Calendar, Users, Clock, AlertCircle } from 'lucide-react'
import attendanceService from '../../services/attendance.service.js'
import employeesService from '../../services/employees.service.js'
import toast from 'react-hot-toast'

const AttendanceSummary = () => {
  const [employees, setEmployees] = useState([])
  const [selectedEmployee, setSelectedEmployee] = useState(null)
  const [summary, setSummary] = useState(null)
  const [loading, setLoading] = useState(false)
  const [month, setMonth] = useState(new Date().getMonth() + 1)
  const [year, setYear] = useState(new Date().getFullYear())

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

  const fetchSummary = async () => {
    if (!selectedEmployee) {
      toast.error('Please select an employee')
      return
    }

    setLoading(true)
    try {
      const response = await attendanceService.getSummary(selectedEmployee, month, year)
      setSummary(response.data)
    } catch (error) {
      toast.error('Failed to fetch summary')
    } finally {
      setLoading(false)
    }
  }

  const StatCard = ({ title, value, icon: Icon, color }) => (
    <div className="bg-white rounded-lg shadow-sm p-6">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-600">{title}</p>
          <p className="text-2xl font-semibold mt-1">{value}</p>
        </div>
        <div className={`${color} p-3 rounded-lg`}>
          <Icon className="h-6 w-6 text-white" />
        </div>
      </div>
    </div>
  )

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold text-gray-900">Attendance Summary</h1>

      {/* Filters */}
      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Employee
            </label>
            <select
              value={selectedEmployee || ''}
              onChange={(e) => setSelectedEmployee(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">Select Employee</option>
              {employees.map(emp => (
                <option key={emp.id} value={emp.id}>{emp.name}</option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Month
            </label>
            <select
              value={month}
              onChange={(e) => setMonth(parseInt(e.target.value))}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              {Array.from({ length: 12 }, (_, i) => i + 1).map(m => (
                <option key={m} value={m}>
                  {new Date(2000, m - 1, 1).toLocaleString('default', { month: 'long' })}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Year
            </label>
            <select
              value={year}
              onChange={(e) => setYear(parseInt(e.target.value))}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              {[2024, 2025, 2026, 2027, 2028].map(y => (
                <option key={y} value={y}>{y}</option>
              ))}
            </select>
          </div>

          <div className="flex items-end">
            <button
              onClick={fetchSummary}
              disabled={loading}
              className="w-full bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 disabled:opacity-50"
            >
              {loading ? 'Loading...' : 'Generate Summary'}
            </button>
          </div>
        </div>
      </div>

      {/* Summary Cards */}
      {summary && (
        <>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <StatCard
              title="Total Days"
              value={summary.total_days}
              icon={Calendar}
              color="bg-blue-500"
            />
            <StatCard
              title="Late Days"
              value={summary.late_days}
              icon={AlertCircle}
              color="bg-yellow-500"
            />
            <StatCard
              title="Total Hours"
              value={summary.total_hours}
              icon={Clock}
              color="bg-green-500"
            />
            <StatCard
              title="Avg Hours/Day"
              value={summary.average_hours_per_day}
              icon={Users}
              color="bg-purple-500"
            />
          </div>

          {/* Detailed Attendance */}
          <div className="bg-white rounded-lg shadow-sm overflow-hidden">
            <div className="px-6 py-4 border-b">
              <h2 className="text-lg font-semibold">Detailed Attendance</h2>
            </div>
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Check In</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Check Out</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Duration</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {summary.attendances?.map((attendance) => (
                  <tr key={attendance.id}>
                    <td className="px-6 py-4 whitespace-nowrap text-sm">
                      {new Date(attendance.date).toLocaleDateString()}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm">
                      {new Date(attendance.check_in_time).toLocaleTimeString()}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm">
                      {attendance.check_out_time 
                        ? new Date(attendance.check_out_time).toLocaleTimeString()
                        : '-'
                      }
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className={`px-2 py-1 text-xs rounded-full ${
                        attendance.status === 'present' ? 'bg-green-100 text-green-800' :
                        attendance.status === 'late' ? 'bg-yellow-100 text-yellow-800' :
                        'bg-red-100 text-red-800'
                      }`}>
                        {attendance.status}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm">
                      {attendance.duration ? `${attendance.duration} hours` : '-'}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </>
      )}
    </div>
  )
}

export default AttendanceSummary