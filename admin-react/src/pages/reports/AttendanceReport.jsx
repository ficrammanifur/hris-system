import { useState } from 'react'
import { Download, Calendar } from 'lucide-react'
import attendanceService from '../../services/attendance.service.js'
import employeesService from '../../services/employees.service.js'
import toast from 'react-hot-toast'

const AttendanceReport = () => {
  const [loading, setLoading] = useState(false)
  const [month, setMonth] = useState(new Date().getMonth() + 1)
  const [year, setYear] = useState(new Date().getFullYear())

  const generateReport = async () => {
    setLoading(true)
    try {
      const employees = await employeesService.getAll()
      const reportData = []

      for (const employee of employees.data) {
        const summary = await attendanceService.getSummary(employee.id, month, year)
        reportData.push({
          employee: employee.name,
          employee_id: employee.employee_id,
          department: employee.department?.name,
          ...summary.data
        })
      }

      // Convert to CSV
      const csv = [
        ['Employee', 'Employee ID', 'Department', 'Total Days', 'Late Days', 'Total Hours', 'Avg Hours/Day'],
        ...reportData.map(r => [
          r.employee,
          r.employee_id,
          r.department,
          r.total_days,
          r.late_days,
          r.total_hours,
          r.average_hours_per_day
        ])
      ].map(row => row.join(',')).join('\n')

      // Download CSV
      const blob = new Blob([csv], { type: 'text/csv' })
      const url = window.URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.href = url
      a.download = `attendance-report-${month}-${year}.csv`
      a.click()
      window.URL.revokeObjectURL(url)

      toast.success('Report generated successfully')
    } catch (error) {
      toast.error('Failed to generate report')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold text-gray-900">Attendance Report</h1>

      <div className="bg-white rounded-lg shadow-sm p-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
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
              onClick={generateReport}
              disabled={loading}
              className="w-full bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 disabled:opacity-50 flex items-center justify-center gap-2"
            >
              <Download className="h-5 w-5" />
              {loading ? 'Generating...' : 'Download Report'}
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}

export default AttendanceReport