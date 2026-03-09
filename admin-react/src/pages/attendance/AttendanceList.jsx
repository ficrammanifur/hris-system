import { useState, useEffect } from 'react'
import { Calendar, Search, Filter } from 'lucide-react'
import attendanceService from '../../services/attendance.service.js'
import employeesService from '../../services/employees.service.js'
import toast from 'react-hot-toast'
import { format } from 'date-fns'

const AttendanceList = () => {
  const [attendances, setAttendances] = useState([])
  const [employees, setEmployees] = useState([])
  const [loading, setLoading] = useState(true)
  const [filters, setFilters] = useState({
    date: format(new Date(), 'yyyy-MM-dd'),
    employee_id: ''
  })

  useEffect(() => {
    fetchEmployees()
  }, [])

  useEffect(() => {
    if (employees.length > 0) {
      fetchAttendances()
    }
  }, [filters, employees])

  const fetchEmployees = async () => {
    try {
      const response = await employeesService.getAll()
      setEmployees(response.data)
    } catch (error) {
      toast.error('Failed to fetch employees')
    }
  }

  const fetchAttendances = async () => {
    setLoading(true)
    try {
      const params = {}
      if (filters.date) params.date = filters.date
      if (filters.employee_id) params.user_id = filters.employee_id
      
      const response = await attendanceService.getAll(params)
      setAttendances(response.data)
    } catch (error) {
      toast.error('Failed to fetch attendances')
    } finally {
      setLoading(false)
    }
  }

  const getEmployeeName = (userId) => {
    const employee = employees.find(e => e.id === userId)
    return employee ? employee.name : 'Unknown'
  }

  const getStatusColor = (status) => {
    const colors = {
      present: 'bg-green-100 text-green-800',
      late: 'bg-yellow-100 text-yellow-800',
      absent: 'bg-red-100 text-red-800',
      'half_day': 'bg-orange-100 text-orange-800'
    }
    return colors[status] || 'bg-gray-100 text-gray-800'
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-2xl font-semibold text-gray-900">Attendance Records</h1>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-lg shadow-sm p-4">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Date
            </label>
            <div className="relative">
              <Calendar className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
              <input
                type="date"
                value={filters.date}
                onChange={(e) => setFilters({ ...filters, date: e.target.value })}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Employee
            </label>
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
              <select
                value={filters.employee_id}
                onChange={(e) => setFilters({ ...filters, employee_id: e.target.value })}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              >
                <option value="">All Employees</option>
                {employees.map(emp => (
                  <option key={emp.id} value={emp.id}>{emp.name}</option>
                ))}
              </select>
            </div>
          </div>

          <div className="flex items-end">
            <button
              onClick={fetchAttendances}
              className="w-full bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 flex items-center justify-center gap-2"
            >
              <Filter className="h-5 w-5" />
              Apply Filters
            </button>
          </div>
        </div>
      </div>

      {/* Attendance Table */}
      <div className="bg-white rounded-lg shadow-sm overflow-hidden">
        {loading ? (
          <div className="flex items-center justify-center h-64">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500"></div>
          </div>
        ) : (
          <table className="min-w-full divide-y divide-gray-200">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Employee
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Date
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Check In
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Check Out
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Status
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Duration
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {attendances.map((attendance) => (
                <tr key={attendance.id} className="hover:bg-gray-50">
                  <td className="px-6 py-4 whitespace-nowrap">
                    <div className="text-sm font-medium text-gray-900">
                      {getEmployeeName(attendance.user_id)}
                    </div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {format(new Date(attendance.date), 'dd MMM yyyy')}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {attendance.check_in_time 
                      ? format(new Date(attendance.check_in_time), 'HH:mm:ss')
                      : '-'
                    }
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {attendance.check_out_time
                      ? format(new Date(attendance.check_out_time), 'HH:mm:ss')
                      : '-'
                    }
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <span className={`px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full ${getStatusColor(attendance.status)}`}>
                      {attendance.status}
                    </span>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {attendance.duration ? `${attendance.duration} hours` : '-'}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}

        {!loading && attendances.length === 0 && (
          <div className="text-center py-8 text-gray-500">
            No attendance records found
          </div>
        )}
      </div>
    </div>
  )
}

export default AttendanceList